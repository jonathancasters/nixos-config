{ config, lib, pkgs, user, ... }:

{
  options.${user}.base.network.mobile = {
    enable = lib.mkOption {
      default = false;
      example = true;
    };
    wireless-interface = lib.mkOption {
      type = lib.types.str;
      example = "wlp2s0";
    };
    wired-interfaces = lib.mkOption {
      type = lib.types.attrs;
      example = { 
        "enp0s29f0u1u2" = { 
        }; 
      };
    };
  };

  config = with config.${user}.base.network.mobile; lib.mkIf enable {

    environment.systemPackages = with pkgs; [
      networkmanager_dmenu
      networkmanagerapplet
    ];

    users.users.${user}.extraGroups = ["network" "networkmanager"];
    users.groups.network = {};

    networking = {
      hostName = "asus-vivobook-pro-16";
      useDHCP = false;
      networkmanager.enable = true;
      wireless = {
        enable = true;
        interfaces = [ wireless-interface ];
        environmentFile = config.age.secrets."passwords/networks.age".path;
        userControlled = {
          enable = true;
          group = "network";
        };
        networks = {
          "telenet-28893".psk = "@PSK_telenet-28893@";
          "telenet-7F56A95".psk = "@PSK_telenet-7F56A95";
          "Nietjouwifi".psk = "@PSK_Nietjouwifi";
          "eduroam" = {
            authProtocols = [ "WPA-EAP" ];
            auth = ''
              eap=PEAP
              identity="@EDUROAM_USER@"
              password="@EDUROAM_PASS@"
            '';
            extraConfig = ''
              phase1="peaplabel=0"
              phase2="auth=MSCHAPV2"
              group=CCMP TKIP
              ca_cert="${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt"
              altsubject_match="DNS:radius.ugent.be"
            '';
          };
          "Wifibri" = {
            authProtocols = [ "WPA-EAP" ];
            auth = ''
              eap=PEAP
              identity="@WIFIBRI_USER@"
              password="@WIFIBRI_PASS@"
            '';
            extraConfig = ''
              phase1=""
              phase2="auth=MSCHAPV2"
              group=CCMP TKIP
            '';
          };
        };
      };
    };

    /*
    systemd-networkd is the network configuration component of the systemd software suite. 
    It is well integrated into NixOS below systemd.network and should be preferred over networking.interfaces options for most use cases, 
    since it receives far superior maintenance.
    */
    systemd.network = {
      enable = true;
      networks = {
        "${wireless-interface}" = {
          enable = true;
          DHCP = "yes";
          matchConfig = { Name = wireless-interface; };
          dhcpV4Config = { RouteMetric = 20; };
          ipv6AcceptRAConfig = { RouteMetric = 20; };
        };
      } // lib.mapAttrs
        (name: attrs: {
          enable = true;
          DHCP = "yes";
          matchConfig = { Name = name; };
          dhcpV4Config = { RouteMetric = 10; };
          ipv6AcceptRAConfig = { RouteMetric = 10; };
        } // attrs)
        wired-interfaces;
      wait-online.anyInterface = true;
    };

    age.secrets."passwords/networks.age" = {
      file = ../../secrets/passwords/networks.age;
    };
  };

}
