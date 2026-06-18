{ inputs, lib, ... }: {
  # CI-specific outputs that don't fit elsewhere
  flake = {
    # CI builds happen via GitHub Actions (.github/workflows/check.yml)
    # No need for additional outputs here
  };
}