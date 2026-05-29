# https://wiki.archlinux.org/title/Security#Mount_options
{
  fileSystems =
    [
      # "/var"
      # "/var/log"
      # "/home" # shouldn't have noexec
      # "/dev/shm"
      # "/tmp" # shouldn't have noexec
      "/boot"
    ]
    |> map (name: {
      inherit name;
      value.options = [
        "nodev"
        "nosuid"
        "noexec"
      ];
    })
    |> builtins.listToAttrs;
}
