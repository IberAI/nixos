{
  config,
  pkgs,
  ...
}: {
  programs.librewolf.profiles.default = {
    id = 0;
    isDefault = true;
    name = "Default";

    ##################################################################
    # Settings
    ##################################################################
    settings = {
      "browser.startup.homepage" = "about:home";
      "browser.shell.checkDefaultBrowser" = false;

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
