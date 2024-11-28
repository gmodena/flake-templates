{
  description = "C++20 development environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachSystem ["x86_64-linux" "aarch64-darwin"] (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };

        # Common packages for both platforms
        commonPackages = with pkgs; [
          cmake
          ninja
          lldb
          include-what-you-use
          cppcheck
        ];

        # Platform specific packages
        platformPackages = with pkgs;
          if system == "x86_64-linux" then [
            valgrind
          ] else [];

      in
      {
        devShells.default = pkgs.mkShell.override {
        stdenv = pkgs.clang18Stdenv; } {
          packages = commonPackages ++ platformPackages;

          shellHook = ''
            echo "C++20 Development Environment"
            echo "Available tools:"
            echo " - cmake (Build system)"
            ${if system == "x86_64-linux" then ''
              echo " - valgrind (Memory checker)"
            '' else ""}
          '';

          postShellHook = ''
            # Set CC and CXX environment variables to use clang
            export CC = "clang";
            export CXX = "clang++";
            '';
        };
      });
}
