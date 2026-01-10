{ config, pkgs, lib, ... }:

let
  # Writable SDK root (this MUST be writable for Gradle/AGP to download/install packages)
  sdkRoot     = "${config.home.homeDirectory}/.local/share/android-sdk";
  overlayRoot = "${config.home.homeDirectory}/.local/share/android-sdk-overlay";

  # Pin if you know your logs demand a specific NDK; otherwise you can set includeNDK=false
  requiredNdk = "27.1.12297006";

  androidComposition = pkgs.androidenv.composeAndroidPackages {
    # Use "latest" unless you want strict pinning
    cmdLineToolsVersion  = "latest";
    platformToolsVersion = "latest";
    platformVersions     = [ "latest" ];
    buildToolsVersions   = [ "latest" ];

    includeNDK   = true;
    ndkVersions  = [ requiredNdk "latest" ];

    includeCmake   = true;
    cmakeVersions  = [ "latest" ];

    # Optional: emulator bits (remove if you don't need emulator)
    includeEmulator     = true;
    includeSystemImages = true;
    systemImageTypes    = [ "google_apis" ];
    abiVersions         = [ "x86_64" ];

    toolsVersion = null; # deprecated, keep null
  };

  # Where nixpkgs puts its SDK (read-only). We'll COPY initial pieces into sdkRoot.
  storeSdkRoot = "${androidComposition.androidsdk}/libexec/android-sdk";

  jdk = pkgs.jdk17;

in
{
  # Tooling you'll want around for Expo/RN native Android builds
  home.packages = with pkgs; [
    jdk
    androidComposition.androidsdk
    android-tools   # adb, etc.
    watchman
    pkg-config
    gnumake
    ninja
    cmake
    python3
    rsync
  ];

  # ✅ Correct way to enable AGP/Gradle SDK auto-download:
  # Put it in gradle.properties (NOT via env var), because the key contains dots.
  home.file.".gradle/gradle.properties".text = ''
    # Allow AGP/Gradle to download missing Android SDK components
    android.builder.sdkDownload=true
  '';

  # Environment variables for shells
  home.sessionVariables = {
    ANDROID_HOME     = sdkRoot;
    ANDROID_SDK_ROOT = sdkRoot;

    JAVA_HOME = "${jdk}";

    # Optional stable NDK pointers (some tools read these)
    ANDROID_NDK_HOME = "${overlayRoot}/ndk/current";
    ANDROID_NDK_ROOT = "${overlayRoot}/ndk/current";
    NDK_HOME         = "${overlayRoot}/ndk/current";
  };

  # Environment variables for GUI-launched apps (Android Studio, IDEs, etc.)
  systemd.user.sessionVariables = {
    ANDROID_HOME     = sdkRoot;
    ANDROID_SDK_ROOT = sdkRoot;

    ANDROID_NDK_HOME = "${overlayRoot}/ndk/current";
    ANDROID_NDK_ROOT = "${overlayRoot}/ndk/current";
    NDK_HOME         = "${overlayRoot}/ndk/current";
  };

  # Put writable SDK tools on PATH
  home.sessionPath = [
    "${sdkRoot}/platform-tools"
    "${sdkRoot}/emulator"
    "${sdkRoot}/cmdline-tools/latest/bin"
  ];

  # Seed a minimal, working writable SDK tree from the nix store SDK so Gradle can
  # later download/install missing platforms/build-tools into sdkRoot.
  home.activation.seedAndroidSdk = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    set -euo pipefail

    mkdir -p "${sdkRoot}"
    mkdir -p "${overlayRoot}/ndk"

    # Copy cmdline-tools into writable SDK root (critical for downloads)
    if [ ! -d "${sdkRoot}/cmdline-tools/latest" ] && [ -d "${storeSdkRoot}/cmdline-tools/latest" ]; then
      mkdir -p "${sdkRoot}/cmdline-tools"
      cp -a "${storeSdkRoot}/cmdline-tools/latest" "${sdkRoot}/cmdline-tools/"
    fi

    # Copy platform-tools (adb)
    if [ ! -d "${sdkRoot}/platform-tools" ] && [ -d "${storeSdkRoot}/platform-tools" ]; then
      cp -a "${storeSdkRoot}/platform-tools" "${sdkRoot}/"
    fi

    # Copy emulator bits if present (optional)
    if [ ! -d "${sdkRoot}/emulator" ] && [ -d "${storeSdkRoot}/emulator" ]; then
      cp -a "${storeSdkRoot}/emulator" "${sdkRoot}/"
    fi

    # Seed licenses if available (helps avoid the first-run license failure)
    mkdir -p "${sdkRoot}/licenses"
    if [ -d "${storeSdkRoot}/licenses" ]; then
      # Only copy if sdkRoot/licenses is empty-ish (avoid clobber)
      if [ -z "$(ls -A "${sdkRoot}/licenses" 2>/dev/null || true)" ]; then
        cp -a "${storeSdkRoot}/licenses/." "${sdkRoot}/licenses/" || true
      fi
    fi

    # Create a stable "current" NDK symlink pointing at the pinned version (if present in store)
    if [ -d "${storeSdkRoot}/ndk/${requiredNdk}" ]; then
      rm -f "${overlayRoot}/ndk/current"
      ln -s "${storeSdkRoot}/ndk/${requiredNdk}" "${overlayRoot}/ndk/current"
    fi

    # Ensure the directories exist even if not yet downloaded
    mkdir -p "${sdkRoot}/cmdline-tools"
    mkdir -p "${sdkRoot}/platforms" "${sdkRoot}/build-tools"

    echo "Android SDK (writable) ready at: ${sdkRoot}"
  '';
}
