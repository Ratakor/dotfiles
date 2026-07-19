# bootstrap:
# nixos-generate-config --show-hardware-config > hosts/{{hostname}}/hw.nix
# nix-shell -p nh --run 'nh os switch -f . nixosConfigurations.{{hostname}}'

default: switch
    @# just --list

# Build and activate the new configuration, and make it the boot default
[group('deploy')]
switch host="$(hostname)":
    @# nixos-rebuild switch --sudo --flake .
    @# nh os switch -f . nixosConfigurations.{{host}}
    nh os switch --diff always --hostname {{host}} .

# Build the new configuration and make it the boot default
[group('deploy')]
boot host="$(hostname)":
    nh os boot --diff always --hostname {{host}} .

# Build and activate the new configuration
[group('deploy')]
test host="$(hostname)":
    nh os test --diff always --hostname {{host}} .


# Build a `NixOS` VM image
[group('build')]
build-vm host="$(hostname)":
    nh os build-vm --hostname {{host}} .

# Build a custom `NixOS` ISO
[group('build')]
build-iso:
    nix build .#nixosConfigurations.iso.config.system.build.isoImage

# Run checks
[group('dev')]
check:
    nix flake check

# Format all files
[group('dev')]
fmt:
    nix fmt .

# Flex evaltime :D
[group('dev')]
evaltime host="$(hostname)":
    @time nix eval \
        .#nixosConfigurations.{{host}}.config.system.build.toplevel \
        --option eval-cache false \
        --read-only \
        --raw

# Open a nix shell with custom variables
[group('dev')]
repl host="$(hostname)":
    @nix repl --file flake/repl.nix --argstr host {{host}}

# Garbage collect all unused nix store entries & remove old generations
[group('system')]
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
[group('system')]
rollback:
    @# nix profile rollback --profile /nix/var/nix/profiles/system
    nh os rollback --verbose --ask

# List all generations of the system profile
[group('system')]
info:
    @# nix profile history --profile /nix/var/nix/profiles/system
    nh os info

# Update sources
[group('system')]
update *inputs:
    tack update {{inputs}}
