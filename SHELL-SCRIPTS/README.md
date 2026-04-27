# SHELL SCRIPTS

- Bash Autosuggestions

```shell
 curl -fsSL https://manhavn.github.io/SHELL-SCRIPTS/install-bash-autosuggestions.sh | bash
```

- Zsh Autosuggestions

```shell
 curl -fsSL https://manhavn.github.io/SHELL-SCRIPTS/install-zsh-autosuggestions.sh | bash
```

- Allow SSH root login

```shell
 sudo -i
 passwd root
 #[sudo] password for linuxconfig:
 #Enter new UNIX password:
 #Retype new UNIX password:
 #passwd: password updated successfully
 #sudo sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
 #sudo service ssh restart

 echo "PermitRootLogin yes" | tee /etc/ssh/sshd_config.d/allow-root-login.conf
 echo "PermitRootLogin yes" | sudo tee /etc/ssh/sshd_config.d/allow-root-login.conf
 sudo service ssh restart
```

- Create VPN (server): wireguard.sh

```shell
 curl -fsSL https://manhavn.github.io/SHELL-SCRIPTS/wireguard.sh | bash
```

- Connect VPN (local): wireguard-use.sh
- https://www.wireguard.com/install/
- https://play.google.com/store/apps/details?id=com.wireguard.android
- https://apps.apple.com/us/app/wireguard/id1451685025

```shell
 wget https://manhavn.github.io/SHELL-SCRIPTS/wireguard-use.sh
 sh wireguard-use.sh
```

- RAM: swapfile-init.sh `+2G`

```shell
 curl -fsSL https://manhavn.github.io/SHELL-SCRIPTS/swapfile-init.sh | bash
```

