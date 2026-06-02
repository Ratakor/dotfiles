# Backup tool

# TODO:
# - clean that up
# - add options to self.services.borgmatic
# - decide on which interface to use, probably borgbackup or borgmatic from nixos
# - backup via zfs instead?
#   - see https://github.com/NixOS/nixpkgs/pull/430453 too

# doc taken from my previous arch config:
## init repos:
# sudo borgmatic init
#
## create -> prune -> compact
## do not use --list on first create
# sudo borgmatic --verbose 1 --list --stats
{ lib, ... }:
let
  mkConfig = lib.recursiveUpdate {
    # 1. if /home is the only source_directories this can be run entirely as a user
    # 2. if other dirs like /root or /etc are backed up this must be run as root
    # 3. it's possible to have multiple repo, one for /home and one for sys dirs
    source_directories = [
      "/home"
      "/root"
      "/etc"
      "/var/lib"
      # "/var/log"
    ];

    exclude_patterns = [
      "/home/*/.cache"
      "/home/*/.local/var/cache"
      "/home/*/.local/share/Trash"

      # Temporary files created by zig
      "**/.zig-cache"
      "**/zig-out"
    ];

    exclude_caches = true;

    ## Compression:
    # lzbench 2.1 | GCC 15.1.1 | 64-bit Linux | Intel(R) Core(TM)2 Duo CPU     P8600  @ 2.40GHz
    ### A lot of small files (462 files, 3MB)
    # % lzbench -elz4/zstd,3/xz,6 -t15,30 -o1c4 -rj ~/repos/zpotify
    # | Compressor name         | Compression| Decompress.| Compr. size | Ratio |
    # | ---------------         | -----------| -----------| ----------- | ----- |
    # | zstd 1.5.7 -3           |   120 MB/s |   713 MB/s |      734977 | 74.05 |
    # | xz 5.6.3 -6             |  0.57 MB/s |  25.0 MB/s |      742966 | 74.85 |
    # | lz4 1.10.0              |   539 MB/s |  1882 MB/s |      779237 | 78.51 |
    ### A big file (833MB)
    # % lzbench -elz4/zstd,3/xz,6 -o1c4 ~/tmp/cromite/chrome-lin64.tar
    # | Compressor name         | Compression| Decompress.| Compr. size | Ratio |
    # | ---------------         | -----------| -----------| ----------- | ----- |
    # | xz 5.6.3 -6             |  1.64 MB/s |  67.7 MB/s |   166526137 | 19.05 |
    # | zstd 1.5.7 -3           |   110 MB/s |   405 MB/s |   230010694 | 26.31 |
    # | lz4 1.10.0              |   271 MB/s |   960 MB/s |   358790397 | 41.05 |
    ### borg /home
    # zstd,20:   63G -> 38G 6:00:00
    # lz4:       66G -> 44G   30:00
    # auto,lzma: 60G -> 38G 3:00:00
    compression = "auto,lzma"; # "lz4";

    # retries = 3;
    # retry_wait = 10;

    keep_daily = 7;
    keep_weekly = 4;
    keep_monthly = 6;

    checks = [
      {
        name = "repository";
      }
      {
        name = "archives";
        frequency = "2 weeks";
      }
    ];

    # verbosity = 0;
    # syslog_verbosity = 1;
    # log_file_verbosity = 1;

    # statistics = true;
    # list_details = true;

    # commands = [
    #   {
    #     before = "action";
    #     when = [ "create" ];
    #     run = [ "echo Doing stuff." ];
    #   }
    # ];

    # monitoring_verbosity = 0;
    # healthchecks = []; # TODO
  };
in
{
  # install borgbackup (backup tool) too
  # python-llfuse # dependency for borg mount

  # services.borgbackup = { };

  # borg wrapper
  services.borgmatic = {
    enable = false;
    configurations = {
      local = mkConfig {
        repositories = [
          {
            path = "/var/lib/borg/backup"; # /var/lib/backups/local.borg
            label = "local";
            # encryption = "none";
            # make_parent_directories = true;
          }
        ];
      };
      removable = mkConfig {
        repositories = [
          {
            path = "/media/borg/backup.borg";
            label = "removable";
            # encryption = "none";
          }
        ];
        commands = [
          {
            before = "repository";
            run = [ "findmnt /media/borg >/dev/null || exit 75" ];
          }
        ];
      };
    };
  };
}
