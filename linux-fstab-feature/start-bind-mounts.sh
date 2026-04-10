#!/bin/bash

HOME_PATH=$HOME
while getopts "p:" opt; do
  case $opt in
    p) HOME_PATH="$OPTARG" ;;
  esac
done
echo $HOME_PATH

# .profile
# sudo "/feature/start-bind-mounts.sh" -p "$HOME"
#
# FIND_TEXT='sudo "/feature/start-bind-mounts.sh" -p "$HOME"'
# grep -q "$FIND_TEXT" ~/.profile || echo "$FIND_TEXT" >> ~/.profile

set -e

mounts=(
  "/feature/var.lib.flatpak:/var/lib/flatpak"
  "/feature/userdata.var.app:$HOME_PATH/.var/app"
  "/feature/userdata.local.share.flatpak:$HOME_PATH/.local/share/flatpak"

  "/desktop:$HOME_PATH/Desktop"

  "/feature/userdata.ssh:$HOME_PATH/.ssh"
  "/feature/userdata.rustup:$HOME_PATH/.rustup"
  "/feature/userdata.cargo:$HOME_PATH/.cargo"
  "/feature/userdata.docker:$HOME_PATH/.docker"
  "/feature/userdata.Android:$HOME_PATH/Android"
  "/feature/userdata.config.ngrok:$HOME_PATH/.config/ngrok"
  "/feature/userdata.nvm:$HOME_PATH/.nvm"
  "/feature/userdata.mongodb:$HOME_PATH/.mongodb"
  "/feature/userdata.local.bin:$HOME_PATH/.local/bin"
  "/feature/userdata.local.share.fnm:$HOME_PATH/.local/share/fnm"
  "/feature/userdata.local.share.containers:$HOME_PATH/.local/share/containers"
  "/feature/userdata.local.share.gnome-shell:$HOME_PATH/.local/share/gnome-shell"
)

for m in "${mounts[@]}"; do
  src="${m%%:*}"
  dst="${m##*:}"

  sudo mkdir -p "$src" "$dst"

  if ! mountpoint -q "$dst"; then
    sudo mount --bind "$src" "$dst"
  fi
done

