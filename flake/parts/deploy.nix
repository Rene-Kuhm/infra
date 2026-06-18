{ inputs, lib, self, ... }: {
  flake.deploy = {
    tecnosquire = {
      hostname = "tecnodespegue";  # Will change to 'tecsnosquire' after NixOS install
      profiles.system = {
        user = "root";
        sshUser = "root";
        path = inputs.deploy-rs.lib.x86_64-linux.activate.${self.nixosConfigurations.tecsnosquire};
        sshOpts = [ "-o" "StrictHostKeyChecking=accept-new" ];
      };
    };
  };
}