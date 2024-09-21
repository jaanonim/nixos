{
  pkgs,
  jaanonim-pkgs,
  ...
}: {
  packages = with pkgs; [
    jaanonim-pkgs.rider
    unityhub
  ];
}
