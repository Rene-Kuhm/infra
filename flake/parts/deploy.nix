{ inputs, lib, self, ... }: {
  flake.deploy = {
    tecnosquire = {
      hostname = "tecnodespegue";  # Will change to 'tecsnosquire' after NixOS install
      profiles.system = {
        user = "root";
        sshUser = "root";
        path = deploy-rs.lib.x86_64-linux.activate.${self.nixosConfigurations.tecsnosquire};
        # Replace this with your public SSH key after first deploy
        sshOpts = [ "-o" "StrictHostKeyChecking=accept-new" ];
      };
    };
  } // {
    inherit (inputs.deploy-rs) deploy;
  };
}