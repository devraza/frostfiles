{
  # Git config
  programs.git = {
    enable = true;
    userName  = "Muhammad Nauman Raza";
    userEmail = "razadev@proton.me";
    signing = {
      key = "0xB0EF3A98B29ADB1D";
      signByDefault = true;
    };
    extraConfig = {
      pull.rebase = true;
    };
  };
}
