{
  pkgs,
  pkgs-stable,
  inputs,
  ...
}:
let
  mumble-fix = pkgs.symlinkJoin {
    name = "mumble";
    paths = [ pkgs.mumble ];
    nativeBuildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/mumble \
        --set DISABLE_RTKIT 1
    '';
  };
in
{
  home.packages = with pkgs; [
    protonplus # windows compat
    mumble-fix # voice chat (with fix)
    osu-lazer-bin # osu!(mania)
    pkgs-stable.bottles # wine environment creation
    graalvmPackages.graalvm-ce # java runtime
    prismlauncher # minecraft launcher
  ];
  # benchmarking
  programs.mangohud = {
    enable = true;
    settings = {
      preset = 3;
    };
  };
}
