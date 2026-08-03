default:
    @just --list

rebuild:
	git add .
	nh os switch .

alias boot := rebuild-boot
rebuild-boot:
	git add .
	nh os boot .

repair:
	git add .
	nh os switch . -- --repair

rebuild-trace:
	git add .
	nh os switch . -- --show-trace

alias check := checks
checks:
	nix flake check --all-systems

update:
	nix flake update --no-warn-dirty

rebuild-update:
	git add .
	nh os switch . -u

iso:
	git add .
	nix build .#nixosConfigurations.iso.config.system.build.isoImage

update-secrets:
	nix flake update jaanonim-secrets

docs:
	git add .
	nix build .#docs

# -- --log-format internal-json -v |& nom --json

homepi:
	git add .
	deploy .#homepi -c

nas:
	git add .
	deploy .#nas -c