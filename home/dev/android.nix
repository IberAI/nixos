{ config, pkgs, lib, ... }:

let
  # Read-only SDK root (symlink to Nix store)
  stableSdkRoot = "${config.home.homeDirectory}/.local/share/android-sdk";

  # Writable overlay for stable pointers (safe to modify)
  overlayRoot = "${config.home.homeDirectory}/.local/share/android-sdk-overlay";

  androidComposition = pkgs.androidenv.composeAndroidPackages {
    # Your nixpkgs uses this knob (NOT includeCmdlineTools)
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

    # Prefer cmdline-tools; disable legacy tools package
    toolsVersion = null;
  };

  androidSdk = androidComposition.androidsdk;
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
    cmake
    python3
  ];

  # Stable SDK root -> Nix store SDK (read-only)
  home.file.".local/share/android-sdk".source =
    "${androidSdk}/libexec/android-sdk";

  home.sessionVariables = {
    ANDROID_HOME     = stableSdkRoot;
    ANDROID_SDK_ROOT = stableSdkRoot;

    JAVA_HOME = "${jdk}";

    # Stable NDK path via overlay symlink
    ANDROID_NDK_HOME = "${overlayRoot}/ndk/current";
    ANDROID_NDK_ROOT = "${overlayRoot}/ndk/current";
    NDK_HOME         = "${overlayRoot}/ndk/current";
  };

  home.sessionPath = [
    "${stableSdkRoot}/platform-tools"
    "${stableSdkRoot}/emulator"
    "${stableSdkRoot}/cmdline-tools/latest/bin"
  ];

  # Create overlay dir + ndk/current symlink WITHOUT writing into the SDK tree
  home.activation.androidOverlay = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
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

    # Fallback: legacy ndk-bundle
    if [ -d "$sdk/ndk-bundle" ]; then
      ln -sfn "$sdk/ndk-bundle" "$overlay/ndk/current"
      exit 0
    fi

    echo "Warning: No NDK found under $sdk/ndk or $sdk/ndk-bundle"
  '';
}
