#!/bin/bash
set -e # Exit immediately if any command fails

function check_php_installed() {
    if ! command -v php >/dev/null 2>&1; then
        install_php
    else
        echo -e "\e[32mPHP is already installed. Version: $(php -v | head -n 1)\e[0m"
    fi
}

function install_composer() {
    echo -e "Installing \e[36mComposer\e[0m"

    # Check if PHP is installed first
    check_php_installed

    # Install Composer (if not already installed)
    if ! command -v composer >/dev/null 2>&1; then
        echo "Composer is not installed. Installing..."
        if [[ "$(uname)" == "Darwin" ]]; then
            brew install composer
        elif [[ "$(expr substr $(uname -s) 1 5)" == "Linux" ]]; then
            EXPECTED_CHECKSUM="$(php -r 'copy("https://composer.github.io/installer.sig", "php://stdout");')"
            php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
            ACTUAL_CHECKSUM="$(php -r "echo hash_file('sha384', 'composer-setup.php');")"

            if [ "$EXPECTED_CHECKSUM" != "$ACTUAL_CHECKSUM" ]; then
                >&2 echo -e "\e[31mERROR: Invalid installer checksum\e[0m"
                rm composer-setup.php
                exit 1
            fi

            php composer-setup.php --quiet
            RESULT=$?
            rm composer-setup.php
            exit $RESULT
        fi
    else
        echo -e "\e[32mComposer is already installed. Version: $(composer --version | head -n 1)\e[0m"
    fi
}

function install_php() {
    echo -e "Installing \e[36mPHP\e[0m"

    if [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS installation
        if command -v brew >/dev/null 2>&1; then
            brew install php
        else
            echo -e "\e[31mHomebrew is not installed. Please install Homebrew first: https://brew.sh/\e[0m"
            exit 1
        fi
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        # Linux installation
        if command -v apt >/dev/null 2>&1; then
            sudo apt update && sudo apt install -y php
        elif command -v yum >/dev/null 2>&1; then
            sudo yum install -y php
        elif command -v dnf >/dev/null 2>&1; then
            sudo dnf install -y php
        else
            echo -e "\e[31mNo supported package manager found. Install PHP manually.\e[0m"
            exit 1
        fi
    else
        echo -e "\e[31mUnsupported OS. Please install PHP manually.\e[0m"
        exit 1
    fi

    # Verify PHP installation
    if command -v php >/dev/null 2>&1; then
        echo -e "\e[32mPHP successfully installed. Version: $(php -v | head -n 1)\e[0m"
    else
        echo -e "\e[31mPHP installation failed. Please check logs.\e[0m"
        exit 1
    fi
}

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
        curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
    fi
}

function install_zsh() {
    echo -e "Installing \e[36mZSH\e[0m"

    # Install ZSH (if not already installed)
    if [ -z "$(command -v zsh)" ]; then
        echo "ZSH is not installed. Installing..."
        if [ "$(uname)" == "Darwin" ]; then
            brew install zsh
            chsh -s $(which zsh)
        elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
            sudo apt-get install zsh -y
            chsh -s $(which zsh)
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
    install_composer
}