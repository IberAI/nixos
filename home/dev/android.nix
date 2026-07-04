# home/dev/android.nix
{
  pkgs,
  config,
  lib,
  ...
}:
let
  androidPkgs = pkgs.androidenv.composeAndroidPackages {
    toolsVersion = "26.1.1";
    platformVersions = [
      "35"
      "34"
    ];
    buildToolsVersions = [
      "35.0.0"
      "34.0.0"
    ];
    includeEmulator = true;

    # Let Gradle download NDK/SDK stuff into ~/Android/Sdk (writable)
    includeNDK = false;
  };

  nixAndroidSdk = androidPkgs.androidsdk;
  nixSdkRoot = "${nixAndroidSdk}/libexec/android-sdk";

  # Writable SDK used by ALL projects
  userSdkRoot = "${config.home.homeDirectory}/Android/Sdk";
in
{
  home = {
    packages = with pkgs; [
      nixAndroidSdk
      jdk17
      watchman
      gradle
      unzip
      zip
      which
      file
    ];

    sessionVariables = {
      ANDROID_HOME = userSdkRoot;
      ANDROID_SDK_ROOT = userSdkRoot;

      JAVA_HOME = pkgs.jdk17.home;
      LANG = "en_US.UTF-8";
    };

    # Put writable SDK paths first; keep Nix SDK tools as a fallback
    sessionPath = [
      "${userSdkRoot}/platform-tools"
      "${userSdkRoot}/emulator"
      "${userSdkRoot}/cmdline-tools/latest/bin"

      "${nixSdkRoot}/cmdline-tools/latest/bin"
      "${nixSdkRoot}/platform-tools"
      "${nixSdkRoot}/emulator"
    ];

    # Ensure folders exist + provide adb at the path Expo expects
    activation.androidSdkDirs = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      mkdir -p "${userSdkRoot}"
      mkdir -p "${userSdkRoot}/cmdline-tools"
      mkdir -p "${userSdkRoot}/platform-tools"

      # Convenience symlink: expose cmdline-tools under ~/Android/Sdk without copying
      if [ ! -e "${userSdkRoot}/cmdline-tools/latest" ]; then
        ln -sfn "${nixSdkRoot}/cmdline-tools/latest" "${userSdkRoot}/cmdline-tools/latest"
      fi

      # Expo expects adb at: $ANDROID_SDK_ROOT/platform-tools/adb
      if [ ! -e "${userSdkRoot}/platform-tools/adb" ]; then
        ln -sfn "${nixSdkRoot}/platform-tools/adb" "${userSdkRoot}/platform-tools/adb"
      fi

      # Optional: fastboot (sometimes handy)
      if [ -e "${nixSdkRoot}/platform-tools/fastboot" ] && [ ! -e "${userSdkRoot}/platform-tools/fastboot" ]; then
        ln -sfn "${nixSdkRoot}/platform-tools/fastboot" "${userSdkRoot}/platform-tools/fastboot"
      fi
    '';

    # Help Gradle locate the SDK globally (avoids per-project local.properties)
    file.".gradle/gradle.properties".text = ''
      android.sdk.path=${userSdkRoot}
    '';
  };
}
