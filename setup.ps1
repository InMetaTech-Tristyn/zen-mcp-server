# Gemini MCP Server Setup Script (PowerShell)
Write-Host "Gemini MCP Server Setup"
Write-Host "========================="

# Get script directory
$SCRIPT_DIR = Split-Path -Parent $MyInvocation.MyCommand.Definition
Set-Location $SCRIPT_DIR

# Check if python is installed
$python = Get-Command python -ErrorAction SilentlyContinue
if (-not $python) {
    Write-Host "Error: Python is not installed."
    Write-Host "Please install Python 3.10 or higher from https://python.org"
    exit 1
}

# Check Python version
$pyVersion = & python --version 2>&1
if ($pyVersion -match "Python (\d+)\.(\d+)") {
    $major = [int]$Matches[1]
    $minor = [int]$Matches[2]
    if ($major -lt 3 -or ($major -eq 3 -and $minor -lt 10)) {
        Write-Host "Error: Python 3.10 or higher is required (you have Python $major.$minor)"
        exit 1
    }
} else {
    Write-Host "Error: Could not determine Python version."
    exit 1
}

# Check if venv exists
if (Test-Path "venv") {
    Write-Host "✓ Virtual environment already exists"
} else {
    Write-Host "Creating virtual environment..."
    & python -m venv venv
    if ($LASTEXITCODE -ne 0) {
        Write-Host "Error: Failed to create virtual environment"
        exit 1
    }
    Write-Host "✓ Virtual environment created"
}

# Activate virtual environment
$venvActivate = Join-Path $SCRIPT_DIR "venv\bin\Activate.ps1"
. $venvActivate

# Upgrade pip
python -m pip install --upgrade pip

# Install requirements
python -m pip install -r requirements.txt
if ($LASTEXITCODE -ne 0) {
    Write-Host "Error: Failed to install dependencies"
    exit 1
}

# Check for run_gemini.ps1 or run_gemini.bat script
$runScriptPS1 = Join-Path $SCRIPT_DIR 'run_gemini.ps1'
$runScriptBAT = Join-Path $SCRIPT_DIR 'run_gemini.bat'
if (!(Test-Path $runScriptPS1) -and !(Test-Path $runScriptBAT)) {
    Write-Host "\u274c Error: Neither run_gemini.ps1 nor run_gemini.bat script found in $SCRIPT_DIR."
    Write-Host "Please ensure one of these run scripts exists."
    exit 1
}

Write-Host ""
Write-Host "Setup completed successfully!"
Write-Host ""
Write-Host "Next steps:"
Write-Host "1. Get your Gemini API key from: https://makersuite.google.com/app/apikey"
Write-Host "2. Configure Claude Desktop with your API key (see README.md)"
Write-Host "3. Restart Claude Desktop"
Write-Host ""
Write-Host "Note: The virtual environment has been activated for this session."
Write-Host "The run_gemini.ps1 script will automatically activate it when needed."