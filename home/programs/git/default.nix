{
  # Git config
  programs.git = {
    enable = true;
    userName  = "Muhammad Nauman Raza";
    userEmail = "devraza.hazard643@slmail.me";
    signing = {
      key = "0xB0EF3A98B29ADB1D";
      signByDefault = true;
    };
    extraConfig = {
      pull.rebase = true;
    };
  };
}
