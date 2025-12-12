{ config, pkgs, ... }:

{
  programs.librewolf.profiles.default = {
    id        = 0;
    isDefault = true;
    name      = "Default";

    ##################################################################
    # Settings
    ##################################################################
    settings = {
      "browser.startup.homepage"          = "about:home";
      "browser.shell.checkDefaultBrowser" = false;

      # No ads / sponsored junk on new tab.
      "browser.newtabpage.activity-stream.feeds.topsites"        = false;
      "browser.newtabpage.activity-stream.showSponsored"         = false;
      "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
      "extensions.activeThemeID" = "firefox-compact-dark@mozilla.org";

      # Telemetry off.
      "datareporting.healthreport.uploadEnabled"   = false;
      "datareporting.policy.dataSubmissionEnabled" = false;
    };

    ##################################################################
    # Bookmarks 
    ##################################################################
    bookmarks = {
      force = true;

      settings = [
        {
          name    = "Toolbar";
          toolbar = true;

          bookmarks =
            let
              entry = name: url: { inherit name url; };
              folder = name: bookmarks: { inherit name bookmarks; };
            in
            [
              (entry "Discord" "https://discord.com/channels/@me")
              (entry "YouTube" "https://youtube.com/")
              (entry "GitHub" "https://github.com/")
              (entry "ChatGPT" "https://chatgpt.com/")
              "separator"

              (folder "School" [
                (entry "UCF Dashboard" "https://my.ucf.edu/dashboard")
              ])

              (folder "Work" [
                (entry "Supabase" "https://supabase.com/dashboard")
                (entry "Expo"     "https://expo.dev/")
                (entry "Vercel"   "https://vercel.com/")
                (entry "Play Console" "https://play.google.com/console")
                (entry "RevenueCat"   "https://app.revenuecat.com/overview")
                (entry "Slack"        "https://app.slack.com/client")
              ])

              (folder "ComputeSDK" [])

              (folder "Docs" [])

              (folder "Reads" [])
            ];
        }
      ];
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

          privacy.disableRemoteFonts = false;
        };
      };
    };
  };
}
