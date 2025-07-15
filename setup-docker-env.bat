@echo off
REM Setup .env for Gemini MCP Server Docker (Windows)

setlocal enabledelayedexpansion
set CURRENT_DIR=%cd%

REM Check if .env already exists
if exist .env (
    echo ⚠️  .env file already exists! Skipping creation.
    echo.
) else (
    if defined GEMINI_API_KEY (
        set API_KEY_VALUE=%GEMINI_API_KEY%
        echo ✅ Found existing GEMINI_API_KEY in environment
    ) else (
        set API_KEY_VALUE=your-gemini-api-key-here
    )
    (
        echo # Gemini MCP Server Docker Environment Configuration
        echo # Generated on %date% %time%
        echo.
        echo # Your Gemini API key (get one from https://makersuite.google.com/app/apikey)
        echo # IMPORTANT: Replace this with your actual API key
        echo GEMINI_API_KEY=!API_KEY_VALUE!
    ) > .env
    echo ✅ Created .env file
    echo.
)

echo Next steps:
if "%API_KEY_VALUE%"=="your-gemini-api-key-here" (
    echo 1. Edit .env and replace 'your-gemini-api-key-here' with your actual Gemini API key
    echo 2. Copy this configuration to your Claude Desktop config:
) else (
    echo 1. Copy this configuration to your Claude Desktop config:
)
echo.
echo ===== COPY BELOW THIS LINE =====
echo {
echo   "mcpServers": {
echo     "gemini": {
echo       "command": "docker",
echo       "args": [
echo         "run",
echo         "--rm",
echo         "-i",
echo         "--env-file", "%CURRENT_DIR%\.env",
echo         "-e", "WORKSPACE_ROOT=%%USERPROFILE%%",
echo         "-v", "%%USERPROFILE%%:/workspace:ro",
echo         "gemini-mcp-server:latest"
echo       ]
echo     }
echo   }
echo }
echo ===== COPY ABOVE THIS LINE =====
echo.
echo Config file location:
echo   macOS: ~/Library/Application Support/Claude/claude_desktop_config.json
echo   Windows: %%APPDATA%%\Claude\claude_desktop_config.json
echo.
echo Note: This configuration mounts your home directory (%%USERPROFILE%%).
echo Docker can access any file within your home directory.
echo.
echo If you want to restrict access to a specific directory:
echo Change both the mount (-v) and WORKSPACE_ROOT to match:
echo Example: -v "%CURRENT_DIR%:/workspace:ro" and WORKSPACE_ROOT=%CURRENT_DIR%
echo The container will automatically use /workspace as the sandbox boundary. 