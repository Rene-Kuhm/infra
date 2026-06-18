{ lib, stdenv, fetchurl }:

stdenv.mkDerivation {
  pname = "hello-tecsnosquire";
  version = "0.1.0";

  src = fetchurl {
    url = "https://raw.githubusercontent.com/Rene-Kuhm/infra/main/README.md";
    sha256 = "sha256-0000000000000000000000000000000000000000000000000000000000000000";
  };

  dontUnpack = true;

  installPhase = ''
    mkdir -p $out/share
    cp $src $out/share/README.md
  '';

  meta = {
    description = "Hello from TecnoSquire";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
  };
}