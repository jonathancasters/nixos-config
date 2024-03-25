{ config, lib, pkgs, user, ... }:

{
  home = {
    username ="${user}";
    homeDirectory = "/home/${user}";
    
    packages = with pkgs; [
      arandr    # Screen management
      rofi      # Launch apps
      dconf
      simplescreenrecorder

      # printing
      hplip

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

      insomnia
      
      anki # flashcards
    ];
    
    stateVersion = "23.05";
  };
  
  programs = {
    home-manager.enable = true;
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
      pinentryFlavor = "gtk2";
    };
  };
  
}
