{ config, lib, ... }:
let
  inherit (lib.modules) mkIf;
  inherit (lib.filesystem) GiB;
in
{
  # This uses zram-generator under the hood.
  zramSwap = {
    enable = true;
    algorithm = "zstd"; # can also use "lz4"
    # Maximum percentage of memory that can be stored in zram swap.
    memoryPercent = 50; # 0-200, default is 50
    # Maximum total amount of memory (in bytes) that can be stored in zram swap.
    memoryMax = 16 * GiB;
    # Write incompressible pages to this device,
    # as there’s no gain from keeping them in RAM.
    # null because I don't have disk swap :/
    writebackDevice = null;
  };

  # https://www.kernel.org/doc/html/latest/admin-guide/sysctl/vm.html
  # https://github.com/pop-os/default-settings/pull/163
  # https://wiki.archlinux.org/title/Zram#Optimizing_swap_on_zram
  # https://fedoraproject.org/wiki/Changes/SwapOnZRAM
  boot.kernel.sysctl = mkIf config.zramSwap.enable {
    # Higher values encourage the kernel to move memory pages to swap.
    "vm.swappiness" = 180; # 0-200
    # Level of reclaim when memory is being fragmented.
    "vm.watermark_boost_factor" = 0; # 0 to disable
    # Aggressiveness of kswapd.
    "vm.watermark_scale_factor" = 125; # 0-300
    # Number of pages up to which consecutive pages are read in
    # from swap in a single attempt. Default is 3.
    "vm.page-cluster" = 0; # disable readahead
  };
}
