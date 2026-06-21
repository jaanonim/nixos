{
  lib,
  writeTextFile,
  nix-search-tv,
  xdg-utils,
  writeShellScriptBin,
  fzf,
  gnused,
  gnugrep,
  ...
}: let
  nstv-config = {
    indexes = [
      "nixpkgs"
      "nixos"
      "home-manager"
      "noogle"
    ];
    update_interval = "24h";
  };

  nstv-config-file = writeTextFile {
    name = "nix-search-tv-config";
    text = builtins.toJSON nstv-config;
  };
  nstv = cmd: "${lib.getExe nix-search-tv} ${cmd} --config ${nstv-config-file}";

  open = "${xdg-utils}/bin/xdg-open";

  nix-shell-cmd = ''
    pkgs=$(echo "{+}" | ${lib.getExe gnused} "s:nixpkgs/ ::g" | tr -d \\047) \
      && echo -e "\e[94mEntering shell with:\e[0m $pkgs" \
      && $SHELL -i -c "nix-shell -p $pkgs"
  '';
  nix-run-cmd = ''
    pkg=$(echo "{}" | ${lib.getExe gnused} "s:nixpkgs/ ::g" | tr -d \\047) \
      && echo -en "\e[94mConfirm command:\e[0m $pkg " \
      && read args \
      && eval NIXPKGS_ALLOW_UNFREE=1 nix run --impure nixpkgs#$pkg -- $args
  '';

  actions = {
    "ctrl-s" = {
      name = "open source";
      action = "execute(${nstv "source"} {} | xargs ${open})";
    };
    "ctrl-h" = {
      name = "open homepage";
      action = "execute(${nstv "homepage"} {} | xargs ${open})";
    };
    "alt-enter" = {
      name = "execute command";
      action = "become(${nix-run-cmd})";
    };
    "enter" = {
      name = "enter nix shell";
      action = "become(${nix-shell-cmd})";
    };
    "space" = {
      name = "show preview";
      action = "change-preview-window(top,80%|hidden)+transform-footer:if [ \$FZF_PREVIEW_LINES -gt 0 ]; then echo \"\"; else echo \"${footer}\"; fi";
    };
  };

  footer = "\n${lib.concatStringsSep "\n" (map (key: "${lib.toUpper key} - ${actions.${key}.name}") (builtins.attrNames actions))}";
  bindings = lib.concatStringsSep " " (map (key: " --bind '${key}:${actions.${key}.action}'") (builtins.attrNames actions));
in
  writeShellScriptBin "ns" ''
    if [ $# -ne 0 ]; then
      $SHELL -i -c "nix-shell -p $@"
      exit 0
    fi

    ${nstv "print"} | ${lib.getExe gnugrep} -v "Indexing packages..." | ${lib.getExe fzf} \
      ${bindings} \
      --preview '${nstv "preview"} {}' \
      --preview-label "Details" \
      --preview-window hidden \
      --footer '${footer}' \
      --scheme history \
      --tiebreak length
  ''
