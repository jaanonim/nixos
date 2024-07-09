TAG:="virtualbox"

default:
  @just --list

rebuild-pre:
	git add .

rebuild:
	just rebuild-pre
	sudo nixos-rebuild switch --impure --flake ./#{{TAG}} --no-warn-dirty

rebuild-trace:
	just rebuild-pre
	sudo nixos-rebuild switch --impure --flake ./#{{TAG}} --show-trace --no-warn-dirty

update:
	nix flake update --no-warn-dirty

rebuild-update:
	just update
	just rebuild

