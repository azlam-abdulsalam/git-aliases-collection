# Git Aliases Collection

A collection of useful Git aliases, commands, and utility functions to enhance your Git workflow.

## What's Included

This collection includes:

### Git Global Aliases

- `git lg` - Pretty git log with graph for ALL branches
- `git lgb` - Pretty git log with graph for CURRENT branch only

### Shell Aliases

- `gitfiles` - Shows commits with changed files
- `gitempty` - Creates an empty commit (useful for triggering CI/CD)
- `gitrecent` - Shows 20 most recently updated branches
- `squash-all` - Resets to a single initial commit (caution: destructive)

### Utility Functions

- `git-commit-changes-zip` - Creates a zip file with changes from a specific commit
- `git-apply-changes-zip` - Applies changes from a zip file created by git-commit-changes-zip

## Installation

### Quick Setup

1. Clone this repository:
```bash
git clone https://github.com/azlam-abdulsalam/git-aliases-collection.git
```

2. Set up the Git global aliases:
```bash
git config --global alias.lg "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --all"
git config --global alias.lgb "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
```

3. For shell aliases and functions, add the content from `git-aliases-and-functions.sh` to your `.zshrc` or `.bashrc` file.

### Using the Install Script

Alternatively, you can source the script which includes an installation function:

```bash
# Source the script
source /path/to/git-aliases-and-functions.sh

# Run the installation function
install_all_git_aliases
```

## Usage Examples

### Pretty Git Log

```bash
# Show graph for all branches
git lg

# Show graph for current branch only
git lgb
```

### Working with Files

```bash
# Show commits with changed files
gitfiles

# Create an empty commit
gitempty
```

### Recent Branches

```bash
# Show recent branches
gitrecent
```

### Commit Bundling

```bash
# Create a zip with changes from a commit
git-commit-changes-zip <commit-hash> [output-filename]

# Apply changes from a zip file
git-apply-changes-zip <zip-file>
```

## License

MIT