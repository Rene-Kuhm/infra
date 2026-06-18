{ pkgs, ... }: {
  # VM tests for services
  # These run in a NixOS VM and verify the service starts correctly

  # Example: test that adguard serves a test page
  nginxTest = pkgs.nixosTest {
    name = "nginx-basic-test";

    nodes.machine = { pkgs, ... }: {
      imports = [
        ../../modules/services/adguard
        ../../modules/services/gitea
        ../../modules/services/monitoring
      ];

      services.adguard.enable = true;
      services.gitea.enable = true;
      services.monitoring.enable = true;
    };

    testScript = ''
      machine.wait_for_unit("adguard.service")
      machine.wait_for_open_port(3000)
      machine.succeed("curl -sf http://localhost:3000/ | grep -q 'AdGuard'")
    '';
  };
}