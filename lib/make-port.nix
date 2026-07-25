{lib, ...}:
# returns number in the range 1024-9999
name: let
  hash = builtins.hashString "md5" name;
  length = builtins.stringLength hash;
  hashSlice = builtins.substring (length - 4) (-1) hash;
  number = lib.fromHexString (builtins.trace hashSlice hashSlice);
in
  (lib.mod number 8976) + 1024
