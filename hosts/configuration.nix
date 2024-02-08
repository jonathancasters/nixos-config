{ config, lib, pkgs, inputs, user, ... }:

{
  # define all system users
  users.users.${user} = {
    isNormalUser = true;
    description = "Jonathan Casters";
    extraGroups = ["networkmanager" "wheel" "vboxusers" "video"];
    shell = pkgs.zsh;
  };

  # define locale settings
  time.timeZone = "Europe/Brussels";
  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_TIME = "nl_BE.UTF-8";
      LC_MONETARY = "nl_BE.UTF-8";
    };
  };

  # enable gps
  location.provider = "geoclue2";
  
  # TODO: Remove fonts here and add to 'theme' module
  fonts.fonts = with pkgs; [
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
  
  environment = {
    variables = {
      TERMINAL = "alacritty";
      EDITOR = "nvim";
      VISUAL = "nvim";
    };
    systemPackages = with pkgs; [
      # process management
      htop                      # process overview 
      killall                   # kill process by name
      # sound
      alsa-utils                
      pulseaudio
      # network management
      networkmanagerapplet
      # C/C++ development
      clang-tools
      gnumake
      cmake
      gcc_multi
      binutils
      # other 
      sshfs                    # remote filesystem
      wget                     # download from url (in terminal)
      acpilight                # replacement for xbacklight TODO: check if it works
    ];
  };

  programs = {
    # file browser
    thunar = {
      enable = true;
      plugins = with pkgs.xfce; [
        thunar-archive-plugin
        thunar-volman
        thunar-media-tags-plugin
      ];
    };
    # terminal
    zsh = {
      enable = true;
      autosuggestions.enable = true;
      syntaxHighlighting.enable = true;
      enableCompletion = true;

      shellAliases = {
        hpc = "ssh vsc45383@login.hpc.ugent.be -i ~/.ssh/id_ed25519_school";
      };

      histSize = 100000;
      histFile = "~/.histfile";

      ohMyZsh = {
        enable = true;
      	theme = "robbyrussell";
        plugins = [
          "git" "aliases" "sudo" 
        ];
      };
    };
  };

  services = {
    # sound
    pipewire = {
      enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
      pulse.enable = true;
      jack.enable = true;
    };
    # color temperature screens
    redshift.enable = true;
    # remote control
    teamviewer.enable = true;
    openssh.allowSFTP = true;
  };

  nix = {
    settings.auto-optimise-store = true;
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than-2d";
    };
    package = pkgs.nixVersions.unstable;
    registry.nixpkgs.flake = inputs.nixpkgs;
    extraOptions = ''
       experimental-features = nix-command flakes
       keep-outputs          = true
       keep-derivations      = true
    '';
  };

  # virtualisation
  virtualisation.virtualbox.host.enable = true;
  #virtualisation.virtualbox.host.enableExtensionPack = true;
  
  system.stateVersion = "23.05";
}
