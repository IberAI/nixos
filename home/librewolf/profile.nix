{
  pkgs,
  ...
}:
{
  programs.firefox.profiles.default = {
    id = 0;
    isDefault = true;
    name = "Default";
    path = "default";

    ##################################################################
    # Settings
    ##################################################################
    settings = {
      "browser.startup.homepage" = "about:home";
      "browser.shell.checkDefaultBrowser" = false;

      "browser.contentblocking.category" = "strict";
      "network.cookie.lifetimePolicy" = 0;
      "privacy.sanitize.sanitizeOnShutdown" = false;
      "privacy.clearOnShutdown.history" = false;
      "privacy.clearOnShutdown.cookies" = false;
      "privacy.clearOnShutdown.downloads" = false;
      "privacy.clearOnShutdown.sessions" = false;
      "privacy.clearOnShutdown.offlineApps" = false;
      "dom.event.clipboardevents.enabled" = true;
      "privacy.userContext.enabled" = true;
      "webgl.disabled" = false;
      "media.peerconnection.enabled" = true;
      "media.navigator.enabled" = true;
      "dom.security.https_only_mode" = true;
      "dom.security.https_only_mode_pbm" = true;
      "privacy.resistFingerprinting" = false;
      "dom.battery.enabled" = false;
      "network.dns.disablePrefetch" = true;
      "network.prefetch-next" = false;
      "network.predictor.enabled" = false;
      "network.http.referer.XOriginPolicy" = 2;
      "browser.send_pings" = false;
      "device.sensors.enabled" = false;
      "dom.gamepad.enabled" = false;
      "dom.vibrator.enabled" = false;
      "gfx.font_rendering.opentype_svg.enabled" = false;
      "permissions.default.geo" = 2;
      "permissions.default.desktop-notification" = 2;
      "permissions.default.camera" = 0;
      "permissions.default.microphone" = 0;
      "dom.serviceWorkers.enabled" = false;
      "dom.push.enabled" = false;
      "dom.push.connection.enabled" = false;
      "dom.webnotifications.enabled" = false;
      "dom.webnotifications.serviceworker.enabled" = false;
      "extensions.htmlaboutaddons.recommendations.enabled" = false;
      "extensions.getAddons.showPane" = false;
      "app.normandy.enabled" = false;
      "app.normandy.api_url" = "";
      "app.shield.optoutstudies.enabled" = false;
      "extensions.systemAddon.update.enabled" = false;
      "extensions.systemAddon.update.url" = "";

      # No ads / sponsored junk on new tab.
      "browser.newtabpage.activity-stream.feeds.topsites" = false;
      "browser.newtabpage.activity-stream.showSponsored" = false;
      "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;

      "extensions.activeThemeID" = "firefox-compact-dark@mozilla.org";

      # Telemetry off.
      "datareporting.healthreport.uploadEnabled" = false;
      "datareporting.policy.dataSubmissionEnabled" = false;
    };

    ##################################################################
    # Containers
    ##################################################################
    containersForce = true;
    containers = {
      "default" = {
        id = 0;
        name = "Default (Fun)";
        color = "blue";
      };
      "work" = {
        id = 1;
        name = "Work";
        color = "green";
      };
      "school" = {
        id = 2;
        name = "School";
        color = "orange";
      };
    };

    ##################################################################
    # Extensions
    ##################################################################
    extensions = {
      force = true;

      packages = with pkgs.nur.repos.rycee.firefox-addons; [
        ublock-origin
        canvasblocker
        decentraleyes
        keepassxc-browser
      ];

      settings = {
        "uBlock0@raymondhill.net".settings = {
          selectedFilterLists = [
            "user-filters"
            "ublock-filters"
            "ublock-badware"
            "ublock-privacy"
            "ublock-unbreak"
            "ublock-quick-fixes"
            "easylist"
            "easyprivacy"
            "urlhaus-1"
            "adguard-url-tracking"
            "plowe-0"
          ];

          advancedUserEnabled = true;
          privacy.disableRemoteFonts = false;
        };
      };
    };
  };
}
