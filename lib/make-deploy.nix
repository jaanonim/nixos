{inputs, ...}: {
  system,
  target,
  nixosConfig,
  sshUser ? "root",
}: {
  hostname = target;
  interactiveSudo = true;
  profiles.system = {
    inherit sshUser;

    user = "root";
    path = inputs.deploy-rs.lib.${system}.activate.nixos nixosConfig;
  };
}
