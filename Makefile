SHELL = /usr/bin/env bash

PODMAN := $(shell command -v podman || command -v docker || { echo "no container runtime found" ; exit 1 ; } )
UDS := $(shell command -v uds || { ls -t /nix/store/*-uds-*/bin/uds-cli | head -n1; } )
# TODO: optimize this. caching derivations/builds, flake inputs, etc.
NIX := $(shell command -v nix || echo "$(PODMAN) run -it --entrypoint nix -v \"${PWD}:/code\" -v \"/tmp:/tmp\" --device=/dev/kvm -w /code docker.io/nixos/nix --extra-experimental-features nix-command --extra-experimental-features flakes" )

SRC = ./src

RESULT = ./result

# THIS MUST BE OUTSIDE OF THE CURRENT GIT REPO
TMP = /tmp
TMPD = $(TMP)/uds-bundle-nixos

.PHONY: default clean show amd64/% aarch64/%

default: amd64/qcow-efi

uds-bundle.yaml:
	@:

uds-config.yaml:
	@:

# nix will lose its mind if this is in the local
$(TMPD)/uds-bundle-demo-bundle-amd64-0.0.1.tar.zst: uds-bundle.yaml
	mkdir -p $(@D)
	$(UDS) create --confirm --output $(TMPD)
	$(UDS) inspect $@

$(TMPD)/uds-config.yaml: uds-config.yaml
	mkdir -p $(@D)
	cp ./uds-config.yaml $@

amd64/%: $(TMPD)/uds-config.yaml $(TMPD)/uds-bundle-demo-bundle-amd64-0.0.1.tar.zst
	$(NIX) build --impure --show-trace '$(SRC)/.#packages.x86_64-linux.$(@F)' --out-link $(RESULT)/$@

arm64/%: $(TMPD)/uds-config.yaml $(TMPD)/uds-bundle-demo-bundle-arm64-0.0.1.tar.zst
	$(NIX) build --impure --show-trace '$(SRC)/.#packages.aarch64-linux.$(@F)' --out-link $(RESULT)/$@

show:
	$(NIX) flake show "$(SRC)" --all-systems

clean:
	rm -rf $(TMPD)
	rm -rf $(RESULT)
