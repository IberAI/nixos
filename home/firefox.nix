{ config, pkgs, ... }:

{
  programs.librewolf = {
    enable  = true;
    package = pkgs.librewolf;

    # KeePassXC native messaging
    nativeMessagingHosts = [ pkgs.keepassxc ];

    ################################################
    # Global LibreWolf prefs (strict but usable)
    ################################################
    settings = {
      # Use strict content blocking / Total Cookie Protection
      "browser.contentblocking.category" = "strict";
      # 5 => cross-site tracking cookies + isolate other cross-site cookies (TCP)
      "network.cookie.cookieBehavior" = 5;

      # Keep cookies until they expire (needed for logins)
      "network.cookie.lifetimePolicy" = 0;

      # Do NOT auto-wipe cookies/history on shutdown
      "privacy.clearOnShutdown.history"   = false;
      "privacy.clearOnShutdown.cookies"   = false;
      "privacy.clearOnShutdown.downloads" = false;
      "privacy.sanitize.sanitizeOnShutdown" = false;

      # Let Discord / video calls work
      "webgl.disabled" = false;
    };

    profiles.default = {
      id        = 0;
      name      = "default";
      isDefault = true;

      ##################################
      # Per-profile preferences
      ##################################
      settings = {
        "browser.startup.homepage"          = "https://duckduckgo.com";
        "browser.shell.checkDefaultBrowser" = false;

        # Turn off telemetry / sponsored cruft
        "datareporting.healthreport.uploadEnabled"   = false;
        "datareporting.policy.dataSubmissionEnabled" = false;
        "browser.newtabpage.activity-stream.feeds.topsites" = false;
        "browser.newtabpage.activity-stream.showSponsored"  = false;

        # Dark theme
        "ui.systemUsesDarkTheme" = 1;

        # Fingerprinting protection – as strong as possible without killing Discord
        "privacy.resistFingerprinting"                      = true;
        "privacy.trackingprotection.fingerprinting.enabled" = true;
        "privacy.trackingprotection.cryptomining.enabled"   = true;
        "privacy.trackingprotection.enabled"                = true;

        # Use TCP (cookieBehavior=5) instead of explicit FPI
        "privacy.firstparty.isolate" = false;

        # Discord/WebRTC
        "media.peerconnection.enabled" = true;
        "geo.enabled"                  = false;
      };

      #####################
      # Search engines
      #####################
      search = {
        force = true;

        default = "ddg";
        order   = [ "ddg" "google" ];

        engines = {
          ddg = {
            urls = [{
              template = "https://duckduckgo.com/";
              params = [
                { name = "q"; value = "{searchTerms}"; }
                { name = "t"; value = "h_"; }
              ];
            }];
            icon           = "https://duckduckgo.com/favicon.ico";
            definedAliases = [ "@ddg" ];
          };

          google = {
            urls = [{
              template = "https://www.google.com/search";
              params = [
                { name = "q"; value = "{searchTerms}"; }
              ];
            }];
            icon           = "https://www.google.com/favicon.ico";
            definedAliases = [ "@google" ];
          };
        };
      };

      #####################
      # Bookmarks
      #####################
      bookmarks = {
        force = true;
        settings = [
          {
            name    = "Start";
            toolbar = true;
            bookmarks = [
              {
                name    = "ChatGPT";
                url     = "https://chat.openai.com/";
                keyword = "cgpt";
                tags    = [ "ai" ];
              }
              {
                name    = "Gmail";
                url     = "https://mail.google.com/";
                keyword = "gmail";
                tags    = [ "mail" ];
              }
              {
                name    = "YouTube";
                url     = "https://www.youtube.com/";
                keyword = "yt";
                tags    = [ "video" ];
              }
              {
                name    = "Discord";
                url     = "https://discord.com/app";
                keyword = "disc";
                tags    = [ "chat" "voice" ];
              }
            ];
          }

          {
            name    = "Nix";
            toolbar = true;
            bookmarks = [
              {
                name    = "NixOS Search";
                url     = "https://search.nixos.org/";
                keyword = "nix";
                tags    = [ "nix" "nixos" ];
              }
              {
                name    = "NixOS Wiki";
                url     = "https://nixos.wiki/";
                keyword = "nixw";
                tags    = [ "nix" "docs" ];
              }
            ];
          }

          {
            name    = "Docs";
            toolbar = false;
            bookmarks = [
              {
                name = "LibreWolf Docs";
                url  = "https://librewolf.net/docs/";
              }
              {
                name = "KeePassXC Docs";
                url  = "https://keepassxc.org/docs/";
              }
            ];
          }
        ];
      };

      #####################
      # Extensions
      #####################
      extensions = {
        packages = with pkgs.nur.repos.rycee.firefox-addons; [
          ublock-origin
          keepassxc-browser
          decentraleyes
          canvasblocker
        ];
      };
    };

    # Policies to allow specific cookies for login purposes
    extraPolicies = {
      Bookmarks = bookmarks;
      ExtensionSettings = extensions;

      Cookies = {
        Allow = [
          "https://discord.com"
          "https://www.youtube.com"
          "https://mail.google.com"
          "https://chat.openai.com"
          "https://play.google.com"
          "https://console.cloud.google.com"
          "https://accounts.google.com"
          "https://developer.apple.com"
          "https://account.apple.com"
        ];
      };

      EnableTrackingProtection = {
        Exceptions = [
          # Add any domains here that need exceptions for tracking protection
        ];
      };
    };
  };
}

