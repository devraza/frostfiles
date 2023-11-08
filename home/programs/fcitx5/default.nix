{ pkgs, ... }:
{
  i18n.inputMethod.enabled = "fcitx5";
  i18n.inputMethod.fcitx5.addons = with pkgs; [ fcitx5-mozc ]; # Enable and use the 'mozc' input method addon - for japanese
}
