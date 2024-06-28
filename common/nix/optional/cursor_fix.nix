/* idk if it's needed */
{
  config,
  pkgs,
  ...
}: {
  system.fsPackages = [pkgs.bindfs];
  fileSystems = let
    mkRoSymBind = path: {
      device = path;
      fsType = "fuse.bindfs";
      options = ["ro" "resolve-symlinks" "x-gvfs-hide"];
    };
    aggregatedFonts = pkgs.buildEnv {
      name = "system-fonts";
      paths = config.fonts.packages;
      pathsToLink = ["/share/fonts"];
    };
    aggregatedIcons = pkgs.buildEnv {
      name = "system-icons";
      paths = with pkgs; [breeze-icons breeze-qt5 breeze-gtk];
      pathsToLink = ["/share/icons"];
    };
    aggregatedThemes = pkgs.buildEnv {
      name = "system-themes";
      paths = with pkgs; [breeze-qt5 breeze-gtk];
      pathsToLink = ["/share/themes"];
    };
  in {
    "/usr/share/themes" = mkRoSymBind (aggregatedThemes + "/share/themes");
    "/usr/share/icons" = mkRoSymBind (aggregatedIcons + "/share/icons");
    "/usr/share/fonts" = mkRoSymBind (aggregatedFonts + "/share/fonts");
  };
}
