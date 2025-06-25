{
  description = "NixOS image: single-node k3s + UDS bundle (multi-format)";

  inputs = {
    # Upstream nixpkgs for core packages
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixos-unstable";
    };

    # custom nixpkgs fork containing the uds package
    udspkgs = {
      url = "github:aescalera-defenseunicorns/nixpkgs/add-uds-package";
    };

    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {
    self,
    udspkgs,
    nixpkgs,
    nixos-generators,
    ...
  }: let
    system = "x86_64-linux";

    # Define an overlay that pulls `uds` from your fork
    udsOverlay = final: prev: {
      uds = (import udspkgs {inherit system;}).uds;
    };

    # Import nixpkgs + our overlay
    customPkgs = import nixpkgs {
      inherit system;
      overlays = [udsOverlay];
    };

    specialArgs =
      inputs
      // {
        inherit system customPkgs;
      };
  in {
    # a machine consuming the module
    nixosConfigurations.nixos-uds-singlenode = nixpkgs.lib.nixosSystem {
      inherit system;
      inherit specialArgs;
      modules = [
            {
              # Pin nixpkgs to the flake input, so that the packages installed
              # come from the flake inputs.nixpkgs.url.
              nix.registry.nixpkgs.flake = nixpkgs;
              # set disk size to to 20G
              virtualisation.diskSize = 20 * 1024;
            }
        nixos-generators.nixosModules.all-formats
        ./modules/common.nix
        ./modules/k3s-singlenode.nix
        ./modules/uds.nix
      ];
    };
  };
}
