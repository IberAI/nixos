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
    NoDefaultBookmarks     = false;
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
