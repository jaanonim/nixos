{
  pkgs,
  lib,
  ...
}: let
  extra-path = with pkgs; [
    # dotnetCorePackages.sdk_6_0
    dotnetCorePackages.sdk_8_0
    # dotnetCorePackages.sdk_9_0
    dotnetPackages.Nuget
    dotnet-ef
    mono
    # msbuild
    # Add any extra binaries you want accessible to Rider here
  ];

  extra-lib = [
    # Add any extra libraries you want accessible to Rider here
  ];
in rec {
  rider = pkgs.jetbrains.rider.overrideAttrs (attrs: {
    postInstall =
      ''
        # Wrap rider with extra tools and libraries
        mv $out/bin/rider $out/bin/.rider-toolless
        makeWrapper $out/bin/.rider-toolless $out/bin/rider \
          --argv0 rider \
          --prefix PATH : "${lib.makeBinPath extra-path}" \
          --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath extra-lib}"

        # Making Unity Rider plugin work!
        # The plugin expects the binary to be at /rider/bin/rider,
        # with bundled files at /rider/
        # It does this by going up two directories from the binary path
        # Our rider binary is at $out/bin/rider, so we need to link $out/rider/ to $out/
        shopt -s extglob
        ln -s $out/rider/!(bin) $out/
        shopt -u extglob
      ''
      + attrs.postInstall or "";
  });

  riderDesktop = pkgs.makeDesktopItem {
    name = "jetbrains-rider";
    desktopName = "Rider";
    exec = "\"${rider}/bin/rider\"";
    icon = "rider";
    type = "Application";
    # Don't show desktop icon in search or run launcher
    extraConfig.NoDisplay = "true";
  };
}
