{ pkgs ? import <nixpkgs> { }, ... }: {
  default = pkgs.mkShell {
    NIX_CONFIG = "extra-experimental-features = nix command flakes";
    # nix run github:nix-community/disko/latest -- --mode destroy,format,mount disko.nix
    nativeBuildInputs = with pkgs; [ disko git nix neovim ripgrep ];
  };
}
