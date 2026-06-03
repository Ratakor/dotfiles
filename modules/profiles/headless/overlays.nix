{
  # Install less voices for speechd to save some space
  nixpkgs.overlays = [
    (_final: prev: {
      mbrola-voices = prev.mbrola-voices.override {
        # only ship with one voice per language
        languages = [ "*1" ];
      };
    })
  ];
}
