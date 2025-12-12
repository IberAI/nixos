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
        ##############################################################
        # GitHub (OAuth, login)
        ##############################################################
        "https://github.com"
        "https://api.github.com"

        ##############################################################
        # Discord (login, OAuth, SSO)
        ##############################################################
        "https://discord.com"
        "https://login.discord.com"

        # REQUIRED for Discord login
        "https://id.discord.com"

        ##############################################################
        # Slack (login + workspace session)
        ##############################################################
        "https://slack.com"
        "https://app.slack.com"

        ##############################################################
        # Supabase (auth only)
        ##############################################################
        "https://supabase.com"
        "https://auth.supabase.com"

        # Supabase OAuth redirector
        "https://oauth.supabase.com"

        ##############################################################
        # Expo (auth only)
        ##############################################################
        "https://expo.dev"
        "https://auth.expo.dev"

        ##############################################################
        # Vercel (OAuth login)
        ##############################################################
        "https://vercel.com"
        "https://api.vercel.com"

        # Vercel uses an auth callback host
        "https://auth.vercel.com"

        ##############################################################
        # RevenueCat (login only)
        ##############################################################
        "https://app.revenuecat.com"

        ##############################################################
        # Google authentication
        ##############################################################
        "https://accounts.google.com"
        "https://securetoken.googleapis.com"

        # Google OAuth helpers
        "https://oauth2.googleapis.com"
        "https://www.googleapis.com"

        # Only needed if you actually use these services:
        "https://mail.google.com"
        "https://play.google.com"
        "https://console.cloud.google.com"

        ##############################################################
        # Apple login
        ##############################################################
        "https://appleid.apple.com"
        "https://idmsa.apple.com"

        ##############################################################
        # School
        ##############################################################
        "https://my.ucf.edu"

        ##############################################################
        # ChatGPT / OpenAI authentication
        ##############################################################
        "https://chatgpt.com"
        "https://chat.openai.com"
        "https://auth.openai.com"

        # Required for token exchange
        "https://api.openai.com"

        ##############################################################
        # Figma authentication
        ##############################################################
        "https://www.figma.com"
        "https://id.figma.com"

        # Required for Google SSO on Figma
        "https://www.googleapis.com"
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
