{ config, pkgs, lib, ... }:

let
  stableSdkRoot = "${config.home.homeDirectory}/.local/share/android-sdk";

  androidComposition = pkgs.androidenv.composeAndroidPackages {
    # In your nixpkgs, cmdline-tools is controlled by this
    cmdLineToolsVersion = "latest";

    # Most recent available in your nixpkgs snapshot (flake.lock controls reproducibility)
    platformVersions   = [ "latest" ];
    buildToolsVersions = [ "latest" ];

    includeNDK    = true;
    ndkVersions   = [ "latest" ];

    includeCmake  = true;
    cmakeVersions = [ "latest" ];

    includeEmulator     = true;
    includeSystemImages = true;

    abiVersions      = [ "x86_64" ];
    systemImageTypes = [ "google_apis" ];

    # Avoid legacy "tools" package; rely on cmdline-tools
    toolsVersion = null;
  };

  androidSdk = androidComposition.androidsdk;

  # Java 17 is the safe default for modern Android Gradle Plugin / RN builds
  jdk = pkgs.jdk17;
in
{
  home.packages = with pkgs; [
    androidSdk

    # Gradle/AGP friendliness
    jdk

    # Expo / RN helpers
    watchman
    pkg-config
    gnumake
    ninja
    cmake
    python3
  ];

  # Stable SDK path that does not change across rebuilds
  home.file.".local/share/android-sdk".source =
    "${androidSdk}/libexec/android-sdk";

  home.sessionVariables = {
    ANDROID_HOME     = stableSdkRoot;
    ANDROID_SDK_ROOT = stableSdkRoot;

    # Many Android builds expect JAVA_HOME
    JAVA_HOME = "${jdk}";

    # Use a stable NDK path (avoid versioned dir surprises)
    ANDROID_NDK_HOME = "${stableSdkRoot}/ndk/current";
    ANDROID_NDK_ROOT = "${stableSdkRoot}/ndk/current";
    NDK_HOME         = "${stableSdkRoot}/ndk/current";
  };

  home.sessionPath = [
    "${stableSdkRoot}/platform-tools"
    "${stableSdkRoot}/emulator"
    "${stableSdkRoot}/cmdline-tools/latest/bin"
  ];

  # Create a stable NDK symlink:
  # - Prefer side-by-side NDK at $SDK/ndk/<version>
  # - Fall back to legacy $SDK/ndk-bundle if that's what exists
  home.activation.androidNdkCurrent = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    set -euo pipefail

    sdk="${stableSdkRoot}"

    mkdir -p "$sdk/ndk"

    # Prefer side-by-side NDK: $sdk/ndk/<version>
    ver="$(ls -1 "$sdk/ndk" 2>/dev/null | grep -E '^[0-9]+' | head -n 1 || true)"
    if [ -n "$ver" ] && [ -d "$sdk/ndk/$ver" ]; then
      ln -sfn "$sdk/ndk/$ver" "$sdk/ndk/current"
      exit 0
    fi

    # Fallback: legacy NDK location
    if [ -d "$sdk/ndk-bundle" ]; then
      ln -sfn "$sdk/ndk-bundle" "$sdk/ndk/current"
    fi
  '';
}
