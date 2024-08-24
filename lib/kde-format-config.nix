{lib, ...}: let
  formatValue = value:
    if builtins.isBool value
    then
      if value
      then "true"
      else "false"
    else builtins.toString value;

  formatSection = path: data: let
    header = lib.concatStrings (map (p: "[${p}]") path);
    formatChild = name: formatLines (path ++ [name]);
    children = lib.mapAttrsToList formatChild data;
    partitioned = lib.partition builtins.isString children;
    directChildren = partitioned.right;
    indirectChildren = partitioned.wrong;
  in
    lib.optional (directChildren != []) header
    ++ directChildren
    ++ lib.flatten indirectChildren;

  formatLines = path: data:
    if builtins.isAttrs data
    then
      if data ? _immutable
      then
        if builtins.isAttrs data.value
        then formatSection (path ++ ["$i"]) data.value
        else "${lib.last path}[$i]=${formatValue data.value}"
      else formatSection path data
    else "${lib.last path}=${formatValue data}";
in
  data: lib.concatStringsSep "\n" (formatLines [] data)
