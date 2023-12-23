{ config, pkgs, ... }:

{
  ## Music
  programs.ncmpcpp = {
    enable = true;
    settings = {
      # Directory
      ncmpcpp_directory = "~/.local/share/ncmpcpp";
      lyrics_directory = "~/.local/share/ncmpcpp/lyrics";
      
      # Connectivity
      mpd_password = "***REMOVED***";
      mpd_host = "127.0.0.1";
      mpd_port = "6600";

      # General configuration
      message_delay_time = 1;
      playlist_disable_highlight_delay = 2;
      autocenter_mode = "no";
      centered_cursor = "no";
      ignore_leading_the = "yes";
      allow_for_physical_item_deletion = "yes";
      connected_message_on_startup = "yes";
      cyclic_scrolling = "yes";
      mouse_support = "yes";
      mouse_list_scroll_whole_page = "yes";
      lines_scrolled = "1";
      playlist_shorten_total_times = "yes";
      playlist_display_mode = "columns";
      browser_display_mode = "columns";
      search_engine_display_mode = "columns";
      playlist_editor_display_mode = "columns";
      follow_now_playing_lyrics = "yes";
      display_bitrate = "no";

      # Progress Bar
      progressbar_look = "▔▔▔";
      progressbar_color = "black";
      progressbar_elapsed_color = "cyan";
      
      # Colours
      main_window_color = "blue";
      color1 = "white";
      color2 = "red";

      # Visualiser
      # visualizer_data_source = "/tmp/mpd.fifo";
      # visualizer_output_name = "my_fifo";
      # visualizer_in_stereo = "yes";
      # visualizer_color = "blue";
      # visualizer_type = "spectrum";

      # UI Visibility
      header_visibility = "no";
      statusbar_visibility = "yes";
      titles_visibility = "no";

      # UI Appearance
      user_interface = "alternative"; # Alternative UI

      # Formats
      song_status_format= "$7%t";
      song_list_format = "$8%a - %t$R  %l";
      song_columns_list_format = "(53)[white]{tr} (45)[blue]{a}";
      song_library_format = "{{%a - %t} (%b)}|{%f}";
      song_window_title_format = "Music";
    };
    mpdMusicDir = "~/Music";
    bindings = [
      { key = "j"; command = "scroll_down"; }
      { key = "k"; command = "scroll_up"; }
      { key = "J"; command = [ "select_item" "scroll_down" ]; }
      { key = "K"; command = [ "select_item" "scroll_up" ]; }

      { key = "v"; command = "show_visualizer"; }
    ];
  };
}
