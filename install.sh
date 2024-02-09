#!/bin/bash

install_packages() {
    local packages=(
        "adwaita-icon-theme"
        "alacritty"
        "alsa-tools"
        "alsa-topology-conf"
        "alsa-ucm-conf"
        "alsa-utils"
        "cmake"
        "curl"
        "dunst"
        "exa"
        "feh"
        "flameshot"
        "ffmpeg"
        "firefox-esr"
        "firmware-amd-graphics"
        "firmware-linux-free"
        "firmware-linux-nonfree"
        "firmware-misc-nonfree"
        "firmware-realtek"
        "fonts-dejavu-core"
        "fonts-droid-fallback"
        "fonts-freefont-ttf"
        "fonts-liberation"
        "fonts-mathjax"
        "fonts-noto-mono"
        "fonts-quicksand"
        "fonts-urw-base35"
        "fuse"
        "fuse3"
        "htop"
        "git"
        "git-man"
        "gettext"
        "kitty"
        "libghc-xmonad-contrib-dev"
        "libghc-xmonad-contrib-doc"
        "libghc-xmonad-dev"
        "libghc-xmonad-doc"
        "lightdm"
        "lightdm-gtk-greeter"
        "lxappearance"
        "lxde-icon-theme"
        "lxde-settings-daemon"
        "man-db"
        "manpages"
        "manpages-dev"
        "materia-gtk-theme"
        "moc"
        "mpv"
        "nano"
        "nala"
        "neofetch"
        "network-manager-gnome"
        "ninja-build"
        "openssh-client"
        "openssh-server"
        "openssh-sftp-server"
        "openssl"
        "packer"
        "pamixer"
        "pavucontrol"
        "pcmanfm"
        "picom"
        "pip"
        "pipx"
        "pulseaudio"
        "pulseaudio-utils"
        "python3"
        "python3-selenium"
        "python3-pandas"
        "qbittorrent"
        "ranger"
        "rofi"
        "rsync"
        "rclone"
        "suckless-tools"
        "unzip"
        "vim"
        "vlc"
        "w3m"
        "w3m-img"
        "wget"
        "x11-common"
        "x11-utils"
        "x11-xkb-utils"
        "x11-xserver-utils"
        "x11proto-dev"
        "xauth"
        "xclip"
        "xdg-user-dirs"
        "xdg-utils"
        "xdotool"
        "xfce4-power-manager"
        "xfce4-power-manager-data"
        "xfce4-power-manager-plugins"
        "xmobar"
        "xmonad"
        "xserver-common"
        "xserver-xorg"
        "xserver-xorg-core"
        "xserver-xorg-input-all"
        "xserver-xorg-input-libinput"
        "xserver-xorg-input-wacom"
        "xserver-xorg-legacy"
        "xserver-xorg-video-all"
        "xserver-xorg-video-amdgpu"
        "xserver-xorg-video-ati"
        "xserver-xorg-video-fbdev"
        "xserver-xorg-video-intel"
        "xserver-xorg-video-nouveau"
        "xserver-xorg-video-qxl"
        "xserver-xorg-video-radeon"
        "xserver-xorg-video-vesa"
        "xserver-xorg-video-vmware"
        "zsh"
        "zsh-autosuggestions"
        "zsh-common"
    )

    for pkg in "${packages[@]}"; do
        sudo apt install -y "$pkg"
    done
}

enable_lightdm() {
    sudo systemctl enable lightdm
}

configure_touchpad() {
    sudo tee /etc/X11/xorg.conf.d/40-libinput.conf > /dev/null <<EOF
Section "InputClass"
    Identifier "touchpad catchall"
    Driver "libinput"
    Option "Tapping" "on"
EndSection
EOF
}

reduce_tearing() {
    sudo tee /etc/X11/xorg.conf.d/20-intel.conf > /dev/null <<EOF
Section "Device"
    Identifier    "Intel Graphics"
    Driver        "intel"
    Option        "TearFree"  "true"
EndSection
EOF
}

download_dotfiles() {
    local DOTFILES_REPO="https://github.com/owlsly94/dotfiles.git"
    local TARGET_DIR="$HOME/"
    local temp_dir=$(mktemp -d)

    git clone "$DOTFILES_REPO" "$temp_dir"
    mv "$temp_dir"/* "$TARGET_DIR"
    rm -r "$temp_dir"

    echo "Dotfiles have been downloaded and moved to $TARGET_DIR"
}

add_aliases() {
    local ZSHRC_FILE="$HOME/.zshrc"
    
    echo -e "\n# Aliases\n" >> "$ZSHRC_FILE"
    echo 'alias v="nvim"' >> "$ZSHRC_FILE"
    echo 'alias lss="exa --icons --all"' >> "$ZSHRC_FILE"

    echo "Aliases added to $ZSHRC_FILE"
}

install_iosevka_font() {
    local iosevka_url="https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/Iosevka.zip"
    local font_directory="/usr/local/share/fonts/iosevka-font"
    local temp_dir="/tmp/iosevka_temp"

    mkdir -p "$temp_dir"
    wget -O "$temp_dir/Iosevka.zip" "$iosevka_url"
    unzip "$temp_dir/Iosevka.zip" -d "$temp_dir"
    sudo mkdir -p "$font_directory"
    sudo mv "$temp_dir"/*.ttf "$font_directory"
    sudo fc-cache -fv
    rm -rf "$temp_dir"
    
    echo "Iosevka Nerd Font installed!"
}

install_neovim() {
  if command -v python3 &> /dev/null; then
    python3 $HOME/debian/nvim.py
  else
    sudo apt install python3
    python3 $HOME/debian/nvim.py
  fi  

  echo "Neovim installed!"
}

recompile_xmonad() {
    cd $HOME/.config/xmonad/
    xmonad --recompile && xmonad --restart
    
    echo "XMonad recompiled and ready to use!"
}

# Main script
install_packages
enable_lightdm
configure_touchpad
reduce_tearing
download_dotfiles
add_aliases
install_iosevka_font
install_neovim
recompile_xmonad

