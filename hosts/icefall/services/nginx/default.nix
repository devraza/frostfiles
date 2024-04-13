{ config, ... }:
let
  subdomain_cert = "/etc/nginx/subdomains/fullchain.pem";
  subdomain_key = "/etc/nginx/subdomains/privkey.pem";
  domain_cert = "/etc/nginx/fullchain.pem";
  domain_key = "/etc/nginx/privkey.pem";
in {
  # Nginx configuration
  services.nginx = {
    enable = true;
    clientMaxBodySize = "128M";
    # Virtual hosts
    virtualHosts = {
      "git" = {
        forceSSL = true;
        serverName = "git.devraza.duckdns.org";
        sslCertificate = subdomain_cert;
        sslCertificateKey = subdomain_key;
        # Gitea proxy
        locations."/" = {
          proxyPass = "http://${toString config.services.gitea.settings.server.HTTP_ADDR}:${toString config.services.gitea.settings.server.HTTP_PORT}/";
          proxyWebsockets = true;
          recommendedProxySettings = true;
        };
      };
      "website" = {
        forceSSL = true;
        serverName = "devraza.duckdns.org";
        sslCertificate = domain_cert;
        sslCertificateKey = domain_key;
        root = "/var/lib/website/public";
        locations."= /.well-known/matrix/server".extraConfig =
          let
            server = { "m.server" = "matrix.devraza.duckdns.org:443"; };
          in ''
            add_header Content-Type application/json;
            return 200 '${builtins.toJSON server}';
          '';
        locations."= /.well-known/matrix/client".extraConfig =
          let
            client = {
              "m.homeserver" =  { "base_url" = "https://matrix.devraza.duckdns.org"; };
              "m.identity_server" =  { "base_url" = "https://vector.im"; };
            };
          in ''
            add_header Content-Type application/json;
            add_header Access-Control-Allow-Origin *;
            return 200 '${builtins.toJSON client}';
          '';
      };
      "matrix" = {
        forceSSL = true;
        serverName = "matrix.devraza.duckdns.org";
        sslCertificate = subdomain_cert;
        sslCertificateKey = subdomain_key;
        # Conduit proxy
        locations."/" = {
          proxyPass = "http://127.0.0.1:8029";
          proxyWebsockets = true;
          recommendedProxySettings = true;
        };
        extraConfig = ''
          listen 8448 ssl http2 default_server;
          listen [::]:8448 ssl http2 default_server;
        '';
      };
      "headscale" = {
        forceSSL = true;
        serverName = "headscale.devraza.duckdns.org";
        sslCertificate = subdomain_cert;
        sslCertificateKey = subdomain_key;
        # Headscale proxy
        locations."/" = {
          proxyPass = "http://127.0.0.1:${toString config.services.headscale.port}";
          proxyWebsockets = true;
          recommendedProxySettings = true;
        };
      };
      "actual" = {
        forceSSL = true;
        serverName = "actual.devraza.duckdns.org";
        sslCertificate = subdomain_cert;
        sslCertificateKey = subdomain_key;
        # Actual budget proxy
        locations."/" = {
          proxyPass = "http://127.0.0.1:5006";
          proxyWebsockets = true;
          recommendedProxySettings = true;
        };
      };
      "vaultwarden" = {
        forceSSL = true;
        serverName = "vault.devraza.duckdns.org";
        sslCertificate = subdomain_cert;
        sslCertificateKey = subdomain_key;
        # Vaultwarden proxy
        locations."/" = {
          proxyPass = "http://127.0.0.1:9493";
          proxyWebsockets = true;
          recommendedProxySettings = true;
        };
      };
    };
    appendHttpConfig = ''
      limit_req_zone $binary_remote_addr zone=one:10m rate=1r/s;
    '';
  };


}
