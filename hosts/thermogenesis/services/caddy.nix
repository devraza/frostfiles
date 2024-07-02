{ config, ... }:
let
  domain_cert = "/var/lib/acme/devraza.giize.com/fullchain.pem";
  domain_key = "/var/lib/acme/devraza.giize.com/key.pem";
  subdomain_cert = "/var/lib/acme/subdomains/fullchain.pem";
  subdomain_key = "/var/lib/acme/subdomains/key.pem";
in {
  # Caddy as a reverse proxy
  services.caddy = {
    enable = true;
    extraConfig = ''
      http://uptime.thermogenesis {
        reverse_proxy localhost:3001
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
        tls ${subdomain_cert} ${subdomain_key}
        reverse_proxy 100.64.0.2:8029
      }
      matrix.devraza.giize.com:8448 {
        tls ${subdomain_cert} ${subdomain_key}
        reverse_proxy 100.64.0.2:8029
      }
      git.devraza.giize.com {
        tls ${subdomain_cert} ${subdomain_key}
        reverse_proxy ${toString config.services.forgejo.settings.server.HTTP_ADDR}:${toString config.services.forgejo.settings.server.HTTP_PORT}
      }
      hs.devraza.giize.com {
        tls ${subdomain_cert} ${subdomain_key}
        reverse_proxy localhost:7070
      }
      *.devraza.giize.com {
        redir https://devraza.giize.com
      }
    '';
  };
}
