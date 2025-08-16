# frostfiles

This is the repository hosting my personal NixOS configuration. My personal desktop environment is built upon Hyprland (boring, I know) and utilises a large variety of related and unrelated programs to make it feature-complete; these are installed and configured via home-manager.

> **Note** I use Nix flakes to manage my configuration since it makes a lot of things easier. If you're new to Nix and/or pained by flakes, just know that [flakes aren't real and can't hurt you](https://jade.fyi/blog/flakes-arent-real/).

## Directory structure

- `home` contains all home-manager configuration options
- `assets` contains content such as images (including wallpapers)
- `hosts` contains per-machine configuration

> **Note** Workstation configuration, which applies to desktops and laptops, is within [`workstations.nix`](./workstations.nix). Almost everything is consistent across my workstations, which is there isn't much in any specific system's hardware configuration.

## Commit style
Commits are generally formatted with the [conventional commits specification](https://www.conventionalcommits.org/en/v1.0.0/):
```
<type>[machine/scope]: <description>
```
Where `type` is usually one of `feat`, `docs`, `hotfix`, `chore`, `refactor`, or `flake` (for flake-related operations).

## License
Everything within this repository, with the exception of the content within [`assets`](./assets), at this moment or previously, licensed under the [Mozilla Public License 2.0](./LICENSE.md).
