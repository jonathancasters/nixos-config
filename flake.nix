{
  description = "NixOS configuration flake";

  inputs =                                                         # Define dependencies
  {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.05";              # Default stable nix packages
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";  # Unstable nix packages

    home-manager = {                                               # User package management + configs
      url = "github:nix-community/home-manager/release-23.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ { self, nixpkgs, nixpkgs-unstable, home-manager }:
    let
      user = "castersj";
    in 
    {
      nixosConfigurations = (
        import ./hosts {                                           # Imports ./hosts/default.nix
          inherit (nixpkgs) lib;
          inherit inputs user nixpkgs nixpkgs-unstable home-manager;
        }
      );
    };
} 
