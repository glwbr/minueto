{ inputs, pkgs, ... }:
let
  aliases = import ./git-aliases.nix;
  ignores = [
    # general
    ".cache/"
    "tmp/"
    "*.tmp"
    "log/"
    "._*"

    # IDE
    "*.swp"
    ".idea/"
    ".~lock*"

    # nix
    "result"
    "result-*"
    ".direnv/"

    # node
    "node_modules/"
  ];
in
{
  home = {
    username = "glwbr";
    homeDirectory = "/home/glwbr";
    stateVersion = "24.11";
  };

  home.packages = with pkgs; [
    bottom
    (discord.override { withVencord = true; })
    firefox
    fd
    ripgrep
  ];

  nixpkgs = {
    config.allowUnfree = true;
    config.allowUnfreePredicate = _: true;
  };

  programs.home-manager.enable = true;

  programs.eza = {
    enable = true;
    enableBashIntegration = false;
    enableFishIntegration = false;
    enableZshIntegration = false;
    enableNushellIntegration = false;
  };

  programs.git = {
    enable = true;
    userName = "glwbr";
    userEmail = "glauber.silva14@gmail.com";
    inherit aliases;
    inherit ignores;
    extraConfig = {
      core = {
        editor = "nvim";
        whitespace = "trailing-space,space-before-tab,indent-with-non-tab";
      };
      checkout = {
        defaultRemote = "origin";
      };
      init.defaultBranch = "main";
      pull.ff = "only";
      pull.rebase = true;
      push.autoSetupRemote = true;
      rebase.autoStash = true;
    };
    lfs.enable = true;
  };

}
