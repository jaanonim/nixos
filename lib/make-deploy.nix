{inputs, ...}: {
  system,
  target,
  nixosConfig,
  fastConnection ? false,
  sshUser ? "root",
}: let
  # Magic for using cache - https://github.com/serokell/deploy-rs/issues/163#issuecomment-2991603313
  deployPkgs = import inputs.nixpkgs {
    inherit system;
    overlays = [
      (self: super: {
        deploy-rs = {
          inherit ((inputs.deploy-rs.overlays.default self super).deploy-rs) lib;
          inherit (super) deploy-rs;
        };
      })
    ];
  };
in {
  hostname = target;
  interactiveSudo = true;
  autoRollback = false;
  magicRollback = false; # not working for me
  inherit fastConnection;
  profiles.system = {
    inherit sshUser;

    user = "root";
    path = deployPkgs.deploy-rs.lib.activate.nixos nixosConfig;
  };
}
