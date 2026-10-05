@echo off
rem Usage: claude-use               show this folder's account
rem        claude-use <name>        use ~\.claude-<name> in this folder
rem        claude-use default       go back to ~\.claude
rem        claude-use add <name>    create ~\.claude-<name>, sharing skills, plugins etc. with ~\.claude
rem        claude-use list          list accounts
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
if /i "%~1"=="list" goto list
if /i "%~1"=="add" (
  if "%~2"=="" (
    echo Usage: claude-use add ^<name^>
    exit /b 1
  )
  set "NAME=%~2"
) else (
  set "NAME=%~1"
)
rem Names: letters, digits, - and _ only. Whatever is left after removing those is invalid.
set "BAD="
if "%NAME:~0,1%"==";" set "BAD=1"
for /f "delims=abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_-" %%x in ("%NAME%") do set "BAD=1"
if /i "%NAME%"=="add" set "BAD=1"
if /i "%NAME%"=="list" set "BAD=1"
if /i "%NAME%"=="default" set "BAD=1"
if defined BAD (
  echo Invalid account name. Use letters, digits, - and _ ^(not add, list or default^).
  exit /b 1
)
set "DST=%USERPROFILE%\.claude-%NAME%"
if /i "%~1"=="add" goto add
if not exist "%DST%\" (
  echo No account '%NAME%'. Create it with: claude-use add %NAME%
  exit /b 1
)
>.claude-account echo %NAME%
echo This folder now uses account: %NAME%
exit /b

:add
if not exist "%DST%" mkdir "%DST%"
rem Shared with the main account. Add folders here if your setup keeps more in ~\.claude.
for %%d in (skills agents commands hooks plugins output-styles) do if exist "%SRC%\%%d" if not exist "%DST%\%%d" mklink /J "%DST%\%%d" "%SRC%\%%d" >nul
rem Copied, because Claude Code rewrites these and would break a link.
for %%f in (settings.json CLAUDE.md) do if exist "%SRC%\%%f" if not exist "%DST%\%%f" copy "%SRC%\%%f" "%DST%\%%f" >nul
echo Account '%NAME%' is ready: %DST%
echo Next: claude-use %NAME%, then run claude and /login.
exit /b

:list
echo default
for /d %%a in ("%USERPROFILE%\.claude-*") do (
  set "N=%%~nxa"
  call echo %%N:~8%%
)
