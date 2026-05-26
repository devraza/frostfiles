{ config, inputs, ... }:
{
    # configure options
    programs.noctalia-shell = {
      enable = true;
      colors = {
        mPrimary = "#a292e8";
        mOnPrimary = "#151517";
        mSecondary = "#55498c";
        mOnSecondary = "#151517";
        mTertiary = "#f06969";
        mOnTertiary = "#151517";
        mError = "#f06969";
        mOnError = "#151517";
        mSurface = "#151517";
        mOnSurface = "#a292e8";
        mSurfaceVariant = "#242426";
        mOnSurfaceVariant = "#ece5ea";
        mOutline = "#55498c";
        mShadow = "#242426";
        mHover = "#b6a6ef";
        mOnHover = "#151517";
      };
      settings = {
        # configure noctalia here
        bar = {
          position = "left";
          showCapsule = false;
          widgets = {
            left = [
              {
                id = "ControlCenter";
                useDistroLogo = true;
              }
              {
                id = "Network";
              }
              {
                id = "Bluetooth";
              }
            ];
            center = [
              {
                hideUnoccupied = false;
                id = "Workspace";
                labelMode = "none";
              }
            ];
            right = [
              {
                alwaysShowPercentage = false;
                id = "Battery";
                warningThreshold = 30;
              }
              {
                formatHorizontal = "HH:mm";
                formatVertical = "HH mm";
                id = "Clock";
                useMonospacedFont = true;
                usePrimaryColor = true;
              }
            ];
          };
        };
        notifications = {
          density = "compact";
          enableMarkdown = true;
          location = "bottom_right";
        };
        nightLight = {
          enabled = true;
          nightTemp = "5000";
        };
        appLauncher = {
          density = "compact";
          showCategories = false;
          enableWindowsSearch = true;
          enableSettingsSearch = false;
          enableSessionSearch = false;
        };
        sessionMenu = {
          showHeader = false;
          enableCountdown = false;
          position = "bottom_center";
          largeButtonsStyle = false; 
        };
        dock.enabled = false;
        audio = {
          volumeStep = 5;
          visualizerType = "mirrored";
          spectrumFrameRate = 30;
        };
        osd = {
          location = "bottom_right";
        };
        general = {
          avatarImage = "/home/devraza/Documents/Profiles/nagato.png";
          radiusRatio = 0.2;
          compactLockScreen = true;
          lockScreenBlur = 0.4;
        };
        ui = {
          fontDefault = "Cartograph CF";
          fontFixed = "ZedMono Nerd Font";
        };
        location = {
          monthBeforeDay = false;
          name = "Walsall, England";
        };
        wallpaper = {
          transitionType = [ "disc" ];
          transitionDuration = 1000;
        };
      };
      # this may also be a string or a path to a JSON file.
    };

    xdg.configFile."wallpapers".source = ../../../assets/wallpapers;
    home.file.".cache/noctalia/wallpapers.json" = {
      text = builtins.toJSON {
        defaultWallpaper = "${config.xdg.configHome}/wallpapers/winterforest.jpg";
      };
    };
}
