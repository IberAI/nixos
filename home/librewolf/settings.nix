{ config, pkgs, ... }:

{
  programs.librewolf.settings = {
    ##################################################################
    # Core privacy / security
    ##################################################################
    "browser.contentblocking.category" = "strict";

    # Allow cookies in principle; enterprise policy decides who gets them.
    "network.cookie.lifetimePolicy" = 0;

    # We control cleaning via SanitizeOnShutdown policy instead.
    "privacy.sanitize.sanitizeOnShutdown" = false;

    # otherwise your allow-list logins won’t persist.
    "privacy.clearOnShutdown.history"     = false;
    "privacy.clearOnShutdown.cookies"     = false;
    "privacy.clearOnShutdown.downloads"   = false;
    "privacy.clearOnShutdown.sessions"    = false;
    "privacy.clearOnShutdown.offlineApps" = false;

    ##################################################################
    # Discord / WebRTC / compatibility
    ##################################################################
    "webgl.disabled" = false;
    "media.peerconnection.enabled" = true;
    "media.navigator.enabled"      = true;

    # HTTPS-only everywhere (normal + PBM).
    "dom.security.https_only_mode"     = true;
    "dom.security.https_only_mode_pbm" = true;

    # LibreWolf enables RFP by default; disable if it breaks your sites.
    "privacy.resistFingerprinting" = false;

    ##################################################################
    # Extra quiet / anti-fingerprinting tweaks
    ##################################################################
    "dom.battery.enabled" = false;

    "network.dns.disablePrefetch" = true;
    "network.prefetch-next"       = false;
    "network.predictor.enabled"   = false;

    "network.http.referer.XOriginPolicy" = 2;

    "browser.send_pings" = false;

    "device.sensors.enabled" = false;

    "dom.gamepad.enabled"  = false;
    "dom.vibrator.enabled" = false;

    "gfx.font_rendering.opentype_svg.enabled" = false;

    ##################################################################
    # Permissions defaults
    ##################################################################
    # 0 = always ask, 1 = allow, 2 = block
    "permissions.default.geo"                  = 2;
    "permissions.default.desktop-notification" = 2;

    "permissions.default.camera"     = 0;
    "permissions.default.microphone" = 0;

    ##################################################################
    # Service workers / push / notifications
    #
    # WARNING: disabling service workers/push can break some webapps.
    # If a site stops staying logged in or behaves weirdly, set these true.
    ##################################################################
    "dom.serviceWorkers.enabled"                 = false;
    "dom.push.enabled"                           = false;
    "dom.push.connection.enabled"                = false;
    "dom.webnotifications.enabled"               = false;
    "dom.webnotifications.serviceworker.enabled" = false;

    ##################################################################
    # Disable studies / system add-ons / recommendations
    ##################################################################
    "extensions.htmlaboutaddons.recommendations.enabled" = false;
    "extensions.getAddons.showPane"                      = false;

    "app.normandy.enabled" = false;
    "app.normandy.api_url" = "";

    "app.shield.optoutstudies.enabled" = false;

    "extensions.systemAddon.update.enabled" = false;
    "extensions.systemAddon.update.url"     = "";
  };
}
