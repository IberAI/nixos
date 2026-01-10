{ config, pkgs, lib, ... }:

let
  stableSdkRoot = "${config.home.homeDirectory}/.local/share/android-sdk";

  androidComposition = pkgs.androidenv.composeAndroidPackages {
    platformVersions    = [ "latest" ];
    buildToolsVersions  = [ "latest" ];

    includeCmdlineTools = true;

    includeNDK          = true;
    ndkVersions         = [ "latest" ];

    includeCmake        = true;
    cmakeVersions       = [ "latest" ];

    includeEmulator     = true;
    includeSystemImages = true;

    abiVersions         = [ "x86_64" ];
    systemImageTypes    = [ "google_apis" ];
  };

  androidSdk = androidComposition.androidsdk;

  # Use a JDK that Gradle/AGP likes (RN/Expo Android commonly requires Java 17) :contentReference[oaicite:1]{index=1}
  jdk = pkgs.jdk17;
in
{
  home.packages = with pkgs; [
    androidSdk
    jdk

    watchman
    pkg-config
    gnumake
    ninja
    python3
  ];

  # Stable SDK root pointing into the Nix store
  home.file.".local/share/android-sdk".source =
    "${androidSdk}/libexec/android-sdk";

  home.sessionVariables = {
    ANDROID_HOME     = stableSdkRoot;
    ANDROID_SDK_ROOT = stableSdkRoot;

    # Make Java explicit for Gradle (more reliable than a system-wide guess)
    JAVA_HOME = "${jdk}";

    # Provide multiple vars because different tools/plugins look for different names
    ANDROID_NDK_HOME = "${stableSdkRoot}/ndk/current";
    ANDROID_NDK_ROOT = "${stableSdkRoot}/ndk/current";
    NDK_HOME         = "${stableSdkRoot}/ndk/current";
  };

  home.sessionPath = [
    "${stableSdkRoot}/platform-tools"
    "${stableSdkRoot}/emulator"
    "${stableSdkRoot}/cmdline-tools/latest/bin"
  ];

  # Create a stable NDK symlink: ~/.local/share/android-sdk/ndk/current -> ndk/<version>
  # This avoids “NDK not found” when the versioned folder name changes.
  home.activation.androidNdkCurrent = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    set -euo pipefail
    if [ -d "${stableSdkRoot}/ndk" ]; then
      ver="$(ls -1 "${stableSdkRoot}/ndk" | head -n 1 || true)"
      if [ -n "$ver" ] && [ -d "${stableSdkRoot}/ndk/$ver" ]; then
        mkdir -p "${stableSdkRoot}/ndk"
        ln -sfn "${stableSdkRoot}/ndk/$ver" "${stableSdkRoot}/ndk/current"
      fi
    fi
  '';
}
