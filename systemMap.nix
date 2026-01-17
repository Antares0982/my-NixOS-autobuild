{
  nixpkgs,
  nixpkgs-old,
  nixpkgs-for-chrome,
  agenix,
  lib,
  my-kde-overlay,
  nix-rpi5,
  home-manager,
  myXray,
  wsl,
  vscode-server,
  pull-all,
  renewal,
  ...
}:
let
  xray = myXray;
  _pull-all = pull-all;
  _renewal = renewal;
in
(
  {
    currentDevice,
    system,
    withHm,
    ...
  }:
  let
    nixpkgsToPkgs =
      _nixpkgs:
      (import _nixpkgs {
        inherit system;
        config = {
          allowUnfree = true;
        };
      }).pkgs;
    myXray = xray.packages.${system}.default;
    needVSCodeServer = currentDevice.rpi or false;
    pkgs-old = nixpkgsToPkgs nixpkgs-old;
    pkgs-for-chrome = nixpkgsToPkgs nixpkgs-for-chrome;
    pull-all = _pull-all.packages.${system}.default;
    renewal = _renewal.packages.${system}.default;
  in
  nixpkgs.lib.nixosSystem {
    inherit system;
    specialArgs = {
      inherit
        agenix
        currentDevice
        myXray
        pkgs-old
        pkgs-for-chrome
        pull-all
        renewal
        ;
    }
    // lib.attrsets.optionalAttrs currentDevice.pc {
      my-kde-overlay = my-kde-overlay.overlays.default;
    }
    // lib.attrsets.optionalAttrs currentDevice.rpi {
      inherit nix-rpi5;
    };
    modules = [
      ./configuration.nix
      agenix.nixosModules.default
    ]
    ++ lib.optionals withHm [
      home-manager.nixosModules.home-manager
    ]
    ++ lib.optionals (currentDevice.wsl or false) [
      wsl.nixosModules.wsl
    ]
    ++ lib.optionals needVSCodeServer [
      vscode-server.nixosModules.default
      (
        { config, pkgs, ... }:
        {
          services.vscode-server.enable = true;
        }
      )
    ];
  }
)
