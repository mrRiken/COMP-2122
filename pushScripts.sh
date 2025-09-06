#!/bin/bash

# -------------------------------
# All-in-One Git Push Script
# -------------------------------

# 1️⃣ Update apt package list
echo "Updating package list..."
sudo apt update -y

# 2️⃣ Check if Git is installed; install if not
if ! command -v git >/dev/null 2>&1; then
    echo "Git is not installed. Installing Git..."
    sudo apt install git -y
else
    echo "Git is already installed."
fi

# 3️⃣ Unlock GitHub token using master password
PASS_SCRIPT="$HOME/.secret/pass.sh"
if [[ ! -f "$PASS_SCRIPT" ]]; then
    echo "Error: pass.sh not found at $PASS_SCRIPT"
    exit 1
fi

# Source pass.sh to get REAL_PASS
source "$PASS_SCRIPT"

# 4️⃣ Update Git remote URL to use token (HTTPS)
# Replace 'mrRiken' and 'COMP-2122' with your username/repo
git remote set-url origin "https://mrRiken:$REAL_PASS@github.com/mrRiken/COMP-2122.git"

# 5️⃣ Loop to push multiple files
while true; do
    # Ask for filename
    read -p "Enter filename to push (or type 'done' to finish): " file
    if [[ "$file" == "done" ]]; then
        echo "Finished pushing files."
        break
    fi

    # Check file existence
    if [[ ! -f "$file" ]]; then
        echo "Error: File '$file' does not exist."
        continue
    fi

    # Make .sh files executable
    if [[ "$file" == *.sh ]]; then
        chmod +x "$file"
        echo "File '$file' is now executable."
    fi

    # Stage file
    git add "$file"
    echo "File '$file' staged successfully."

    # Commit message
    read -p "Enter commit message for '$file': " msg
    git commit -m "$msg"
    echo "Changes committed with message: '$msg'"

    # Pull remote changes to avoid rejection
    echo "Pulling remote changes..."
    git pull --rebase origin main

    # Push file
    git push -u origin main
    echo "File '$file' pushed to GitHub successfully."
done
