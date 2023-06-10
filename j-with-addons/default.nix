{
  lib,
  fetchurl,
  symlinkJoin,
  j,
  stdenv,
}: let
  j_version = builtins.head (lib.splitString "-" j.version);

  javx =
    (
      j.override (old: rec {
        avxSupport = true;
      })
    )
    .overrideAttrs (old: rec {
      passAsFile = ["jaddons"];
      installPhase = ''
        runHook preInstall
        mkdir -p "$out/share/j/"
        cp -r $JLIB/{addons,system} "$out/share/j"
        cp -r $JLIB/bin "$out"
      '';
    });

  jaddon = {
    name,
    version,
    sha256,
  }:
    stdenv.mkDerivation {
      pname = "j-addon-${name}";
      version = version;
      src = fetchurl {
        url = "http://www.jsoftware.com/jal/j${j_version}/addons/${name}_${version}_linux.tar.gz";
        sha256 = sha256;
      };
      configurePhase = "";
      buildPhase = "";
      preInstall = "";
      postInstall = "";
      installPhase = ''
        runHook preInstall

        target=$out/addons/$(basename $PWD)
        mkdir -p $target
        cp -r ./ $target

        runHook postInstall
      '';
    };
in
  symlinkJoin {
    name = "j-with-addons";
    version = javx.version;
    paths =
      [
        javx
      ]
      ++ builtins.map jaddon [
        {
          name = "graphics_bmp";
          sha256 = "sha256-mHVN2/IyN/n9UC/TI6Z+VO28//HlqZ90MKhy3bPp7b4=";
          version = "1.0.17";
        }
        {
          name = "ide_qt";
          sha256 = "sha256-MoLpARBhPo4ijhYonz4SQBQITsP0e2TQYKfd/fn90p0=";
          version = "1.1.151";
        }
      ];
    postBuild = ''
      #  We can't just link because  jconsole looks for the path of the binary
      rm $out/bin/jconsole
      cp -L $(readlink -f ${javx}/bin/jconsole) $out/bin/jconsole

      for i in $out/addons/*
      do
        ln -s $i $out/share/j/addons/$(basename $i)
      done
    '';
  }
