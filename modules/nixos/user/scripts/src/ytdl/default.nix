{
  writeShellApplication,
  coreutils,
  libnotify,
  yt-dlp,
}:
writeShellApplication {
  name = "ytdl";
  runtimeInputs = [
    coreutils
    libnotify
    yt-dlp
  ];
  text = builtins.readFile ./ytdl.sh;
}
