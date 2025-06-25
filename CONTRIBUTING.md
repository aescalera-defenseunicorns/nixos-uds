# Contributing to nixos-uds

## Layout

```bash
tree .
.
├── CONTRIBUTING.md # this guide!
├── Makefile # local build automation
├── README.md # general need-to-knows
├── src
│   ├── flake.lock # state tracking of the flake inputs and other stuff
│   ├── flake.nix # top-level config
│   └── modules # re-usable modules which can be imported by machines
│       ├── common.nix # all nodes get this
│       ├── k3s-singlenode.nix # deploys a single-node k3s cluster
│       └── uds.nix # deploys the UDS bundle with a systemctl unit
├── uds-bundle.yaml # UDS bundle manifest
└── uds-config.yaml # UDS config
```

## Building

use `make`.
The only requirements are an `amd64-linux`-based system, `nix`, and `uds`.
