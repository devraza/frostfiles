#!/usr/bin/env just --justfile

# Deploy to current machine
rebuild:
  sudo nixos-rebuild switch --fast

# Upgrade where applicable
upgrade:
  sudo nixos-rebuild switch --fast --upgrade

# Remove all garbage
clean:
  sudo nix-collect-garbage -d
  nix-collect-garbage -d
