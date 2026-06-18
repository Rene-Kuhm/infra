{ inputs, lib, ... }: {
  perSystem = { pkgs, self', ... }:
    let
      # VM test for nginx serving a test page
      nginxTest = pkgs.nixosTest {
        name = "nginx-test";
        nodes.machine = { ... }: {
          imports = [ ../modules/services/adguard ];
          services.adguard.enable = true;
        };
        testScript = ''
          machine.wait_for_unit("adguard.service")
          machine.wait_for_open_port(3000)
          machine.succeed("curl -sf http://localhost:3000/ | grep -q 'AdGuard'")
        '';
      };
    in
    {
      checks = {
        # Format check
        formatting = self'.formatter;

        # Nix flake check (runs nix flake check)
        # This is added by flake-parts automatically

        # Service VM tests
        nginx-vmtest = nginxTest;

        # Example devshell check (ensure it builds)
        # devshell = self'.devShells.x86_64-linux.default;
      };
    };
}