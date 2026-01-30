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
        reverse_proxy 127.0.0.1:1426
        header {
          X-Frame-Options DENY
          X-Content-Type-Options nosniff
        }
      }
      todo.devraza.giize.com {
        tls ${subdomain_cert} ${subdomain_key}
        reverse_proxy ${toString config.services.vikunja.settings.service.interface}
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
      vault.permafrost.gleeze.com {
        tls ${subdomain_permafrost_cert} ${subdomain_permafrost_key}
        reverse_proxy localhost:9493 {
          header_up X-Real-IP {remote_host}
        }
      }
      panel.permafrost.gleeze.com {
        tls ${subdomain_permafrost_cert} ${subdomain_permafrost_key}
        reverse_proxy 127.0.0.1:9291
      }
      calibre.permafrost.gleeze.com {
        tls ${subdomain_permafrost_cert} ${subdomain_permafrost_key}
        reverse_proxy 127.0.0.1:7074
      }
      dash.permafrost.gleeze.com {
        tls ${subdomain_permafrost_cert} ${subdomain_permafrost_key}
        reverse_proxy 127.0.0.1:8082
      }
      rl.permafrost.gleeze.com {
        tls ${subdomain_permafrost_cert} ${subdomain_permafrost_key}
        reverse_proxy 127.0.0.1:8080
      }
      navi.permafrost.gleeze.com {
        tls ${subdomain_permafrost_cert} ${subdomain_permafrost_key}
        reverse_proxy 127.0.0.1:4533
      }
      feishin.permafrost.gleeze.com {
        tls ${subdomain_permafrost_cert} ${subdomain_permafrost_key}
        reverse_proxy 127.0.0.1:9180
      }
    '';
  };
}
