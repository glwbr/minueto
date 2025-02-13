{
  config,
  lib,
  ...
}:
let
  inherit (lib.aria) mkBoolOpt;
  cfg = config.aria.system.networking;
in
{
  options.aria.system.networking = {
    enable = mkBoolOpt false "Whether to enable networking";
    hostname = lib.mkOption {
      type = lib.types.str;
      default = "minueto";
      description = "The hostname of the machine";
    };
  };

  config = lib.mkIf cfg.enable {
    networking = {
      hostName = cfg.hostname;
      firewall = {
        enable = true;
        allowedTCPPorts = [
          80
          443
          8080
        ];
      };

      nftables.enable = lib.mkDefault true;
      wireless.iwd = {
        enable = cfg.enable;
        settings = {
          IPv6.Enable = true;
          Settings.AutoConnect = true;
        };
      };
    };
  };
}
