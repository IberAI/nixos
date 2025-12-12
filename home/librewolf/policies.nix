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

      # Only these ORIGINS can set cookies and keep sessions:
      # (No wildcards. For Slack you likely need your workspace origin too.)
      Allow = [
        # GitHub
        "https://github.com"
        "https://api.github.com"

        # Discord
        "https://discord.com"
        "https://login.discord.com"
        "https://id.discord.com"

        # Slack (ADD your workspace!)
        "https://slack.com"
        "https://app.slack.com"
        # "https://YOURWORKSPACE.slack.com"

        # Supabase
        "https://supabase.com"
        "https://auth.supabase.com"
        "https://oauth.supabase.com"

        # Expo
        "https://expo.dev"
        "https://auth.expo.dev"

        # Vercel
        "https://vercel.com"
        "https://api.vercel.com"
        "https://auth.vercel.com"

        # RevenueCat
        "https://app.revenuecat.com"

        # Google auth / APIs (used by lots of SSO flows)
        "https://accounts.google.com"
        "https://securetoken.googleapis.com"
        "https://oauth2.googleapis.com"
        "https://www.googleapis.com"
        "https://mail.google.com"
        "https://play.google.com"
        "https://console.cloud.google.com"

        # Apple login
        "https://appleid.apple.com"
        "https://idmsa.apple.com"

        # School
        "https://my.ucf.edu"

        # ChatGPT / OpenAI
        "https://chatgpt.com"
        "https://chat.openai.com"
        "https://auth.openai.com"
        "https://api.openai.com"

        # Figma
        "https://www.figma.com"
        "https://id.figma.com"
      ];

      Locked = true;
    };

    ##############################################################
    # WIPE MOST DATA ON SHUTDOWN — BUT KEEP LOGIN STATE
    #
    # IMPORTANT:
    # - Sessions = "Active Logins" -> MUST be false if you want to stay logged in
    # - OfflineApps / site storage -> keep it if you want modern webapps to persist auth state
    ##############################################################
    SanitizeOnShutdown = {
      Cache       = true;
      Downloads   = true;
      FormData    = true;
      History     = true;

      Cookies     = false;  # keep cookies for allow-listed sites
      Sessions    = false;  # keep active logins
      OfflineApps = false;  # keep site storage

      # Optional: wipe permissions (mic/cam prompts re-ask)
      SiteSettings = true;

      Locked = true;
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
