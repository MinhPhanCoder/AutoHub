#!/bin/bash

set -e  # Exit on error

echo "🚀 Starting Git installation..."

# Update package list
echo "📦 Updating package list..."
sudo apt update -y

# Install Git
echo "⚙️ Installing Git..."
sudo apt install -y git

# Verify installation
echo "✅ Git version:"
git --version

# Basic Git configuration
echo "🔧 Would you like to configure Git with your name and email? (y/n)"
read -r configure

if [[ $configure =~ ^[Yy]$ ]]; then
    echo "Enter your name:"
    read -r git_name
    echo "Enter your email:"
    read -r git_email
    
    git config --global user.name "$git_name"
    git config --global user.email "$git_email"
    
    echo "✨ Git configured successfully!"
fi

echo "🎉 Git installation and setup completed!"