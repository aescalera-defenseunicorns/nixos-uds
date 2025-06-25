# UDS on NixOS

Builds [NixOS]-based OS images which automatically
bootstrap k8s/k3s clusters and deploy UDS bundles.

## Why

It's the ultimate DevSecOps pattern:

- **One source of truth** from the hardware up (declarative by design)
- **Fully automated** from OS -> Kubernetes -> UDS
- **Reproducible** thanks to the Nix ecosystem and UDS
- **Air‑gap ready** ideal for offline or constrained environments
- **Secure root-of-trust** hardware-based trust roots for inventory & secrets management
- **Faster iteration** faster time-to-market

## Supported image types

This project uses [nixos-generators], which currently supports
over 30 differnt types of hypervisors and bare-metal hosts.

```
amazon
azure
cloudstack
do
docker
gce
hyperv
install-iso
install-iso-hyperv
iso
kexec
kexec-bundle
kubevirt
linode
lxc
lxc-metadata
openstack
proxmox
proxmox-lxc
qcow
qcow-efi
raw
raw-efi
sd-aarch64
sd-aarch64-installer
sd-x86_64
vagrant-virtualbox
virtualbox
vm
vm-bootloader
vm-nogui
vmware
```

## Goals

- [x] build single-node k3s cluster and apply UDS bundle
- [x] uds-core deploys successfully
- [ ] integrate with [pixiecore], [nixos-anywhere], [disko], and [nixos-facter]
      to automatically report system hardware/virtualized hardware,
      serve kernel/initrd images with correct configuration based on host mac,
      enable unattended installs
- [ ] declaratively define and deploy sites
      (as far as your DHCP relays will take you)
- [ ] stand up single-node k3s cluster by default which starts
      remote attestation workloads
- [ ] enable automated bootstrapping/joining of nodes to clusters
      WITH GitOps/PR-based approval workflow
- [ ] bots to enable automated reporting/linking of remote attestation,
      hardware reports, etc to PRs
- [ ] Policy/risk engine + AI to (try to help) automate analysis of GitOps PRs.

### Moonshots

- [ ] Enable [SONiC] takeover installs with nixos-infect
- [ ] generate [SONiC] config from site configuration

## How it works

This builds [NixOS] systems using [nixos-generators].
K3s single-node clusters are stood up in NixOS with the contents of [k3s-singlenode.nix](./src/modules/k3s-singlenode.nix)
Finally, a [UDS] bundle is applied using a systemctl unit, which runs after
k3s starts.

## Contributing

see [CONTRIBUTING.md](./CONTRIBUTING.md)

## FOR HARDWARE MANUFACTURERS & DATA CENTER OPERATORS

nixos-uds integrates with TPM 2.0 devices via PKCS#11 for the following purposes:

- node identification
- hardware and software provenance
- remote attestation,
- secrets management

please see the [HARDWARE GUIDE](./HARDWARE.md) for instructions on generating
and validating cryptographic keys and artifacts.

## External References

[NixOS]: https://nixos.org/
[nixos-generators]: https://github.com/nix-community/nixos-generators/
[nixos-anywhere]: https://github.com/nix-community/nixos-anywhere/
[disko]: https://github.com/nix-community/disko
[nixos-facter]: https://github.com/nix-community/nixos-facter
[pixiecore]: https://github.com/danderson/netboot/tree/main/pixiecore
[SONiC]: https://github.com/sonic-net/SONiC
[UDS]: https://uds.defenseunicorns.com
