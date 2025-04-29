#!/bin/bash
# Git and Shell Aliases Collection
# This file contains Git aliases and shell functions for Git workflow enhancement.
# To install these aliases and functions, you can:
# 1. Source this file in your .zshrc or .bashrc: source /path/to/this/file
# OR
# 2. Copy-paste the sections you want into your .zshrc or .bashrc file

#######################################################
# GIT GLOBAL ALIASES (stored in ~/.gitconfig)
#######################################################

# To install the git global aliases, run these commands:
# git config --global alias.lg "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --all"
# git config --global alias.lgb "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"

# git lg - shows pretty git log with graph for ALL branches
# Example: git lg
function install_git_lg() {
  git config --global alias.lg "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --all"
  echo "Installed git lg alias"
}

# git lgb - shows pretty git log with graph for CURRENT branch only
# Example: git lgb
function install_git_lgb() {
  git config --global alias.lgb "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
  echo "Installed git lgb alias"
}

#######################################################
# SHELL ALIASES (stored in ~/.zshrc or ~/.bashrc)
#######################################################

# gitfiles - shows commits with changed files
# Shows a colorful log with files changed in each commit
alias gitfiles='git log --graph --pretty=format:"%C(yellow)%h%Creset %C(red)%d%Creset - %C(cyan)(%cr)%Creset %C(green)<%an>%Creset %s" --name-only --all'

# gitempty - creates an empty commit (useful for triggering CI/CD pipelines)
# Example: gitempty
alias gitempty='git commit --allow-empty -m "Empty"'

# gitrecent - shows 20 most recently updated branches
# This helps you keep track of your recent work across branches
alias gitrecent='git for-each-ref --sort=-committerdate refs/heads/ --format="%(color:yellow)%(committerdate:short)%(color:reset) %(color:bold blue)%(refname:short)" --count=20'

# squash-all - resets to a single initial commit (caution: destructive)
# This is useful when you want to start over with a clean history
alias squash-all='git reset $(git commit-tree HEAD^{tree} -m "Initial Commit")'

#######################################################
# GIT UTILITY FUNCTIONS
#######################################################

# git-commit-changes-zip - creates a zip file with changes from a specific commit
# Usage: git-commit-changes-zip <commit-hash> [output-filename]
function git_commit_changes_zip() {
    if [ -z "$1" ]; then
        echo "Usage: git-commit-changes-zip <commit-hash> [output-filename]"
        return 1
    fi
    
    commit_hash=$1
    output_filename=${2:-"commit_changes.zip"}
    
    # Get the list of changed files
    changed_files=$(git diff-tree -r --no-commit-id --name-only --diff-filter=ACMRT $commit_hash)
    
    if [ -z "$changed_files" ]; then
        echo "No changed files found in commit $commit_hash"
        return 1
    fi
    
    # Create a temporary directory
    temp_dir=$(mktemp -d)
    
    # Copy the changed files to the temporary directory, preserving paths
    echo "$changed_files" | while read file; do
        mkdir -p "$temp_dir/$(dirname "$file")"
        git show "$commit_hash:$file" > "$temp_dir/$file"
    done
    
    # Create the zip file
    (cd "$temp_dir" && zip -r - .) > "$output_filename"
    
    # Clean up
    rm -rf "$temp_dir"
    
    echo "Created $output_filename with changes from commit $commit_hash"
}
alias git-commit-changes-zip='git_commit_changes_zip'

# git-apply-changes-zip - applies changes from a zip file created by git-commit-changes-zip
# Usage: git-apply-changes-zip <zip-file>
function git_apply_changes_zip() {
    local zip_file="$1"
    
    if [ -z "$zip_file" ]; then
        echo "Usage: git-apply-changes-zip <zip-file>"
        return 1
    fi
    
    if [ ! -f "$zip_file" ]; then
        echo "Error: File $zip_file does not exist"
        return 1
    fi
    
    if ! git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
        echo "Error: Not in a git repository"
        return 1
    fi
    
    local git_root=$(git rev-parse --show-toplevel)
    local temp_dir=$(mktemp -d)
    
    if ! unzip -q "$zip_file" -d "$temp_dir"; then
        echo "Error: Failed to unzip $zip_file"
        rm -rf "$temp_dir"
        return 1
    fi
    
    echo "Applying changes from $zip_file..."
    
    find "$temp_dir" -type f | while read -r file; do
        local relative_path=${file#$temp_dir/}
        local target_path="$git_root/$relative_path"
        
        mkdir -p "$(dirname "$target_path")"
        cp "$file" "$target_path"
        echo "Applied: $relative_path"
    done
    
    rm -rf "$temp_dir"
    echo "Changes applied successfully"
}
alias git-apply-changes-zip='git_apply_changes_zip'

#######################################################
# INSTALLATION
#######################################################

# Run this function to install all aliases and functions
function install_all_git_aliases() {
  # Install Git global aliases
  install_git_lg
  install_git_lgb
  
  # The shell aliases and functions are already defined above.
  # You'll need to add them to your .zshrc or .bashrc manually.
  echo "Git global aliases installed."
  echo "Shell aliases and functions defined."
  echo "To make shell aliases and functions permanent, add the relevant sections of this file to your .zshrc or .bashrc"
}

# Uncomment this line to run the installation automatically when sourcing this file
# install_all_git_aliases