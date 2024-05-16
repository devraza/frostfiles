{ config, ... }:
let
  domain_cert = "/etc/certs/fullchain.pem";
  domain_key = "/etc/certs/privkey.pem";
in {
  # Caddy as a reverse proxy
  services.caddy = {
    enable = true;
    extraConfig = ''
      http://invidious.icefall {
        reverse_proxy 127.0.0.1:4202
      }
      :8888 {
        reverse_proxy 127.0.0.1:8887
      }
      :8080 {
        reverse_proxy 127.0.0.1:8079
      }
      :9291 {
        reverse_proxy 127.0.0.1:9290
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
      fs.devraza.giize.com {
        tls ${domain_cert} ${domain_key}
        reverse_proxy localhost:9039
        basicauth {
          guest $2y$10$kc6KxK42Dk3xO5bbK5X8WeFlKd0Y/zXAsO2zdxTcysPfhx4WzFcIm
        }
      }
      vault.devraza.giize.com {
        tls ${domain_cert} ${domain_key}
        reverse_proxy localhost:9493 {
          header_up X-Real-IP {remote_host}
        }
      }
    '';
  };
}
