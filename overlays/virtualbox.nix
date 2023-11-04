final: prev:
{
  virtualbox = prev.virtualbox.overrideAttrs (old: {
    patches = (old.patches or []) ++ [
      ../patches/vbox-7.0.10.patch
    ];
  });
}
