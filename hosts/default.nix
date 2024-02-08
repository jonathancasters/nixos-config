{ lib, inputs, user, nixpkgs, home-manager, ... }:
let
  system = "x86_64-linux";                      # system architecture

  pkgs = import nixpkgs {                       # allow proprietary software
    inherit system;
    config.allowUnfree = true;
  };

  args = {                                      # args to be made available in other modules
    inherit pkgs inputs user;
    hostName = "laptop";
  };

in 
{
  laptop = lib.nixosSystem {                    # laptop profile
    inherit system;

    specialArgs = args;                         # make args available in modules 

    modules = [
      ./configuration.nix                       # default module
      ./laptop                                  # laptop-specific module 
      home-manager.nixosModules.home-manager {  # home manager as module
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.extraSpecialArgs = args;   # pass arguments to ./home.nix
        home-manager.users.${user} = {
          imports = [
            ./home.nix
          ];
        };
      }                        
    ];
  };

  # INFO: add more profiles below when adding new devices
}
