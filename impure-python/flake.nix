{
  # Based on https://ryantm.github.io/nixpkgs/languages-frameworks/python/#python
  # (modified).
  description = "Nix Development Flake for python legacy projects";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.11";

  outputs =
    { self, nixpkgs, flake-utils }:

    flake-utils.lib.eachDefaultSystem
      (system:
      let
        pkgs = import nixpkgs { inherit system; };
        python = pkgs.python310;
        pythonPackages = python.pkgs;
        # A set of system dependencies for Python modules.
        # They act as build inputs and are used to configure
        # LD_LIBRARY_PATH in the shell.
        systemPackages = with pkgs; [
            taglib
            openssl
            git
            libxml2
            libxslt
            libzip
            zlib
            stdenv.cc.cc.lib
          ]; 
      in
      {
        devShells.default = pkgs.mkShell {
          name = "impurePythonEnv";
          venvDir = ".venv";
          buildInputs = [
            pythonPackages.python
            # This executes some shell code to initialize 
            # a venv in $venvDir before dropping into the shell
            pythonPackages.venvShellHook

            # Those are dependencies that we would like 
            # to use from nixpkgs, which will add 
            # them to PYTHONPATH and thus make them accessible 
            # from within the venv.
            #pythonPackages.numpy
          ] 
          ++ systemPackages;

          postVenvCreation = ''
            unset SOURCE_DATE_EPOCH
          '';

          postShellHook = ''
            unset SOURCE_DATE_EPOCH
            export LD_LIBRARY_PATH=${pkgs.lib.makeLibraryPath libraryPath}
            pip install -r ${requirementsFile}
          '';
        };
      });
}
