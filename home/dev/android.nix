# home/dev/android.nix
{ config, pkgs, ... }:

let
  androidPkgs = pkgs.androidenv.composeAndroidPackages {
    # These are the common knobs that still exist on newer nixpkgs.
    # If toolsVersion ever errors, delete the line.
    toolsVersion = "26.1.1";

    # Expo/RN Android builds: ensure API 35 exists.
    # Keeping 34 as fallback helps when deps still reference 34 toolchains.
    platformVersions = [ "35" "34" ];

    # Build tools: keep both for compatibility.
    buildToolsVersions = [ "35.0.0" "34.0.0" ];

    includeEmulator = true;
    includeNDK = true;

    # Pinning NDK can break evaluation if nixpkgs doesn't carry that exact version.
    # Only enable if you're sure the version exists in your channel.
    # ndkVersions = [ "26.1.10909125" ];
  };

  androidSdk = androidPkgs.androidsdk;
  sdkRoot = "${androidSdk}/libexec/android-sdk";

  sdkPaths = [
    "${sdkRoot}/platform-tools"            # adb
    "${sdkRoot}/emulator"                  # emulator
    "${sdkRoot}/cmdline-tools/latest/bin"  # sdkmanager, avdmanager (if present)
    "${sdkRoot}/tools/bin"
    "${sdkRoot}/tools"
  ];
in
{
  # License acceptance: system-level is best (you already set it), but harmless here too.
  nixpkgs.config.android_sdk.accept_license = true;

  home.packages = with pkgs; [
    androidSdk
    jdk17
    watchman
  ];

  # Visible to all shells AND GUI apps (Sway-launched apps too)
  home.sessionVariables = {
    ANDROID_HOME = sdkRoot;
    ANDROID_SDK_ROOT = sdkRoot;
    JAVA_HOME = pkgs.jdk17.home;
  };

  # PATH for all shells (bash/zsh/fish) + session
  home.sessionPath = sdkPaths;

  # Fish: add (deduped) + export vars, without overriding your other fish config
  programs.fish.enable = true;
  programs.fish.shellInit = ''
    set -gx ANDROID_HOME "${sdkRoot}"
    set -gx ANDROID_SDK_ROOT "${sdkRoot}"
    set -gx JAVA_HOME "${pkgs.jdk17.home}"

    fish_add_path -g \
      ${builtins.concatStringsSep " \\\n      " sdkPaths}
  '';
}
