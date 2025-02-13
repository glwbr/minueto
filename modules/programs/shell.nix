{
  config,
  lib,
  ...
}:
let
  inherit (lib) types;
  inherit (lib.aria) mkBoolOpt mkOpt;
  cfg = config.aria.programs.shell;
in
{
  options.aria.programs.shell = with types; {
    enable = mkBoolOpt false "Whether to enable shell configuration";
    historySize = mkOpt int 10000 "Size of history to keep";
    historyFile = mkOpt str "$HOME/.cache/zsh_history" "Location of history file";

  };

  config = lib.mkIf cfg.enable {
    environment.pathsToLink = [ "/share/zsh" ];

    programs = {
      direnv = {
        enable = cfg.enable;
        enableBashIntegration = true;
        enableFishIntegration = false;
        enableZshIntegration = true;
        nix-direnv.enable = true;
      };

      zsh = {
        enable = cfg.enable;
        enableCompletion = true;
        histFile = cfg.historyFile;
        histSize = cfg.historySize;
        setOptions = [
          "EXTENDED_HISTORY"
          "HIST_IGNORE_DUPS"
          "SHARE_HISTORY"
        ];
        shellAliases = import ./shell-aliases.nix;
      };
    };
  };
}
