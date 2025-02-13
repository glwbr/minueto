{
  config,
  lib,
  ...
}:
let
  inherit (lib.aria) mkBoolOpt;
  cfg = config.aria.hardware.bluetooth;
in
{
  options.aria.hardware.bluetooth = {
    enable = mkBoolOpt false "Whether to enable bluetooth";
  };

  config = lib.mkIf cfg.enable {
    hardware.bluetooth = {
      enable = cfg.enable;
      powerOnBoot = true;
      settings.General.FastConnectable = true;
    };
  };
}
