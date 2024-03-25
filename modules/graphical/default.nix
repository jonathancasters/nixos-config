{ config, lib, pkgs, user, ... }:
{
  imports = [
    ./xserver
    ./theme
  ];

  options.${user}.graphical.enable = lib.mkOption {
    default = false;
    example = true;
  };

  config = lib.mkIf config.${user}.graphical.enable {
    users.users.${user}.extraGroups = [ "input" "video" ];

    ${user}.graphical = {
      xserver = {
        enable = true;
      };
      theme = {
        enable = true;
        xserver = true;
      };
    };
  };
}
