{
  username,
  zen,
  pkgs,
  ...
}:
{
  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 4d --keep 3";
  };

  programs.fish.enable = true;

  users.users.${username} = {
    shell = pkgs.fish;
    isNormalUser = true;
    description = username;

    extraGroups = [
      "networkmanager"
      "wheel"
    ];

    packages =
      with pkgs;
      [
        alacritty
        bat
        chromium
        claude-code
        delta
        dig
        direnv
        eza
        fd
        fzf
        gcc
        git
        git-lfs
        gnumake
        go-task
        htop
        jq
        neovim
        nix-direnv
        nushell
        postgresql
        pspg
        ripgrep
        sd
        starship
        stow
        vesktop
        wezterm
        wget
        wireguard-tools
        zed-editor-fhs
        zoxide

        # LSPs
        bash-language-server
        lua-language-server
        metals
        nixd
        postgres-language-server
        pyright
        rubocop
        ruby-lsp
        rust-analyzer

        # Formatters
        isort
        nixfmt-rfc-style
        rustfmt
        shellcheck
        stylua
      ]
      ++ [ zen.default ];
  };
}
