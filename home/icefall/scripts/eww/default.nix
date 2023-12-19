{ pkgs, lib, ... }:

let
  getinfo = pkgs.writeShellScriptBin "getinfo" (lib.fileContents ./getinfo);

in {
  home.packages = [
    getinfo
    pkgs.mpc-cli # dependency of script
  ];
}
