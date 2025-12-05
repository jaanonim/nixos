/*
idk if it's needed
*/
{
  config,
  pkgs,
  lib,
  ...
}: {
  config = lib.mkIf config.my.desktop.enable (
    let
      cursor =
        if config.my.stylix.enable
        then config.stylix.cursor.package
        else null;
    in {
      system.fsPackages = [pkgs.bindfs];
      fileSystems = let
        mkRoSymBind = path: {
          device = path;
          fsType = "fuse.bindfs";
          options = ["ro" "resolve-symlinks" "x-gvfs-hide"];
        };
        aggregatedFonts = pkgs.buildEnv {
          ignoreCollisions = true;
          name = "system-fonts";
          paths = config.fonts.packages;
          pathsToLink = ["/share/fonts"];
        };
        aggregatedIcons = pkgs.buildEnv {
          ignoreCollisions = true;
          name = "system-icons";
          paths = [pkgs.kdePackages.breeze-icons pkgs.kdePackages.breeze pkgs.kdePackages.breeze-gtk cursor];
          pathsToLink = ["/share/icons"];
        };
        aggregatedThemes = pkgs.buildEnv {
          ignoreCollisions = true;
          name = "system-themes";
          paths = [pkgs.kdePackages.breeze pkgs.kdePackages.breeze-gtk cursor];
          pathsToLink = ["/share/themes"];
        };
      in {
        "/usr/share/themes" = mkRoSymBind (aggregatedThemes + "/share/themes");
        "/usr/share/icons" = mkRoSymBind (aggregatedIcons + "/share/icons");
        "/usr/share/fonts" = mkRoSymBind (aggregatedFonts + "/share/fonts");
      };
      environment.systemPackages = [cursor];
    }
  );
}
