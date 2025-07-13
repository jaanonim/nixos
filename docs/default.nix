{
  lib,
  runCommandLocal,
  nixosOptionsDoc,
  gnused,
}: {
  inputs,
  pkgs,
}: let
  modules = [
    {_module.check = false;}
    ../modules/system
  ];

  options =
    removeAttrs
    (lib.evalModules {
      inherit modules;
      specialArgs = {
        inherit inputs pkgs;
        lib = inputs.nixpkgs.lib.extend (_: _: {mkDoc = x: x;});
      };
    }).options ["_module"];

  # Recursively update value named `key` based on function `fun` in `attrset`
  walkAttrs = key: fun: attrset:
    builtins.mapAttrs (
      k: v:
        if k == key
        then fun v
        else if builtins.isAttrs v
        then walkAttrs key fun v
        else v
    )
    attrset;

  # If a path ends in a .nix file, do nothing, otherwise add string '/default.nix'
  # This is because options defined in default.nix files show as being defined just in the directory
  addDefaultNix = path:
    if lib.hasSuffix ".nix" path
    then path
    else "${path}/default.nix";

  # Map list of store paths to relative paths, that still start with / not ./
  storeToRelativePath = paths:
    map (
      path: let
        matches = builtins.match "^/nix/store/[^/]+(.*)" path;
      in
        if matches == []
        then path
        else addDefaultNix (builtins.head matches)
    )
    paths;

  # Replace all attributes with key 'declarations' with that path in relative form
  # This way the docs don't show /nix/store paths that can change even though the options don't change themself
  transformedOptions = walkAttrs "declarations" storeToRelativePath options;

  docs = nixosOptionsDoc {
    options = lib.traceVal transformedOptions;
  };

  optionsJson = pkgs.runCommand "options-json" {} ''
    cat ${docs.optionsJSON}/share/doc/nixos/options.json > $out
  '';

  filteredJson = pkgs.runCommand "filter-json" {nativeBuildInputs = [pkgs.jq];} ''
    jq 'with_entries(select(.key | startswith("my.") ))' ${optionsJson} > $out
  '';

  docsMarkdown =
    pkgs.runCommand "options-md" {
      nativeBuildInputs = [pkgs.nixos-render-docs];
    } ''
      nixos-render-docs -j $NIX_BUILD_CORES options commonmark \
        --manpage-urls ${pkgs.path + "/doc/manpage-urls.json"} \
        --revision ${lib.escapeShellArg ""} \
        ${filteredJson} \
        $out
    '';
in
  runCommandLocal "option-docs"
  {
    nativeBuildInputs = [
      gnused
    ];
  }
  ''
    mkdir -p $out
    { \
      echo "# Jaanonim's options"; \
      echo ""; \
      cat ${docsMarkdown}; \
    } > $out/docs.md
    sed -i 's/file:\/\///' $out/docs.md # Remove 'file://' prefix from links
  ''
