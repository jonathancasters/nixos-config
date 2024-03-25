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
        configurationLimit = 4;
      };
      timeout = 1;
    };
  };
  services = {
    tlp.enable = true;                  # powermanagement
    blueman.enable = true;              # bluetooth
  };
}
