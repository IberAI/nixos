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

  # GC / optimisation: keep these as “optimizations”
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

  # New-style graphics module (replaces hardware.opengl)
  hardware.graphics = {
    enable = true;
    enable32Bit = true; # 32-bit for Steam / Proton etc.
  };

  # Extra AMD-specific goodies
  hardware.amdgpu = {
    initrd.enable = true;   # load amdgpu early for nicer boot / KMS
    opencl.enable = true;   # enable ROCm OpenCL stack where supported
  };

  hardware.pulseaudio.enable = false;
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
    wrapperFeatures.gtk = true;  # GTK + XWayland support
  };

  # Portals (for screen sharing, file pickers, etc.).
  xdg.portal.enable = true;
  xdg.portal.extraPortals = with pkgs; [
    xdg-desktop-portal-wlr
  ];

  # Wayland-friendly environment variables.
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";  # make Electron/Chrome apps use Wayland
    EDITOR = "nvim";
  };

  ########################################
  # Packages installed in system profile
  ########################################

  environment.systemPackages = with pkgs; [
    ####################
    # Desktop components
    ####################
    waybar            # bar
    kitty             # terminal
    rofi              # app launcher (Wayland/X via XWayland)
    dunst             # notifications
    wlogout           # logout/power menu
    grim              # screenshots
    slurp             # region selection
    wl-clipboard      # clipboard (wl-copy / wl-paste)
    wf-recorder       # screen recording

    # theming / cursors
    adwaita-icon-theme

    ####################
    # Your main apps
    ####################
    keepassxc
    neovim
    emacs
    wireshark
    kicad
    librewolf
    android-studio
    mpv
    gimp
    ffmpeg

    ####################
    # Shell / CLI extras
    ####################
    lsd
    fastfetch

    ####################
    # Dev toolchains you asked for
    ####################
    gcc                 # C / C++ compiler
    cmake               # build system (C / C++ etc.)
    gdb                 # C / C++ debugger

    rustc               # Rust compiler
    cargo               # Rust package manager / build tool
    rustfmt             # Rust formatter
    clippy              # Rust lints
    rust-analyzer       # Rust language server (for NVChad / LSP)

    nodejs              # Node.js + npm (for React Native / Expo, JS tooling)

    ####################
    # Basic tools
    ####################
    git
    curl
    wget
    zip
    unzip
    p7zip
    htop
  ];

  ########################################
  # Programs / services
  ########################################

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # System-wide JDK with proper JAVA_HOME (good for Android/Gradle)
  programs.java = {
    enable = true;
    package = pkgs.jdk17;  # JDK 17 works with AGP 8.x builds
  };

  # Wireshark (basic enable)
  programs.wireshark.enable = true;
  programs.wireshark.package = pkgs.wireshark;

  # (SSH / firewall left as in your old config – commented if unused)
  # services.openssh.enable = true;
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # networking.firewall.enable = false;

  ########################################
  # Home-Manager (via flakes)
  ########################################

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;

    # Load full declarative user/Sway configuration
    users.iber = import ./home.nix;
  };

  ########################################
  # System state version
  ########################################

  system.stateVersion = "24.11"; # keep as your install release
}

