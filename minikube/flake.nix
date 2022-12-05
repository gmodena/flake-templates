{
description = "minikube development environment for macOS";

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
            minikube
            kubernetes-helm
            jq
          ];
          shellHook = ''
            . <(minikube completion bash)
            . <(helm completion bash)

            # kubectk and docker completion require the control plane to be running
            if [ $(minikube status -o json | jq -r .Host) = "Running" ]; then
              . <(kubectl completion bash)
              . <(minikube -p minikube docker-env)
            fi
          '';
        };
      }
    );
}
