{
  outputs,
  inputs,
  nixpkgs,
  pkgs,
  lib,
  ...
}: {
  nix = {
    settings = {
      experimental-features = ["nix-command" "flakes"];
      nix-path = lib.mkForce "nixpkgs=${inputs.nixpkgs}";
      download-buffer-size = 524288000; # 500 MB
    };

    registry.nixpkgs.flake = nixpkgs;
    channel.enable = false;

    optimise = {
      automatic = true;
      dates = ["23:55"];
    };

    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };

  nixpkgs = {
    overlays = builtins.attrValues outputs.overlays;
    config = {
      allowUnfree = true;
      allowUnfreePredicate = _: true;
    };
  };

  environment.etc."nix/inputs/nixpkgs".source = "${nixpkgs}";

  # linking libarys
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; []; # add packages here
}
