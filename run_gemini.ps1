# Run Gemini MCP Server (PowerShell)
$SCRIPT_DIR = Split-Path -Parent $MyInvocation.MyCommand.Definition
Set-Location $SCRIPT_DIR

# Check if venv exists
if (-not (Test-Path "venv")) {
    Write-Host "Virtual environment not found. Running setup..."
    & "$SCRIPT_DIR\setup.ps1"
    if ($LASTEXITCODE -ne 0) { exit 1 }
}

# Activate virtual environment
. "$SCRIPT_DIR\venv\Scripts\Activate.ps1"

# Load environment variables from .env if it exists
if (Test-Path ".env") {
    Get-Content .env | ForEach-Object {
        $line = $_.Trim()
        if ($line -and -not $line.StartsWith("#")) {
            $kv = $line -split '=', 2
            if ($kv.Length -eq 2) {
                [System.Environment]::SetEnvironmentVariable($kv[0], $kv[1])
            }
        }
    }
}

# Run the server
python server.py 