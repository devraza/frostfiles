{ config, ... }:
let
  domain_cert = "/etc/certs/fullchain.pem";
  domain_key = "/etc/certs/privkey.pem";
  permafrost_cert = "/etc/certs/permafrost/permafrost.gleeze.com.crt";
  permafrost_key = "/etc/certs/permafrost/permafrost.gleeze.com.key";
in {
  # Caddy as a reverse proxy
  services.caddy = {
    enable = true;
    extraConfig = ''
      http://invidious.icefall {
        reverse_proxy 127.0.0.1:4202
      }
      http://redlib.icefall {
        reverse_proxy 127.0.0.1:9080
      }
      vault.permafrost.gleeze.com {
        bind 100.64.0.2
        tls ${permafrost_cert} ${permafrost_key}
        reverse_proxy localhost:9493 {
          header_up X-Real-IP {remote_host}
        }
      }
      actual.permafrost.gleeze.com {
        bind 100.64.0.2
        tls ${permafrost_cert} ${permafrost_key}
        reverse_proxy 127.0.0.1:5006
      }
      http://miniflux.icefall {
        reverse_proxy 127.0.0.1:9050
      }
      http://scrutiny.icefall {
        reverse_proxy 127.0.0.1:9070
      }
      http://linkwarden.icefall {
        reverse_proxy 127.0.0.1:9040
      }
      http://media.icefall {
        reverse_proxy 127.0.0.1:8096
      }
      http://search.icefall {
        reverse_proxy 127.0.0.1:8888
      }
      http://torrent.icefall {
        reverse_proxy 127.0.0.1:8080
      }
      http://panel.icefall {
        reverse_proxy 127.0.0.1:9291
      }
      http://sonarr.icefall {
        reverse_proxy 127.0.0.1:8989
      }
      http://grafana.icefall {
        reverse_proxy 127.0.0.1:3000
      }
      http://uptime.icefall {
        reverse_proxy 127.0.0.1:3001
      }
      http://todo.icefall {
        reverse_proxy 127.0.0.1:3456
      }
      http://calibre.icefall {
        reverse_proxy 127.0.0.1:7074
      }
      http://kiwix.icefall {
        reverse_proxy 127.0.0.1:3920
      }
      http://dash.icefall {
        reverse_proxy 127.0.0.1:8082
      }

      devraza.giize.com {
        tls ${domain_cert} ${domain_key}

        handle /.well-known/matrix/server {
	        header Content-Type application/json
	        header Access-Control-Allow-Origin *
	        respond `{"m.server": "matrix.devraza.giize.com:8448"}`
        }
        handle /.well-known/matrix/client {
	        header Content-Type application/json
	        header Access-Control-Allow-Origin *
	        respond `{"m.homeserver": {"base_url": "https://matrix.devraza.giize.com:8448"}}`
        }

        root * /var/lib/website/public
        encode zstd gzip
        file_server
      }
      matrix.devraza.giize.com {
        tls ${domain_cert} ${domain_key}
        reverse_proxy localhost:8029
      }
      matrix.devraza.giize.com:8448 {
        tls ${domain_cert} ${domain_key}
        reverse_proxy localhost:8029
      }
      git.devraza.giize.com {
        tls ${domain_cert} ${domain_key}
        reverse_proxy ${toString config.services.forgejo.settings.server.HTTP_ADDR}:${toString config.services.forgejo.settings.server.HTTP_PORT}
      }
      hs.devraza.giize.com {
        tls ${domain_cert} ${domain_key}
        reverse_proxy localhost:7070
      }
      *.devraza.giize.com {
        redir https://devraza.giize.com
      }
      fs.devraza.giize.com {
        tls ${domain_cert} ${domain_key}
        reverse_proxy localhost:9039
        basicauth {
          guest $2y$10$kc6KxK42Dk3xO5bbK5X8WeFlKd0Y/zXAsO2zdxTcysPfhx4WzFcIm
        }
      }
    '';
  };
}
