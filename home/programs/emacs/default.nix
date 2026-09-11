{ pkgs, inputs, ... }:
{
  home.packages = with pkgs; [
    (pkgs.emacs-pgtk.overrideAttrs (old: {
      configureFlags = (old.configureFlags or []) ++ [
        "--with-native-compilation"
        "--without-x"
        "--with-toolkit-scroll-bars"
        "--with-cairo"
        "--without-xft"
        "--with-harfbuzz"
        "--without-libotf"
        "--with-gnutls"
        "--without-xdbe"
        "--without-xim"
        "--without-gpm"
        "--disable-gc-mark-trace"
        "--with-gsettings"
        "--with-modules"
        "--with-threads"
        "--with-libgmp"
        "--with-xml2"
        "--with-tree-sitter"
        "--with-zlib"
        "--without-included-regex"
        "--with-native-compilation"
        "--without-selinux"
        "--with-file-notification=inotify"
        "--without-compress-install"
        "--without-sound"
        "--without-dbus"
        "--without-gconf"
        "--without-m17n-flt"
        "--disable-acl"
        "--without-kerberos"
        "--without-pop"
        "--without-kerberos5"
        "--without-hesiod"
        "--without-mail-unlink"
      ];

      CFLAGS="-O2 -pipe -march=native -mtune=native -fno-omit-frame-pointer -fno-plt -flto=auto";
      LDFLAGS="-Wl,-O2 -Wl,-z,now -Wl,-z,relro -Wl,--sort-common -Wl,--as-needed -Wl,-z,pack-relative-relocs -flto=auto -O2";
    }))
  ];
}
