#!/bin/bash

echo "🚀 Manual GitHub Push Script"
echo "=========================="
echo ""
echo "This script will help you push your code to GitHub."
echo "You'll need to authenticate when prompted."
echo ""
echo "Repository: https://github.com/The-Grim-Repo/ansible-network-automation-lab"
echo ""
echo "When prompted:"
echo "  Username: The-Grim-Repo"
echo "  Password: Use a Personal Access Token (not your GitHub password)"
echo ""
echo "To create a Personal Access Token:"
echo "1. Go to GitHub.com → Settings → Developer settings → Personal access tokens"
echo "2. Generate new token with 'repo' permissions"
echo "3. Copy the token and use it as your password"
echo ""
echo "Press Enter to continue..."
read

echo "Pushing to GitHub..."
git push -u origin main

if [ $? -eq 0 ]; then
    echo ""
    echo "✅ Success! Your code has been pushed to GitHub!"
    echo "🌐 View your repository at: https://github.com/The-Grim-Repo/ansible-network-automation-lab"
else
    echo ""
    echo "❌ Push failed. Please check your authentication."
    echo "💡 Try creating a Personal Access Token and use it as your password."
fi
