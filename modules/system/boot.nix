{
  config,
  lib,
  ...
}:
let
  inherit (lib.aria) mkBoolOpt;
  cfg = config.aria.system.boot;
in
{
  options.aria.system.boot = {
    enable = mkBoolOpt false "Whether to enable boot configuration";
    silentBoot = mkBoolOpt false "Whether to enable silent boot";
  };

  config = lib.mkIf cfg.enable {
    boot = {
      consoleLogLevel = if cfg.silentBoot then 0 else 3;
      initrd.systemd.enable = true;
      initrd.verbose = !cfg.silentBoot;
      kernelParams = [ "console=tty1" ];
      loader = {
        systemd-boot.enable = true;
        efi.canTouchEfiVariables = true;
        timeout = 0;
      };
      tmp = {
        useTmpfs = true;
        cleanOnBoot = true;
        # tmpfsSize = "50%";
      };
    };
  };
}
