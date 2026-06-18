{ lib, stdenv, writeText }:

stdenv.mkDerivation {
  pname = "hello-tecsnosquire";
  version = "0.1.0";

  src = writeText "hello.txt" "Hello from TecnoSquire!";

  dontUnpack = true;

  installPhase = ''
    mkdir -p $out/share
    cp $src $out/share/hello.txt
  '';

  meta = {
    description = "Hello from TecnoSquire";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
  };
}