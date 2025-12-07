{ config, pkgs, ... }:

{
  programs.librewolf = {
    enable = true;
    package = pkgs.librewolf;  # run LibreWolf, configured via this module

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
        };

        #####################
        # Search engines
        #####################
        search = {
          force = true;

          # Use engine IDs, not names
          default = "ddg";
          order   = [ "ddg" "google" ];

          engines = {
            # Custom: Nix Packages search
            "Nix Packages" = {
              urls = [{
                template = "https://search.nixos.org/packages";
                params = [
                  { name = "type";  value = "packages"; }
                  { name = "query"; value = "{searchTerms}"; }
                ];
              }];
              definedAliases = [ "@np" ];
            };

            # Custom: NixOS Wiki search
            "NixOS Wiki" = {
              urls = [{
                template = "https://nixos.wiki/index.php";
                params = [
                  { name = "search"; value = "{searchTerms}"; }
                ];
              }];
              definedAliases = [ "@nw" ];
            };

            # DuckDuckGo, referenced by id "ddg"
            ddg = {
              urls = [{
                template = "https://duckduckgo.com/";
                params = [
                  { name = "q"; value = "{searchTerms}"; }
                  { name = "t"; value = "h_"; }
                ];
              }];
              iconUpdateURL  = "https://duckduckgo.com/favicon.ico";
              updateInterval = 24 * 60 * 60 * 1000; # every day
              definedAliases = [ "@ddg" ];
            };
          };
        };

        #####################
        # Bookmarks
        #####################
        # New submodule shape: { force = true; settings = [ ... ]; }
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
        # New shape: extensions = { packages = [ ... ]; }
        extensions = {
          packages = with pkgs.nur.repos.rycee.firefox-addons; [
            ublock-origin
            keepassxc-browser
            decentraleyes
          ];
        };
      };
    };
  };
}

