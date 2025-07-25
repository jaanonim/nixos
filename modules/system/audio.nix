{
  lib,
  config,
  ...
}:
with lib; let
  inherit (config) my;
  cfg = config.my.audio;
in {
  options.my.audio = {
    enable = mkEnableOption "audio";
  };

  config = mkIf cfg.enable {
    # Enable sound with pipewire.
    security.rtkit.enable = true;
    services.pulseaudio.enable = false;
    services.pipewire = {
      enable = true;
      # systemWide = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      # If you want to use JACK applications, uncomment this
      #jack.enable = true;

      # use the example session manager (no others are packaged yet so this is enabled by default,
      # no need to redefine it in your config for now)
      #media-session.enable = true;
      wireplumber = {
        enable = true;
        extraConfig.bluetoothEnhancements = mkIf my.bluetooth.enable {
          "monitor.bluez.properties" = {
            "bluez5.enable-sbc-xq" = true;
            "bluez5.enable-msbc" = true;
            "bluez5.enable-hw-volume" = true;
            "bluez5.roles" = [
              "hsp_hs"
              "hsp_ag"
              "hfp_hf"
              "hfp_ag"
              "a2dp_sink"
              "a2dp_source"
              "bap_sink"
              "bap_source"
            ];
          };
        };
      };
    };
  };
}
