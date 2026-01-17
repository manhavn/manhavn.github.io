	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
	eval "$(/usr/local/bin/brew shellenv)"

	brew install pyenv
	brew install readline xz
	pyenv init
	pyenv global
	pyenv install -l
	pyenv install 2.7.18
	pyenv install 3.12.4
	pyenv global 3.12.4
	python --version

	curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
	\. "$HOME/.nvm/nvm.sh"
	nvm install 22
	nvm install 20
	nvm install 18
	nvm install 16
	nvm install 14
	nvm list
	nvm alias default 22
	nvm use 22
	nvm current
	node -v

	brew install go
	brew install node
	brew install wget
	brew install wakeonlan
	brew install lazydocker
	brew install golangci-lint

	brew install --cask goland
	brew install --cask mongodb-compass
	brew install --cask webstorm
	brew install --cask jetbrains-gateway
	brew install --cask firefox
	brew install --cask visual-studio-code
	brew install --cask google-chrome
	brew install --cask clipy
	brew install --cask onlyoffice
	brew install --cask orbstack
	brew install --cask sublime-merge
	brew install --cask sublime-merge
	brew install --cask telegram
	brew install --cask sublime-text
	brew install --cask sublime-text
	brew install --cask google-cloud-sdk
	brew install --cask utm
	brew update; brew upgrade; brew outdated; brew cleanup
	brew list

	sh -c "$(wget https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)"
	search=plugins=\(git\)
	replace=plugins=\(zsh-autosuggestions\)
	filename=~/.zshrc
	sed -i "s/$search/$replace/" $filename
	sed -i "" "s/$search/$replace/" $filename
	git clone https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions

	sudo chown root ~/.zsh_history
	sudo chmod 644 ~/.zsh_history
