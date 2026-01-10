{ config, pkgs, lib, ... }:

let
  stableSdkRoot = "${config.home.homeDirectory}/.local/share/android-sdk";
  overlayRoot   = "${config.home.homeDirectory}/.local/share/android-sdk-overlay";

  # Expo SDK 54 / RN 0.81 is requesting this in your logs
  requiredNdk = "27.1.12297006";

  androidComposition = pkgs.androidenv.composeAndroidPackages {
    cmdLineToolsVersion = "latest";

    # Ensure common components exist (latest from your pinned nixpkgs snapshot)
    platformToolsVersion = "latest";
    platformVersions     = [ "latest" ];
    buildToolsVersions   = [ "latest" ];

    includeNDK  = true;

    # Put required first so androidenv’s legacy ndk-bundle points to it
    ndkVersions = [ requiredNdk "latest" ];

    includeCmake  = true;
    cmakeVersions = [ "latest" ];

    includeEmulator     = true;
    includeSystemImages = true;
    systemImageTypes    = [ "google_apis" ];
    abiVersions         = [ "x86_64" ];

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
    JAVA_HOME        = "${jdk}";

    # Stable NDK path via overlay symlink (writable location)
    ANDROID_NDK_HOME = "${overlayRoot}/ndk/current";
    ANDROID_NDK_ROOT = "${overlayRoot}/ndk/current";
    NDK_HOME         = "${overlayRoot}/ndk/current";

    # 🔥 The critical “no project edits” fix:
    # This is equivalent to putting android.builder.sdkDownload=false in gradle.properties,
    # but applied globally via environment.
    ORG_GRADLE_PROJECT_android_builder_sdkDownload = "false";
  };

  # (Optional but helpful) ensure GUI-launched processes also inherit vars
  systemd.user.sessionVariables = {
    ANDROID_HOME     = stableSdkRoot;
    ANDROID_SDK_ROOT = stableSdkRoot;
    ANDROID_NDK_HOME = "${overlayRoot}/ndk/current";
    ANDROID_NDK_ROOT = "${overlayRoot}/ndk/current";
    NDK_HOME         = "${overlayRoot}/ndk/current";
    ORG_GRADLE_PROJECT_android_builder_sdkDownload = "false";
  };

  home.sessionPath = [
    "${stableSdkRoot}/platform-tools"
    "${stableSdkRoot}/emulator"
    "${stableSdkRoot}/cmdline-tools/latest/bin"
  ];

  # Create overlay dir + ndk/current symlink WITHOUT writing into the SDK tree
  # Deterministic: always prefer the REQUIRED NDK if present.
  home.activation.androidOverlay = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    set -euo pipefail
    sdk="${stableSdkRoot}"
    overlay="${overlayRoot}"
    required="${requiredNdk}"

    mkdir -p "$overlay/ndk"

    if [ -d "$sdk/ndk/$required" ]; then
      ln -sfn "$sdk/ndk/$required" "$overlay/ndk/current"
      exit 0
    fi

    # fallback: highest side-by-side ndk
    if [ -d "$sdk/ndk" ]; then
      ver="$(ls -1 "$sdk/ndk" 2>/dev/null | grep -E '^[0-9]+' | sort -V | tail -n 1 || true)"
      if [ -n "$ver" ] && [ -d "$sdk/ndk/$ver" ]; then
        ln -sfn "$sdk/ndk/$ver" "$overlay/ndk/current"
        exit 0
      fi
    fi

    # fallback: legacy ndk-bundle
    if [ -d "$sdk/ndk-bundle" ]; then
      ln -sfn "$sdk/ndk-bundle" "$overlay/ndk/current"
      exit 0
    fi

    echo "Warning: No NDK found under $sdk/ndk or $sdk/ndk-bundle"
  '';
}
