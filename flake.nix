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
          kernelsu = {
            default = {
              arch = "arm64";
              anyKernelVariant = "kernelsu";
              clangVersion = "18";

              kernelSU.enable = false;
              susfs.enable = false;

              kernelPatches = [
                (pkgs.fetchpatch {
                  url = "https://github.com/cdpkp/android_kernel_tree_samsung_a05s/commit/7d9b335ca739f0c559cdbc15ebae807c62296f07.patch";
                  sha256 = "sha256-N8ii8wJtQpJbLQHvzJLgqTeTrlNN0LMSpKQ1EZumL4k=";
                })
                (pkgs.fetchpatch {
                  url = "https://github.com/cdpkp/android_kernel_tree_samsung_a05s/commit/72c67f9b85b492a8ba500ce2a03eff1bd78f6b9e.patch";
                  sha256 = "sha256-FTcURki4RA6aMw+LGuSln1lKHsWwCDNvpRu1aKss9gU=";
                })
                (pkgs.fetchpatch {
                  url = "https://github.com/cdpkp/android_kernel_tree_samsung_a05s/commit/9bd23082815e1c7b455d7384563a454023e0c202.patch";
                  sha256 = "sha256-Ekf9DwjPKg66KsbcDAY85PoH3te39GalRtLJbA0xJno=";
                })
              ];

              kernelDefconfigs = [
                "gki_defconfig"
              ];
              kernelImageName = "Image";
              kernelSrc = ./.;
              oemBootImg = ./oem-boot.img;
            };
          };
        };
    };
}
