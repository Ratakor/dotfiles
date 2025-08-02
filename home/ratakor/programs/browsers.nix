{
  pkgs,
  config,
  username,
  ...
  }: {
    # # ungoogled-chromium required to `pacman -Rdd your-freedom`
    # #aur/ungoogled-chromium-bin
    # #aur/ungoogled-chromium-xdg-bin # ungoogled chromium but without ~/.pki
    # aur/cromite-bin

    programs = {
      chromium = {
        enable = true;
	# package = pkgs.cromite; # TODO: cromite or UC
	# TODO: add UBO, ...
	extensions = [
	  { id = "dbepggeogbaibhgnhhndojpepiihcmeb"; } # Vimium
	];
      };

      # TODO: remove
      firefox = {
        enable = true;
        # profiles.${username} = {};
      };
    };
  }
