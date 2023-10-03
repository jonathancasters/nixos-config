{ config, pkgs, user, ... }:

{
  imports = [(import ./hardware-configuration.nix)]; # current system hardware config @ /etc/hardware-configuration.nix
  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    
    loader = {
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot";
      };
      grub = {
        enable = true;
        devices = ["nodev"];
        efiSupport = true;
        useOSProber = true;
        configurationLimit = 2;
      };
      timeout = 1;
    };
  };
  services = {
    tlp.enable = true;                  # powermanagement
    blueman.enable = true;              # bluetooth
    xserver = {
      enable = true;
      layout = "us";
      displayManager = {
        lightdm.enable = true;
        defaultSession = "none+qtile";
      };
      desktopManager.xfce.enable = true;
      windowManager.qtile.enable = true;
      xkbVariant = "";
    };
  };
  networking = {
    hostName = "asus-vivobook-pro-16";
    networkmanager.enable = true;
  };
}
