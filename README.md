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

**macOS / Linux** (adds `bin` to `~/.zshrc`, `~/.bashrc`, `~/.bash_profile` on macOS bash, or `~/.profile`):

```sh
sh install.sh
```

Using fish? Run `fish_add_path -m /path/to/claude-code-accounts/bin` instead.

Afterwards, restart your terminal app (VS Code, Windows Terminal, etc.), not just the tab. Open terminals keep the old PATH.

## Usage

Name accounts whatever you like: `work`, `hobby`, `client-acme` and so on. Names can use letters, digits, `-` and `_`.

```sh
claude-use add work      # create an account (~/.claude-work), once per account
claude-use add hobby
claude-use list          # show all accounts

cd ~/code/work-project
claude-use work          # this folder now uses the work account
claude                   # first time: run /login and sign in with the work account

claude-use               # show which account this folder uses
claude-use default       # go back to the main account (~/.claude)
```

Folders without a `.claude-account` file use your normal `~/.claude` login. If a folder names an account that doesn't exist on this machine, `claude` stops with an error instead of starting logged out.

## Notes

- **Run `claude` from the project root.** The account file is only read in the current folder, not in parent folders.
- **Keep `.claude-account` out of git.** Add it to a global ignore file:
  `git config --global core.excludesFile ~/.gitignore_global` and put `.claude-account` in that file.
- **Settings are copied, not shared.** `settings.json` and `CLAUDE.md` are copied when the account is created, because Claude Code rewrites them and that would break a link. Copy them again if you want the accounts to match.
- **More shared folders.** If your setup keeps other folders in `~/.claude` (for example, tools your hooks call), add their names to the list in `bin/claude-use.cmd` (Windows) or `bin/claude-use` (macOS/Linux) before running `claude-use add`.
- **Plugins.** If a plugin doesn't load in a new account, run `/plugin` there and reinstall it.
- **`alias claude=...` wins over PATH.** Older Claude Code "local" installs add an alias like `alias claude="~/.claude/local/claude"` to your shell config. Remove it, or the wrapper is skipped. The wrapper still finds `~/.claude/local/claude` without the alias.
- **macOS login.** On macOS, Claude Code stores the login in the Keychain under a name derived from the config folder, so each account keeps its own login there too.
- **Tested on** Windows (PowerShell, cmd, Git Bash) and Linux (Ubuntu). macOS uses the same `sh` scripts as Linux but hasn't been run on a Mac yet.

## Uninstall

Remove the `bin` folder from your PATH. Account folders (`~/.claude-<name>`) and `.claude-account` files can be deleted by hand.
