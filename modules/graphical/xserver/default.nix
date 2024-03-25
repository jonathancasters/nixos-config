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
      desktopManager = {
        xfce = {
          enable = true;
          noDesktop = true;
          enableXfwm = false;
          enableScreensaver = false;
        };
        wallpaper.mode = "scale";
      };
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
