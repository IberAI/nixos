{ config, pkgs, lib, ... }:

let
  stableSdkRoot = "${config.home.homeDirectory}/.local/share/android-sdk";
  overlayRoot   = "${config.home.homeDirectory}/.local/share/android-sdk-overlay";

  # Expo SDK 54 / RN 0.81 requested this in your logs
  requiredNdk = "27.1.12297006";

  androidComposition = pkgs.androidenv.composeAndroidPackages {
    cmdLineToolsVersion = "latest";

    platformToolsVersion = "latest";
    platformVersions     = [ "latest" ];
    buildToolsVersions   = [ "latest" ];

    includeNDK   = true;
    # Put required first so androidenv is likely to include it
    ndkVersions  = [ requiredNdk "latest" ];

    includeCmake  = true;
    cmakeVersions = [ "latest" ];

    includeEmulator     = true;
    includeSystemImages = true;
    systemImageTypes    = [ "google_apis" ];
    abiVersions         = [ "x86_64" ];

    toolsVersion = null;
  };

  androidSdkStoreRoot = "${androidComposition.androidsdk}/libexec/android-sdk";
  jdk = pkgs.jdk17;
in
{
  home.packages = with pkgs; [
    androidComposition.androidsdk
    jdk
    watchman
    pkg-config
    gnumake
    ninja
    cmake
    python3
  ];

  # IMPORTANT:
  # Do NOT symlink the whole SDK root into the Nix store.
  # That makes it unwritable and Gradle fails when it tries to install NDK/components.
  #
  # REMOVE/DO NOT USE:
  # home.file.".local/share/android-sdk".source = "${androidSdk}/libexec/android-sdk";

  home.sessionVariables = {
    ANDROID_HOME     = stableSdkRoot;
    ANDROID_SDK_ROOT = stableSdkRoot;
    JAVA_HOME        = "${jdk}";

    # Stable NDK path for tooling that expects ANDROID_NDK_HOME
    ANDROID_NDK_HOME = "${overlayRoot}/ndk/current";
    ANDROID_NDK_ROOT = "${overlayRoot}/ndk/current";
    NDK_HOME         = "${overlayRoot}/ndk/current";

    # Global “don’t download SDK components” without editing project gradle.properties
    ORG_GRADLE_PROJECT_android_builder_sdkDownload = "false";
  };

  # Optional but useful so GUI-launched apps inherit vars too
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

  # Build a writable SDK root that *links* store components but keeps writeable dirs local.
  home.activation.androidSdkWritable = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    set -euo pipefail

    sdk="${stableSdkRoot}"
    store="${androidSdkStoreRoot}"

    mkdir -p "$sdk"

    # Symlink read-only components from the Nix store into the writable root
    link_dir () {
      local name="$1"
      if [ -e "$store/$name" ] && [ ! -e "$sdk/$name" ]; then
        ln -s "$store/$name" "$sdk/$name"
      fi
    }

    link_dir "platform-tools"
    link_dir "cmdline-tools"
    link_dir "emulator"
    link_dir "tools"

    # Create writable directories Android tooling may want to write into
    mkdir -p "$sdk/licenses" "$sdk/ndk" "$sdk/build-tools" "$sdk/platforms"

    # Copy licenses if present (small files; avoids license/props write failures)
    if [ -d "$store/licenses" ]; then
      cp -n "$store/licenses/"* "$sdk/licenses/" 2>/dev/null || true
    fi

    # Expose NDKs from the store SDK if present
    if [ -d "$store/ndk" ]; then
      # Link each available side-by-side NDK version into the writable root if missing
      for d in "$store/ndk/"*; do
        ver="$(basename "$d")"
        if [ -d "$d" ] && [ ! -e "$sdk/ndk/$ver" ]; then
          ln -s "$d" "$sdk/ndk/$ver"
        fi
      done
    fi

    # Also support legacy layout in case androidenv produced ndk-bundle
    if [ -d "$store/ndk-bundle" ] && [ ! -e "$sdk/ndk-bundle" ]; then
      ln -s "$store/ndk-bundle" "$sdk/ndk-bundle"
    fi
  '';

  # Create overlay dir + ndk/current symlink WITHOUT writing into the SDK tree
  # Deterministic: always prefer REQUIRED NDK if present.
  home.activation.androidOverlay = lib.hm.dag.entryAfter [ "androidSdkWritable" ] ''
    set -euo pipefail

    sdk="${stableSdkRoot}"
    overlay="${overlayRoot}"
    required="${requiredNdk}"

    mkdir -p "$overlay/ndk"

    # Prefer required side-by-side NDK if present
    if [ -d "$sdk/ndk/$required" ]; then
      ln -sfn "$sdk/ndk/$required" "$overlay/ndk/current"
      exit 0
    fi

    # Otherwise pick highest available side-by-side NDK
    if [ -d "$sdk/ndk" ]; then
      ver="$(ls -1 "$sdk/ndk" 2>/dev/null | grep -E '^[0-9]+' | sort -V | tail -n 1 || true)"
      if [ -n "$ver" ] && [ -d "$sdk/ndk/$ver" ]; then
        ln -sfn "$sdk/ndk/$ver" "$overlay/ndk/current"
        exit 0
      fi
    fi

    # Fallback to legacy ndk-bundle
    if [ -d "$sdk/ndk-bundle" ]; then
      ln -sfn "$sdk/ndk-bundle" "$overlay/ndk/current"
      exit 0
    fi

    echo "Warning: No NDK found under $sdk/ndk or $sdk/ndk-bundle"
  '';
}
