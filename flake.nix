{
  description = "Kernel builder for Samsung galaxy A05s";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    nix-kernelsu-builder.url = "github:xddxdd/nix-kernelsu-builder";
  };
  outputs =
    { flake-parts, ... }@inputs:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        inputs.nix-kernelsu-builder.flakeModules.default
      ];
      systems = [ "x86_64-linux" ];
      perSystem =
        { pkgs, ... }:
        {
          devShells.default = pkgs.mkShell {
            buildInputs = [
              # pkgs.linuxPackages.kernel.configEnv
            ];
          };
          kernelsu =
            let
              arch = "arm64";
              clangVersion = "18";
              kernelPatches = [
                (pkgs.fetchpatch {
                  url = "https://github.com/cdpkp/android_kernel_tree_samsung_a05s/commit/72c67f9b85b492a8ba500ce2a03eff1bd78f6b9e.patch";
                  sha256 = "sha256-DXaih7kqe73nl6fT1dyMxT5IlSosYQTaPc/qENXn248=";
                })
                (pkgs.fetchpatch {
                  url = "https://github.com/cdpkp/android_kernel_tree_samsung_a05s/commit/9bd23082815e1c7b455d7384563a454023e0c202.patch";
                  sha256 = "sha256-/IrhIfDniqRZIvoAYmaCnaG9iWnWymKK4X0bmTHq0Ec";
                })
              ];

              kernelDefconfigs = [
                "gki_defconfig"
              ];
              kernelImageName = "Image";
              kernelSrc = ./.;
              oemBootImg = ./oem-boot.img;
            in
            rec {
              default = stock;
              stock = {
                inherit
                  arch
                  clangVersion
                  kernelPatches
                  kernelDefconfigs
                  kernelSrc
                  oemBootImg
                  kernelImageName
                  ;

                anyKernelVariant = "osm0sis";

                kernelSU.enable = false;
                susfs.enable = false;
              };
              kernelsu = {
                inherit
                  arch
                  clangVersion
                  kernelPatches
                  kernelDefconfigs
                  kernelSrc
                  oemBootImg
                  kernelImageName
                  ;

                anyKernelVariant = "kernelsu";

                kernelSU = {
                  enable = true;
                  variant = "sukisu-susfs";
                };
              };
            };
        };
    };
}
