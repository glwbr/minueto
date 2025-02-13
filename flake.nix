{
  description = "Test disko";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    hm = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nvim.url = "path:/home/glwbr/projects/personal/nvim";
    #nvim.url = "path:github:glwbr/nvim";
  };

  outputs =
    {
      self,
      nixpkgs,
      disko,
      ...
    }@inputs:
    let
      inherit (self) outputs;

      lib = nixpkgs.lib.extend (
        final: prev: {
          aria = import ./lib {
            lib = final;
          };
        }
      );

      systems = [
        "aarch64-linux"
        "x86_64-linux"
      ];

      forEachSystem = f: lib.genAttrs systems (system: f pkgsFor.${system});

      pkgsFor = lib.genAttrs systems (
        system:
        import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        }
      );
    in
    {
      devShells = forEachSystem (pkgs: import ./shell.nix { inherit pkgs; });
      formatter = forEachSystem (pkgs: pkgs.alejandra);

      nixosConfigurations = {
        minueto = lib.nixosSystem {
          modules = [
            disko.nixosModules.disko
            ./disko.nix
            ./configuration.nix
          ];
          specialArgs = { inherit lib inputs outputs; };
        };
      };
    };
}
