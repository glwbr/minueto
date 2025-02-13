{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.aria) mkBoolOpt;
  cfg = config.aria.system.fonts;
in
{
  options.aria.system.fonts = {
    enable = mkBoolOpt false "Whether to enable font configuration";
  };

  config = lib.mkIf cfg.enable {
    fonts = {
      enableDefaultPackages = false;
      packages = with pkgs; [
        nerd-fonts.jetbrains-mono
        nerd-fonts.symbols-only
        nerd-fonts.noto
        noto-fonts
        noto-fonts-cjk-sans
        noto-fonts-emoji
      ];
      fontconfig = {
        enable = true;
        subpixel.lcdfilter = "none";
      };
    };
  };
}
