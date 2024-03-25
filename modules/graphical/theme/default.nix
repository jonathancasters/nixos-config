{ config, lib, pkgs, user, ... }:
{
  options.${user}.graphical.theme = {
    enable = lib.mkOption {
      default = false;
      example = true;
    };
    xserver = lib.mkOption {
      default = false;
      example = true;
    };
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

      home.pointerCursor = {
        gtk.enable = true;
        name = "Catppucin-Latte-Light-Cursors";
        package = pkgs.catppuccin-cursors.latteLight;
        size = 16;
      };

      gtk = {
        enable = true;
        font = {
          name = "FiraCode Nerd Font Mono Medium";
        };
        theme = {
          name = "Catppucin-Latte-Compact-Blue-Light";
          package = pkgs.catppuccin-gtk.override {
            accents = ["blue"];
            size = "compact";
            variant = "latte";
          };
        };
        iconTheme = {
          name = "Papirus-Light";
          package = pkgs.papirus-icon-theme;
        };
      };
      # TODO: Check if this code below does anything
      qt = {
        enable = true;
        style = {
          name = "Catppuccin-Latte";
          package = pkgs.catppuccin-qt5ct;
        };
      };
    };

    # TODO: Remove redundant theme and icon definition!
    services.xserver.displayManager.lightdm = lib.mkIf config.${user}.graphical.theme.xserver {
      background = ./wall.png;
      greeters.slick = {
        draw-user-backgrounds = true;
        theme = {
            name = "Catppucin-Latte-Compact-Blue-Light";
            package = pkgs.catppuccin-gtk.override {
              accents = ["blue"];
              size = "compact";
              variant = "latte";
            };
        };
        iconTheme = {
            name = "Papirus-Light";
            package = pkgs.papirus-icon-theme;
        };
        cursorTheme = {
          name = "Catppucin-Latte-Light-Cursors";
          package = pkgs.catppuccin-cursors.latteLight;
          size = 16;
        };
        font = {
          name = "FiraCode Nerd Font Mono Medium";
        };
      };
    };
  };
}
