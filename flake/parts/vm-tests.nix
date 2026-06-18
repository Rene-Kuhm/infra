{ pkgs, ... }: {
  # VM tests for services - CURRENTLY DISABLED
  # The path resolution issue between flake-parts imports and module imports
  # requires restructuring. Tracked in: https://github.com/Rene-Kuhm/infra/issues

  # When re-enabled, this will test that core services (adguard, gitea, monitoring)
  # start correctly in a NixOS VM.

  # nginxTest = pkgs.nixosTest {
  #   name = "nginx-basic-test";
  #   nodes.machine = { pkgs, ... }: {
  #     imports = [
  #       ../../modules/services/adguard
  #       ../../modules/services/gitea
  #       ../../modules/services/monitoring
  #     ];
  #     services.adguard.enable = true;
  #     services.gitea.enable = true;
  #     services.monitoring.enable = true;
  #   };
  #   testScript = ''
  #     machine.wait_for_unit("adguard.service")
  #     machine.wait_for_open_port(3000)
  #   '';
  # };
}