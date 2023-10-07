{
  services.mpd = {
    enable = true;
    musicDirectory = "~/Music";
    extraConfig = ''
        audio_output {
            type   "fifo"
            name   "my_fifo"
            path   "/tmp/mpd.fifo"
            format "44100:16:2"
        }

        audio_output {
            type "pipewire"
            name "PipeWire Output"
        }
    '';
  };
} 
