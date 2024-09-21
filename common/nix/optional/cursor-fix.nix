/*
idk if it's needed
*/
{
  config,
  pkgs,
  ...
}: let
  cursor = config.stylix.cursor.package;
in {
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
      paths = [pkgs.breeze-icons pkgs.breeze-qt5 pkgs.breeze-gtk cursor];
      pathsToLink = ["/share/icons"];
    };
    aggregatedThemes = pkgs.buildEnv {
      name = "system-themes";
      paths = [pkgs.breeze-qt5 pkgs.breeze-gtk cursor];
      pathsToLink = ["/share/themes"];
    };
  in {
    "/usr/share/themes" = mkRoSymBind (aggregatedThemes + "/share/themes");
    "/usr/share/icons" = mkRoSymBind (aggregatedIcons + "/share/icons");
    "/usr/share/fonts" = mkRoSymBind (aggregatedFonts + "/share/fonts");
  };
  environment.systemPackages = [cursor];
}
