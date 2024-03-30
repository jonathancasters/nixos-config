{ config, lib, pkgs, user, ... }:

{
  imports = [
    ./editors
    ./git
    ./docker
  ];
  
  options.${user}.development.enable = lib.mkOption {
    default = false;
    example = true;
  }; 

  config = lib.mkIf config.${user}.development.enable {
    ${user} = {
      # TODO: add language servers to nvim
      development = {
        git.enable = lib.mkDefault true;
        docker.enable = lib.mkDefault true;
        nvim.enable = lib.mkDefault true;
        vscode.enable = lib.mkDefault true;
        jetbrains.enable = lib.mkDefault true;
      };
    };

    environment.systemPackages = [
      pkgs.devbox
    ];
  };
}
