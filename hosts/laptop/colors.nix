{
  pkgs,
  inputs,
  ...
}: {
  imports = [inputs.stylix.nixosModules.stylix];

  stylix.image = pkgs.fetchurl {
    url = "https://images.unsplash.com/photo-1467703834117-04386e3dadd8?ixlib=rb-4.0.3&q=85&fm=jpg&crop=entropy&cs=srgb&dl=anders-jilden-5sxQH0ugTaA-unsplash.jpg";
    hash = "sha256-kXWxrugHOlP1MKrGxYjxfiqhXEjoh/iFSvQ/S2q2OIg=";
  };

  stylix.polarity = "dark";
}
