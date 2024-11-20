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
    breezeOverlay.url = "github:Antares0982/my-breeze-overlay";
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      agenix,
      breezeOverlay,
      ...
    }@inputs:
    {
      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs =
          let
            _breezeOverlay = breezeOverlay.overlays.default;
          in
          {
            inherit agenix;
            breezeOverlay = _breezeOverlay;
          };
        modules = [
          ./packages.nix
          home-manager.nixosModules.home-manager
          agenix.nixosModules.default
        ];
      };
    };
}
