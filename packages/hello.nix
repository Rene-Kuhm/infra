{ stdenv, fetchurl }:

stdenv.mkDerivation {
  pname = "hello-tecsnosquire";
  version = "0.1.0";

  src = fetchurl {
    url = "https://raw.githubusercontent.com/insyd/morning-pages/main/hello.txt";
    sha256 = "0000000000000000000000000000000000000000000000000";
  };

  dontUnpack = true;

  installPhase = ''
    mkdir -p $out/share
    cp $src $out/share/hello.txt
  '';

  meta = with stdenv.lib; {
    description = "Hello from TecnoSquire";
    license = licenses.mit;
    platforms = platforms.all;
  };
}