{ inputs, ... }: {
  imports = [
    ../../hardware-configuration.nix
    ../../modules/nixos/android.nix
    ../../modules/nixos/audio.nix
    ../../modules/nixos/boot.nix
    ../../modules/nixos/desktop.nix
    ../../modules/nixos/hardware.nix
    ../../modules/nixos/home-manager.nix
    ../../modules/nixos/networking.nix
    ../../modules/nixos/nix.nix
    ../../modules/nixos/printing.nix
    ../../modules/nixos/programs.nix
    ../../modules/nixos/radio.nix
    ../../modules/nixos/security.nix
    ../../modules/nixos/secrets.nix
    ../../modules/nixos/tor.nix
    ../../modules/nixos/users.nix
    ../../modules/nixos/virtualisation.nix

    inputs.home-manager.nixosModules.default
    inputs.sops-nix.nixosModules.sops
  ];

  system.stateVersion = "24.11";
}
