{ config, lib, pkgs, user, ... }:

{
  imports = (
    import ../modules/editors
  );

  home = {
    username ="${user}";
    homeDirectory = "/home/${user}";
    
    packages = with pkgs; [
      arandr    # Screen management
      rofi      # Launch apps
      dconf
      simplescreenrecorder

      # Terminal 
      btop	# Resource manager
      ranger	# File manager
      tldr	# Helper

      # Video/Audio
      pavucontrol
      vlc
      flameshot
      imagemagick

      # Apps
      brave
      spotify
      discord
      cura
      
      # Filemanagement
      zip
      unzip
      unrar
      xclip

      # Development
      jetbrains.clion
      jetbrains.pycharm-professional
      jetbrains.webstorm
      jetbrains.datagrip
      
      anki # flashcards
    ];
    
    pointerCursor = {
      gtk.enable = true;
      name = "Catppucin-Mocha-Dark-Cursors";
      package = pkgs.catppuccin-cursors.mochaDark;
      size = 16;
    };
    stateVersion = "23.05";
  };
  
  programs = {
    home-manager.enable = true;
    ssh.enable = true;
    gpg.enable = true;
    git = {
      enable = true;
      userName = "jonathancasters";
      userEmail = "jonathancasters284@gmail.com";

      extraConfig = {
        init.defaultBranch = "main";
        user.signingkey = "B9A05FF81B94474C";
        commit.gpgSign = true;
        core = {
          sshCommand = "ssh -i ~/.ssh/id_ed25519_personal";
        };
      };

      includes = [
        {
          contents = {
            user = {
              name = "jpcaster";
              email = "jonathan.casters@ugent.be";
              signingkey = "40FF8380DB6F5FA9";
            };
            core = {
              sshCommand = "ssh -i ~/.ssh/id_ed25519_school";
            };
          };
          condition = "gitdir:~/ugent/";
        }
      ];
    };
    rofi = {
      enable = true;
      location = "center";
    };
  };

  services = {
    gpg-agent = {
      enable = true;
      pinentryFlavor = "gtk2";
    };
  };
  
  gtk = {
    enable = true;
    theme = {
      name = "Catppucin-Mocha-Compact-Blue-Dark";
      package = pkgs.catppuccin-gtk.override {
        accents = ["blue"];
        size = "compact";
        variant = "mocha";
      };
    };
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
    font = {
      name = "FiraCode Nerd Font Mono Medium";
    };
  };
}
