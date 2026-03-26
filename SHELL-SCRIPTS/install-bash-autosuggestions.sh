#!/bin/bash
echo 'cd '"$(dirname "$0")"
cd "$(dirname "$0")"

apt install sudo -y
sudo apt install gcc make gawk git curl -y

bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmybash/oh-my-bash/master/tools/install.sh)"
sudo rm -R ~/.ble.sh
git clone --recursive https://github.com/akinomyoga/ble.sh.git ~/.ble.sh
make -C ~/.ble.sh
source ~/.ble.sh/out/ble.sh

if [[ $(grep "~/.ble.sh/out/ble.sh" ~/.bashrc) == "source ~/.ble.sh/out/ble.sh" ]]; then
  echo "--------------------------------------------------------------"
  echo "Exists ~/.ble.sh/out/ble.sh ==> ~/.bashrc"
  echo "--------------------------------------------------------------"
else
  echo "source ~/.ble.sh/out/ble.sh" >> ~/.bashrc
fi
