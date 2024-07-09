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
  };
}
