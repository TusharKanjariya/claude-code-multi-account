# Adds this repo's bin folder to the front of your user PATH (Windows).
$bin = Join-Path $PSScriptRoot 'bin'
$path = [Environment]::GetEnvironmentVariable('Path', 'User')
if (($path -split ';') -contains $bin) { "Already on PATH: $bin"; return }
[Environment]::SetEnvironmentVariable('Path', "$bin;$path", 'User')
"Added $bin to PATH. Restart your terminal app (not just the tab)."
