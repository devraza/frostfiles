{
  # Git config
  programs.git = {
    enable = true;
    settings = {
      user = {
        email = "devraza.hazard643@slmail.me";
        name = "Muhammad Nauman Raza";
      };
      pull.rebase = true;
    };
    signing = {
      key = "0x91EAD6081011574B";
      signByDefault = true;
    };
  };
}
