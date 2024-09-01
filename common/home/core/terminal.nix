_: {
  programs = {
    zoxide = {
      enable = true;
      enableZshIntegration = true;
      options = ["--cmd cd"];
    };
    vim = {
      enable = true;
      settings = {
        number = true;
      };
    };
    direnv = {
      enable = true;
      config = {
        hide_env_diff = true;
      };
      enableZshIntegration = true;
      nix-direnv.enable = true;
    };
  };
}
