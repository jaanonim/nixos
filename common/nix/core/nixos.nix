{_}: {
  nix = {
    settings.experimental-features = ["nix-command" "flakes"];

    optimise = {
      automatic = true;
      dates = ["23:55"];
    };

    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
  };
}
