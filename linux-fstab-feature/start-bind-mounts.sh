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
  "/feature/userdata/dot.var.app:$HOME_PATH/.var/app"
  "/feature/userdata/dot.local.share.flatpak:$HOME_PATH/.local/share/flatpak"

  "/desktop:$HOME_PATH/Desktop"
  "/feature/userdata/Android:$HOME_PATH/Android"

  "/feature/userdata/dot.sdkman:$HOME_PATH/.sdkman"
  "/feature/userdata/dot.ssh:$HOME_PATH/.ssh"
  "/feature/userdata/dot.rustup:$HOME_PATH/.rustup"
  "/feature/userdata/dot.cargo:$HOME_PATH/.cargo"
  "/feature/userdata/dot.docker:$HOME_PATH/.docker"
  "/feature/userdata/dot.config.ngrok:$HOME_PATH/.config/ngrok"
  "/feature/userdata/dot.nvm:$HOME_PATH/.nvm"
  "/feature/userdata/dot.mongodb:$HOME_PATH/.mongodb"
  "/feature/userdata/dot.local.bin:$HOME_PATH/.local/bin"
  "/feature/userdata/dot.local.share.fnm:$HOME_PATH/.local/share/fnm"
  "/feature/userdata/dot.local.share.containers:$HOME_PATH/.local/share/containers"
  "/feature/userdata/dot.local.share.gnome-shell:$HOME_PATH/.local/share/gnome-shell"

  "/feature/userdata/dot.gemini:$HOME_PATH/.gemini"
  "/feature/userdata/dot.antigravity:$HOME_PATH/.antigravity"
)

echo 'Config jdk: https://jdk.java.net/26/ OR use sdkman curl -s "https://get.sdkman.io" | bash'

for m in "${mounts[@]}"; do
  src="${m%%:*}"
  dst="${m##*:}"

  sudo mkdir -p "$src" "$dst"

  if ! mountpoint -q "$dst"; then
    sudo mount --bind "$src" "$dst"
  fi
done
