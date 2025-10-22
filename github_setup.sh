#!/bin/bash

# GitHub Repository Setup Script
# Run this after creating the repository on GitHub

echo "🚀 Setting up GitHub repository connection..."

# Add GitHub remote (replace with your actual repository URL)
git remote add origin https://github.com/The-Grim-Repo/ansible-network-automation-lab.git

# Rename default branch to main (modern standard)
git branch -M main

# Push to GitHub
git push -u origin main

echo "✅ Repository successfully pushed to GitHub!"
echo "🌐 View your repository at: https://github.com/The-Grim-Repo/ansible-network-automation-lab"
