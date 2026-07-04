{ pkgs, ... }: {
  programs = {
    fish.enable = true;
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
  };

  environment = {
    sessionVariables.EDITOR = "nvim";

    systemPackages = with pkgs; [
      clang
      cmake
      gcc
      gdb
      torsocks
    ];
  };
}
