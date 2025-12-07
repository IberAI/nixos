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

        settings = {
          # Homepage -> DuckDuckGo instead of Searx
          "browser.startup.homepage" = "https://duckduckgo.com/";

          # Use KeePassXC, not built-in password manager
          "signon.rememberSignons" = false;

          # Optional: fewer search suggestions in the URL bar
          "browser.urlbar.suggest.searches" = false;
        };

        # Custom search engines
        search = {
          force = true;

          # Default -> DuckDuckGo
          default = "DuckDuckGo";

          # Remove Searx from order
          order = [ "DuckDuckGo" "Google" ];

          engines = {
            "Nix Packages" = {
              urls = [{
                template = "https://search.nixos.org/packages";
                params = [
                  { name = "type"; value = "packages"; }
                  { name = "query"; value = "{searchTerms}"; }
                ];
              }];
              icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
              definedAliases = [ "@np" ];
            };

            "NixOS Wiki" = {
              urls = [{
                template = "https://nixos.wiki/index.php?search={searchTerms}";
              }];
              iconUpdateURL = "https://nixos.wiki/favicon.png";
              updateInterval = 24 * 60 * 60 * 1000; # every day
              definedAliases = [ "@nw" ];
            };

            "DuckDuckGo" = {
              urls = [{
                template = "https://duckduckgo.com/?q={searchTerms}&t=h_";
              }];
              iconUpdateURL = "https://duckduckgo.com/favicon.ico";
              updateInterval = 24 * 60 * 60 * 1000; # every day
              definedAliases = [ "@ddg" ];
            };
          };
        };

        # Bookmarks: shortcuts + Docs folder with School subfolder
        bookmarks = [
          # Links
          {
            name = "ChatGPT";
            url = "https://chatgpt.com/";
            keyword = "cgpt";
            tags = [ "ai" ];
          }
          {
            name = "Discord";
            url = "https://discord.com/app";
            keyword = "dc";
            tags = [ "chat" "social" ];
          }
          {
            name = "YouTube";
            url = "https://www.youtube.com/";
            keyword = "yt";
            tags = [ "video" ];
          }

          # Docs folder
          {
            name = "Docs";

            # Subfolders inside Docs
            bookmarks = [
              {
                name = "School";
                bookmarks = [ ];
              }
              {
                name = "Personal";
                bookmarks = [ ];
              }
            ];
          }
        ];

        # Extensions: uBlock Origin + KeePassXC browser + Decentraleyes
        # (assumes pkgs.nur.repos.rycee.firefox-addons is available)
        extensions = with pkgs.nur.repos.rycee.firefox-addons; [
          ublock-origin
          keepassxc-browser
          decentraleyes
        ];
      };
    };
  };
}

