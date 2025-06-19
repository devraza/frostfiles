{
  programs.waybar = {
    enable = true;
    style = ''
      window#waybar {
          background: #151517;
          border-top: 2px solid #454449;
      }
      
      #clock,
      #cpu,
      #memory,
      #battery,
      #pulseaudio {
          margin: 6px 4px 6px 0px;
          padding: 2px 12px 0px 8px;
      }
      
      #workspaces {
          padding: 2px 8px;
          background-color: #242426;
          margin: 6px 0px 6px 6px;
      }
      
      #memory {
          color: #91d65c;
      }
      #battery {
          color: #a292e8;
      }
      #cpu {
          color: #f06969;
      }
      #pulseaudio {
          color: #e887bb;
      }
      
      #workspaces button {
          all: initial;
          min-width: 0;
          color: #a292e8;
          font-weight: 900;
          padding: 0px 0px;
      }
      
      #cpu,
      #memory,
      #battery,
      #pulseaudio {
          background-color: #242426;
      }
    '';
  };

  xdg.configFile."waybar/config.jsonc".source = ./config.jsonc;
}
