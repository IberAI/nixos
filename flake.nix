{
  description = "iber's NixOS configuration";

  inputs = {
    # Stable NixOS
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";

    # Home Manager matching nixpkgs
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # NUR (for pkgs.nur.* like firefox-addons)
    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Optional: your Aporetic Nerd Font source, kept as an input
    aporetic-font = {
      url = "github:Echinoidea/Aporetic-Nerd-Font";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix4nvchad = {
      url = "github:nix-community/nix4nvchad";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs = { self, nixpkgs, home-manager, nur, aporetic-font, ... } @ inputs:
    let
      system = "x86_64-linux";
    in {
      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
        inherit system;

        # So configuration.nix can do { config, pkgs, inputs, ... }:
        specialArgs = { inherit inputs; };

        modules = [
          # Make NUR available as pkgs.nur.*
          { nixpkgs.overlays = [ nur.overlays.default ]; }

          # Your main system config (this already imports home-manager)
          ./configuration.nix
        ];
      };
    };
}

