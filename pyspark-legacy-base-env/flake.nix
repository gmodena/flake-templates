{
  description = "jdk8 and python3.7 development environment for macOS";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-21.11-darwin";
    flake-utils.url = "github:numtide/flake-utils";
    mach-nix.url = "github:DavHau/mach-nix?ref=3.5.0";
  };

  outputs = { self, nixpkgs, flake-utils, mach-nix }:
    flake-utils.lib.eachDefaultSystem
      (system:
      let 
        python = "python38";
        mach-nix-wrapper = import mach-nix { inherit pkgs python; };
        pythonBuild = mach-nix-wrapper.mkPython {
          requirements = ''
            black
            pyflakes
            isort
            pyspark
            '';
          providers = {
            _default = "sdist";
          };
        };
        pkgs = import nixpkgs { inherit system; }; 
      in
        {
          devShell = pkgs.mkShell {
            buildInputs = with pkgs; [
              (pkgs.${python}.withPackages(ps: with ps; [ pip ]))
              adoptopenjdk-openj9-bin-8
              sbt
              gradle
              pythonBuild
            ];
          };
        }
      );
}
