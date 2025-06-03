{
  config,
  lib,
  pkgs,
  ...
}:
let
  nix-zshell = pkgs.callPackage ../_nix-zshell.nix { };
in
{
  # imports = [ ../common/packages.nix ];
  environment.systemPackages = with pkgs; [
    cheat
    direnv
    imagemagick
    # linuxKernel.packages.linux_zen.perf
    nixfmt-rfc-style
    # rocmPackages.llvm.clang-tools-extra
    cachix
    eza
    fd
    gcc
    gdb
    gh
    git
    gnumake
    gnupg
    jq
    nano
    nix-prefetch-scripts
    oh-my-zsh
    ripgrep
    tree
    zsh
    zsh-powerlevel10k
    #
    nix-zshell
  ];
}
