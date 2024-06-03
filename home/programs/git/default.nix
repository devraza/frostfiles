{
  # Git config
  programs.git = {
    enable = true;
    userName  = "Muhammad Nauman Raza";
    userEmail = "devraza.hazard643@slmail.me";
    signing = {
      key = "0x91EAD6081011574B";
      signByDefault = true;
    };
    extraConfig = {
      pull.rebase = true;
    };
  };
}
