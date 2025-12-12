{ config, pkgs, ... }:

{
  programs.librewolf.policies = {
    ##############################################################
    # De-bloat & privacy hardening
    ##############################################################
    CaptivePortal          = false;
    DisableFirefoxAccounts = true;
    DisableFirefoxStudies  = true;
    DisablePocket          = true;
    DisableTelemetry       = true;

    EnableTrackingProtection = {
      Value          = true;
      Cryptomining   = true;
      Fingerprinting = true;
    };

    PasswordManagerEnabled   = false;
    OfferToSaveLogins        = false;
    OfferToSaveLoginsDefault = false;

    ##############################################################
    # ALLOW-LIST ONLY COOKIE MODEL
    ##############################################################
    Cookies = {
      # EVERYTHING blocked unless allow-listed:
      Behavior                = "reject";
      BehaviorPrivateBrowsing = "reject";

      # Only these origins can set cookies and keep sessions:
      Allow = [
        # Core accounts / dev
        "https://github.com"

        # Discord (calls, screenshare)
        "https://discord.com"

        # Slack (work)
        "https://slack.com"
        "https://app.slack.com"

        # Supabase
        "https://supabase.com"

        # Dev tooling / hosting
        "https://expo.dev"
        "https://vercel.com"
        "https://app.revenuecat.com"

        # Google auth / mail / dev consoles
        "https://accounts.google.com"
        "https://mail.google.com"
        "https://play.google.com"
        "https://console.cloud.google.com"

        # Apple developer
        "https://developer.apple.com"

        # School
        "https://my.ucf.edu"

        # ChatGPT / OpenAI
        "https://chatgpt.com"
        "https://chat.openai.com"

        # Figma
        "https://www.figma.com"
      ];

      Locked = false;
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

    ##############################################################
    # WIPE EVERYTHING ON SHUTDOWN (except allow-list cookies)
    ##############################################################
    SanitizeOnShutdown = {
      Cache        = true;
      Downloads    = true;
      FormData     = true;
      History      = true;
      Sessions     = true;
      OfflineApps  = true;

      # Delete all permissions (mic/screen will re-ask).
      SiteSettings = true;

      # Keep cookies for allow-listed sites.
      Cookies = false;

      Locked = false;
    };

    ##############################################################
    # Remove Firefox/LibreWolf clutter
    ##############################################################
    FirefoxHome = {
      Search            = true;
      TopSites          = true;
      Highlights        = false;
      Pocket            = false;
      SponsoredPocket   = false;
      SponsoredTopSites = false;
      Snippets          = false;
    };

    FirefoxSuggest = {
      WebSuggestions       = false;
      SponsoredSuggestions = false;
      ImproveSuggest       = false;
    };

    UserMessaging = {
      ExtensionRecommendations = false;
      UrlbarInterventions      = false;
      SkipOnboarding           = true;
    };
  };
}
