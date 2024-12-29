{ config, ... }:
let
  domain_cert = "/var/lib/acme/devraza.giize.com/fullchain.pem";
  domain_key = "/var/lib/acme/devraza.giize.com/key.pem";
  subdomain_cert = "/var/lib/acme/subdomains/fullchain.pem";
  subdomain_key = "/var/lib/acme/subdomains/key.pem";
in
{
  # Caddy as a reverse proxy
  services.caddy = {
    enable = true;
    extraConfig = ''
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
            git.devraza.giize.com {
              tls ${subdomain_cert} ${subdomain_key}
              reverse_proxy ${toString config.services.forgejo.settings.server.HTTP_ADDR}:${toString config.services.forgejo.settings.server.HTTP_PORT}
              header {
                X-Frame-Options DENY
                X-Content-Type-Options nosniff
              }
            }
            hs.devraza.giize.com {
              tls ${subdomain_cert} ${subdomain_key}
              reverse_proxy localhost:7070
              header {
                X-Frame-Options DENY
                X-Content-Type-Options nosniff
              }
            }
            todo.devraza.giize.com {
              tls ${subdomain_cert} ${subdomain_key}
              reverse_proxy localhost:3456
            }
            *.devraza.giize.com {
              redir https://devraza.giize.com
            }
    '';
  };
}
