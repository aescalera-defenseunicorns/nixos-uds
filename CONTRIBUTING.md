# Contributing to nixos-uds

## Layout

```bash
tree .
.
├── Makefile # local build automation
├── src
│   ├── flake.lock
│   ├── flake.nix
│   ├── modules # re-usable modules which can be imported by machines
│   │   ├── common.nix # all nodes get this
│   │   ├── k3s-singlenode.nix # deploys a single-node k3s cluster
│   │   └── uds.nix # deploys the UDS bundle with a systemctl unit
│   └── uds-bundle.tar.zst -> ../uds-bundle-demo-bundle-amd64-0.0.1.tar.zst
├── uds-bundle-demo-bundle-amd64-0.0.1.tar.zst # UDS bundle tarball
└── uds-bundle.yaml # UDS bundle manifest
```

## Building

### First-time builds

Use `make -B` for first-time builds.
Subsequent builds may use `make`.
