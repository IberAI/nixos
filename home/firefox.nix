{ config, pkgs, ... }:

{
  programs.librewolf = {
    enable = true;
    package = pkgs.librewolf;

    # KeePassXC native messaging for keepassxc-browser
    nativeMessagingHosts = [ pkgs.keepassxc ];

    ########################################
    # Enterprise-style policies (cookies, permissions)
    ########################################
    # These become policies.json under the hood.
    policies = {
      # Login cookies & tracking behavior
      Cookies = {
        # Keep strict anti-tracking while allowing your login sites.
        Behavior = "reject-tracker-and-partition-foreign";
        BehaviorPrivateBrowsing = "reject-tracker-and-partition-foreign";

        # Sites that are always allowed to set cookies
        # (so logins "stick" instead of constantly logging you out).
        Allow = [
          "https://accounts.google.com"
          "https://mail.google.com"
          "https://www.google.com"
          "https://www.youtube.com"
          "https://chat.openai.com"
          "https://discord.com"
        ];
      };

      # Discord voice + screen share
      Permissions = {
        Microphone = {
          Allow = [ "https://discord.com" ];
        };
        Camera = {
          Allow = [ "https://discord.com" ];
        };
        ScreenShare = {
          Allow = [ "https://discord.com" ];
        };
      };
    };

    ########################################
    # Profile
    ########################################
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

          # Disable telemetry / sponsored content
          "datareporting.healthreport.uploadEnabled" = false;
          "datareporting.policy.dataSubmissionEnabled" = false;
          "browser.newtabpage.activity-stream.feeds.topsites" = false;
          "browser.newtabpage.activity-stream.showSponsored" = false;

          # Dark theme preference
          "ui.systemUsesDarkTheme" = 1;

          # Anti-fingerprinting
          "privacy.resistFingerprinting" = true;
          "privacy.firstparty.isolate" = true;
          "privacy.trackingprotection.fingerprinting.enabled" = true;

          # WebRTC for Discord voice/screen share
          "media.peerconnection.enabled" = true;
          "webgl.disabled" = false;

          # Disable geolocation
          "geo.enabled" = false;

          ############################################
          # Cookie persistence for logins you care about
          ############################################
          # 0 = keep cookies until they expire (needed for staying logged in).
          "network.cookie.lifetimePolicy" = 0;

          # Do NOT wipe cookies on shutdown (otherwise logins die).
          "privacy.sanitize.sanitizeOnShutdown" = false;
          "privacy.clearOnShutdown.cookies" = false;
        };

        #####################
        # Search engines
        #####################
        search = {
          force = true;

          default = "ddg";
          order = [ "ddg" "google" ];

          engines = {
            ddg = {
              urls = [{
                template = "https://duckduckgo.com/";
                params = [
                  { name = "q"; value = "{searchTerms}"; }
                  { name = "t"; value = "h_"; }
                ];
              }];
              icon = "https://duckduckgo.com/favicon.ico";
              definedAliases = [ "@ddg" ];
            };

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
        # Bookmarks (with folders)
        #####################
        bookmarks = {
          force = true;
          settings = [
            # Toolbar folder: everyday stuff
            {
              name = "Start";
              toolbar = true;
              bookmarks = [
                {
                  name = "ChatGPT";
                  url = "https://chat.openai.com/";
                  keyword = "cgpt";
                  tags = [ "ai" ];
                }
                {
                  name = "Gmail";
                  url = "https://mail.google.com/";
                  keyword = "gmail";
                  tags = [ "mail" ];
                }
                {
                  name = "YouTube";
                  url = "https://www.youtube.com/";
                  keyword = "yt";
                  tags = [ "video" ];
                }
                {
                  name = "Discord";
                  url = "https://discord.com/app";
                  keyword = "disc";
                  tags = [ "chat" "voice" ];
                }
              ];
            }

            # Nix/NixOS folder
            {
              name = "Nix";
              toolbar = true;
              bookmarks = [
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
              ];
            }

            # Docs folder
            {
              name = "Docs";
              toolbar = false;
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
          # NUR must be enabled in your flake / Nixpkgs for this to work:
          #   pkgs.nur.repos.rycee.firefox-addons
          packages = with pkgs.nur.repos.rycee.firefox-addons; [
            ublock-origin
            keepassxc-browser
            decentraleyes
            canvasblocker
          ];
        };
      };
    };
  };
}

