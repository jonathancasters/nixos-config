{ config, lib, pkgs, inputs, user, ... }:

{
  imports = [
    ../modules
  ];

  # Custom modules settings
  ${user} = {
    development.enable = true;
    graphical.enable = true;
    printing.enable = true;
    base = {
      network.mobile = {
        enable = true;
        wireless-interface = "wlp44s0";
        wired-interfaces = {
          "enp45s0" = { };
        };
      };
    };
  };

  # define all system users
  users.users.${user} = {
    isNormalUser = true;
    description = "Jonathan Casters";
    extraGroups = ["networkmanager" "wheel" "vboxusers"];
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
      deja-dup                 # backups
      ntfs3g                   # support ntfs mounts
      inputs.agenix.packages.x86_64-linux.default
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
          "git" "aliases" "sudo" "direnv"
        ];
      };

      interactiveShellInit = ''
        eval "$(direnv hook zsh)"
      '';
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
    gnome.gnome-keyring.enable = true;
    # enable auto mounting for removable devices on Thunar
    gvfs.enable = true;
    # enable thumbnail images on Thunar
    tumbler.enable = true;
  };

  nix = {
    settings.auto-optimise-store = true;
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than-2d";
    };
    package = pkgs.nixVersions.git;
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
