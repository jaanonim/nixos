{inputs, ...}: {
  system,
  target,
  nixosConfig,
  fastConnection ? false,
  sshUser ? "root",
}: {
  hostname = target;
  interactiveSudo = true;
  autoRollback = false;
  magicRollback = false; # not working for me
  inherit fastConnection;
  profiles.system = {
    inherit sshUser;

    user = "root";
    path = inputs.deploy-rs.lib.${system}.activate.nixos nixosConfig;
  };
}
