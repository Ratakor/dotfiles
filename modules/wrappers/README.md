# WE'RE GETTING RID OF HOME-MANAGER

For home I'm thinking about doing something like

- `programs/` with each program config, kinda like ~/.config
- `services/` with systemd services built with wrapper-manager
- `packages.nix` A list of all packages installed

or

- `programs/`
  - `graphical/`
    - `packages.nix`
  - `terminal/`
    - `packages.nix`
- `serivces/`

or

same as now home-manager like

---

Let's try the first one, it looks simpler and more like what I used to do on
Arch but I wonder how it will go for managing multiple computers.
