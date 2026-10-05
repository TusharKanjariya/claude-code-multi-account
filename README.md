# claude-code-accounts

Use more than one Claude account with [Claude Code](https://claude.com/claude-code) and choose the account per project. It works in PowerShell, cmd, Git Bash, macOS and Linux.

Claude Code stores its login in a config folder (`~/.claude`), and the `CLAUDE_CONFIG_DIR` environment variable points it at a different one. This repo adds two small commands around that:

- `claude-use`: choose the account for the current folder (it writes a `.claude-account` file).
- `claude`: a thin wrapper that reads `.claude-account` and starts the real Claude Code with that account.

Skills, agents, commands, hooks, plugins and output styles stay shared between accounts. Each account keeps its own login, history, memory and settings.

## Install

Clone the repo somewhere permanent, then put its `bin` folder on your PATH, **before** the real `claude`.

**Windows** (one PATH for PowerShell, cmd and Git Bash):

```powershell
powershell -ExecutionPolicy Bypass -File install.ps1
```

**macOS / Linux**: add this line to `~/.bashrc` or `~/.zshrc`:

```sh
export PATH="/path/to/claude-code-accounts/bin:$PATH"
```

Open a new terminal afterwards.

## Usage

```sh
claude-use add work      # create a "work" account (~/.claude-work), once
cd ~/code/work-project
claude-use work          # this folder now uses the work account
claude                   # first time: run /login and sign in with the work account

claude-use               # show which account this folder uses
claude-use default       # go back to the main account (~/.claude)
```

Folders without a `.claude-account` file use your normal `~/.claude` login.

## Notes

- **Run `claude` from the project root.** The account file is only read in the current folder, not in parent folders.
- **Keep `.claude-account` out of git.** Add it to a global ignore file:
  `git config --global core.excludesFile ~/.gitignore_global` and put `.claude-account` in that file.
- **Settings are copied, not shared.** `settings.json` and `CLAUDE.md` are copied when the account is created, because Claude Code rewrites them and that would break a link. Copy them again if you want the accounts to match.
- **More shared folders.** If your setup keeps other folders in `~/.claude` (for example, tools your hooks call), add their names to the list in `bin/claude-use.cmd` (Windows) or `bin/claude-use` (macOS/Linux) before running `claude-use add`.
- **Plugins.** If a plugin doesn't load in a new account, run `/plugin` there and reinstall it.
- **macOS / Linux are untested.** These scripts were tested on Windows (PowerShell, cmd and Git Bash). The macOS/Linux scripts are plain `sh`, but nobody has run them there yet.

## Uninstall

Remove the `bin` folder from your PATH. Account folders (`~/.claude-<name>`) and `.claude-account` files can be deleted by hand.
