{ config, lib, pkgs, user, ...} :
{
  options.${user}.development.docker = {
    enable = lib.mkOption {
      default = false;
      example = true;
    };
  };

  config = lib.mkIf config.${user}.development.docker.enable {
    virtualisation.docker.enable = true;
    environment.systemPackages = [ pkgs.docker-compose ];
    users.users.${user}.extraGroups = [ "docker" ];
  };
}
