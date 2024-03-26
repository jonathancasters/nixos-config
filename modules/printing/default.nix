{ config, lib, pkgs, user, ... }:
{
  options.${user}.printing.enable = lib.mkOption {
    default = false;
    example = true;
  };

  config = lib.mkIf config.${user}.printing.enable {
    services = {
      printing = {
        enable = true;
        drivers = with pkgs; [
          hplip
        ];
      };
      avahi = {
        enable = true;
        nssmdns4 = true;
        openFirewall = true;
      };
    };
  };
}
