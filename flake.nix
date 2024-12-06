{
  description = "PC NixOS flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/master";
      # The `follows` keyword in inputs is used for inheritance.
      # Here, `inputs.nixpkgs` of home-manager is kept consistent with
      # the `inputs.nixpkgs` of the current flake,
      # to avoid problems caused by different versions of nixpkgs.
      inputs.nixpkgs.follows = "nixpkgs";
    };
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    kdeOverlay.url = "github:Antares0982/my-kde-overlay";
    nix-rpi5 = {
      url = "gitlab:vriska/nix-rpi5";
      inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      agenix,
      kdeOverlay,
      nix-rpi5,
      ...
    }@inputs:
    {
      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs =
          let
            _kdeOverlay = kdeOverlay.overlays.default;
          in
          {
            inherit agenix;
            kdeOverlay = _kdeOverlay;
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
    };
}
