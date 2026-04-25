#!/bin/bash
echo 'cd '"$(dirname "$0")"
cd "$(dirname "$0")"

apt install sudo -y
sudo apt install zsh git wget -y
brew install zsh zsh-completions git wget

touch ~/.zshrc
rm -rf ~/.oh-my-zsh

sh -c "$(wget https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)"
search=plugins=\(git\)
replace=plugins=\(zsh-autosuggestions\)
filename=~/.zshrc
sed -i "s/$search/$replace/" $filename
git clone https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
