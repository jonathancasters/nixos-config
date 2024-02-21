{
  description = "NixOS configuration flake";

  inputs =                                                         # Define dependencies
  {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";           # Unstable nix packages

    home-manager = {                                               # User package management + configs
      url = "github:nix-community/home-manager/";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ { self, nixpkgs, home-manager}:
    let
      user = "castersj";

      # utility function that overlays the lib module
      mkLib = nixpkgs:
        nixpkgs.lib.extend(
          final: prev: (import ./lib {inherit (final) lib;}) // home-manager.lib
        );
      lib = mkLib nixpkgs;

      inherit (lib) mapModule;
    in 
    {
      nixpkgs.overlays = mapModule ./overlays import;

      nixosConfigurations = (
        import ./hosts {                                           # Imports ./hosts/default.nix
          inherit lib;
          inherit inputs user nixpkgs home-manager;
        }
      );
    };
} 
