# UDS on NixOS

Builds [NixOS]-based OS images which automatically
bootstrap k8s/k3s clusters and deploy UDS bundles.

## Supported image types

This project uses [nixos-generators], which currently supports
over 30 differnt types of hypervisors and bare-metal hosts.

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

This builds [NixOS] systems using [nixos-generators](https://github.com/nix-community/nixos-generators/).
K3s single-node clusters are stood up in NixOS with the contents of [k3s-singlenode.nix](./src/modules/k3s-singlenode.nix)
Finally, a [UDS] bundle is applied using a systemctl unit, which runs after
k3s starts.

## Contributing

see [CONTRIBUTING.md](./CONTRIBUTING.md)

## References

[NixOS]: https://nixos.org/
[nixos-generators]: https://github.com/nix-community/nixos-generators/
[nixos-anywhere]: https://github.com/nix-community/nixos-anywhere/
[disko]: https://github.com/nix-community/disko
[nixos-facter]: https://github.com/nix-community/nixos-facter
[pixiecore]: https://github.com/danderson/netboot/tree/main/pixiecore
[SONiC]: https://github.com/sonic-net/SONiC
[UDS]: https://uds.defenseunicorns.com
