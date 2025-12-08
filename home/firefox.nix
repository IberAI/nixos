{ config, pkgs, ... }:

{
  programs.librewolf = {
    enable  = true;
    package = pkgs.librewolf;

    nativeMessagingHosts = [ pkgs.keepassxc ];

    settings = {
      "browser.contentblocking.category"      = "strict";
      "network.cookie.cookieBehavior"         = 5;
      "network.cookie.lifetimePolicy"         = 0;
      "privacy.clearOnShutdown.history"       = false;
      "privacy.clearOnShutdown.cookies"       = false;
      "privacy.clearOnShutdown.downloads"     = false;
      "privacy.sanitize.sanitizeOnShutdown"   = false;
      "webgl.disabled"                        = false;
    };

    profiles.default = {

      # Per-profile Firefox prefs
      settings = {
        "browser.startup.homepage" = "https://duckduckgo.com";
        "browser.shell.checkDefaultBrowser" = false;

        "datareporting.healthreport.uploadEnabled" = false;
        "datareporting.policy.dataSubmissionEnabled" = false;

        "browser.newtabpage.activity-stream.feeds.topsites" = false;
        "browser.newtabpage.activity-stream.showSponsored" = false;

        "ui.systemUsesDarkTheme" = 1;

        "privacy.resistFingerprinting" = true;
        "privacy.trackingprotection.fingerprinting.enabled" = true;
        "privacy.trackingprotection.cryptomining.enabled"   = true;
        "privacy.trackingprotection.enabled"                 = true;

        "privacy.firstparty.isolate" = false;
        "media.peerconnection.enabled" = true;
        "geo.enabled" = false;
      };

      # Extensions for this profile
      extensions = with pkgs.nur.repos.rycee.firefox-addons; [
        ublock-origin
        keepassxc-browser
        decentraleyes
        canvasblocker
      ];
    };

    policies = {
      Cookies = {
        Allow = [
          "https://discord.com"
          "https://www.youtube.com"
          "https://mail.google.com"
          "https://accounts.google.com"
          "https://play.google.com"
          "https://console.cloud.google.com"
          "https://chat.openai.com"
          "https://developer.apple.com"
          "https://account.apple.com"
        ];
      };

      Bookmarks = [
        {
          Title = "ChatGPT";
          URL = "https://chat.openai.com";
          Placement = "toolbar";
        }
        {
          Title = "Gmail";
          URL = "https://mail.google.com";
          Placement = "toolbar";
        }
        {
          Title = "YouTube";
          URL = "https://www.youtube.com";
          Placement = "toolbar";
        }
        {
          Title = "Discord";
          URL = "https://discord.com/app";
          Placement = "toolbar";
        }
      ];

      DisableTelemetry = true;
      DisableFirefoxStudies = true;
    };
  };
}

