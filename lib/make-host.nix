{
  makeConfig,
  makeDeploy,
  lib,
  ...
}: {
  self,
  system,
  hostname,
  hardwareModules ? [],
  profileModules ? [],
  deploy ? false,
  target ? null,
  sshUser ? null,
}: let
  cfgVal = self.nixosConfigurations.${hostname}.config;
  cfg = makeConfig {
    osConfig = cfgVal;
    inherit system hardwareModules;
    profileModules = profileModules ++ [{my.hostname = hostname;}];
  };
  _target =
    if target != null
    then target
    else cfgVal.my.networking.ip;
  _sshUser =
    if sshUser != null
    then sshUser
    else cfgVal.my.mainUser;
in
  {
    nixosConfigurations.${hostname} = cfg;
  }
  // lib.optionalAttrs deploy
  {
    deploy.nodes.${hostname} = makeDeploy {
      inherit system;
      target = _target;
      sshUser = _sshUser;
      nixosConfig = cfg;
    };
  }
