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

    };
  };
}
