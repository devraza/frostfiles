#!/usr/bin/env just --justfile

# Deploy to current machine
rebuild:
  sudo nixos-rebuild switch --fast

# Remove all garbage
clean:
  sudo nix-collect-garbage -d && nix-collect-garbage -d
