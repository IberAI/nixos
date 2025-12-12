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

    ##################################################################
    # Extensions: uBlock Origin, CanvasBlocker, Decentraleyes
    ##################################################################
    extensions = {
      force = true;

      packages = with pkgs.nur.repos.rycee.firefox-addons; [
        ublock-origin
        canvasblocker
        decentraleyes
        keepassxc
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
