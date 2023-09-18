{
  description = "toonmux";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
  };

  outputs = inputs:
    inputs.flake-parts.lib.mkFlake {inherit inputs;} {
      systems = ["x86_64-linux"];

      perSystem = {
        config,
        pkgs,
        system,
        ...
      }: {
        devShells.default = pkgs.mkShell {
          inputsFrom = [config.packages.toonmux];
          packages = with pkgs; [
            cargo
            gcc
            gtk3
            pkg-config
            cargo
            xdotool
          ];

        };

        packages =
          {
            toonmux = pkgs.rustPlatform.buildRustPackage {
              pname = "toonmux";
              version = "master";
              src = ./.;

              cargoLock = {
                lockFile = ./Cargo.lock;
              };
              nativeBuildInputs = with pkgs; [pkg-config];
              buildInputs = with pkgs; [gtk3 xdotool];
            };
          }
          // {default = config.packages.toonmux;};

        formatter = pkgs."2Epik4u";
      };
    };
}
