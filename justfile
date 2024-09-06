TAG:="laptop"

default:
  @just --list

rebuild-pre:
	git add .

rebuild:
	just rebuild-pre
	sudo nixos-rebuild switch --impure --flake ./#{{TAG}}

rebuild-trace:
	just rebuild-pre
	sudo nixos-rebuild switch --impure --flake ./#{{TAG}} --show-trace

checks:
	. scripts/checks.sh

update:
	nix flake update --no-warn-dirty

rebuild-update:
	just update
	just rebuild

iso:
	just rebuild-pre
	nix build .#nixosConfigurations.iso.config.system.build.isoImage

update-secrets:
	nix flake lock --update-input jaanonim-secrets
