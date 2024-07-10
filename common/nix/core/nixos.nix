_: {
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

  # linking libarys
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = []; # add packages here
}
