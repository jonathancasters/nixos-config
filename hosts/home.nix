{ config, lib, pkgs, user, ... }:

{
  home = {
    username ="${user}";
    homeDirectory = "/home/${user}";
    
    packages = with pkgs; [
      arandr    # Screen management
      autorandr 
      rofi      # Launch apps
      dconf
      simplescreenrecorder

      # printing
      hplip

      # Terminal 
      btop	# Resource manager
      ranger	# File manager
      tldr	# Helper
      ripgrep

      # Video/Audio
      pavucontrol
      vlc
      flameshot
      imagemagick

      # Apps
      brave
      spotify
      discord
      blender
      
      # Filemanagement
      zip
      unzip
      unrar
      xclip
      filezilla

      postman
      
      anki # flashcards
    ];
    
    stateVersion = "23.05";
  };
  
  programs = {
    home-manager.enable = true;
    direnv = {
      enable = true;
      enableZshIntegration = true;
    };
    ssh.enable = true;
    gpg.enable = true;
    rofi = {
      enable = true;
      location = "center";
    };
  };

  services = {
    gpg-agent = {
      enable = true;
      pinentryPackage = pkgs.pinentry-tty;
    };
  };
  
}
