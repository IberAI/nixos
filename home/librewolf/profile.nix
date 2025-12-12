{ config, pkgs, ... }:

{
  programs.librewolf.profiles.default = {
    id        = 0;
    isDefault = true;
    name      = "Default";

    settings = {
      "browser.startup.homepage"          = "about:home";
      "browser.shell.checkDefaultBrowser" = false;

      # No ads / sponsored junk on new tab.
      "browser.newtabpage.activity-stream.feeds.topsites"        = false;
      "browser.newtabpage.activity-stream.showSponsored"         = false;
      "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;

      # Telemetry off.
      "datareporting.healthreport.uploadEnabled"   = false;
      "datareporting.policy.dataSubmissionEnabled" = false;
    };

    Bookmarks = [
      {
        Title = "Discord";
        URL = "https://discord.com/channels/@me";
        Placement = "toolbar";
      }
      {
        Title = "YouTube";
        URL = "https://youtube.com/";
        Placement = "toolbar";
      }
      {
        Title = "GitHub";
        URL = "https://github.com/";
        Placement = "toolbar";
      }
      {
        Title = "ChatGPT";
        URL = "https://chatgpt.com/";
        Placement = "toolbar";
      }
      {
        Folder = "School";
        Placement = "toolbar";
        Children = [
          {
            Title = "UCF Dashboard";
            URL = "https://my.ucf.edu/dashboard";
          }
        ];
      }
      {
        Folder = "Work";
        Placement = "toolbar";
        Children = [
          { Title = "Supabase"; URL = "https://supabase.com/dashboard"; }
          { Title = "Expo";     URL = "https://expo.dev/"; }
          { Title = "Vercel";   URL = "https://vercel.com/"; }
          { Title = "Play Console"; URL = "https://play.google.com/console"; }
          { Title = "RevenueCat"; URL = "https://app.revenuecat.com/overview"; }
          { Title = "Slack"; URL = "https://app.slack.com/client"; }
        ];
      }
      {
        Folder = "ComputeSDK";
        Placement = "toolbar";
        Children = [];
      }
      {
        Folder = "Docs";
        Placement = "toolbar";
        Children = [];
      }
      {
        Folder = "Reads";
        Placement = "toolbar";
        Children = [];
      }
    ];


    ##################################################################
    # Extensions: uBlock Origin, CanvasBlocker, Decentraleyes
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

          privacy = {
            disableRemoteFonts = false;
          };
        };

      };
    };
  };
}
