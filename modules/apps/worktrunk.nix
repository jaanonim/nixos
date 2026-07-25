{
  pkgs,
  config,
  lib,
  ...
}:
with lib; let
  inherit (config) my;
in {
  config = mkIf (builtins.any (ele: (ele == (lib.removeSuffix ".nix" (baseNameOf __curPos.file)))) my.apps) {
    my._packages = with pkgs; [
      worktrunk
    ];

    home-manager.users.${my.mainUser} = mkIf my.homeManager {
      home.file.".config/worktrunk/config.toml".text = ''
        worktree-path = "{{ repo_path }}/.worktrees/{{ branch | sanitize }}"
      '';
    };
  };
}
