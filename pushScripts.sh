#!/bin/bash

# Source PAT and unlock
source ~/.secret/pass.sh
git remote set-url origin "https://mrRiken:$REAL_PASS@github.com/mrRiken/COMP2137.git"

echo "Git is already installed."

# Ask for master password
while true; do
    read -p "Enter filename to push (or type 'done' to finish): " file
    [[ "$file" == "done" ]] && break

    # Check if file exists
    if [[ ! -f "$file" ]]; then
        echo "File does not exist."
        continue
    fi

    # Stage file regardless of previous commits
    git add "$file"
    echo "File '$file' staged successfully."

    # Commit with custom message
    read -p "Enter commit message for '$file': " msg
    git commit -m "$msg"
    echo "Changes committed with message: '$msg'"

    # Push to branch
    git push -u origin myScripts
    echo "File '$file' pushed to GitHub successfully."
done
