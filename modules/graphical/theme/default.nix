{ config, lib, pkgs, user, ... }:
{
  options.${user}.graphical.theme.enable = lib.mkOption {
    default = false;
    example = true;
  };

  config = lib.mkIf config.${user}.graphical.theme.enable {
    fonts.packages = with pkgs; [
      carlito
      vegur
      source-code-pro
      jetbrains-mono
      font-awesome
      corefonts
      (nerdfonts.override {
        fonts = [
          "FiraCode"
        ];
      })
    ];

    home-manager.users.${user} = {
      programs.alacritty = {
        enable = true;
        settings = {
          font = {
            size = 11;
            normal = {
              family = "FiraCode Nerd Font";
              style = "Regular";
            };
            bold = {
              family = "FiraCode Nerd Font";
              style = "Bold";
            };
            italic = {
              family = "FiraCode Nerd Font";
              style = "Italic";
            };
          };
        };
      };
    };
  };
}
