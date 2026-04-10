#!/bin/bash
cd "$(dirname "$0")"

 sudo mkdir -p /feature /desktop
 sudo chown $USER:$USER /feature /desktop

 echo "$USER ALL=(ALL) NOPASSWD: /feature/start-bind-mounts.sh" | sudo tee /etc/sudoers.d/start-bind-mounts-$USER-nopasswd
 sudo chmod +x /feature/start-bind-mounts.sh
 bash /feature/start-bind-mounts.sh -p "$HOME"
 sudo chown -R $USER:$USER /feature/userdata.* "$HOME/Desktop"
 sudo chown -R root:root var.lib.flatpak

 # .profile
 # sudo "/feature/start-bind-mounts.sh" -p "$HOME"
 FIND_TEXT='sudo "/feature/start-bind-mounts.sh" -p "$HOME"'
 grep -q "$FIND_TEXT" ~/.profile || echo "$FIND_TEXT" >> ~/.profile

 sudo apt update && sudo apt full-upgrade -y && sudo apt autoremove -y && sudo apt autoclean

 # snap
 sudo snap remove firefox
 sudo snap refresh; sudo snap list --all | awk '/disabled/{print $1, $3}' | while read snap revision; do echo sudo snap remove "$snap" --revision="$revision"; sudo snap remove "$snap" --revision="$revision"; done
 sudo snap install go --classic

 sudo apt install docker.io podman git curl ibus-unikey flatpak gparted gedit micro gcc libssl-dev pkg-config -y
 flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
 sudo ln -s /var/lib/flatpak/exports/share/applications /usr/local/share/
 # sudo systemctl disable docker.socket docker.service containerd.service
 sudo groupadd docker
 sudo usermod -aG docker $USER

 # docker daemon
 cat /feature/etc.docker.daemon.json | sudo tee /etc/docker/daemon.json

 # bash_history
 cat <<EOFHISTORY | sudo tee ~/.bash_history
 curl -fsSL https://code-server.dev/install.sh | sh
 # sudo systemctl enable --now code-server@\$USER
 sudo systemctl start code-server@\$USER
 cat ~/.config/code-server/config.yaml
 sudo systemctl stop code-server@\$USER

 sudo apt update && sudo apt full-upgrade -y && sudo apt autoremove -y && sudo apt autoclean
 flatpak update -y; flatpak uninstall --unused --delete-data -y; flatpak uninstall --unused; rm -rf ~/.cache/flatpak; rm -rf ~/.var/app/*/cache/*
 sudo snap refresh; sudo snap list --all | awk '/disabled/{print \$1, \$3}' | while read snap revision; do echo sudo snap remove "\$snap" --revision="\$revision"; sudo snap remove "\$snap" --revision="\$revision"; done
EOFHISTORY

 # bash_aliases
 cat <<EOFALIASES | sudo tee ~/.bash_aliases
. "\$HOME/.cargo/env"

export PATH="\$HOME/.cargo/bin:\$PATH"

export NVM_DIR="\$HOME/.nvm"
[ -s "\$NVM_DIR/nvm.sh" ] && \. "\$NVM_DIR/nvm.sh"
[ -s "\$NVM_DIR/bash_completion" ] && \. "\$NVM_DIR/bash_completion"

export FNM_PATH="\$HOME/.local/share/fnm"
if [ -d "\$FNM_PATH" ]; then
  export PATH="\$FNM_PATH:\$PATH"
  eval "\$(fnm env --shell bash)"
fi
EOFALIASES

 sudo chmod 644 ~/.bash_history ~/.bash_aliases
 sudo chown root:root ~/.bash_history ~/.bash_aliases

# sudo mkdir -p ~/.config/systemd/user
# # ~/.config/systemd/user/bind-mounts.service
# cat <<EOFSYSTEMD | sudo tee ~/.config/systemd/user/bind-mounts.service
#[Unit]
#Description=User Bind Mounts Umounts
#After=default.target
#
#[Service]
#Type=oneshot
#ExecStart=/usr/local/bin/start-bind-mounts.sh
## ExecStop=/usr/local/bin/stop-bind-mounts.sh
#RemainAfterExit=yes
#
#[Install]
#WantedBy=default.target
#EOFSYSTEMD
# sudo chmod 644 ~/.config/systemd/user/bind-mounts.service
# sudo chown $USER:$USER ~/.config/systemd/user/bind-mounts.service
# # systemctl --user enable bind-mounts.service

 # NodeJS nvm
 curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.4/install.sh | bash
 \. "$HOME/.nvm/nvm.sh"
 source ~/.bashrc
 nvm i 22
 nvm i 24
 nvm i 20
 nvm i 18
 nvm i 16
 nvm i 14
 
 nvm use 22
 npm i -g bun yarn serve @shopify/cli bestzip

 # NodeJS fnm
 curl -o- https://fnm.vercel.app/install | bash
 source ~/.bashrc
 fnm i 22
 fnm i 24
 fnm i 20
 fnm i 18
 fnm i 16
 fnm i 14
 
 fnm use 22
 npm i -g bun yarn serve @shopify/cli bestzip

 # bash autosuggestions
 bash /feature/install-bash-autosuggestions.sh

 flatpak install com.google.Chrome -y

 # rustup
 sudo apt install gcc libssl-dev pkg-config -y
 curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
 source ~/.bashrc
 cargo install cargo-generate cargo-watch trunk wasm-pack
 rustup update
 rustup toolchain install stable
 rustup component add rust-analyzer rust-src rustc-dev llvm-tools-preview
 rustup target add wasm32-unknown-unknown
 # rustup toolchain install nightly
 # rustup component add rust-analyzer rust-src rustc-dev llvm-tools-preview --toolchain nightly

 # sudo apt install gnome-shell-extension-manager -y
 # echo "Gnome Shell Extensions: Clipboard Indicator, Compact Top Bar, Gradient Top Bar"

 # sudo snap remove snap-store
 # sudo snap install snap-store
 # sudo snap install snap-store --channel=latest/stable

 # sudo snap changes
 # sudo snap abort 
 # sudo snap saved
 # sudo snap forget 

 # sudo snap disable 
 # sudo snap enable

 # flatpak install io.github.zyedidia.micro io.podman_desktop.PodmanDesktop org.gnome.Epiphany nl.hjdskes.gcolor3 org.filezillaproject.Filezilla com.getpostman.Postman io.dbeaver.DBeaverCommunity net.waterfox.waterfox org.telegram.desktop org.gimp.GIMP org.inkscape.Inkscape com.sublimemerge.App com.sublimehq.SublimeText com.visualstudio.code org.mozilla.firefox com.google.Chrome app.zen_browser.zen com.mongodb.Compass org.onlyoffice.desktopeditors com.jetbrains.RustRover com.jetbrains.WebStorm com.jetbrains.GoLand

 # flatpak install io.podman_desktop.PodmanDesktop org.virt_manager.virt-manager org.gnome.Epiphany org.adishatz.Screenshot com.cloudchewie.cloudotp io.gitlab.adhami3310.Impression com.github.tchx84.Flatseal com.belmoussaoui.Authenticator com.yubico.yubioath org.kde.krdc org.gnome.Totem nl.hjdskes.gcolor3 app.drey.Warp org.kde.falkon com.jgraph.drawio.desktop org.openshot.OpenShot sh.ppy.osu org.raspberrypi.rpi-imager dev.zed.Zed io.github.shiftey.Desktop org.filezillaproject.Filezilla org.flameshot.Flameshot com.getpostman.Postman io.dbeaver.DBeaverCommunity net.waterfox.waterfox org.kde.haruna org.remmina.Remmina us.zoom.Zoom org.sigxcpu.Livi org.gnu.emacs org.kde.kate org.telegram.desktop org.kde.krita org.fedoraproject.MediaWriter org.kde.kdenlive org.ksnip.ksnip org.gimp.GIMP org.inkscape.Inkscape com.sublimemerge.App com.sublimehq.SublimeText com.visualstudio.code org.mozilla.firefox com.google.Chrome app.zen_browser.zen com.jetbrains.DataGrip com.mongodb.Compass org.onlyoffice.desktopeditors com.google.AndroidStudio com.jetbrains.IntelliJ-IDEA-Ultimate com.jetbrains.RustRover com.jetbrains.WebStorm com.jetbrains.GoLand

