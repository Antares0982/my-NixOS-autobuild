{
  config,
  pkgs,
  lib,
  ...
}:
{
  nixpkgs.config.allowUnfree = true;
  imports =
    [
      ./configuration.nix
    ]
    ;
}
