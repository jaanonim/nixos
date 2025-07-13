# NixOS Configuration

My NixOS configuration

## Docs

My modules are documented at [jaanonim.github.io/nixos](https://jaanonim.github.io/nixos/).

## Usage

```bash
git clone git@github.com:jaanonim/nixos.git
cd nixos
nix develop
```

Build minimal vm:

```bash
nh os build-vm -H minimal .
```

Build iso image:

```bash
just iso
```

For more commands, see `just` file.
