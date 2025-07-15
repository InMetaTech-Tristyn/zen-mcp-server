@echo off
REM Gemini MCP Server Setup Script (Windows)
REM This script helps users set up the virtual environment and install dependencies

echo 🚀 Gemini MCP Server Setup
echo =========================

REM Get script directory
set SCRIPT_DIR=%~dp0
cd /d %SCRIPT_DIR%

REM Check if python is installed
where python >nul 2>nul
if %ERRORLEVEL% neq 0 (
    echo ❌ Error: Python is not installed.
    echo Please install Python 3.10 or higher from https://python.org
    exit /b 1
)

REM Check Python version
for /f "tokens=2 delims=. " %%a in ('python --version 2^>nul') do set PY_MAJOR=%%a
for /f "tokens=3 delims=. " %%a in ('python --version 2^>nul') do set PY_MINOR=%%a
if not defined PY_MAJOR set PY_MAJOR=0
if not defined PY_MINOR set PY_MINOR=0
if %PY_MAJOR% lss 3 (
    echo ❌ Error: Python 3.10 or higher is required (you have Python %PY_MAJOR%.%PY_MINOR%)
    exit /b 1
)
if %PY_MAJOR%==3 if %PY_MINOR% lss 10 (
    echo ❌ Error: Python 3.10 or higher is required (you have Python %PY_MAJOR%.%PY_MINOR%)
    exit /b 1
)

REM Check if venv exists
if exist venv (
    echo ✓ Virtual environment already exists
) else (
    echo 📦 Creating virtual environment...
    python -m venv venv
    if %ERRORLEVEL% neq 0 (
        echo ❌ Error: Failed to create virtual environment
        exit /b 1
    )
    echo ✓ Virtual environment created
)

REM Activate virtual environment
call venv\Scripts\activate.bat

REM Upgrade pip
python -m pip install --upgrade pip

REM Install requirements
python -m pip install -r requirements.txt
if %ERRORLEVEL% neq 0 (
    echo ❌ Error: Failed to install dependencies
    exit /b 1
)

echo.
echo ✅ Setup completed successfully!
echo.
echo Next steps:
echo 1. Get your Gemini API key from: https://makersuite.google.com/app/apikey
echo 2. Configure Claude Desktop with your API key (see README.md)
echo 3. Restart Claude Desktop
echo.
echo Note: The virtual environment has been activated for this session.
echo The run_gemini.bat script will automatically activate it when needed. 