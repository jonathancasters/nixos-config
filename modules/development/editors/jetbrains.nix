{ config, lib, pkgs, user, ... } : 
{
  options.${user}.development.jetbrains = {
    enable = lib.mkOption {
      default = false;
      example = true;
    };
  };

  # Inspired by https://github.com/rien/nixos-config/blob/master/modules/intellij.nix
  config = lib.mkIf config.${user}.development.jetbrains.enable {
    home-manager.users.${user} = let
      overrideWithGApps = (pkg: pkg.overrideAttrs (oldAttrs: {nativeBuildInputs = oldAttrs.nativeBuildInputs ++ [ pkgs.wrapGAppsHook ];}));
      devSDKs = with pkgs; {
        python = python3;
        node = nodejs;
        yarn = yarn;
        c = clang_14;
        make = gnumake;
        valgrind = valgrind;
        dutch = hunspellDicts.nl_nl;
      };
      extraPath = lib.makeBinPath (builtins.attrValues devSDKs);
      idea-with-copilot = pkgs.jetbrains.plugins.addPlugins pkgs.jetbrains.idea-ultimate [ "github-copilot" ];
      clion-with-copilot = pkgs.jetbrains.plugins.addPlugins pkgs.jetbrains.clion [ "github-copilot" ];
      nix-ld-path = lib.makeLibraryPath [
        pkgs.stdenv.cc.cc
      ];
      nix-ld = "$(cat '${pkgs.stdenv.cc}/nix-support/dynamic-linker')";
      intellij = pkgs.runCommand "intellij"
        { nativeBuildInputs = [ pkgs.makeWrapper ]; }
        ''
          mkdir -p $out/bin
          makeWrapper ${idea-with-copilot}/bin/idea-ultimate \
            $out/bin/intellij \
            --prefix PATH : ${extraPath} \
            --set NIX_LD_LIBRARY_PATH "${nix-ld-path}" \
            --set NIX_LD "${nix-ld}"
        '';
      pycharm = pkgs.runCommand "pycharm"
        { nativeBuildInputs = [ pkgs.makeWrapper ]; }
        ''
          mkdir -p $out/bin
          makeWrapper ${pkgs.jetbrains.pycharm-professional}/bin/pycharm-professional \
            $out/bin/pycharm \
            --prefix PATH : ${extraPath} \
            --set NIX_LD_LIBRARY_PATH "${nix-ld-path}" \
            --set NIX_LD "${nix-ld}"
        '';
      clion = pkgs.runCommand "clion"
        { nativeBuildInputs = [ pkgs.makeWrapper ]; }
        ''
          mkdir -p $out/bin
          makeWrapper ${clion-with-copilot}/bin/clion \
            $out/bin/clion \
            --set NIX_CC ${devSDKs.c}/bin/cc \
            --prefix PATH : ${extraPath} \
            --set NIX_LD_LIBRARY_PATH "${nix-ld-path}" \
            --set NIX_LD "${nix-ld}"
        '';
    in { ... }: {
      home.packages = [ intellij clion pycharm ];
      home.file.".local/dev".source = let
          mkEntry = name: value: { inherit name; path = value; };
          entries = lib.mapAttrsToList mkEntry devSDKs;
        in pkgs.linkFarm "local-dev" entries;
    };
  };
}
