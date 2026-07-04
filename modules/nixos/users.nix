{ pkgs, ... }: {
  users.users.iber = {
    isNormalUser = true;
    description = "iber";
    shell = pkgs.fish;

    extraGroups = [
      "adbusers"
      "audio"
      "dialout"
      "docker"
      "kvm"
      "libvirtd"
      "plugdev"
      "video"
      "wheel"
      "wireshark"
    ];
  };
}
