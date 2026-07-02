{
  pkgs,
  config,
  lib,
  jaanonim-pkgs,
  ...
}:
with lib; let
  inherit (config) my;
  minimumReleaseAgeDays = 5;
  minimumReleaseAgeMinutes = minimumReleaseAgeDays * 24 * 60;
in {
  config = mkIf (builtins.any (ele: (ele == (lib.removeSuffix ".nix" (baseNameOf __curPos.file)))) my.apps) {
    my._packages = with pkgs;
      [
        # jetbrains.clion
        jetbrains.pycharm
        # jetbrains.idea-ultimate
        # jetbrains.goland
        # jetbrains.rider
        vscode
      ]
      ++ (with jaanonim-pkgs; [forklab]);

    # Config for protection against supply chain attacks in package managers

    environment.etc."npmrc".text = ''
      ignore-scripts=true
      audit=true
      fund=false
      save-exact=true
      update-notifier=false
      min-release-age=${toString minimumReleaseAgeDays}
    '';

    environment.etc."pip.conf".text = ''
      [global]
      require-virtualenv = true

      [install]
      uploaded-prior-to = P${toString minimumReleaseAgeDays}D
    '';

    environment.etc."uv/uv.toml".text = ''
      exclude-newer = P${toString minimumReleaseAgeDays}D
    '';

    home-manager.users.${my.mainUser} = mkIf my.homeManager {
      xdg.configFile."pnpm/config.yaml".text = ''
        ignore-scripts: true
        minimumReleaseAge: ${toString minimumReleaseAgeMinutes}
        verifyStoreIntegrity: true
      '';

      xdg.configFile.".bunfig.toml".text = ''
        [install]
        ignoreScripts = true
        minimumReleaseAge = ${toString minimumReleaseAgeMinutes}
      '';
    };
  };
}
