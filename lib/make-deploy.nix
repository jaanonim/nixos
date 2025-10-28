{inputs, ...}: {
  system,
  target,
  nixosConfig,
  sshUser ? "root",
}: {
  hostname = target;
  interactiveSudo = true;
  autoRollback = false;
  magicRollback = false; # not working for me
  profiles.system = {
    inherit sshUser;

    user = "root";
    path = inputs.deploy-rs.lib.${system}.activate.nixos nixosConfig;
  };
}
