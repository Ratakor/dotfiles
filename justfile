# $XDG_CONFIG_HOME/nix/nix.conf
# extra-experimental-features = nix-command flakes
# nix shell nixpkgs#just nixpkgs#nh
# just switch

default:
    @just --list

# Rebuild and switch to the new configuration
[group('nh')]
switch host="$(hostname)":
    @# nixos-rebuild switch --sudo --flake .
    nh os switch --hostname {{host}} .

# Build a `NixOS` VM image
[group('nh')]
build-vm host="$(hostname)":
    nh os build-vm --hostname {{host}} .

# Garbage collect all unused nix store entries & remove old generations
[group('nh')]
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
[group('nh')]
rollback:
    @# nix profile rollback --profile /nix/var/nix/profiles/system
    nh os rollback --verbose --ask

# List all generations of the system profile
[group('nh')]
info:
    @# nix profile history --profile /nix/var/nix/profiles/system
    nh os info

# Flex evaltime :D
[group('nix')]
evaltime host="$(hostname)":
    @time nix eval \
        .#nixosConfigurations.{{host}}.config.system.build.toplevel \
        --option eval-cache false \
        --read-only \
        --raw

# `nh os repl` sucks
# Open a nix shell with the flake's nixpkgs
[group('nix')]
repl:
    # Load the flake with `:lf .`
    nix repl

# Format all files
[group('nix')]
fmt:
    nix fmt .

# Run checks
[group('nix')]
check:
    nix flake check

# Update nixpkgs
[group('nix')]
update:
    nix flake update nixpkgs
