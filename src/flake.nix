{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    udspkgs = {
      url = "github:aescalera-defenseunicorns/nixpkgs/add-uds-package";
    };
  };

  outputs = {
    nixpkgs,
    nixos-generators,
    udspkgs,
    ...
  }: let
    pkgsForSystem = system:
      import nixpkgs {
        inherit system;
        overlays = [
          (final: prev: {
            uds = (import udspkgs {inherit system;}).uds;
          })
        ];
      };

    # nixos-generators doesn't export this list or attrs, so we have to set it manually.
    # last modified: 2025-06-24
    formats = [
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

    allVMs = ["x86_64-linux" "aarch64-linux"];

    forAllVMsFormats = f:
      nixpkgs.lib.genAttrs allVMs (
        system:
          nixpkgs.lib.genAttrs formats (
            format:
              f {
                inherit system format;
                pkgs = pkgsForSystem system;
              }
          )
      );
  in {
    packages = forAllVMsFormats ({
      system,
      format,
      pkgs,
    }:
      nixos-generators.nixosGenerate {
        inherit system format;
        modules = [
          {nixpkgs.pkgs = pkgs;}
          {
            nix.registry.nixpkgs.flake = nixpkgs;
            virtualisation.diskSize = 30 * 1024;
          }
          ./modules/common.nix
          ./modules/k3s-singlenode.nix
          ./modules/uds.nix
        ];
      });
  };
}
