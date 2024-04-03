function install_homebrew() {
    echo -e "Installing \e[36mHomebrew\e[0m"

    # Install Homebrew (if not already installed)
    if [ -z "$(command -v brew)" ]; then
        echo "Homebrew is not installed. Installing..."
        NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi
}

function install_nvm() {
    # Install NVM (if not already installed)
    if [ ! -d "$HOME/.nvm" ]; then
        echo "NVM is not installed. Installing..."
        curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
    fi
}

function install_zsh() {
    echo -e "Installing \e[36mZSH\e[0m"

    # Install ZSH (if not already installed)
    if [ -z "$(command -v zsh)" ]; then
        echo "ZSH is not installed. Installing..."
        if [ "$(uname)" == "Darwin" ]; then
            brew install zsh
        elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
            sudo apt-get install zsh
        fi
    fi

    # Install Oh My Zsh (if not already installed)
    if [ ! -d "$HOME/.oh-my-zsh" ]; then
        echo "Oh My Zsh is not installed. Installing..."
        sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    fi

    # Install Spaceship Prompt (if not already installed)
    if [ ! -d "$ZSH_CUSTOM/themes/spaceship-prompt" ]; then
        echo "Spaceship Prompt is not installed. Installing..."
        git clone https://github.com/spaceship-prompt/spaceship-prompt.git "$ZSH_CUSTOM/themes/spaceship-prompt" --depth=1
        ln -s "$ZSH_CUSTOM/themes/spaceship-prompt/spaceship.zsh-theme" "$ZSH_CUSTOM/themes/spaceship.zsh-theme"
    fi

    cp .zsh_aliases $HOME/.zsh_aliases
    cp .zsh_functions $HOME/.zsh_functions
    cp .zshrc $HOME/.zshrc

    # Set ZSH as the default shell
    chsh -s $(which zsh)
}

function install_zsh_extras() {
    if [ "$(uname)" == "Darwin" ]; then
        echo -e "Installing \e[36mZSH Extras\e[0m"

        # Install ZSH Syntax Highlighting
        if [ ! -d "/opt/homebrew/share/zsh-syntax-highlighting" ]; then
            echo "ZSH Syntax Highlighting is not installed. Installing..."
            brew install zsh-syntax-highlighting
            echo "source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >> $HOME/.zshrc
            echo "export ZSH_HIGHLIGHT_HIGHLIGHTERS_DIR=/opt/homebrew/share/zsh-syntax-highlighting/highlighters" >> $HOME/.zshrc
        fi

        # Install ZSH Autosuggestions
        if [ ! -d "/opt/homebrew/share/zsh-autosuggestions" ]; then
            echo "ZSH Autosuggestions is not installed. Installing..."
            brew install zsh-autosuggestions
            echo "source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh" >> $HOME/.zshrc
        fi

        # Install ZSH Autocomplete
        if [ ! -d "/opt/homebrew/share/zsh-autocomplete" ]; then
            echo "ZSH Autocomplete is not installed. Installing..."
            brew install zsh-autocomplete
            echo "source /opt/homebrew/share/zsh-autocomplete/zsh-autocomplete.plugin.zsh" >> $HOME/.zshrc
        fi
    fi
}

function install() {
    echo "Installing dependencies..."

    install_homebrew
    install_nvm
    install_zsh
    install_zsh_plugins
}