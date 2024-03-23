{
  # Git config
  programs.git = {
    enable = true;
    userName  = "Muhammad Nauman Raza";
    userEmail = "devraza@skiff.com";
    signing = {
      key = "0xB0EF3A98B29ADB1D";
      signByDefault = true;
    };
    extraConfig = {
      pull.rebase = true;
    };
  };
}
