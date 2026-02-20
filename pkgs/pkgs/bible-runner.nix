{
  lib,
  pkg-config,
  dbus,
  rustPlatform,
  makeDesktopItem,
  ...
}: let
  srcInfo = fetchTree {
    type = "github";
    owner = "jaanonim";
    repo = "BibleRunner-rs";
    rev = "fd80e22b31058140fdb10195890f16630b352993";
    narHash = "sha256-S8cuEt0eke5dJ2ZrsBGupdvz1Gx6V+YDMhlhNfutHas=";
  };
  src = srcInfo.outPath;

  inherit (builtins) readFile head match length elemAt;

  cargoToml = fromTOML (readFile "${src}/Cargo.toml");
  inherit (cargoToml) package;
  inherit (package) version description authors repository;
  inherit (package.metadata.krunner) service path;
  toml_name = package.name;

  primaryAuthor =
    if (authors != [])
    then match "(.+) <(.*)>" (head authors)
    else [];
in
  rustPlatform.buildRustPackage rec {
    inherit version src;
    pname = toml_name;
    name = "bible-runner";

    cargoLock.lockFile = "${src}/Cargo.lock";

    nativeBuildInputs = [pkg-config];
    buildInputs = [dbus];

    desktopItem = makeDesktopItem {
      name = "plasma-runner-${toml_name}";
      desktopName = "BibleRunner";
      type = "Service";
      icon = toml_name;
      comment = description;

      extraConfig =
        {
          X-KDE-PluginInfo-Name = pname;
          X-KDE-PluginInfo-Version = version;
          X-KDE-PluginInfo-EnabledByDefault = "true";
          X-KDE-ServiceTypes = "Plasma/Runner";
          X-Plasma-API = "DBus";
          X-Plasma-DBusRunner-Service = service;
          X-Plasma-DBusRunner-Path = path;
        }
        // lib.optionalAttrs (length meta.license >= 1) {
          X-KDE-PluginInfo-License = (head meta.license).spdxId;
        }
        // lib.optionalAttrs (length primaryAuthor >= 1) {
          X-KDE-PluginInfo-Author = head primaryAuthor;
        }
        // lib.optionalAttrs (length primaryAuthor >= 2) {
          X-KDE-PluginInfo-Email = elemAt primaryAuthor 1;
        };
    };

    postInstall = ''
      mkdir -p $out/share/icons
      cp ./resources/${toml_name}.png $out/share/icons/${toml_name}.png

      mkdir -p $out/share/krunner/dbusplugins
      cp $desktopItem/share/applications/* $out/share/krunner/dbusplugins

      mkdir -p $out/share/dbus-1/services
      cat<<EOF > $out/share/dbus-1/services/plasma-runner-${toml_name}.service
      [D-BUS Service]
      Name=${service}
      Exec=$out/bin/${toml_name}
      EOF
    '';

    meta = with lib; {
      inherit description;

      homepage = repository;
      license = with licenses; [mit];
    };
  }
