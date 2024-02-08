{ lib, ... } : 
let
  inherit (builtins) pathExists nameValuePair readDir;
  inherit (lib.strings) hasPrefix hasSuffix removeSuffix;
  inherit (lib.attrsets) filterAttrs mapAttrs';
in rec {

  # mapFilterAttrs ::
  #   (name -> value -> bool)
  #   (name -> value -> { name = any; value = any; })
  #   attrs
  mapFilterAttrs = pred: f: attrs: filterAttrs pred (mapAttrs' f attrs);

  mapModule = dir: fn:
    mapFilterAttrs (n: v: v != null && !(hasPrefix "_" n)) (n: v: 
      let
        path = "${toString dir}/${n}";
      in
        if v == "directory" && pathExists "${path}/default.nix"
          then nameValuePair n (fn path)
        else if v == "regular" && n != "default.nix" && hasSuffix ".nix" n
          then nameValuePair (removeSuffix ".nix" n) (fn path)
        else nameValuePair "" null) (readDir dir);  
}
