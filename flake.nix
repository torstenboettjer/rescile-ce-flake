{
  description = "Nix Flake for Rescile CE";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config = {
            allowUnfree = true;
          };
        };

        rescileCE = pkgs.callPackage ./pkgs/package.nix { };
      in
      {
        # packages (build artifacts)
        packages.default = rescileCE;
        packages.rescile-ce = rescileCE;

        # devShell (direnv / nix develop environment)
        devShells.default = pkgs.mkShell {
          packages = [
            rescileCE
          ];

          shellHook = ''
            echo "Rescile CE devShell active"
          '';
        };
      });
}
