{
  description = "A collection of flake templates";

  outputs = { self, ... }: {
    templates = {
      pyspark-legacy-base-dev-env = {
        path = ./pyspark-legacy-base-dev-env;
        description = "jdk8, python3.7 and pyspark development environment for macOS";
      };
      minikube = {
        path = ./minikube;
        description = "minikube development environment for macOS";
      };
      impure-python = {
        path = ./impure-python;
        description = "python development environment with venv (legacy projects)";
      };
      rust = {
        path = ./rust;
        description = "rust development environment";
      };
    };
  };
}
