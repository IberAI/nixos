{ config, pkgs, ... }:

{
  programs.librewolf.profiles.default = {
    id        = 0;
    isDefault = true;
    name      = "Default";

    settings = {
      "browser.startup.homepage"          = "https://github.com";
      "browser.shell.checkDefaultBrowser" = false;

      # No ads / sponsored junk on new tab.
      "browser.newtabpage.activity-stream.feeds.topsites"        = false;
      "browser.newtabpage.activity-stream.showSponsored"         = false;
      "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;

      # Telemetry off.
      "datareporting.healthreport.uploadEnabled"   = false;
      "datareporting.policy.dataSubmissionEnabled" = false;
    };

    ##################################################################
    # Bookmarks – structured toolbar
    ##################################################################
    bookmarks = {
      force = true;

      settings = [
        {
          name    = "Toolbar";
          toolbar = true;
          bookmarks = [
            { name = "Discord"; url = "https://discord.com/channels/@me"; }
            { name = "YouTube"; url = "https://youtube.com/"; }
            { name = "GitHub";  url = "https://github.com/"; }
            { name = "ChatGPT"; url = "https://chatgpt.com/"; }

            {
              name = "School";
              bookmarks = [
                {
                  name = "UCF Dashboard";
                  url  = "https://my.ucf.edu/dashboard";
                }
              ];
            }

            {
              name = "Work";
              bookmarks = [
                {
                  name = "Supabase";
                  url  = "https://supabase.com/dashboard";
                }
                {
                  name = "Expo";
                  url  = "https://expo.dev/";
                }
                {
                  name = "Vercel";
                  url  = "https://vercel.com/";
                }
                {
                  name = "Play Console";
                  url  = "https://play.google.com/console";
                }
                {
                  name = "RevenueCat";
                  url  = "https://app.revenuecat.com/overview";
                }
                {
                  name = "Slack";
                  url  = "https://app.slack.com/client";
                }
              ];
            }

            { name = "ComputeSDK"; bookmarks = [ ]; }
            { name = "Docs";       bookmarks = [ ]; }
            { name = "Reads";      bookmarks = [ ]; }
          ];
        }
      ];
    };

    ##################################################################
    # Extensions: uBlock Origin, CanvasBlocker, Decentraleyes
    ##################################################################
    extensions = {
      force = true;

      packages = with pkgs.nur.repos.rycee.firefox-addons; [
        ublock-origin
        canvasblocker
        decentraleyes
      ];

      settings = {
        ##############################################################
        # uBlock Origin – privacy-heavy but not insane
        ##############################################################
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

          privacy = {
            disableRemoteFonts = false;
          };
        };

      };
    };
  };
}
