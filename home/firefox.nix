{ config, pkgs, ... }:

{
  programs.librewolf = {
    enable = true;
    package = pkgs.librewolf;

    # Make KeePassXC available as a native messaging host for LibreWolf
    nativeMessagingHosts = [ pkgs.keepassxc ];

    profiles = {
      default = {
        id = 0;
        name = "default";
        isDefault = true;

        #############################
        # General LibreWolf settings
        #############################
        settings = {
          "browser.startup.homepage" = "https://duckduckgo.com";
          "browser.shell.checkDefaultBrowser" = false;

          # Disable some telemetry / annoyances
          "datareporting.healthreport.uploadEnabled" = false;
          "datareporting.policy.dataSubmissionEnabled" = false;
          "browser.newtabpage.activity-stream.feeds.topsites" = false;
          "browser.newtabpage.activity-stream.showSponsored" = false;

          # Example: dark theme preference
          "ui.systemUsesDarkTheme" = 1;

          # Anti-fingerprinting settings
          "privacy.resistFingerprinting" = true;
          "privacy.firstparty.isolate" = true;
          "privacy.trackingprotection.fingerprinting.enabled" = true;

          # Disable WebRTC (for privacy, but we will enable for Discord below)
          "media.peerconnection.enabled" = false;  # Default is disabled for privacy

          # Prevent IP leakage (disable WebRTC globally)
          "media.peerconnection.enabled" = false;

          # Prevent browser's location sharing
          "geo.enabled" = false;
        };

        #####################
        # Search engines
        #####################
        search = {
          force = true;

          # Use engine IDs, not names
          default = "ddg";
          order = [ "ddg" "google" ];

          engines = {
            # DuckDuckGo, referenced by id "ddg"
            ddg = {
              urls = [{
                template = "https://duckduckgo.com/";
                params = [
                  { name = "q"; value = "{searchTerms}"; }
                  { name = "t"; value = "h_"; }
                ];
              }];
              icon = "https://duckduckgo.com/favicon.ico";
              updateInterval = 24 * 60 * 60 * 1000; # every day
              definedAliases = [ "@ddg" ];
            };

            # Google search engine, added as fallback
            google = {
              urls = [{
                template = "https://www.google.com/search";
                params = [
                  { name = "q"; value = "{searchTerms}"; }
                ];
              }];
              icon = "https://www.google.com/favicon.ico";
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
            # Simple top-level bookmarks
            {
              name = "ChatGPT";
              url = "https://chat.openai.com/";
              keyword = "cgpt";
              tags = [ "ai" ];
            }
            {
              name = "NixOS Search";
              url = "https://search.nixos.org/";
              keyword = "nix";
              tags = [ "nix" "nixos" ];
            }
            {
              name = "NixOS Wiki";
              url = "https://nixos.wiki/";
              keyword = "nixw";
              tags = [ "nix" "docs" ];
            }

            # Example folder with sub-bookmarks
            {
              name = "Docs";
              toolbar = true;
              bookmarks = [
                {
                  name = "LibreWolf Docs";
                  url = "https://librewolf.net/docs/";
                }
                {
                  name = "KeePassXC Docs";
                  url = "https://keepassxc.org/docs/";
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
            canvasblocker        # Block canvas fingerprinting
          ];
        };

        #####################
        # Cookies settings for Google, YouTube, ChatGPT, Discord
        #####################
        settings = rec {
          # Allow cookies for Google, YouTube, ChatGPT, and Discord
          "network.cookie.cookieBehavior" = 0; # Accept all cookies by default
          "network.cookie.lifetimePolicy" = 2; # Accept cookies until the browser closes
          
          # Whitelist these domains to retain cookies:
          "network.cookie.acceptCookiePolicy" = 1;
          "network.cookie.allowGoogle" = true;
          "network.cookie.allowYoutube" = true;
          "network.cookie.allowChatGPT" = true;
          "network.cookie.allowDiscord" = true;

          # Prevent other cookies from staying
          "privacy.sanitize.sanitizeOnShutdown" = true;
          "privacy.clearOnShutdown.cookies" = true;
          "privacy.clearOnShutdown.cache" = true;
          "privacy.clearOnShutdown.sessions" = true;

          # Keep the cookies for specific sites
          "network.cookie.domain.include" = [
            "accounts.google.com"
            "google.com"
            "youtube.com"
            "youtube-nocookie.com"
            "chat.openai.com"
            "discord.com"
          ];
        };

        #####################
        # WebRTC for Discord
        #####################
        settings."media.peerconnection.enabled" = true;  # Enable WebRTC for Discord to function correctly (screen sharing)
      };
    };
  };
}

