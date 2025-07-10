{
  pkgs,
  lib,
  ...
}: base16Scheme: let
  colorschemeSlug =
    lib.concatStrings
    (builtins.filter builtins.isString
      (builtins.split "[^a-zA-Z]" base16Scheme.scheme));

  colorEffect = {
    ColorEffect = 0;
    ColorAmount = 0;
    ContrastEffect = 1;
    ContrastAmount = 0.5;
    IntensityEffect = 0;
    IntensityAmount = 0;
  };

  colors = with base16Scheme; {
    BackgroundNormal = "${base00-rgb-r},${base00-rgb-g},${base00-rgb-b}";
    BackgroundAlternate = "${base01-rgb-r},${base01-rgb-g},${base01-rgb-b}";
    DecorationFocus = "${base0D-rgb-r},${base0D-rgb-g},${base0D-rgb-b}";
    DecorationHover = "${base0D-rgb-r},${base0D-rgb-g},${base0D-rgb-b}";
    ForegroundNormal = "${base05-rgb-r},${base05-rgb-g},${base05-rgb-b}";
    ForegroundActive = "${base05-rgb-r},${base05-rgb-g},${base05-rgb-b}";
    ForegroundInactive = "${base05-rgb-r},${base05-rgb-g},${base05-rgb-b}";
    ForegroundLink = "${base05-rgb-r},${base05-rgb-g},${base05-rgb-b}";
    ForegroundVisited = "${base05-rgb-r},${base05-rgb-g},${base05-rgb-b}";
    ForegroundNegative = "${base08-rgb-r},${base08-rgb-g},${base08-rgb-b}";
    ForegroundNeutral = "${base0D-rgb-r},${base0D-rgb-g},${base0D-rgb-b}";
    ForegroundPositive = "${base0B-rgb-r},${base0B-rgb-g},${base0B-rgb-b}";
  };

  colorscheme = {
    General = {
      ColorScheme = colorschemeSlug;
      Name = base16Scheme.scheme;
    };

    "ColorEffects:Disabled" = colorEffect;
    "ColorEffects:Inactive" = colorEffect;

    "Colors:Window" = colors;
    "Colors:View" = colors;
    "Colors:Button" = colors;
    "Colors:Tooltip" = colors;
    "Colors:Complementary" = colors;
    "Colors:Selection" =
      colors
      // (with base16Scheme; {
        BackgroundNormal = "${base0D-rgb-r},${base0D-rgb-g},${base0D-rgb-b}";
        BackgroundAlternate = "${base0D-rgb-r},${base0D-rgb-g},${base0D-rgb-b}";
        ForegroundNormal = "${base00-rgb-r},${base00-rgb-g},${base00-rgb-b}";
        ForegroundActive = "${base00-rgb-r},${base00-rgb-g},${base00-rgb-b}";
        ForegroundInactive = "${base00-rgb-r},${base00-rgb-g},${base00-rgb-b}";
        ForegroundLink = "${base00-rgb-r},${base00-rgb-g},${base00-rgb-b}";
        ForegroundVisited = "${base00-rgb-r},${base00-rgb-g},${base00-rgb-b}";
      });

    WM = with base16Scheme; {
      activeBlend = "${base0A-rgb-r},${base0A-rgb-g},${base0A-rgb-b}";
      activeBackground = "${base00-rgb-r},${base00-rgb-g},${base00-rgb-b}";
      activeForeground = "${base05-rgb-r},${base05-rgb-g},${base05-rgb-b}";
      inactiveBlend = "${base03-rgb-r},${base03-rgb-g},${base03-rgb-b}";
      inactiveBackground = "${base00-rgb-r},${base00-rgb-g},${base00-rgb-b}";
      inactiveForeground = "${base05-rgb-r},${base05-rgb-g},${base05-rgb-b}";
    };
  };
in
  pkgs.runCommand "kde-color-sheme" {
    colorscheme = lib.kdeFormatConfig colorscheme;
  } ''
    write_text() {
      mkdir --parents "$(dirname "$2")"
      printf '%s\n' "$1" >"$2"
    }

    write_text \
      "$colorscheme" \
      "$out/kdeglobals"
  ''
