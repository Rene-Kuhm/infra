{
  nodes.tecsnosquire = {
    hostname = "tecnodespegue";  # Will change to 'tecsnosquire' after NixOS install
    profiles.system = {
      path = inputs.deploy-rs.lib.x86_64-linux.activate.${self.nixosConfigurations.tecsnosquire};
      user = "root";
      sshUser = "root";
      sshOpts = [ "-o" "StrictHostKeyChecking=accept-new" ];
      # Replace with your public key after first deploy:
      # activationTimeout = 120;
      # magicRollback = true;
    };
  };

  # Health checks
  healthchecks.tecsnosquire.http = {
    url = "http://tecnodespegue:9090/-/healthy";
    expectedStatus = 200;
    interval = 60;
  };
}