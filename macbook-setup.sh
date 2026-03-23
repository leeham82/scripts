#!/usr/bin/env bash

echo "Starting setup..."

# 1. Install Xcode Command Line Tools if not present
if ! xcode-select -p &>/dev/null; then
    echo "Installing Xcode Command Line Tools..."
    xcode-select --install
    echo "WAIT: A popup has appeared. Please complete the installation before continuing."
    read -p "Press [Enter] once the Xcode tools are finished installing..."
fi

# 2. Install Homebrew
if ! command -v brew &> /dev/null; then
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    
    # Identify Brew path based on architecture
    if [[ $(uname -m) == "arm64" ]]; then
        BREW_PATH="/opt/homebrew/bin/brew"
    else
        BREW_PATH="/usr/local/bin/brew"
    fi

    # Load for current session
    eval "$($BREW_PATH shellenv)"

    # 3. Add Homebrew to PATH permanently in .zshrc
    if ! grep -qs "shellenv" ~/.zshrc; then
        echo "Adding Homebrew to ~/.zshrc..."
        echo "eval \"\$($BREW_PATH shellenv)\"" >> ~/.zshrc
    fi
else
    echo "Homebrew is already installed"
fi

# 4. Git Configuration
echo "--- Configuring Git ---"
read -p "Enter your full name for Git (e.g., John Doe): " GIT_NAME
read -p "Enter your email for Git: " GIT_EMAIL

git config --global user.name "${GIT_NAME:-Unknown User}"
git config --global user.email "${GIT_EMAIL:-user@example.com}"
git config --global init.defaultBranch main

# Create a global gitignore for macOS junk
touch ~/.gitignore_global
echo ".DS_Store" >> ~/.gitignore_global
git config --global core.excludesfile ~/.gitignore_global

echo "Git configured for: $(git config --global user.name)"

# 5. Install Packages
echo "--- Installing Packages ---"
brew update

FORMULAE=(git mas readline speedtest-cli tcpdump terminal-notifier tldr)
CASKS=(anydesk github google-chrome google-drive iterm2 keka rectangle vlc)

echo "Installing CLI tools..."
brew install ${FORMULAE[@]}

echo "Installing GUI applications..."
brew install --cask ${CASKS[@]}

# 6. Final Notification
if command -v terminal-notifier &> /dev/null; then
    echo "Macbook setup completed!" | terminal-notifier -sound default
else
    echo "Macbook setup completed!"
fi
