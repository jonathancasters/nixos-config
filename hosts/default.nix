{ inputs, user, lib, nixpkgs, nixpkgs-unstable, home-manager, ... }:

let
  system = "x86_64-linux";                  # Systen architecture

  pkgs = import nixpkgs {                   # Allow proprietary software
    inherit system;
    config.allowUnfree = true;
  };

  nixpkgs-unstable-patch = (import nixpkgs-unstable { inherit system; }).applyPatches{
    name = "vbox-7.0.10";
    src = nixpkgs-unstable;
    patches = [ ../patches/vbox-7.0.10.patch ];
  }; 

  unstable-pkgs = import nixpkgs-unstable-patch {      # Allow proprietary software
    inherit system;
    config.allowUnfree = true;
  };

  lib = nixpkgs.lib;
in 
{
  laptop = lib.nixosSystem {                     # Laptop profile
    inherit system;
    specialArgs = {
      inherit unstable-pkgs inputs user;
      hostName = "laptop";
    };
    modules = [
      ./laptop                                    
      ./configuration.nix

      home-manager.nixosModules.home-manager {   # Set up home manager as module
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.extraSpecialArgs = {
          inherit unstable-pkgs user;
          hostName = "laptop";
        };
        home-manager.users.${user} = {
          imports = [
            ./home.nix
          ];
        };
      }                        
    ];
  };
}
