default:
    @just --list

rebuild:
	git add .
	nh os switch .

repair:
	git add .
	nh os switch . -- --repair

rebuild-trace:
	git add .
	nh os switch . -- --show-trace

checks:
	. scripts/checks.sh

update:
	nix flake update --no-warn-dirty

rebuild-update:
	git add .
	nh os switch . -u

iso:
	git add .
	nix build .#nixosConfigurations.iso.config.system.build.isoImage

update-secrets:
	nix flake lock --update-input jaanonim-secrets

docs:
	git add .
	nix build .#docs