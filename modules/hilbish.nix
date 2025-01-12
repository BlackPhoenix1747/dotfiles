{ pkgs, ... }:

let
  hilbish-git = pkgs.buildGoModule rec {
    pname = "hilbish-git";
    version = "master";

    src = pkgs.fetchFromGitHub {
      owner = "Rosettea";
      repo = "Hilbish";
      rev = "${version}";
      hash = "sha256-1al03n8vpl14gqccwnhaf52r2j89p9xhxrajjqpg1sybyb5nf9wb=";
      fetchSubmodules = true;
    };

    subPackages = [ "." ];

    vendorHash = "sha256-v5YkRZA8oOKwXa6yFGQ33jKEc742zIrmJ0+w8ggmu/0=";

    ldflags = [
      "-s"
      "-w"
      "-X main.dataDir=${placeholder "out"}/share/hilbish"
    ];

    postInstall = ''
      mkdir -p "$out/share/hilbish"

      cp .hilbishrc.lua $out/share/hilbish/
      cp -r docs -t $out/share/hilbish/
      cp -r libs -t $out/share/hilbish/
      cp -r nature $out/share/hilbish/
    '';

    meta = with pkgs.lib; {
      description = "Interactive Unix-like shell written in Go";
      mainProgram = "hilbish";
      #  changelog = "https://github.com/Rosettea/Hilbish/releases/tag/v${version}";
      #  homepage = "https://github.com/Rosettea/Hilbish";
      maintainers = with pkgs.maintainers; [ "moni" ];
      #   license = pkgs.licenses.mit;
    };
  };
in
{
  environment.systemPackages = with pkgs; [
    hilbish-git
  ];
}
