{
  description = "iber's NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    aporetic-font = {
      url = "github:Echinoidea/Aporetic-Nerd-Font";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix4nvchad = {
      url = "github:nix-community/nix4nvchad";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    nixpkgs,
    nur,
    ...
  } @ inputs: let
    system = "x86_64-linux";
    pkgs = import nixpkgs {inherit system;};
  in {
    # ✅ Dotfiles formatter: enables `nix fmt` in this repo
    formatter.${system} = pkgs.alejandra; # or pkgs.nixfmt-rfc-style

    # ✅ Dotfiles dev shell: enables `nix develop` in this repo
    devShells.${system}.default = pkgs.mkShell {
      packages = with pkgs; [
        alejandra
        deadnix
        statix
        nix-tree
      ];

      shellHook = ''
        echo "Dotfiles shell loaded."
        echo "Commands:"
        echo "  nix fmt"
        echo "  deadnix ."
        echo "  statix check ."
        echo "  nix-tree"
      '';
    };

    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      inherit system;

      specialArgs = {inherit inputs;};

      modules = [
        {nixpkgs.overlays = [nur.overlays.default];}
        ./configuration.nix
      ];
    };
  };
}
