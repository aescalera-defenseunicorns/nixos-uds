SHELL = /usr/bin/env bash

.PHONY: default clean vm/qcow

default: vm/qcow

uds-bundle.yaml:
	@:

src/uds-bundle.tar.zst: uds-bundle.yaml
	rm -f uds-bundle*.tar.zst src/uds-bundle.tar.zst
	uds create --confirm
	ln -s $(shell realpath uds-bundle*.tar.zst) $@

result: src/uds-bundle.tar.zst
	nix build --show-trace './src/.#nixosConfigurations.nixos-uds-singlenode.config.formats.qcow'

vm/qcow: result
