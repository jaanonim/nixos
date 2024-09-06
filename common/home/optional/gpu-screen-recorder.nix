{config, ...}: {
  home.file.".config/gpu-screen-recorder.env".source = builtins.toFile "gpu-screen-recorder.env" ''
    WINDOW=screen
    CONTAINER=mp4
    QUALITY=very_high
    CODEC=h264
    AUDIO_CODEC=opus
    AUDIO_DEVICE=default_output
    SECONDARY_AUDIO_DEVICE=default_input
    FRAMERATE=60
    REPLAYDURATION=60
    OUTPUTDIR=${config.home.homeDirectory}/Wideo
    KEYINT=2
    ENCODER=gpu
    RESTORE_PORTAL_SESSION=yes
  '';
}
