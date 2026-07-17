{
  pkgs,
  lib,
  username,
  ...
}:
let
  guestSystem = import (pkgs.path + "/nixos/lib/eval-config.nix") {
    system = "x86_64-linux";
    modules = [ ./guest.nix ];
  };
  sandboxImage = guestSystem.config.system.build.images.qemu;

  guestIP = "192.168.150.10";
  guestMAC = "52:54:00:cc:5a:01";
  disk = "/var/lib/libvirt/images/sandbox.qcow2";
  cpus = 8;
  memoryGiB = 20;
  codeDir = "/home/${username}/Documents/cc-sandbox/workspace"; # -> /workspace
  claudeDir = "/home/${username}/Documents/cc-sandbox/claude"; # -> /root/.claude
  hostUid = "1000"; # lucas
  hostGid = "100"; # users

  # one virtiofsd per share, mapping guest root to the host user
  # migration-mode keeps the mount valid across a freeze/resume
  virtiofsd = name: dir: mode: {
    "virtiofsd-${name}" = {
      description = "virtiofsd for sandbox share ${name}";
      wantedBy = [ "libvirtd.service" ];
      before = [ "libvirtd.service" ];
      after = [ "local-fs.target" ];
      serviceConfig = {
        RuntimeDirectory = "virtiofsd";
        RuntimeDirectoryPreserve = "yes"; # both services share this dir, keep it on stop
        # virtiofsd exits when the VM disconnects; respawn so a socket is always ready
        Restart = "always";
        RestartSec = 1;
        # create the shared dir owned by the host user before starting
        ExecStartPre = [
          "${pkgs.coreutils}/bin/mkdir -p ${dir}"
          "${pkgs.coreutils}/bin/chown ${hostUid}:${hostGid} ${dirOf dir} ${dir}"
          "${pkgs.coreutils}/bin/chmod ${mode} ${dir}"
        ];
        ExecStart = lib.concatStringsSep " " [
          "${pkgs.virtiofsd}/bin/virtiofsd"
          "--socket-path=/run/virtiofsd/${name}.sock"
          "--shared-dir=${dir}"
          "--sandbox=none"
          "--translate-uid guest:0:${hostUid}:1"
          "--translate-uid host:${hostUid}:0:1"
          "--translate-gid guest:0:${hostGid}:1"
          "--translate-gid host:${hostGid}:0:1"
          "--migration-mode find-paths"
        ];
        # wait for the socket before libvirt starts the domain
        ExecStartPost =
          "${pkgs.coreutils}/bin/timeout 10 ${pkgs.bash}/bin/sh -c "
          + "'until [ -S /run/virtiofsd/${name}.sock ]; do sleep 0.1; done'";
      };
    };
  };
