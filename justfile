#!/usr/bin/env just --justfile

# Deploy to current machine
rebuild:
  sudo nixos-rebuild switch --no-reexec

# Upgrade where applicable
upgrade:
  sudo nixos-rebuild switch --no-reexec --upgrade

# Remove all garbage
clean:
  sudo nix-collect-garbage -d
  nix-collect-garbage -d
