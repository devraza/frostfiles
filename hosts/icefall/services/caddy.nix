{ config, ... }:
let
  permafrost_cert = "/var/lib/acme/permafrost.gleeze.com/fullchain.pem";
  permafrost_key = "/var/lib/acme/permafrost.gleeze.com/key.pem";
  subdomain_permafrost_cert = "/var/lib/acme/subdomains-permafrost/fullchain.pem";
  subdomain_permafrost_key = "/var/lib/acme/subdomains-permafrost/key.pem";
in
{
  # Caddy as a reverse proxy
  services.caddy = {
    enable = true;
    extraConfig = ''
      iv.permafrost.gleeze.com {
        tls ${subdomain_permafrost_cert} ${subdomain_permafrost_key}
        reverse_proxy 127.0.0.1:4202
      }
      uptime.permafrost.gleeze.com {
        tls ${subdomain_permafrost_cert} ${subdomain_permafrost_key}
        reverse_proxy thermogenesis:3001
      }
      redlib.permafrost.gleeze.com {
        tls ${subdomain_permafrost_cert} ${subdomain_permafrost_key}
        reverse_proxy thermogenesis:9080
      }
      scrutiny.permafrost.gleeze.com {
        tls ${subdomain_permafrost_cert} ${subdomain_permafrost_key}
        reverse_proxy 127.0.0.1:9070
      }
      paperless.permafrost.gleeze.com {
        tls ${subdomain_permafrost_cert} ${subdomain_permafrost_key}
        reverse_proxy 127.0.0.1:10000
      }
      vault.permafrost.gleeze.com {
        tls ${subdomain_permafrost_cert} ${subdomain_permafrost_key}
        reverse_proxy localhost:9493 {
          header_up X-Real-IP {remote_host}
        }
      }
      actual.permafrost.gleeze.com {
        tls ${subdomain_permafrost_cert} ${subdomain_permafrost_key}
        reverse_proxy 127.0.0.1:5006
      }
      miniflux.permafrost.gleeze.com {
        tls ${subdomain_permafrost_cert} ${subdomain_permafrost_key}
        reverse_proxy 127.0.0.1:9050
      }
      linkwarden.permafrost.gleeze.com {
        tls ${subdomain_permafrost_cert} ${subdomain_permafrost_key}
        reverse_proxy 127.0.0.1:9040
      }
      media.permafrost.gleeze.com {
        tls ${subdomain_permafrost_cert} ${subdomain_permafrost_key}
        reverse_proxy 127.0.0.1:8096
      }
      search.permafrost.gleeze.com {
        tls ${subdomain_permafrost_cert} ${subdomain_permafrost_key}
        reverse_proxy 127.0.0.1:8888
      }
      torrent.permafrost.gleeze.com {
        tls ${subdomain_permafrost_cert} ${subdomain_permafrost_key}
        reverse_proxy 127.0.0.1:8080
      }
      panel.permafrost.gleeze.com {
        tls ${subdomain_permafrost_cert} ${subdomain_permafrost_key}
        reverse_proxy 127.0.0.1:9291
      }
      sonarr.permafrost.gleeze.com {
        tls ${subdomain_permafrost_cert} ${subdomain_permafrost_key}
        reverse_proxy 127.0.0.1:8989
      }
      grafana.permafrost.gleeze.com {
        tls ${subdomain_permafrost_cert} ${subdomain_permafrost_key}
        reverse_proxy 127.0.0.1:3000
      }
      todo.permafrost.gleeze.com {
        tls ${subdomain_permafrost_cert} ${subdomain_permafrost_key}
        reverse_proxy 127.0.0.1:3456
      }
      calibre.permafrost.gleeze.com {
        tls ${subdomain_permafrost_cert} ${subdomain_permafrost_key}
        reverse_proxy 127.0.0.1:7074
      }
      kiwix.permafrost.gleeze.com {
        tls ${subdomain_permafrost_cert} ${subdomain_permafrost_key}
        reverse_proxy 127.0.0.1:3920
      }
      dash.permafrost.gleeze.com {
        tls ${subdomain_permafrost_cert} ${subdomain_permafrost_key}
        reverse_proxy 127.0.0.1:8082
      }
    '';
  };
}
