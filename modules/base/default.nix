{ config, lib, pkgs, ... }:

{
  imports = [
    ./network.nix
    ./openssh.nix
  ];

}
