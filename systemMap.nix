{
  nixpkgs,
  nixpkgs-24-05,
  nixpkgs-24-11,
  nixpkgs-for-chrome,
  agenix,
  lib,
  my-kde-overlay,
  nix-rpi5,
  home-manager,
  myXray,
  wsl,
  vscode-server,
  ...
}:
let
  xray = myXray;

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
    pkgs-24-05 = nixpkgsToPkgs nixpkgs-24-05;
    pkgs-24-11 = nixpkgsToPkgs nixpkgs-24-11;
    pkgs-for-chrome = nixpkgsToPkgs nixpkgs-for-chrome;
  in
  nixpkgs.lib.nixosSystem {
    inherit system;
    specialArgs =
      {
        inherit
          agenix
          currentDevice
          myXray
          pkgs-24-05
          pkgs-24-11
          pkgs-for-chrome
          ;
      }
      // lib.attrsets.optionalAttrs currentDevice.pc {
        my-kde-overlay = my-kde-overlay.overlays.default;
      }
      // lib.attrsets.optionalAttrs currentDevice.rpi {
        inherit nix-rpi5;
      };
    modules =
      [
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
