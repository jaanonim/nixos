TAG:="virtualbox"

default:
  @just --list

rebuild-pre:
	git add *.nix

rebuild:
	just rebuild-pre
	sudo nixos-rebuild switch --impure  --flake ./#{{TAG}}

rebuild-trace:
	just rebuild-pre
	sudo nixos-rebuild switch --impure  --flake ./#{{TAG}} --show-trace

update:
	nix flake update

rebuild-update:
	just update
	just rebuild
