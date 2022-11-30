{
  description = "jdk8, python3.7 and pyspark development environment for macOS";

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
            '';
           _.tomli.propagatedBuildInputs.mod = pySelf: self: oldVal: oldVal ++ [ pySelf.flit-core ];
          };
        pkgs = import nixpkgs { inherit system; }; 
      in
        {
          devShell = pkgs.mkShell {
            buildInputs = with pkgs; [
              (pkgs.${python}.withPackages(ps: with ps; [ pip pyspark ]))
              adoptopenjdk-openj9-bin-8
              sbt
              gradle
              pythonBuild
            ];
          };

        }
      );
}
