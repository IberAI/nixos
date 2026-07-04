{ lib, pkgs, ... }:
let
  secretsFile = ../../secrets/secrets.yaml;
  hasSecretsFile = builtins.pathExists secretsFile;
in
{
  environment.systemPackages = with pkgs; [
    age
    sops
    ssh-to-age
  ];

  sops = lib.mkIf hasSecretsFile {
    defaultSopsFile = secretsFile;

    age.sshKeyPaths = [
      "/etc/ssh/ssh_host_ed25519_key"
    ];

    secrets =
      let
        userSecret = {
          owner = "iber";
          group = "users";
          mode = "0400";
        };
      in
      {
        "git/userName" = userSecret;
        "git/userEmail" = userSecret;
        "git/signingKey" = userSecret;
        "matrix/userId" = userSecret;
        "matrix/homeserver" = userSecret;
      };
  };
}
