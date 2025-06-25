SHELL = /usr/bin/env bash

.PHONY: default vm/qcow

default: vm/qcow

uds-bundle.yaml:
	@:

src/uds-bundle.tar.zst: uds-bundle.yaml
	rm -f uds-bundle*.tar.zst src/uds-bundle.tar.zst
	# uds create --confirm
	/nix/store/s2lryyz7hh3lshj6cpzs8hy33r9fvvzd-uds-0.27.6/bin/uds-cli create --confirm
	ln -s $(shell realpath uds-bundle*.tar.zst) $@

result: src/uds-bundle.tar.zst
	nix build --show-trace './src/.#nixosConfigurations.udsOS-singlenode.config.formats.qcow'

vm/qcow: result
