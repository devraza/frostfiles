{
  config,
  lib,
  pkgs,
  ...
}:

{
  programs.qutebrowser = {
    enable = true;
    searchEngines = {
      DEFAULT = "https://search.permafrost.gleeze.com/search?q={}";
      d = "https://duckduckgo.com/?ia=web&q={}";
      g = "https://www.google.com/search?hl=en&amp;q={}";
    };
    settings = {
      url.default_page = "https://search.permafrost.gleeze.com";
      url.start_pages = [ "https://search.permafrost.gleeze.com" ];

      auto_save.session = true;

      colors.webpage.preferred_color_scheme = "dark";

      fileselect.handler = "external";
      fileselect.multiple_files.command = [
        "alacritty"
        "-e"
        "yazi"
        "--chooser-file"
        "{}"
      ];
      fileselect.single_file.command = [
        "alacritty"
        "-e"
        "yazi"
        "--chooser-file"
        "{}"
      ];
    };
    keyBindings = {
      normal = {
        "t" = "open -t";
        "C" = "history-clear -f";

        "J" = "tab-prev";
        "K" = "tab-next";
      };
    };
    extraConfig = ''
      import rosepine
      rosepine.setup(c, 'rose-pine', True)

      def fonts(c, font, size):
          c.fonts.tabs.selected = f"{size}pt {font}"
          c.fonts.tabs.unselected = f"{size}pt {font}"
          c.fonts.hints = f"{size}pt {font}"
          c.fonts.keyhint = f"{size}pt {font}"
          c.fonts.prompts = f"{size}pt {font}"
          c.fonts.downloads = f"{size}pt {font}"
          c.fonts.statusbar = f"{size}pt {font}"
          c.fonts.contextmenu = f"{size}pt {font}"
          c.fonts.messages.info = f"{size}pt {font}"
          c.fonts.debug_console = f"{size}pt {font}"
          c.fonts.completion.entry = f"{size}pt {font}"
          c.fonts.completion.category = f"{size}pt {font}"

          # Additional (default) font settings
          c.fonts.web.family.serif = f"{font}"
          c.fonts.web.family.sans_serif = f"{font}"
          c.fonts.web.family.fixed = f"{font}"
          c.fonts.web.family.standard = f"{font}"
          c.fonts.default_family = f"{font}"
      fonts(c, "Cartograph CF", "10")

      # Redirecting services
      from qutebrowser.api import interceptor, message
      REDIRECT_MAPS = [
          {
              "reddit.com": 'redlib.catsarch.com',
              "www.reddit.com": 'redlib.catsarch.com',
          },
          {
              "imgur.com": 'rimgo.pussthecat.org',
              "www.imgur.com": 'rimgo.pussthecat.org',
          },
      ];

      def int_fn(info: interceptor.Request):
          for REDIRECT_MAP in REDIRECT_MAPS:
              if (info.resource_type != interceptor.ResourceType.main_frame or info.request_url.scheme() in {"data", "blob"}):
                  return
              url = info.request_url
              source_host = url.host()
              target_host = REDIRECT_MAP.get(source_host)
              if target_host is not None and url.setHost(target_host) is not False:
                  url.setScheme('http')
                  message.info("Redirecting to " + url.toString())
                  info.redirect(url)

      interceptor.register(int_fn)
    '';
  };

  xdg.configFile."qutebrowser/rosepine".source = pkgs.fetchFromGitHub {
    owner = "aalbegr";
    repo = "qutebrowser-rose-pine";
    rev = "4662474db0fa6b52985f9e9ea9c3eca16a721b5b";
    hash = "sha256-YP+Y00Ag69eO8Xx2adAEVzHYp3DuvfSfHnPh7lUXhss=";
  };
}
