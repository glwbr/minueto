{
  inputs,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib.aria) enabled;
in
{
  imports = [
    ./hardware.nix
    ./modules
  ];

  users = {
    defaultUserShell = pkgs.zsh;
    users.glwbr = {
      useDefaultShell = true;
      isNormalUser = true;
      initialPassword = "changeme";
      extraGroups = [
        "wheel"
        "networkmanager"
      ];
    };
  };

  environment = {
    variables = {
      DIRENV_LOG_FORMAT = "";
    };

    sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
    };

    systemPackages = with pkgs; [
      dunst
      git
      foot
      kitty
      pulsemixer
      waybar
      inputs.nvim.packages.${pkgs.system}.default
    ];
  };

  systemd = {
    extraConfig = ''
      DefaultTimeoutStopSec=15s
      DefaultTimeoutAbortSec=5s
    '';

    oomd = {
      enableRootSlice = true;
      enableUserSlices = true;
    };
  };

  services = {
    fstrim = {
      enable = true;
      interval = "weekly";
    };

    # Decrease journal size
    journald.extraConfig = ''
      SystemMaxUse=500M
    '';
  };

  zramSwap = enabled;

  aria = {
    system = {
      boot = enabled;
      locale = enabled;
      networking = {
        enable = true;
        hostname = "minueto";
      };
      fonts = enabled;
    };
    hardware = {
      audio = enabled;
      bluetooth = enabled;
    };
    nix = enabled;
    programs = {
      hyprland = enabled;
      nh = enabled;
      shell = enabled;
    };
    services = {
      dbus = enabled;
      gpg = enabled;
    };
  };

  system.stateVersion = "24.11";
}
