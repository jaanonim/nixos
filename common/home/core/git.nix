_: {
  programs.git = {
    enable = true;
    userName = "jaanonim";
    userEmail = "mat8mro@gmail.com";
    extraConfig = {
      init.defaultBranch = "main";
      core.autocrlf = "input";
      github.user = "jaanonim";
    };
    signing = {
      signByDefault = true;
      key = "933AF32D3ABD5CAF";
    };
  };
  programs.gpg = {
    enable = true;
  };
}
