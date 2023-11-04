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

  outputs = inputs @ { self, nixpkgs, home-manager }:
    let
      user = "castersj";
    in 
    {
      # TODO: make library function that reads dir and maps a function onto all nix files in that dir
      nixpkgs.overlays = [
        (import ./overlays/virtualbox.nix)
      ]; 

      nixosConfigurations = (
        import ./hosts {                                           # Imports ./hosts/default.nix
          inherit (nixpkgs) lib;
          inherit inputs user nixpkgs home-manager;
        }
      );
    };
} 
