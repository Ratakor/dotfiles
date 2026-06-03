# Based on https://github.com/NixOS/nixpkgs/blob/nixos-unstable/nixos/modules/profiles/base.nix
{ pkgs, ... }:
{
  environment = {
    systemPackages = with pkgs; [
      # utils for cool kids
      (wrappers.helix.override { extraPackages = [ nil ]; })
      wrappers.yazi
      wrappers.zellij
      moor
      ripgrep
      fd

      # tools related to this flake
      just
      agenix
      npins
      #gh

      # general installation tools
      curl
      wget
      rsync
      util-linux
      jq
      ouch # compress / decompress

      # nix installation tools
      nixos-install-tools
      disko
      disko-install

      # partitioning tools
      testdisk # useful for repairing boot problems
      ms-sys # for writing Microsoft boot sectors / MBRs
      efibootmgr
      efivar
      parted
      gptfdisk
      ddrescue
      ccrypt
      cryptsetup # needed for dm-crypt volumes

      # hardware related tools
      sdparm
      hdparm
      smartmontools
      pciutils # lspci
      usbutils # lsusb
      nvme-cli
      lm_sensors # sensors
      lshw
    ];

    variables = {
      EDITOR = "hx";
      PAGER = "moor";
    };

    shellAliases = {
      e = "hx";
      y = "yazi";
      z = "zellij --layout welcome";
      zac = "zellij attach --create";
    };
  };

  programs = {
    git = {
      enable = true;
      lfs.enable = true;
    };
  };
}
