{ pkgs, hostName, inputs, ... }:
{
  home.packages = if (hostName == "endogenesis") then 
    with pkgs; [
      steam
      inputs.nix-gaming.packages.${pkgs.system}.osu-stable
    ] else
    with pkgs; [
    ];
}
