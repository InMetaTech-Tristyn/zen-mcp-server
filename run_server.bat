@echo off
REM Batch launcher for run-server.ps1

REM Check for PowerShell
where pwsh >nul 2>nul
if %ERRORLEVEL%==0 (
    set POWERSHELL=pwsh
) else (
    where powershell >nul 2>nul
    if %ERRORLEVEL%==0 (
        set POWERSHELL=powershell
    ) else (
        echo Error: PowerShell is not installed or not in PATH.
        echo Please install PowerShell 5.1+ or PowerShell Core (pwsh).
        exit /b 1
    )
)

REM Run the PowerShell script with all arguments
%POWERSHELL% -NoProfile -ExecutionPolicy Bypass -File "%~dp0run-server.ps1" %*
exit /b %ERRORLEVEL% 