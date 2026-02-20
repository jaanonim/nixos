{
  stdenv,
  cmake,
  openssl,
  fetchFromGitHub,
}:
stdenv.mkDerivation (finalAttrs: {
  name = "forklab";
  src = fetchFromGitHub {
    owner = "jaanonim";
    repo = "forklab";
    rev = "8460f6a6df661e388c48a3cecf45a9c9824baf0e";
    hash = "sha256-1HLY+dYGnuAxFNTZcfv+UkJuUjvGVak2/73fZFxNvAQ=";
  };

  buildInputs = [
    cmake
    openssl
  ];

  configurePhase = ''
    mkdir -p build
    cd build
    cmake ..
  '';

  buildPhase = ''
    cmake --build . --config Release
  '';

  installPhase = ''
    mkdir -p $out/bin
    mv forklab $out/bin
  '';
})
