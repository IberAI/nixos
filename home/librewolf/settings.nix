{ config, pkgs, ... }:

{
  programs.librewolf.settings = {
    ##################################################################
    # Core privacy / security
    ##################################################################
    "browser.contentblocking.category" = "strict";

    # Allow cookies in principle; enterprise policy decides who gets them.
    "network.cookie.lifetimePolicy" = 0;

    # We control shutdown cleaning via SanitizeOnShutdown policy instead.
    "privacy.sanitize.sanitizeOnShutdown" = false;
    "privacy.clearOnShutdown.history"    = false;
    "privacy.clearOnShutdown.cookies"    = false;
    "privacy.clearOnShutdown.downloads"  = false;

    ##################################################################
    # Discord / WebRTC / compatibility
    ##################################################################
    "webgl.disabled" = false;
    "media.peerconnection.enabled" = true;
    "media.navigator.enabled"      = true;

    # HTTPS-only everywhere (normal + PBM).
    "dom.security.https_only_mode"     = true;
    "dom.security.https_only_mode_pbm" = true;

    # LibreWolf enables RFP by default; we disable it so Discord
    # screenshare and some webapps work. CanvasBlocker + policies
    # handle fingerprinting instead.
    "privacy.resistFingerprinting" = false;

    ##################################################################
    # Extra quiet / anti-fingerprinting tweaks
    ##################################################################
    # Don’t expose battery status.
    "dom.battery.enabled" = false;

    # Kill speculative prefetch / prediction.
    "network.dns.disablePrefetch" = true;
    "network.prefetch-next"       = false;
    "network.predictor.enabled"   = false;

    # Referrer: only send on same-origin, and trim to origin.
    "network.http.referer.XOriginPolicy"         = 2; # same origin only
    "network.http.referer.XOriginTrimmingPolicy" = 2; # origin only

    # No ping tracking.
    "browser.send_pings" = false;

    # No motion / orientation sensors.
    "device.sensors.enabled" = false;

    # No gamepad or vibration.
    "dom.gamepad.enabled"   = false;
    "dom.vibrator.enabled"  = false;

    # Slightly narrow font/fancy SVG surface.
    "gfx.font_rendering.opentype_svg.enabled" = false;

    ##################################################################
    # Permissions defaults
    ##################################################################
    # 0 = always ask, 1 = allow, 2 = block
    "permissions.default.geo"                  = 2; # never share location
    "permissions.default.desktop-notification" = 2; # never allow notifications

    # Camera/mic you *do* need for Discord, so keep them as "ask".
    "permissions.default.camera"     = 0;
    "permissions.default.microphone" = 0;

    ##################################################################
    # Service workers / push / notifications
    ##################################################################
    # Kill background workers & push channels (max privacy).
    "dom.serviceWorkers.enabled"                 = false;
    "dom.push.enabled"                           = false;
    "dom.push.connection.enabled"                = false;
    "dom.webnotifications.enabled"               = false;
    "dom.webnotifications.serviceworker.enabled" = false;

    ##################################################################
    # Disable studies / system add-ons / recommendations
    ##################################################################
    # No “extension recommendations” junk.
    "extensions.htmlaboutaddons.recommendations.enabled" = false;
    "extensions.getAddons.showPane"                      = false;

    # No remote experiments / Normandy.
    "app.normandy.enabled"  = false;
    "app.normandy.api_url"  = "";

    # No Shield studies.
    "app.shield.optoutstudies.enabled" = false;

    # Don’t silently update or fetch system add-ons.
    "extensions.systemAddon.update.enabled" = false;
    "extensions.systemAddon.update.url"     = "";
  };
}
