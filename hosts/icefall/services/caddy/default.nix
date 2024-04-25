{ config, ... }:
let
  subdomain_cert = "/etc/certs/subdomains/fullchain.pem";
  subdomain_key = "/etc/certs/subdomains/privkey.pem";
  domain_cert = "/etc/certs/fullchain.pem";
  domain_key = "/etc/certs/privkey.pem";
in {
  # Caddy as a reverse proxy
  services.caddy = {
    enable = true;
    extraConfig = ''
      :4203 {
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
      :3030 {
        reverse_proxy localhost:9493
      }
     
      devraza.duckdns.org {
        tls ${domain_cert} ${domain_key}

        handle /.well-known/matrix/server {
	        header Content-Type application/json
	        header Access-Control-Allow-Origin *
	        respond `{"m.server": "matrix.devraza.duckdns.org:8448"}`
        }
        handle /.well-known/matrix/client {
	        header Content-Type application/json
	        header Access-Control-Allow-Origin *
	        respond `{"m.homeserver": {"base_url": "https://matrix.devraza.duckdns.org:8448"}}`
        }

        root * /var/lib/website/public
        encode zstd gzip
        file_server
      }
      matrix.devraza.duckdns.org {
        tls ${subdomain_cert} ${subdomain_key}
        reverse_proxy localhost:8029
      }
      matrix.devraza.duckdns.org:8448 {
        tls ${subdomain_cert} ${subdomain_key}
        reverse_proxy localhost:8029
      }
      git.devraza.duckdns.org {
        tls ${subdomain_cert} ${subdomain_key}
        reverse_proxy ${toString config.services.gitea.settings.server.HTTP_ADDR}:${toString config.services.gitea.settings.server.HTTP_PORT}
      }
      hs.devraza.duckdns.org {
        tls ${subdomain_cert} ${subdomain_key}
        reverse_proxy localhost:7070
      }
      actual.devraza.duckdns.org {
        tls ${subdomain_cert} ${subdomain_key}
        reverse_proxy localhost:5006
      }
      fs.devraza.duckdns.org {
        tls ${subdomain_cert} ${subdomain_key}
        reverse_proxy localhost:9039
        basicauth {
          guest $2y$10$kc6KxK42Dk3xO5bbK5X8WeFlKd0Y/zXAsO2zdxTcysPfhx4WzFcIm
        }
      }
    '';
  };


}
