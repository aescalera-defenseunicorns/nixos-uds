SHELL = /usr/bin/env bash

UDS := $(shell { command -v uds && echo "uds" ; } || { ls -t /nix/store/*-uds-*/bin/uds-cli | head -n1; } )

.PHONY: default clean vm/qcow

default: vm/qcow

uds-bundle.yaml:
	@:

uds-config.yaml:
	@:

/tmp/uds-bundle-nixos/uds-bundle-demo-bundle-amd64-0.0.1.tar.zst: uds-bundle.yaml
	$(UDS) create --confirm
	mkdir -p $(shell dirname $@)
	mv ./uds-bundle-demo-bundle-amd64-0.0.1.tar.zst $@
	$(UDS) inspect $@

/tmp/uds-bundle-nixos/uds-config.yaml: uds-config.yaml
	cp ./uds-config.yaml $@

result: /tmp/uds-bundle-nixos/uds-config.yaml /tmp/uds-bundle-nixos/uds-bundle-demo-bundle-amd64-0.0.1.tar.zst
	nix build --impure --show-trace './src/.#nixosConfigurations.nixos-uds-singlenode.config.formats.qcow-efi'

vm/qcow: result
	
