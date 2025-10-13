{
  description = "PC NixOS flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-old.url = "github:NixOS/nixpkgs/nixos-25.05";
    nixpkgs-for-chrome.url = "github:NixOS/nixpkgs/f771eb401a46846c1aebd20552521b233dd7e18b";
    flake-compat.url = "github:edolstra/flake-compat";
    flake-utils.url = "github:numtide/flake-utils";
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    agenix = {
      url = "github:ryantm/agenix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
      };
    };
    my-kde-overlay = {
      url = "github:Antares0982/my-kde-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-rpi5 = {
      url = "gitlab:vriska/nix-rpi5";
      # use nixpkgs-old to avoid frequent rebuild
      inputs = {
        nixpkgs.follows = "nixpkgs-old";
        flake-compat.follows = "flake-compat";
      };
    };
    myXray = {
      url = "github:Antares0982/rules-dat-xray-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    wsl = {
      url = "github:nix-community/NixOS-WSL";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-compat.follows = "flake-compat";
      };
    };
    vscode-server = {
      url = "github:nix-community/nixos-vscode-server";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "flake-utils";
      };
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-old,
      nixpkgs-for-chrome,
      home-manager,
      agenix,
      my-kde-overlay,
      nix-rpi5,
      myXray,
      wsl,
      vscode-server,
      ...
    }@inputs:
    {
      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs =
          let
            _kdeOverlay = my-kde-overlay.overlays.default;
          in
          {
            inherit agenix;
            my-kde-overlay = _kdeOverlay;
          };
        modules = [
          ./packages.nix
          home-manager.nixosModules.home-manager
          agenix.nixosModules.default
        ];
      };
      nixosConfigurations.rpi5 = nixpkgs.lib.nixosSystem {
        system = "aarch64-linux";
        specialArgs = {
          inherit nix-rpi5;
        };
        modules = [
          ./rpi
        ];
      };
      nixosConfigurations.wsl = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          wsl.nixosModules.wsl
          ./wsl
        ];
      };
    };
}
