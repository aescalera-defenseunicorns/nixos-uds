SHELL = /usr/bin/env bash
UDS := /nix/store/s2lryyz7hh3lshj6cpzs8hy33r9fvvzd-uds-0.27.6/bin/uds-cli

.PHONY: default clean vm/qcow

default: vm/qcow

uds-bundle.yaml:
	@:

uds-bundle.tar.zst: uds-bundle.yaml
	rm -f uds-bundle-*.tar.zst $@
	touch $@
	git add -f $@
	$(UDS) create --confirm
	mv $(shell realpath uds-bundle-*.tar.zst) $@
	git add $@

result: uds-bundle.tar.zst
	nix build --impure --show-trace './src/.#nixosConfigurations.nixos-uds-singlenode.config.formats.qcow'
	git restore --staged uds-bundle.tar.zst

vm/qcow: result
	
