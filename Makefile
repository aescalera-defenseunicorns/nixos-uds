SHELL = /usr/bin/env bash

UDS := $(shell { command -v uds && echo "uds" ; } || { ls -t /nix/store/*-uds-*/bin/uds-cli | head -n1; } )

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
	# mv ./uds-bundle-demo-bundle-amd64-0.0.1.tar.zst $@
	$(UDS) inspect $@

$(TMPD)/uds-config.yaml: uds-config.yaml
	mkdir -p $(@D)
	cp ./uds-config.yaml $@

amd64/%: $(TMPD)/uds-config.yaml $(TMPD)/uds-bundle-demo-bundle-amd64-0.0.1.tar.zst
	nix build --impure --show-trace '$(SRC)/.#packages.x86_64-linux.$(@F)' --out-link $(RESULT)/$@

arm64/%: $(TMPD)/uds-config.yaml $(TMPD)/uds-bundle-demo-bundle-arm64-0.0.1.tar.zst
	nix build --impure --show-trace '$(SRC)/.#packages.aarch64-linux.$(@F)' --out-link $(RESULT)/$@

show:
	nix flake show "$(SRC)" --all-systems

clean:
	rm -rf $(TMPD)
	rm -rf $(RESULT)
