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
      icefall.devraza.devraza.duckdns.org {
        reverse_proxy 127.0.0.1:5006
      }

      devraza.duckdns.org {
        tls ${domain_cert} ${domain_key}
        root * /var/lib/website/public
	      header /.well-known/matrix/\* Content-Type application/json
	      header /.well-known/matrix/\* Access-Control-Allow-Origin *
	      respond /.well-known/matrix/server `{"m.server": "https://matrix.devraza.duckdns.org:443"}`
	      respond /.well-known/matrix/client `{"m.homeserver":{"base_url":"https://matrix.devraza.duckdns.org"},"m.identity_server":{"base_url":"https://vector.im"}}`
        file_server
      }
      matrix.devraza.duckdns.org {
        tls ${subdomain_cert} ${subdomain_key}
        reverse_proxy localhost:8029
      }
      matrix.devraza.duckdns.org:8448 {
        tls ${subdomain_cert} ${subdomain_key}
        reverse_proxy /_matrix/* localhost:8029
      }
      git.devraza.duckdns.org {
        tls ${subdomain_cert} ${subdomain_key}
        reverse_proxy ${toString config.services.gitea.settings.server.HTTP_ADDR}:${toString config.services.gitea.settings.server.HTTP_PORT}
      }
      headscale.devraza.duckdns.org {
        tls ${subdomain_cert} ${subdomain_key}
        reverse_proxy localhost:${toString config.services.headscale.port}
      }
      vault.devraza.duckdns.org {
        tls ${subdomain_cert} ${subdomain_key}
        reverse_proxy localhost:9493
      }
    '';
  };


}
