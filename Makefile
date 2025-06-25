SHELL = /usr/bin/env bash
UDS := /nix/store/s2lryyz7hh3lshj6cpzs8hy33r9fvvzd-uds-0.27.6/bin/uds-cli

.PHONY: default clean vm/qcow

default: vm/qcow

uds-bundle.yaml:
	@:

/tmp/uds-bundle-nixos/uds-bundle-nixos-amd64-0.0.1.tar.zst: uds-bundle.yaml
	$(UDS) create --confirm --name nixos --architecture amd64
	mkdir -p $(shell dirname $@)
	mv $(shell realpath uds-bundle-nixos*.tar.zst) $@
	$(UDS) inspect $@

result: /tmp/uds-bundle-nixos/uds-bundle-nixos-amd64-0.0.1.tar.zst
	nix build --impure --show-trace './src/.#nixosConfigurations.nixos-uds-singlenode.config.formats.qcow-efi'

vm/qcow: result
	
