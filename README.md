# NixOS Configuration

This repository defines the NixOS host and the matching Home Manager setup for this machine. The config is split by concern so the system layer, desktop layer, dev tools, radio stack, browser policy, and secrets are independent modules instead of one large file.

## Layout

- `flake.nix`: flake entry point and system output
- `hosts/nixos/`: host composition for this machine
- `modules/nixos/`: NixOS modules split by concern
- `home/`: Home Manager modules split by area
- `scripts/`: bootstrap and verification helpers
- `secrets/`: encrypted secret examples and local templates

## Requirements

- Nix with flakes enabled
- A Linux machine matching the generated hardware config
- `git`
- `sops` plus `age` support for private values

## Quick Start

1. Clone the repo.
2. Run `scripts/secrets-bootstrap` to create `.sops.yaml` from the example and print the host age public key.
3. Replace the placeholder key in `.sops.yaml` with the real age recipient.
4. Run `scripts/secrets-edit` and fill `secrets/secrets.yaml` with your private values.
5. Build and switch:

```bash
sudo nixos-rebuild switch --flake .#nixos
```

## Verification

- `nix flake check`
- `nix build .#nixosConfigurations.nixos.config.system.build.toplevel --dry-run`
- `scripts/check`

## Secrets

Public repository content stays free of private identity data. Git identity, GPG signing key, and Matrix account details are read from `sops-nix` secrets when `secrets/secrets.yaml` exists.

The bootstrap flow is:

1. Create `.sops.yaml` from `.sops.yaml.example`.
2. Put the machine's age recipient in that file.
3. Edit `secrets/secrets.yaml` through `scripts/secrets-edit`.

The secret template lives at `secrets/secrets.example.yaml`.

## Notes

- `hardware-configuration.nix` is still generated and machine-specific.
- `home/radio/` contains user-space ham/radio applications.
- `modules/nixos/radio.nix` enables the system-level SDR support.
- `home/librewolf/` contains Firefox policy, profile, and extension setup.

## Rebuild

For routine updates:

```bash
git pull
sudo nixos-rebuild switch --flake .#nixos
```

For Home Manager-only changes, the same rebuild command is still the simplest path because Home Manager is wired through the NixOS configuration.
