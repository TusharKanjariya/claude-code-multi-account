# claude-code-multi-account

**Use multiple Claude Code accounts on one machine and switch automatically per project.** Keep your work, personal and client Claude accounts logged in side by side, with no more `/logout` and `/login` every time you change projects. Works on Windows (PowerShell, cmd, Git Bash), macOS and Linux.

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
![Platforms](https://img.shields.io/badge/platform-Windows%20%7C%20macOS%20%7C%20Linux-lightgrey)

```sh
cd ~/code/client-project
claude-use client      # this folder now uses your "client" Claude account
claude                 # starts Claude Code logged in as that account
```

## Why

Claude Code is logged into one account at a time. If you have a work account and a personal account (or one per client), switching means logging out and back in, and it's easy to burn the wrong plan's usage by accident.

This tool remembers which account each project uses. Run `claude` in a project and it starts with the right account automatically.

## Features

- **Multiple Claude accounts at once.** Each account stays logged in, so there's no repeated `/login`.
- **Automatic switching per project.** A small `.claude-account` file in the folder picks the account.
- **Any account names.** For example `work`, `personal`, `hobby` or `client-acme`.
- **Shared setup.** Skills, agents, slash commands, hooks, plugins and output styles are shared across all accounts.
- **Separate where it matters.** Each account has its own login, history, memory and settings.
- **Cross-platform.** Windows (PowerShell, cmd, Git Bash / MSYS2), macOS and Linux.
- **No changes to Claude Code.** It uses Claude Code's own `CLAUDE_CONFIG_DIR` setting.
- **Small and dependency-free.** A few shell and batch scripts, with nothing to compile or run in the background.

## Install

Clone the repo somewhere permanent:

```sh
git clone https://github.com/TusharKanjariya/claude-code-multi-account.git
cd claude-code-multi-account
```

Then put its `bin` folder on your PATH, **before** the real `claude`:

**Windows** (one PATH for PowerShell, cmd and Git Bash):

```powershell
powershell -ExecutionPolicy Bypass -File install.ps1
```

**macOS / Linux** (adds `bin` to `~/.zshrc`, `~/.bashrc`, `~/.bash_profile` on macOS bash, or `~/.profile`):

```sh
sh install.sh
```

Using fish? Run `fish_add_path -m /path/to/claude-code-multi-account/bin` instead.

Afterwards, **restart your terminal app** (VS Code, Windows Terminal, etc.), not just the tab. Open terminals keep the old PATH.

## Quick start

```sh
claude-use add work      # 1. create an account (once per account)

cd ~/code/work-project
claude-use work          # 2. this folder uses the work account
claude                   # 3. first time only: run /login and sign in with your work account
```

From then on, `claude` in that folder starts as your work account. Folders without a `.claude-account` file use your normal login.

## Commands

| Command | What it does |
|---|---|
| `claude-use add <name>` | Create an account (`~/.claude-<name>`) that shares your skills, plugins etc. |
| `claude-use <name>` | Use that account in the current folder |
| `claude-use` | Show which account the current folder uses |
| `claude-use list` | List all accounts |
| `claude-use default` | Go back to the main account (`~/.claude`) in this folder |
| `claude` | Start Claude Code with the folder's account (all arguments are passed through) |

Account names can use letters, digits, `-` and `_`.

## How it works

Claude Code keeps its login and settings in a config folder (`~/.claude`), and the `CLAUDE_CONFIG_DIR` environment variable points it at a different one. This repo adds two small commands around that:

- `claude-use` creates account folders (`~/.claude-work`, `~/.claude-personal` and so on) and writes the account name to `.claude-account` in your project.
- `claude` is a thin wrapper. It reads `.claude-account`, sets `CLAUDE_CONFIG_DIR`, and starts the real Claude Code.

Shared folders are linked from `~/.claude` (directory junctions on Windows, symlinks on macOS/Linux), so installing a skill or plugin once makes it available in every account.

## FAQ

**Does it work with Claude Pro, Max, Team and API accounts?**
Yes. Each account folder holds whatever you sign in with through `/login`.

**Can I use two accounts at the same time?**
Yes. Open two terminals in projects that use different accounts. Each `claude` runs independently.

**Does it change or patch Claude Code?**
No. It only sets `CLAUDE_CONFIG_DIR`, a setting Claude Code supports itself, before starting the normal `claude`.

**Where are my credentials stored?**
In the same place Claude Code always stores them: the account's config folder on Windows and Linux, and the macOS Keychain on macOS, where each config folder gets its own entry.

**What if a project names an account I don't have on this machine?**
`claude` stops with an error telling you to run `claude-use add <name>`, instead of starting logged out.

## Notes

- **Run `claude` from the project root.** The account file is only read in the current folder, not in parent folders.
- **Keep `.claude-account` out of git.** It's a personal choice, not project config. Add it to a global ignore file:
  `git config --global core.excludesFile ~/.gitignore_global` and put `.claude-account` in that file.
- **Settings are copied, not shared.** `settings.json` and `CLAUDE.md` are copied when the account is created, because Claude Code rewrites them and that would break a link. Copy them again if you want the accounts to match.
- **More shared folders.** If your setup keeps other folders in `~/.claude` (for example, tools your hooks call), add their names to the list in `bin/claude-use.cmd` (Windows) or `bin/claude-use` (macOS/Linux) before running `claude-use add`.
- **Plugins.** If a plugin doesn't load in a new account, run `/plugin` there and reinstall it.
- **`alias claude=...` wins over PATH.** Older Claude Code "local" installs add an alias like `alias claude="~/.claude/local/claude"` to your shell config. Remove it, or the wrapper is skipped. The wrapper still finds `~/.claude/local/claude` without the alias.
- **Tested on** Windows (PowerShell, cmd, Git Bash, MSYS2) and Linux (Ubuntu). macOS uses the same `sh` scripts as Linux but hasn't been tested on a Mac yet. Reports are welcome.

## Uninstall

Remove the `bin` folder from your PATH (Windows: user environment variables; macOS/Linux: the `# claude-code-multi-account` line in your shell config). Account folders (`~/.claude-<name>`) and `.claude-account` files can be deleted by hand.

## Contributing

Issues and pull requests are welcome, especially macOS test reports and fixes for other shells.

## License

[MIT](LICENSE)
