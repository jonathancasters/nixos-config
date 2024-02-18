{ config, lib, user, ...} :
{
  options.${user}.development.git = {
    enable = lib.mkOption {
      default = false;
      example = true;
    };
  };

  config = lib.mkIf config.${user}.development.git.enable {
    # TODO: change nvim plugins depending on git usage 
    home-manager.users.${user} = {
      programs.git = {
          enable = true;
          userName = "jonathancasters";
          userEmail = "jonathancasters284@gmail.com";

          extraConfig = {
            init.defaultBranch = "main";
            user.signingkey = "B9A05FF81B94474C";
            commit.gpgSign = true;
            core = {
              sshCommand = "ssh -i ~/.ssh/id_ed25519_personal";
            };
          };

          includes = [
            {
              contents = {
                user = {
                  name = "jpcaster";
                  email = "jonathan.casters@ugent.be";
                  signingkey = "40FF8380DB6F5FA9";
                };
                core = {
                  sshCommand = "ssh -i ~/.ssh/id_ed25519_school";
                };
              };
              condition = "gitdir:~/ugent/";
            }
          ];
        };
      }; 
  };
}
