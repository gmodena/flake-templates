{
  description = "jdk8 and python3.7 development environment for macOS";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-21.11-darwin";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem
      (system:
        let pkgs = import nixpkgs {
          inherit system;
        }; in
        {
          devShell = pkgs.mkShell {
            buildInputs = with pkgs; [
              adoptopenjdk-openj9-bin-8
              sbt
              gradle
              python37
            ];
          };
        }
      );
}
