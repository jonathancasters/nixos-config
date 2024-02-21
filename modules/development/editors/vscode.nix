{ config, lib, pkgs, user, ... } : 
{
  options.${user}.development.vscode = {
    enable = lib.mkOption {
      default = false;
      example = true;
    };
  };

  config = lib.mkIf config.${user}.development.vscode.enable {
    home-manager.users.${user} = { ... } : {
      programs.vscode = {
        enable = true;
        extensions = with pkgs.vscode-extensions; [
          ms-vscode-remote.remote-containers
          github.copilot
          # theming
          catppuccin
          catppuccin-vsc-icons
        ];
      };
    };
  };
}
