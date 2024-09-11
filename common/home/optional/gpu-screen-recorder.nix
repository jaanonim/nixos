{pkgs, ...}: let
  saveReplay = pkgs.writeShellApplication {
    name = "gpu-save-replay";
    runtimeInputs = [pkgs.procps];
    text = ''
      pkill --signal SIGUSR1 -f gpu-screen-recorder && ${pkgs.libnotify}/bin/notify-send "GPU Screen Recorder" "Replay saved."
    '';
  };
in {
  home.packages = [
    saveReplay
  ];

  programs.plasma.hotkeys.commands."replay" = {
    name = "Save GPU Screen Recorder Replay";
    key = "Meta+Shift+R";
    command = "${saveReplay}/bin/gpu-save-replay";
    logs.enabled = true;
  };
}
