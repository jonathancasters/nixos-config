{ config, lib, user, ... }:

{
  imports = [
    ./editors
    ./git
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
      };
    };
  };
}
