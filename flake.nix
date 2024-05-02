{
  description = "A Nix flake which demonstrates a problem with the nwjs-0.85 Nix package";

  inputs = {
    nixpkgs-nwjs-0_85.url = "github:nixos/nixpkgs?ref=d50a896ae5042d9bc9865bc2b00d1df3bd821a63";
    nixpkgs-nwjs-0_84.url = "github:nixos/nixpkgs?ref=841e26462b694d4e1933901139d23f0267b7010b";
    nixpkgs-nwjs-0_87.url = "github:r-ryantm/nixpkgs?ref=6d1b356cdd31df091ef1302643e35bb937156f24";
  };

  outputs = { self, nixpkgs-nwjs-0_84, nixpkgs-nwjs-0_85, nixpkgs-nwjs-0_87 }: {

    packages.x86_64-linux = let
      system = "x86_64-linux";
      pkgs-nwjs-0_84 = import "${nixpkgs-nwjs-0_84}" { inherit system; };
      pkgs-nwjs-0_85 = import "${nixpkgs-nwjs-0_85}" { inherit system; };
      pkgs-nwjs-0_87 = import "${nixpkgs-nwjs-0_87}" { inherit system; };

      hello-nwjs = { stdenvNoCC, writeScript, nwjs }:stdenvNoCC.mkDerivation rec {
        name = "hello-nwjs";
        version = "na";
        src = ./.;

        launcher = writeScript "hello-nwjs" ''
          ${nwjs}/bin/nw @out@/share
        '';

        installPhase = ''
          mkdir -p $out/{bin,share}
          cp index.html $out/share/
          cp package.json $out/share/
          cp ${launcher} $out/bin/hello-nwjs
          substituteAllInPlace $out/bin/hello-nwjs
        '';
      };
    in {
        hello-nwjs-0_84 = pkgs-nwjs-0_84.callPackage hello-nwjs {};
        hello-nwjs-0_85 = pkgs-nwjs-0_85.callPackage hello-nwjs {};
        hello-nwjs-0_87 = pkgs-nwjs-0_87.callPackage hello-nwjs {};
    };
  };
}
