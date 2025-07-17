{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    bash-language-server
    jetbrains.idea-ultimate
    lua-language-server
    metals
    neovim
    nixd
    nixfmt-rfc-style
    postgres-lsp
    pyright
    ruby-lsp
    rust-analyzer
    vscode
  ];
}
