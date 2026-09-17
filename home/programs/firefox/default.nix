{
  config,
  lib,
  pkgs,
  ...
}:
let
  extensions = [
    "uBlock0@raymondhill.net"                   # uBlock Origin
    "myallychou@gmail.com"                      # Unhook
    "7esoorv3@alefvanoon.anonaddy.me"           # Libredirect
    "{446900e4-71c2-419f-a6a7-df9c091e268b}"    # Bitwarden
    "FirefoxColor@mozilla.com"                  # Firefox Color
  ];
in
{
  programs.firefox = {
    enable = true;
    configPath = "${config.xdg.configHome}/mozilla/firefox";
    policies = {
      # Debloat
      DisableFirefoxStudies = true;
      DontCheckDefaultBrowser = true;
      UserMessaging = {
        ExtensionRecommendations = false;
        UrlbarInterventions = false;
        SkipOnboarding = true;
        MoreFromMozilla = false;
        FirefoxLabs = true;
      };
      FirefoxSuggest = {
        WebSuggestions = false;
        SponsoredSuggestions = false;
        ImproveSuggest = false;
        Locked = true;
      };

      # Security
      AutofillAddressEnabled = false;
      AutofillCreditCardEnabled = false;
      HttpsOnlyMode = "force_enabled";
      SSLVersionMin = "tls1.2";
      PostQuantumKeyAgreementEnabled = true;
      HttpAllowlist = [
        "http://localhost"
        "http://127.0.0.1"
      ];

      # Privacy
      DisableTelemetry = true;
      EnableTrackingProtection = {
        Value = true;
        Locked = true;
        Cryptomining = true;
        Fingerprinting = true;
      };
      DisablePocket = true;
      NetworkPrediction = false;

      # Delete data on shutdown
      SanitizeOnShutdown = {
        Cache = false;
        FormData = true;
        SiteSettings = false;
        OfflineApps = true;
      };
      SearchEngines = {
        Remove = [
          "eBay"
          "Google"
          "Bing"
          "Ecosia"
          "Wikipedia"
          "Perplexity"
        ];
        Add = [
          {
            "Name" = "Degoog";
            "URLTemplate" = "https://search.permafrost.gleeze.com/search?q={searchTerms}";
            "Alias" = "degoog";
          }
          {
            "Name" = "DuckDuckGo";
            "URLTemplate" = "https://duckduckgo.com/?q={searchTerms}&ia=web&assist=false";
            "IconURL" = "https://duckduckgo.com/favicon.ico";
            "Alias" = "ddg";
            "Description" = "Duckduckgo without AI integrations";
          }
        ];
        Default = "Degoog";
      };
      SearchSuggestEnabled = false;

      ExtensionSettings = builtins.listToAttrs (builtins.map (id: {
        name = id;
        value = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/${id}/latest.xpi";
          installation_mode = "force_installed";
        };
      }) extensions);
    };
    profiles."default" = {
      id = 0;
      settings = {
        # Homepage
        "browser.startup.homepage" = "https://search.permafrost.gleeze.com";

        # Features
        "layout.spellcheckDefault" = 1;
        "widget.use-xdg-desktop-portal.file-picker" = 1; # Use the systems native filechooser portal
        "media.webrtc.camera.allow-pipewire" = true;

        # Debloat configurations
        "browser.discovery.enabled" = false;
        "app.shield.optoutstudies.enabled" = false;
        "browser.topsites.contile.enabled" = false;
        "browser.urlbar.suggest.quicksuggest.sponsored" = false;
        "browser.urlbar.trending.featureGate" = false;
        "browser.newtabpage.activity-stream.feeds.section.topstories" = false;
        "browser.newtabpage.activity-stream.feeds.snippets" = false;
        "browser.newtabpage.activity-stream.section.highlights.includePocket" = false;
        "browser.newtabpage.activity-stream.section.highlights.includeBookmarks" = false;
        "browser.newtabpage.activity-stream.section.highlights.includeDownloads" = false;
        "browser.newtabpage.activity-stream.section.highlights.includeVisited" = false;
        "browser.newtabpage.activity-stream.showSponsored" = false;
        "browser.newtabpage.activity-stream.system.showSponsored" = false;
        "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
        "browser.contentblocking.category" = "strict";
        "extensions.pocket.enabled" = false;
        "browser.search.suggest.enabled" = false;
        "browser.search.suggest.enabled.private" = false;
        "browser.urlbar.suggest.searches" = false;

        # Privacy settings
        "privacy.resistFingerprinting" = "true";
        "browser.safebrowsing.downloads.remote.enabled" = false;
        "network.dns.disablePrefetch" = false;
        "network.http.speculative-parallel-limit" = 0;
        "browser.places.speculativeConnect.enabled" = "false";
        "privacy.globalprivacycontrol.enabled" = true;
        "privacy.clearOnShutdown_v2.cookiesAndStorage" = true;
        "privacy.fingerprintingProtection" = true;
        "browser.privatebrowsing.forceMediaMemoryCache" = true; # Store media in cache only on private browsing
        "network.http.referer.XOriginTrimmingPolicy" = 2;
        "security.csp.reporting.enabled" = false;

        # Security
        "pdfjs.enableScripting" = false;
        "signon.formlessCapture.enabled" = false;
        "dom.disable_window_move_resize" = true;
        "devtools.debugger.remote-enabled" = false;
        "extensions.enabledScopes" = 5;

        # SSL
        "security.ssl.require_safe_negotiation" = true;
        "security.tls.enable_0rtt_data" = 2;
        "security.cert_pinning.enforcement_level" = 2;
        "security.pki.crlite_mode" = 2;
        "security.ssl.treat_unsafe_negotiation_as_broken" = true;
        "browser.xul.error_pages.expert_bad_cert" = true;
      };
    };
  };
}
