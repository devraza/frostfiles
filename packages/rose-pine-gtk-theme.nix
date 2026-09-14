{
  stdenvNoCC,
  lib,
  fetchFromGitHub,
  gnome-themes-extra,
}:

stdenvNoCC.mkDerivation rec {
  pname = "rose-pine-gtk-theme";
  version = "2.2.0-git";

  src = fetchFromGitHub {
    owner = "rose-pine";
    repo = "gtk";
    rev = "3a11f84e11685aacaa749deea1e9f02872b99fdf";
    hash = "sha256-58HfkFvflQhiJzfHcJCihSE9YbxbD6Koe0/aT+PVv4w=";
  };

  buildInputs = [
    gnome-themes-extra # adwaita engine for Gtk2
  ];

  # avoid the makefile which is only for theme maintainers
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/themes/rose-pine{,-dawn,-moon}/gtk-4.0

    variants=("rose-pine" "rose-pine-dawn" "rose-pine-moon")
    for n in "''${variants[@]}"; do
      cp -r $src/gtk3/"''${n}"-gtk/* $out/share/themes/"''${n}"
      cp -r $src/gtk4/"''${n}".css $out/share/themes/"''${n}"/gtk-4.0/gtk.css
    done

    runHook postInstall
  '';

  meta = {
    description = "Rosé Pine theme for GTK";
    homepage = "https://github.com/rose-pine/gtk";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
  };
}
