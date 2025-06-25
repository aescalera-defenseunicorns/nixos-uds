{
  description = "NixOS image: single-node k3s + UDS bundle (multi-format)";

  inputs = {
    nixpkgs = {
      url = "github:aescalera-defenseunicorns/nixpkgs/add-uds-package";
    };

    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    nixos-generators,
    ...
  }: let
    system = "x86_64-linux";

    # Import your forked nixpkgs (which includes uds)
    pkgs = import nixpkgs {
      inherit system;
    };

    # Helper to generate one image in the given format
    makeImage = format:
      nixos-generators.nixosGenerate {
        inherit system;
        # Pass pkgs and udsBundle into the module
        specialArgs = {inherit pkgs udsBundle;};

        modules = [
          # External module expecting config, pkgs, udsBundle
          ./uds.nix
        ];

        format = format;
      };
  in {
    packages.${system} = {
      k3s-uds-raw = makeImage "raw";
      k3s-uds-iso = makeImage "iso";
      k3s-uds-qcow = makeImage "qcow";
    };

    # Default to raw if you just run `nix build`
    defaultPackage.${system} = self.packages.${system}.k3s-uds-raw;
  };
}
