{
  pkgs,
  config,
  lib,
  ...
}:
with lib; let
  my = config.my;
in {
  config = mkIf (builtins.any (ele: (ele == (lib.removeSuffix ".nix" (baseNameOf __curPos.file)))) my.apps) (let
    gsr = pkgs.gpu-screen-recorder;
    gsr-start = pkgs.writeShellApplication {
      name = "gsr-start";
      runtimeInputs = [pkgs.pulseaudio];
      text = ''
        ${gsr}/bin/gpu-screen-recorder ${concatStringsSep " " [
          ''-v no''
          ''-mf no''
          ''-o ${my.homeDirectory}/Wideo''
          # ''-restore-portal-session yes''
          # Audio settings
          ''-ac opus''
          ''-a "$(pactl get-default-sink).monitor"''
          ''-a "$(pactl get-default-source)"''
          # Video settings
          ''-w "HDMI-A-1"''
          ''-f 60''
          ''-r 60''
          ''-c mp4''
          ''-k auto''
          ''-q very_high''
        ]}
      '';
    };
    save-replay = pkgs.writeShellApplication {
      name = "gpu-save-replay";
      runtimeInputs = [pkgs.procps];
      text = ''
        pkill --signal SIGUSR1 -f gpu-screen-recorder && ${pkgs.libnotify}/bin/notify-send "GPU Screen Recorder" "Replay saved."
      '';
    };
  in {
    my._packages = [
      pkgs.gpu-screen-recorder-gtk
      save-replay
      gsr
    ];

    security.wrappers = {
      gpu-screen-recorder = {
        owner = "root";
        group = "video";
        capabilities = "cap_sys_nice+ep";
        source = "${gsr}/bin/gpu-screen-recorder";
      };

      gsr-kms-server = {
        owner = "root";
        group = "video";
        capabilities = "cap_sys_admin+ep";
        source = "${gsr}/bin/gsr-kms-server";
      };
    };

    systemd.user.services = {
      "gpu-screen-recorder" = {
        enable = true;
        description = "GPU Screen Recorder Service";
        environment = {
          WINDOW = "HDMI-A-1";
          CONTAINER = "mp4";
          QUALITY = "very_high";
          CODEC = "auto";
          AUDIO_CODEC = "opus";
          AUDIO_DEVICE = "default_output";
          FRAMERATE = "60";
          REPLAYDURATION = "60";
          OUTPUTDIR = "%h/Wideo";
          MAKEFOLDERS = "no";
          KEYINT = "2";
          ENCODER = "gpu";
          RESTORE_PORTAL_SESSION = "yes";
        };
        serviceConfig = {
          Type = "simple";
          ExecStart = "${gsr-start}/bin/gsr-start";
          Restart = "on-failure";
          RestartSec = "5s";
        };
        wantedBy = ["default.target"];
      };
    };

    home-manager.users.${my.mainUser}.programs.plasma.hotkeys.commands."replay" = mkIf (my.desktop.plasmaManager && my.homeManager) {
      name = "Save GPU Screen Recorder Replay";
      key = "Meta+Shift+R";
      command = "${saveReplay}/bin/gpu-save-replay";
      logs.enabled = true;
    };
  });
}
