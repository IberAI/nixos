{ config, pkgs, lib, ... }:

let
  # Read-only SDK root (symlink to Nix store)
  stableSdkRoot = "${config.home.homeDirectory}/.local/share/android-sdk";

  # Writable overlay for "current" pointers, caches, etc.
  overlayRoot = "${config.home.homeDirectory}/.local/share/android-sdk-overlay";

  androidComposition = pkgs.androidenv.composeAndroidPackages {
    cmdLineToolsVersion = "latest";
    platformVersions    = [ "latest" ];
    buildToolsVersions  = [ "latest" ];

    includeNDK          = true;
    ndkVersions         = [ "latest" ];

    includeCmake        = true;
    cmakeVersions       = [ "latest" ];

    includeEmulator     = true;
    includeSystemImages = true;
    systemImageTypes    = [ "google_apis" ];
    abiVersions         = [ "x86_64" ];

    # Tools is obsolete; manual explicitly allows setting null :contentReference[oaicite:23]{index=23}
    toolsVersion = null;
  };

  androidSdk = androidComposition.androidsdk;
in
{
  home.packages = with pkgs; [
    androidSdk
    jdk17
    watchman
    cmake
    gnumake
    ninja
    pkg-config
    python3
  ];

  # Stable SDK root -> Nix store SDK (read-only)
  home.file.".local/share/android-sdk".source =
    "${androidSdk}/libexec/android-sdk";

  # Writable overlay
  home.file.".local/share/android-sdk-overlay".directory = true;

  home.sessionVariables = {
    ANDROID_HOME     = stableSdkRoot;
    # Nixpkgs manual notes ANDROID_SDK_ROOT is deprecated but sometimes needed :contentReference[oaicite:24]{index=24}
    ANDROID_SDK_ROOT = stableSdkRoot;

    JAVA_HOME = "${pkgs.jdk17}";

    # Stable NDK path (overlay), avoids ndk-bundle vs side-by-side surprises
    ANDROID_NDK_HOME = "${overlayRoot}/ndk/current";
    ANDROID_NDK_ROOT = "${overlayRoot}/ndk/current";
    NDK_HOME         = "${overlayRoot}/ndk/current";
  };

  home.sessionPath = [
    "${stableSdkRoot}/platform-tools"
    "${stableSdkRoot}/emulator"
    "${stableSdkRoot}/cmdline-tools/latest/bin"
  ];

  # Create overlay "current" symlink pointing into the (read-only) SDK
  home.activation.androidNdkCurrent = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    set -euo pipefail
    sdk="${stableSdkRoot}"
    overlay="${overlayRoot}"

    mkdir -p "$overlay/ndk"

    # Prefer side-by-side NDK: $sdk/ndk/<version>
    ver="$(ls -1 "$sdk/ndk" 2>/dev/null | grep -E '^[0-9]+' | head -n 1 || true)"
    if [ -n "$ver" ] && [ -d "$sdk/ndk/$ver" ]; then
      ln -sfn "$sdk/ndk/$ver" "$overlay/ndk/current"
      exit 0
    fi

    # Fallback to ndk-bundle (manual: first NDK is linked there) :contentReference[oaicite:25]{index=25}
    if [ -d "$sdk/ndk-bundle" ]; then
      ln -sfn "$sdk/ndk-bundle" "$overlay/ndk/current"
      exit 0
    fi

    echo "Warning: No NDK found under $sdk/ndk or $sdk/ndk-bundle"
  '';
}
