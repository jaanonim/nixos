{...}: {
  my.containers.llama = {
    models = {
      "gemma-4-e4b" = {
        hfId = "ggml-org/gemma-4-E4B-it-GGUF";
        context = 32768;
        output = 8192;
        extraArgs = [
          "-ngl 33"
          "--threads 8"
          "--batch-size 512"
          "--ubatch-size 256"
          "--cache-type-k q8_0"
          "--cache-type-v q8_0"
        ];
      };
      "qwen3.5-35b-a3b" = {
        hfId = "mradermacher/Qwen3.5-35B-A3B-Claude-4.6-Opus-Reasoning-Distilled-GGUF";
        context = 98304;
        output = 32768;
        extraArgs = [
          "--threads 8"
          "--batch-size 512"
          "--ubatch-size 256"
          "--cache-type-k q8_0"
          "--cache-type-v q8_0"
          "--temp 0.6"
          "--top-k 20"
          "--top-p 0.95"
        ];
      };
    };
    extraConfig = ''
      healthCheckTimeout: 600
      ttl: 300
    '';
  };
}
