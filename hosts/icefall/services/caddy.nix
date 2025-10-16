{ config, ... }:
let
  # Keys for tailnet
  permafrost_cert = "/var/lib/acme/permafrost.gleeze.com/fullchain.pem";
  permafrost_key = "/var/lib/acme/permafrost.gleeze.com/key.pem";
  subdomain_permafrost_cert = "/var/lib/acme/subdomains-permafrost/fullchain.pem";
  subdomain_permafrost_key = "/var/lib/acme/subdomains-permafrost/key.pem";

  # Keys for public website
  subdomain_cert = "/var/lib/acme/subdomains/fullchain.pem";
  subdomain_key = "/var/lib/acme/subdomains/key.pem";
  domain_cert = "/var/lib/acme/devraza.giize.com/fullchain.pem";
  domain_key = "/var/lib/acme/devraza.giize.com/key.pem";
in
{
  # Caddy as a reverse proxy
  services.caddy = {
    enable = true;
    extraConfig = ''
      git.devraza.giize.com {
        tls ${subdomain_cert} ${subdomain_key}
        reverse_proxy ${toString config.services.forgejo.settings.server.HTTP_ADDR}:${toString config.services.forgejo.settings.server.HTTP_PORT}
        header {
          X-Frame-Options DENY
          X-Content-Type-Options nosniff
        }
      }
      todo.devraza.giize.com {
        tls ${subdomain_cert} ${subdomain_key}
        reverse_proxy ${toString config.services.vikunja.settings.service.interface}
      }
      nixle.devraza.giize.com {
        tls ${subdomain_cert} ${subdomain_key}
  
        root * /var/lib/nixle
        encode zstd gzip
        file_server
      }
      atiran.giize.com {
        tls /var/lib/acme/atiran.giize.com/fullchain.pem /var/lib/acme/atiran.giize.com/key.pem

        header {
          X-Frame-Options DENY
          X-Content-Type-Options nosniff
        }

        root * /var/lib/atiran
        encode zstd gzip
        file_server
      }
      devraza.giize.com {
        tls ${domain_cert} ${domain_key}
        header {
          X-Frame-Options DENY
          X-Content-Type-Options nosniff
        }
  
        root * /var/lib/website/public
        encode zstd gzip
        file_server
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
      dash.permafrost.gleeze.com {
        tls ${subdomain_permafrost_cert} ${subdomain_permafrost_key}
        reverse_proxy 127.0.0.1:8082
      }
    '';
  };
}
