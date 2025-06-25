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

Contributors are expected to use the `make` build system automation in this repo.
The only requirements are an `amd64-linux`-based system, `nix`, and `uds`.
This will soon change to only require an OCI-compliant container runtime.

## Contracts

Assumptions and expected use cases that other developers can rely upon to be
provided by the code in this repo.

### Data

This repo will reliably consume or produce...

#### Inputs

- uds-bundle.yaml
- uds-config.yaml (optional)

#### Outputs

(non-exhaustive)

##### Images

any of the nixos-generators supported image formats

##### Environments

- local dev env
- CI dev env

### Functions

### CI

- build

### Local Dev

- build
