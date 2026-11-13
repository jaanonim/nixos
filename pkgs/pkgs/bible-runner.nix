{
  clangStdenv,
  gcc,
  cmake,
  ninja,
  lib,
  kdePackages,
  qt6,
  boost,
  fetchFromGitHub,
}: let
  gccVer = gcc.cc.version;
  headerFlags = lib.concatStringsSep " " [
    "-stdlib=libstdc++"
    "-isystem ${gcc.cc}/include/c++/${gccVer}"
    "-isystem ${gcc.cc}/include/c++/${gccVer}/x86_64-unknown-linux-gnu"
    "-isystem ${clangStdenv.cc.libc.dev}/include"
    "-isystem ${qt6.qtbase.out}/include"
    "-isystem ${qt6.qtbase.out}/mkspecs/linux-g++"
  ];
  repo = fetchFromGitHub {
    owner = "jaanonim";
    repo = "BibleRunner";
    rev = "f3af2541de2159c1c7933c22ff83a07da1190f6d";
    hash = "sha256-AEYcyuHwdcxzNTWyKWTSO0+GqL1zAu+iUhJK1YXRo1U=";
  };
in
  clangStdenv.mkDerivation {
    name = "bible-runner";
    version = "1.0.0";

    env.CXXFLAGS = headerFlags;
    env.NIX_LDFLAGS = "-L${gcc.cc.lib}/lib -rpath ${gcc.cc.lib}/lib";

    passthru.headerFlags = headerFlags;

    src = "${repo}/src";

    nativeBuildInputs = [
      cmake
      ninja
      gcc
      kdePackages.extra-cmake-modules
      qt6.wrapQtAppsHook
    ];

    buildInputs = [
      kdePackages.kcoreaddons
      kdePackages.ki18n
      kdePackages.kconfig
      kdePackages.krunner
      kdePackages.kio
      kdePackages.knotifications
      kdePackages.kcmutils
      kdePackages.kwidgetsaddons
      qt6.qtbase
      boost
    ];

    doCheck = true;
    checkPhase = "ctest";

    cmakeFlags = ["-GNinja" "-DBUILD_TESTING=ON"];
  }
