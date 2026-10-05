#!/bin/sh
# Adds this repo's bin folder to the front of your PATH (macOS / Linux).
bin="$(cd "$(dirname "$0")" && pwd)/bin"
case "$(basename "${SHELL:-sh}")" in
  zsh) rc="$HOME/.zshrc" ;;
  bash) if [ "$(uname -s)" = Darwin ]; then rc="$HOME/.bash_profile"; else rc="$HOME/.bashrc"; fi ;;
  *) rc="$HOME/.profile" ;;
esac
line="export PATH=\"$bin:\$PATH\""
if grep -qsF "$line" "$rc"; then
  echo "Already on PATH in $rc"
else
  printf '\n# claude-code-multi-account\n%s\n' "$line" >> "$rc"
  echo "Added $bin to PATH in $rc. Restart your terminal app (not just the tab)."
fi
