@echo off
rem Usage: claude-use               show this folder's account
rem        claude-use <name>        use ~\.claude-<name> in this folder
rem        claude-use default       go back to ~\.claude
rem        claude-use add <name>    create ~\.claude-<name>, sharing skills, plugins etc. with ~\.claude
setlocal
set "SRC=%USERPROFILE%\.claude"
if "%~1"=="" (
  if exist .claude-account (type .claude-account) else (echo default)
  exit /b
)
if /i "%~1"=="default" (
  del .claude-account 2>nul
  echo This folder now uses the default account.
  exit /b
)
if /i "%~1"=="add" goto add
if not exist "%USERPROFILE%\.claude-%~1" (
  echo No account '%~1'. Create it with: claude-use add %~1
  exit /b 1
)
>.claude-account echo %~1
echo This folder now uses account: %~1
exit /b

:add
if "%~2"=="" (
  echo Usage: claude-use add ^<name^>
  exit /b 1
)
set "DST=%USERPROFILE%\.claude-%~2"
if not exist "%DST%" mkdir "%DST%"
rem Shared with the main account. Add folders here if your setup keeps more in ~\.claude.
for %%d in (skills agents commands hooks plugins output-styles) do if exist "%SRC%\%%d" if not exist "%DST%\%%d" mklink /J "%DST%\%%d" "%SRC%\%%d" >nul
rem Copied, because Claude Code rewrites these and would break a link.
for %%f in (settings.json CLAUDE.md) do if exist "%SRC%\%%f" if not exist "%DST%\%%f" copy "%SRC%\%%f" "%DST%\%%f" >nul
echo Created %DST%
echo Next: claude-use %~2, then run claude and /login.
