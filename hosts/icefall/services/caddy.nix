{ config, ... }:
let
  domain_cert = "/var/lib/acme/devraza.giize.com/fullchain.pem";
  domain_key = "/var/lib/acme/devraza.giize.com/key.pem";
  subdomain_cert = "/var/lib/acme/subdomains/fullchain.pem";
  subdomain_key = "/var/lib/acme/subdomains/key.pem";

  permafrost_cert = "/var/lib/acme/permafrost.gleeze.com/fullchain.pem";
  permafrost_key = "/var/lib/acme/permafrost.gleeze.com/key.pem";
  subdomain_permafrost_cert = "/var/lib/acme/subdomains-permafrost/fullchain.pem";
  subdomain_permafrost_key = "/var/lib/acme/subdomains-permafrost/key.pem";
in {
  # Caddy as a reverse proxy
  services.caddy = {
    enable = true;
    extraConfig = ''
      iv.permafrost.gleeze.com {
        tls ${subdomain_permafrost_cert} ${subdomain_permafrost_key}
        reverse_proxy 127.0.0.1:4202
      }
      http://redlib.icefall {
        reverse_proxy 127.0.0.1:9080
      }
      http://scrutiny.icefall {
        reverse_proxy 127.0.0.1:9070
      }
      http://paperless.icefall {
        reverse_proxy 127.0.0.1:10000
      }
      vault.subdomain_permafrost.gleeze.com {
        tls ${subdomain_permafrost_cert} ${subdomain_permafrost_key}
        reverse_proxy localhost:9493 {
          header_up X-Real-IP {remote_host}
        }
      }
      actual.subdomain_permafrost.gleeze.com {
        tls ${subdomain_permafrost_cert} ${subdomain_permafrost_key}
        reverse_proxy 127.0.0.1:5006
      }
      http://miniflux.icefall {
        reverse_proxy 127.0.0.1:9050
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
    '';
  };
}
