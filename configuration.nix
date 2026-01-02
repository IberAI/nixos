{
  config,
  pkgs,
  inputs,
  ...
}:

{
  ########################################
  # Imports
  ########################################
  imports = [
    ./hardware-configuration.nix
    # Home Manager via flake
    inputs.home-manager.nixosModules.default
  ];

  hardware.bluetooth.enable = true;
  services.blueman.enable = true;
  services.udisks2.enable = true;
  services.gvfs.enable = true;
  services.upower.enable = true;

  ########################################
  # Bootloader
  ########################################
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot.configurationLimit = 10;

  ########################################
  # Nix settings / unfree packages
  ########################################
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 10d";
  };

  nix.optimise = {
    automatic = true;
    dates = [ "weekly" ];
  };

  ########################################
  # Networking
  ########################################
  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  networking.firewall.enable = true; 

  virtualisation.docker.enable = true;

  ########################################
  # Time zone / locale
  ########################################
  time.timeZone = "America/New_York";
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS        = "en_US.UTF-8";
    LC_MEASUREMENT    = "en_US.UTF-8";
    LC_MONETARY       = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_NAME           = "en_US.UTF-8";
    LC_NUMERIC        = "en_US.UTF-8";
    LC_PAPER          = "en_US.UTF-8";
    LC_TELEPHONE      = "en_US.UTF-8";
    LC_TIME           = "en_US.UTF-8";
  };

  ########################################
  # User account
  ########################################
  users.users.iber = {
    isNormalUser = true;
    description = "iber";
    extraGroups = [
      "wheel"      # sudo
      "audio"
      "video"
      "wireshark"
      "docker"
      "adbusers"
    ];
    packages = with pkgs; [ ];
    shell = pkgs.fish;
  };

  security.sudo.enable = true;
  security.sudo.wheelNeedsPassword = true;
  security.polkit.enable = true;

  ########################################
  # Shells
  ########################################
  programs.fish.enable = true;

  ########################################
  # Graphics / audio (optimized for AMD Vega)
  ########################################
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  hardware.amdgpu = {
    initrd.enable = true;
    opencl.enable = true;
  };

  services.pulseaudio.enable = false;

  security.rtkit.enable = true; # optional but recommended for PipeWire

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
    jack.enable = true;
  };

  ########################################
  # Sway (Wayland tiling "desktop")
  ########################################
  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
  };

  xdg.portal.enable = true;
  xdg.portal.extraPortals = with pkgs; [
    xdg-desktop-portal-wlr
  ];

  # Wayland-friendly environment variables.
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    EDITOR = "nvim";
    JAVA_HOME = "${pkgs.jdk17}";
  };

  ########################################
  # Packages installed in system profile
  ########################################
  environment.systemPackages = with pkgs; [
    gcc
    cmake
    gdb
    clang
  ];

  ########################################
  # Programs / services
  ########################################
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  programs.java = {
    enable = true;
    package = pkgs.jdk17;
  };

  programs.wireshark.enable = true;
  programs.wireshark.package = pkgs.wireshark;

  programs.adb.enable = true;

  ########################################
  # Home-Manager (via flakes)
  ########################################
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = { inherit inputs; };
    users.iber = import ./home.nix;
  };

  ########################################
  # System state version
  ########################################
  system.stateVersion = "24.11";
}
