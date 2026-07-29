{
  programs.fuzzel = {
    enable = true;
    settings = {
      main = {
        terminal = "alacritty";
        layer = "overlay";
        font = "Cartograph CF:size=14";
        use-bold = true;
        prompt = "'$ '";
        horizontal-pad = 8;
      };
      colors = {
        background = "151517ff";
        text = "454449ff";
        message = "ece5eaff";
        prompt = "5c5c61ff";
        input = "ece5eaff";
        match = "5c5c61ff";
        selection = "242426ff";
        selection-text = "a292e8ff";
        selection-match = "e887bbff";
        border = "a292e8ff";
      };
      border = {
        width = 2;
        radius = 6;
        selection-radius = 2;
      };
    };
  };
}
