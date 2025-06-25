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

    supportedFormats = [
      "amazon"
      "azure"
      "cloudstack"
      "do"
      "docker"
      "gce"
      "hyperv"
      "install-iso"
      "install-iso-hyperv"
      "iso"
      "kexec"
      "kexec-bundle"
      "kubevirt"
      "linode"
      "lxc"
      "lxc-metadata"
      "openstack"
      "proxmox"
      "proxmox-lxc"
      "qcow"
      "qcow-efi"
      "raw"
      "raw-efi"
      "sd-aarch64"
      "sd-aarch64-installer"
      "sd-x86_64"
      "vagrant-virtualbox"
      "virtualbox"
      "vm"
      "vm-bootloader"
      "vm-nogui"
      "vmware"
    ];

    specialArgs =
      inputs
      // {
        inherit system customPkgs nixos-generators;
      };

    # formatNames = builtins.attrNames nixos-generators.formats;
  in {
    # a machine consuming the module
    nixosConfigurations.nixos-uds-singlenode = nixpkgs.lib.nixosSystem {
      inherit system;
      inherit specialArgs;
      modules = [
        # ({ lib, config, ... }: {
        #   config.formatConfigs =
        #     lib.genAttrs supportedFormats (_: { size = "16G"; });
        # })
        {
          # Pin nixpkgs to the flake input, so that the packages installed
          # come from the flake inputs.nixpkgs.url.
          nix.registry.nixpkgs.flake = nixpkgs;
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
