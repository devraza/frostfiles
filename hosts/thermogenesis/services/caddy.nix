{ config, ... }:
let
  domain_cert = "/etc/certs/fullchain.pem";
  domain_key = "/etc/certs/privkey.pem";
  permafrost_cert = "/etc/certs/permafrost/permafrost.gleeze.com.crt";
  permafrost_key = "/etc/certs/permafrost/permafrost.gleeze.com.key";
in {
  # Caddy as a reverse proxy
  services.caddy = {
    enable = true;
  };
}
