{
  config,
  lib,
  inputs,
  ...
}:
let
  inherit (lib.aria) mkBoolOpt;
  cfg = config.aria.nix;
  flakeInputs = lib.filterAttrs (_: lib.isType "flake") inputs;
in
{
  options.aria.nix = {
    enable = mkBoolOpt false "Whether to enable Nix configuration";
  };

  config = lib.mkIf cfg.enable {
    nix = {
      settings = {
        auto-optimise-store = lib.mkDefault true;
        experimental-features = [
          "nix-command"
          "flakes"
        ];
        flake-registry = "";
        warn-dirty = false;
      };

      nixPath = lib.mapAttrsToList (n: _: "${n}=flake:${n}") flakeInputs;
      registry = lib.mapAttrs (_: flake: { inherit flake; }) flakeInputs;
    };

    nixpkgs.config.allowUnfree = true;
  };
}
