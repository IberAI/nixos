# home/school/cop3330.nix
#
# COP3330 tooling (Temurin REQUIRED) without buildEnv conflicts:
# - Temurin JDK 21 is NOT added to home.packages (avoids collision with Android JDK17)
# - You still get java21/javac21 wrappers that use Temurin 21
# - eclipse-cop3330 launches Eclipse using Temurin 21
#
{
  pkgs,
  ...
}:
let
  # Temurin JDK 21 (try common attribute names across nixpkgs versions)
  temurin21 = pkgs."temurin-bin-21" or (pkgs.javaPackages.compiler.temurin-bin."jdk-21" or null);

  eclipse = pkgs.eclipses.eclipse-java;

  java21 = pkgs.writeShellScriptBin "java21" ''
    exec "${temurin21}/bin/java" "$@"
  '';

  javac21 = pkgs.writeShellScriptBin "javac21" ''
    exec "${temurin21}/bin/javac" "$@"
  '';

  eclipseCop = pkgs.writeShellScriptBin "eclipse-cop3330" ''
    set -euo pipefail
    export JAVA_HOME="${temurin21}"
    export PATH="${temurin21}/bin:$PATH"
    exec "${eclipse}/bin/eclipse" "$@"
  '';
in
{
  assertions = [
    {
      assertion = temurin21 != null;
      message = "Temurin JDK 21 is required for COP3330, but it wasn't found in your nixpkgs.";
    }
  ];

  # IMPORTANT:
  # Do NOT put temurin21 in home.packages (it conflicts with Android's JDK in buildEnv).
  home.packages = [
    eclipse
    java21
    javac21
    eclipseCop
  ];
}
