@echo off
REM Run Gemini MCP Server (Windows)

set SCRIPT_DIR=%~dp0
cd /d %SCRIPT_DIR%

REM Check if venv exists
if not exist venv (
    echo Virtual environment not found. Running setup...
    call setup.bat
    if %ERRORLEVEL% neq 0 exit /b 1
)

REM Activate virtual environment
call venv\Scripts\activate.bat

REM Load environment variables from .env if it exists
if exist .env (
    for /f "usebackq tokens=* delims=" %%a in ('.env') do (
        set "line=%%a"
        echo !line! | findstr /b /v "#" | findstr /r /v "^$" >nul && (
            for /f "tokens=1,2 delims==" %%b in ("!line!") do set %%b=%%c
        )
    )
)

REM Run the server
python server.py 