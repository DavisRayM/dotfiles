{ ... }:

{
  flake.nixosModules.llm =
    { pkgs, lib, ... }:
    {
      services.ollama = {
        enable = true;
        loadModels = [
          "llama3.2:3b"
          "qwen2.5-coder:7b"
          "deepseek-r1:8b"
        ];
        environmentVariables = {
          OLLAMA_KEEP_ALIVE = "-1";
          OLLAMA_CONTEXT_LENGTH = "8192";
        };
        package = pkgs.ollama-cuda;
      };
    };
}
