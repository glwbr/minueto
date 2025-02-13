{
  config,
  lib,
  ...
}:
let
  inherit (lib.aria) mkBoolOpt;
  cfg = config.aria.programs.nh;
in
{
  options.aria.programs.nh = {
    enable = mkBoolOpt false "Whether to enable nh";
  };

  config = lib.mkIf cfg.enable {
    programs.nh = {
      enable = cfg.enable;
      clean = {
        enable = true;
        extraArgs = "--keep-since 3d --keep 3";
      };
      flake = "/home/glwbr/projects/dotfiles";
    };

  };
}
