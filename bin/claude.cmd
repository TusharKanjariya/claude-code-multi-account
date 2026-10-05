@echo off
rem Starts the real claude with the account chosen for this folder (.claude-account).
setlocal
set "CLAUDE_CONFIG_DIR="
if not exist .claude-account goto find
set /p ACCT=<.claude-account
set "CLAUDE_CONFIG_DIR=%USERPROFILE%\.claude-%ACCT%"
:find
set "REAL="
for %%n in (claude.exe claude.cmd) do for /f "delims=" %%p in ('where %%n 2^>nul') do if not defined REAL if /i not "%%~dpp"=="%~dp0" set "REAL=%%p"
if not defined REAL (
  echo claude-code-accounts: could not find the real claude on PATH. 1>&2
  exit /b 1
)
call "%REAL%" %*
