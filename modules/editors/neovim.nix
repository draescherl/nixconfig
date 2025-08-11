{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    neovim

    # LSPs
    bash-language-server
    lua-language-server
    metals
    nixd
    postgres-lsp
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
  ];
}
