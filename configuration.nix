{
  pkgs,
  inputs,
  ...
}: {
  ########################################
  # Imports
  ########################################
  imports = [
    ./hardware-configuration.nix
    inputs.home-manager.nixosModules.default
  ];

  ########################################
  # Bluetooth / power / storage services
  ########################################
  hardware = {
    bluetooth.enable = true;

    graphics = {
      enable = true;
      enable32Bit = true;
    };

    amdgpu = {
      initrd.enable = true;
      opencl.enable = true;
    };
  };

  services = {
    printing = {
      enable = true;

      drivers = with pkgs; [
        gutenprint
        hplip
      ];

      browsing = true;

      browsedConf = ''
        BrowseRemoteProtocols dnssd
        BrowseLocalProtocols dnssd
        CreateIPPPrinterQueues All
      '';
    };

    avahi = {
      enable = true;
      nssmdns4 = true;

      openFirewall = true;
    };
    blueman.enable = true;
    udisks2.enable = true;
    gvfs.enable = true;
    upower.enable = true;
    pulseaudio.enable = false;

    pipewire = {
      enable = true;
      alsa.enable = true;
      pulse.enable = true;
      jack.enable = true;
    };

    # OPTIONAL but helpful for some Android devices:
    udev.extraRules = ''
      SUBSYSTEM=="usb", ATTR{idVendor}=="04e8", MODE="0660", GROUP="adbusers", TAG+="uaccess"
      SUBSYSTEM=="usb", ATTR{idVendor}=="18d1", MODE="0660", GROUP="adbusers", TAG+="uaccess"
    '';
  };

  ########################################
  # Bootloader
  ########################################
  boot = {
    loader = {
      systemd-boot = {
        enable = true;
        configurationLimit = 10;
      };
      efi.canTouchEfiVariables = true;
    };
  };

  ########################################
  # Nix settings / unfree packages
  ########################################
  nix = {
    settings.experimental-features = ["nix-command" "flakes"];

    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 10d";
    };

    optimise = {
      automatic = true;
      dates = ["weekly"];
    };
  };

  nixpkgs.config = {
    allowUnfree = true;

    # IMPORTANT for Android SDK via Nix
    android_sdk.accept_license = true;
  };

  ########################################
  # Networking
  ########################################
  networking = {
    hostName = "nixos";
    networkmanager.enable = true;
    firewall.enable = true;
  };

  virtualisation = {
    docker.enable = true;
    libvirtd.enable = true; # emulator acceleration (optional)
  };

  ########################################
  # Time zone / locale
  ########################################
  time.timeZone = "America/New_York";

  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "en_US.UTF-8";
      LC_MEASUREMENT = "en_US.UTF-8";
      LC_MONETARY = "en_US.UTF-8";
      LC_IDENTIFICATION = "en_US.UTF-8";
      LC_NAME = "en_US.UTF-8";
      LC_NUMERIC = "en_US.UTF-8";
      LC_PAPER = "en_US.UTF-8";
      LC_TELEPHONE = "en_US.UTF-8";
      LC_TIME = "en_US.UTF-8";
    };
  };

  ########################################
  # User account
  ########################################
  users.users.iber = {
    isNormalUser = true;
    description = "iber";
    extraGroups = [
      "wheel"
      "audio"
      "video"
      "wireshark"
      "docker"
      "adbusers"
      "kvm"
      "libvirtd"
    ];
    packages = [];
    shell = pkgs.fish;
  };

  security = {
    sudo = {
      enable = true;
      wheelNeedsPassword = true;
    };

    polkit.enable = true;
    rtkit.enable = true;
  };

  ########################################
  # Shells / Programs
  ########################################
  programs = {
    fish.enable = true;

    sway = {
      enable = true;
      wrapperFeatures.gtk = true;
    };

    nix-ld.enable = true;

    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };

    java = {
      enable = true;
      package = pkgs.jdk17;
    };

    wireshark.enable = true;

    # ADB + permissions group
    adb.enable = true;
  };

  ########################################
  # Portals (Wayland)
  ########################################
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-wlr
    ];
  };

  ########################################
  # Environment variables
  ########################################
  environment = {
    sessionVariables = {
      NIXOS_OZONE_WL = "1";
      EDITOR = "nvim";
    };

    systemPackages = with pkgs; [
      gcc
      cmake
      gdb
      clang
    ];
  };

  ########################################
  # Home-Manager (via flakes)
  ########################################
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = {inherit inputs;};
    users.iber = import ./home.nix;
  };

  ########################################
  # System state version
  ########################################
  system.stateVersion = "24.11";
}
