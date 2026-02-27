#!/usr/bin/env bash

# Setup script for setting up a new macos machine
echo "Starting setup..."

# install xcode CLI
xcode-select --install

# Check for Homebrew to be present, install if it's missing
if ! command -v brew &> /dev/null; then
    echo "Installing homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
    echo "Homebrew is already installed"
fi

# Update homebrew recipes
brew update

PACKAGES=(
    anydesk
    cask
    git
    github
    google-chrome
    google-drive
    iterm2
    keka
    mas
    readline
    rectangle
    speedtest-cli
    tcpdump
    terminal-notifier
    tldr
    vlc
)
echo "Installing packages..."
brew install ${PACKAGES[@]}

echo "Macbook setup completed!" | terminal-notifier -sound default
