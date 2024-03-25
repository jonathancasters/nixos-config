{ config, lib, pkgs, user, ... }:
{
  options.${user}.graphical.xserver = {
    enable = lib.mkOption {
      default = false;
      example = true;
    };
  };

  config = lib.mkIf config.${user}.graphical.xserver.enable {
    services.xserver = {
      enable = true;
      layout = "us";
      displayManager = {
        lightdm = {
          enable = true;
          greeters.slick = {
            enable = true;
          };
        };
        defaultSession = "none+qtile";
      };
      windowManager.qtile.enable = true;
    };
  };
}
