<!-- vim: set fenc=utf-8 ts=2 sw=0 sts=0 sr et si tw=0 fdm=marker fmr={{{,}}}: -->
# hyprland-rice
These are the configuration files for all of the programs I am going to use inside Hyprland, a Wayland compositor.

## Dependencies (in Arch Linux package names)
`hyprland-git xdg-desktop-portal-hyprland-git hy3-git xwaylandvideobridge-cursor-mode-2-git swaylock-effects blueman networkmanager-dmenu-git nwg-look qt5ct qt6ct libcanberra brightnessctl dunst kitty fuzzel hyprpaper grimblast-git grim slurp hyprpicker wl-clipboard swayidle waybar-git nwg-dock-hyprland nwg-drawer nwg-bar swayosd-git`

## Installation
This Git repo contains `dotconfig` and `dotlocal`. These correspond to `~/.config` and `~/.local` respectively. So, you can go two ways about 'installing' these.

Firstly, clone the repo:
```bash
cd /path/to/clone/folder/
git clone https://github.com/Andy3153/hyprland-rice/
```

(replace `/path/to/clone/folder/` with the folder you want to clone the Git repo inside. Your choice, could be your Home directory)

Then, follow either of these methods:

- Symlinks (you need to keep the cloned folder)
```bash
ln -s /path/to/clone/folder/hyprland-rice/dotconfig/* ~/.config
ln -s /path/to/clone/folder/hyprland-rice/dotlocal/* ~/.local
```

- Copying
```bash
cd hyprland-rice/
cp -r dotconfig/* ~/.config
cp -r dotlocal/* ~/.local
cd ..
rm -rf hyprland-rice/ # feel free to delete the folder
```

## Other dotfiles of mine
- [Zsh config](https://github.com/Andy3153/andy3153-zshrc)
- [Neovim config](https://github.com/Andy3153/andy3153-init.lua)
- [Sway rice](https://github.com/Andy3153/sway-rice)

## Contributing
Feel free to give me advice on this, or even help me with it!
