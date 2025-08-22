# deploy:
# nix-shell -p just nh
# just switch

default:
    @just --list

# Rebuild and switch to the new configuration
[group('nix')]
switch:
    @# nixos-rebuild switch --sudo --flake .
    nh os switch .

# Rebuild and switch to the new configuration with debug output
[group('nix')]
debug:
    @# nixos-rebuild switch --sudo --flake . --show-trace --verbose
    nh os switch --verbose --ask .

# Update all the flake inputs and switch to the new configuration
[group('nix')]
update:
    @# nix flake update --commit-lock-file
    @# nixos-rebuild switch --sudo --flake .
    nh os switch --update --ask .

# Garbage collect all unused nix store entries & remove old generations
[group('nix')]
clean:
    @# # remove all generations older than 7 days
    @# sudo nix profile wipe-history --profile /nix/var/nix/profiles/system --older-than 7d
    @# # garbage collect all unused nix store entries(system-wide)
    @# sudo nix-collect-garbage --delete-older-than 7d
    @# # garbage collect all unused nix store entries(for the user - home-manager)
    @# # https://github.com/NixOS/nix/issues/8508
    @# nix-collect-garbage --delete-older-than 7d
    nh clean all --ask --keep 5 --keep-since 7d

# Rollback to a previous generation
[group('nix')]
rollback:
    @# nix profile rollback --profile /nix/var/nix/profiles/system
    nh os rollback --ask

# List all generations of the system profile
[group('nix')]
info:
    @# nix profile history --profile /nix/var/nix/profiles/system
    nh os info

# TODO: use nh (it's too slow)
# Open a nix shell with the flake's nixpkgs
[group('nix')]
repl:
    # Load the flake with `:lf .`
    nix repl -f flake:nixpkgs
    @# nh os repl .

# Build a `NixOS` VM image
[group('nix')]
build-vm:
    nh os build-vm

# Format all files
fmt:
    nix fmt .

# TODO: add typos & make this CI
# Run checks
check:
    @# -alejandra --check .
    @# -statix check
    @# deadnix --no-lambda-pattern-names
    nix flake check
