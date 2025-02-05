{pkgs, ...}: {
  programs = {
    gamescope.enable = true;
    steam = {
      enable = true;
      gamescopeSession.enable = true;
    };
  };
  packages = with pkgs; [
    (lutris.override {
      extraLibraries = pkgs: [pkgs.libunwind];
      extraPkgs = pkgs: [pkgs.python3];
    })
    prismlauncher
  ];
}
