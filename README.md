# Nixify: Custom Nix and NixOS configurations
```
# 1) Get NixOS minimal ISO from GNOME Boxes or the official website
# 2) Install Virtual Machine Manager because GNOME Boxes can't do UEFI booting by default
sudo dnf install virt-manager

# 3) Create VM with UEFI boot mode and boot into the ISO

# 4) Clone the repo and start a nix-shell
git clone https://github.com/luizberti/nixify.git
cd nixify && nix-shell --command fish

# 5) Choose a configuration and install a variant
cd vaporstate                # or any other configuration
fish installer-ramdisk.fish  # or any other installer variant
```


## `vaporstate` server configuration with evaporative state
## `workstation` personal workstation for desktops and laptops

