# NixOS guest for the Claude Code sandbox VM.
{ pkgs, modulesPath, ... }:
{
  # virtio drivers in the initrd so the guest can find its virtio-blk root disk
  imports = [ (modulesPath + "/profiles/qemu-guest.nix") ];

  system.stateVersion = "26.05";
  boot.kernelModules = [ "virtiofs" ];

  # Serial console (virsh qemu:///system console sandbox) with passwordless root autologin.
  # Recovery path if SSH is ever unavailable
  boot.kernelParams = [ "console=ttyS0,115200" ];
  services.getty.autologinUser = "root";

  fileSystems."/workspace" = {
    device = "workspace";
    fsType = "virtiofs";
  };
  fileSystems."/root/.claude" = {
    device = "claudecfg";
    fsType = "virtiofs";
  };

  services.openssh.enable = true;
  services.openssh.settings.PermitRootLogin = "prohibit-password"; # key-only root login
  services.qemuGuest.enable = true; # clean managedsave/shutdown handshake
  services.timesyncd.enable = true; # correct the clock jump on resume
  services.fstrim.enable = true; # reclaim qcow2 space, pairs with discard=unmap on the disk

  networking.hostName = "sandbox";
  networking.firewall.enable = false;

  users.users.root.openssh.authorizedKeys.keyFiles = [ ./authorized_keys ];

  # let claude run with --dangerously-skip-permissions as root (the VM is the boundary)
  environment.variables = {
    EDITOR = "nvim";
    IS_SANDBOX = "1";
  };

  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    claude-code
    curl
    fd
    git
    jq
    neovim
    python3
    ripgrep
    tmux
    wget
  ];
}
