{...}: {
  programs.git = {
    enable = true;
    userName = "jaanonim";
    userEmail = "mat8mro@gmail.com";
    extraConfig = {
      init.defaultBranch = "main";
      core.autocrlf = "input";
    };
  };
}