in
{
  virtualisation.libvirt.enable = true; # NixVirt declarative domains/networks
  virtualisation.libvirtd = {
    enable = true;
    onBoot = "ignore";
    onShutdown = "shutdown";
    # virtiofsd exits when the VM disconnects, so make it fresh right before qemu
    # (re)connects. libvirt blocks domain start until this returns, so the socket
    # is guaranteed ready. Covers cold start (prepare) and managedsave resume (restore).
    hooks.qemu.sandbox-virtiofs = pkgs.writeShellScript "sandbox-virtiofs-hook" ''
      if [ "$1" = "sandbox" ]; then
        case "$2" in
          prepare|restore)
            /run/current-system/sw/bin/systemctl restart virtiofsd-workspace.service virtiofsd-claudecfg.service
            ;;
        esac
      fi
    '';
  };

  boot.extraModprobeConfig = "options kvm_amd nested=1"; # pin nested virt
  networking.firewall.trustedInterfaces = [ "virbr-cc" ];

  systemd.services =
    (virtiofsd "workspace" codeDir "0755")
    // (virtiofsd "claudecfg" claudeDir "0700")
    // {
      # copy the image to the mutable disk on first boot
      sandbox-disk-init = {
        wantedBy = [ "libvirtd.service" ];
        before = [ "libvirtd.service" ];
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
        };
        script = ''
          if [ ! -e ${disk} ]; then
            mkdir -p /var/lib/libvirt/images
            install -m600 ${sandboxImage}/${sandboxImage.passthru.filePath} ${disk}
            # Disk size is fixed at provisioning.
            # Changing it means editing the qemu-img resize calls and running
            # sandbox reset, which wipes the disk.
            ${pkgs.qemu}/bin/qemu-img resize ${disk} 100G
          fi
        '';
      };
    };

  # private NAT network with a fixed lease for the guest
  virtualisation.libvirt.connections."qemu:///system".networks = [
    {
      definition = pkgs.writeText "sandbox-net.xml" ''
        <network>
          <name>sandbox-net</name>
          <uuid>77637eba-91c0-4e17-bdf7-94ae4ea3b53d</uuid>
          <forward mode="nat"/>
          <bridge name="virbr-cc"/>
          <ip address="192.168.150.1" netmask="255.255.255.0">
            <dhcp><host mac="${guestMAC}" name="sandbox" ip="${guestIP}"/></dhcp>
          </ip>
        </network>
      '';
      active = true;
    }
  ];

  # guest domain
  virtualisation.libvirt.connections."qemu:///system".domains = [
    {
      definition = pkgs.writeText "sandbox.xml" ''
        <domain type="kvm">
          <name>sandbox</name>
          <uuid>fdf757fb-f2fe-40f0-8992-83b74ec54f13</uuid>
          <memory unit="GiB">${toString memoryGiB}</memory>
          <vcpu>${toString cpus}</vcpu>
          <os><type arch="x86_64" machine="q35">hvm</type><boot dev="hd"/></os>
          <cpu mode="host-passthrough"/>
          <features><acpi/><apic/></features>
          <clock offset="utc"/>
          <memoryBacking><source type="memfd"/><access mode="shared"/></memoryBacking>
          <devices>
            <disk type="file" device="disk">
              <driver name="qemu" type="qcow2" discard="unmap"/>
              <source file="${disk}"/>
              <target dev="vda" bus="virtio"/>
            </disk>
            <filesystem type="mount">
              <driver type="virtiofs" queue="1024"/>
              <source socket="/run/virtiofsd/workspace.sock"/>
              <target dir="workspace"/>
            </filesystem>
            <filesystem type="mount">
              <driver type="virtiofs" queue="1024"/>
              <source socket="/run/virtiofsd/claudecfg.sock"/>
              <target dir="claudecfg"/>
            </filesystem>
            <interface type="network">
              <source network="sandbox-net"/>
              <mac address="${guestMAC}"/>
              <model type="virtio"/>
            </interface>
            <channel type="unix">
              <target type="virtio" name="org.qemu.guest_agent.0"/>
            </channel>
            <rng model="virtio"><backend model="random">/dev/urandom</backend></rng>
            <console type="pty"/>
            <memballoon model="virtio"/>
          </devices>
        </domain>
      '';
    }
  ];

  # manual lifecycle commands
  users.users.${username}.extraGroups = [ "libvirtd" ]; # run sandbox without sudo

  environment.systemPackages = [
    (pkgs.writeShellScriptBin "sandbox" ''
      set -euo pipefail
      V="${pkgs.libvirt}/bin/virsh -c qemu:///system"
      disk=${disk}
      case "''${1:-help}" in
        start)  $V start sandbox ;;              # cold boot, or resume if frozen
        freeze) $V managedsave sandbox ;;        # save RAM+state to disk, then stop
        stop)   $V shutdown sandbox ;;           # graceful shutdown (no state saved)
        kill)   $V destroy sandbox ;;            # force off
        reset)                                   # rebuild disk from the Nix image (cold)
          $V destroy sandbox 2>/dev/null || true
          $V managedsave-remove sandbox 2>/dev/null || true
          /run/wrappers/bin/sudo ${pkgs.coreutils}/bin/install -m600 ${sandboxImage}/${sandboxImage.passthru.filePath} "$disk"
          /run/wrappers/bin/sudo ${pkgs.qemu}/bin/qemu-img resize "$disk" 100G
          $V start sandbox ;;
        status) $V domstate sandbox; $V dominfo sandbox 2>/dev/null \
                  | ${pkgs.gnugrep}/bin/grep -E 'State|Managed save' || true ;;
        ssh)    shift; exec ${pkgs.openssh}/bin/ssh sandbox "''$@" ;;
        help|"") echo "usage: sandbox {start|freeze|stop|kill|reset|status|ssh}" ;;
        *) echo "sandbox: unknown command '$1'" >&2
           echo "usage: sandbox {start|freeze|stop|kill|reset|status|ssh}" >&2; exit 1 ;;
      esac
    '')
  ];

  # build the guest image directly with
  #   nix build .#nixosConfigurations.tuxedo.config.system.build.sandboxImage
  system.build.sandboxImage = sandboxImage;

  # ssh sandbox from the host using the dedicated key. The guest is disposable
  # (reset regenerates its host keys) and lives on a private NAT we control, so
  # don't pin/verify host keys against known_hosts.
  programs.ssh.extraConfig = ''
    Host sandbox
      HostName ${guestIP}
      User root
      IdentityFile ~/.ssh/cc-sandbox
      IdentitiesOnly yes
      StrictHostKeyChecking no
      UserKnownHostsFile /dev/null
      LogLevel ERROR
  '';
}
