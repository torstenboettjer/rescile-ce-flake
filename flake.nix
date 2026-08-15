{
  description = "Nix Flake for Rescile CE";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachSystem
      [
        "x86_64-linux"
        "aarch64-darwin"
      ]
      (system:
        let
          pkgs = import nixpkgs {
            inherit system;
            config.allowUnfree = true;
          };

          rescileCE = pkgs.callPackage ./pkgs/package.nix { };
        in
        {
          packages.default = rescileCE;
          packages.rescile-ce = rescileCE;

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
