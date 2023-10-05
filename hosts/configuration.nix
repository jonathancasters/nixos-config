{ config, lib, pkgs, inputs, user, ... }:

{
  # System user
  users.users.${user} = {
    isNormalUser = true;
    description = "Jonathan Casters";
    extraGroups = ["networkmanager" "wheel" "vboxusers" "video"];
    shell = pkgs.zsh;
  };


  time.timeZone = "Europe/Brussels";
  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_TIME = "nl_BE.UTF-8";
      LC_MONETARY = "nl_BE.UTF-8";
    };
  };

  location.provider = "geoclue2";
  
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
      alacritty
      autojump
      rofi
      htop
      nano
      killall
      alsa-utils
      pulseaudio
      wget
      acpilight
      # C/C++ development
      gnumake
      cmake
      gcc_multi
      binutils
    ];
  };

  programs = {
    thunar = {
      enable = true;
      plugins = with pkgs.xfce; [
        thunar-archive-plugin
        thunar-volman
        thunar-media-tags-plugin
      ];
    };
    zsh = {
      enable = true;
      autosuggestions.enable = true;
      syntaxHighlighting.enable = true;
      enableCompletion = true;

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
    # Sound
    pipewire = {
      enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
      pulse.enable = true;
      jack.enable = true;
    };
    # Color temperature screens
    redshift.enable = true;
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
  
  nixpkgs.config.allowUnfree = true;
  nixpkgs.overlays = [(final: prev: {
        virtualbox = prev.virtualbox.overrideAttrs (old: {
          patches = (old.patches or []) ++ [ ../patches/vbox-7.0.10.patch ];
        });
  })];

  # Virtualisation
  virtualisation.virtualbox.host.enable = true;
  #virtualisation.virtualbox.host.enableExtensionPack = true;
  
  system.stateVersion = "23.05";
}
