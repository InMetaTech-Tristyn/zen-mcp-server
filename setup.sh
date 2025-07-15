#!/usr/bin/env bash
# Gemini MCP Server Setup Script (Bash)
set -e

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

function echo_success() { echo -e "${GREEN}$1${NC}"; }
function echo_error() { echo -e "${RED}$1${NC}"; }
function echo_warn() { echo -e "${YELLOW}$1${NC}"; }

# Print header
echo -e "🚀 Gemini MCP Server Setup"
echo -e "========================="

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

# Check if python is installed
if ! command -v python &> /dev/null; then
    echo_error "❌ Error: Python is not installed."
    echo_error "Please install Python 3.10 or higher from https://python.org"
    exit 1
fi

# Check Python version
PY_VERSION=$(python --version 2>&1)
if [[ $PY_VERSION =~ Python\ ([0-9]+)\.([0-9]+) ]]; then
    MAJOR=${BASH_REMATCH[1]}
    MINOR=${BASH_REMATCH[2]}
    if (( MAJOR < 3 || (MAJOR == 3 && MINOR < 10) )); then
        echo_error "❌ Error: Python 3.10 or higher is required (you have Python $MAJOR.$MINOR)"
        exit 1
    fi
else
    echo_error "❌ Error: Could not determine Python version."
    exit 1
fi

# Check if venv exists
if [ -d "venv" ]; then
    echo_success "✓ Virtual environment already exists"
else
    echo -e "📦 Creating virtual environment..."
    python -m venv venv
    if [ $? -ne 0 ]; then
        echo_error "❌ Error: Failed to create virtual environment"
        exit 1
    fi
    echo_success "✓ Virtual environment created"
fi

# Activate virtual environment
source venv/bin/activate

# Upgrade pip
python -m pip install --upgrade pip

# Install requirements
python -m pip install -r requirements.txt
if [ $? -ne 0 ]; then
    echo_error "❌ Error: Failed to install dependencies"
    exit 1
fi

# Check for run_gemini.sh script
if [ ! -f "run_gemini.sh" ]; then
    echo_error "\u274c Error: run_gemini.sh script not found in $SCRIPT_DIR."
    echo_error "Please ensure the run_gemini.sh script exists."
    exit 1
fi

# Ensure run_gemini.sh is executable
if [ ! -x "run_gemini.sh" ]; then
    chmod +x run_gemini.sh
    echo_success "Made run_gemini.sh executable."
fi

echo
echo_success "✅ Setup completed successfully!"
echo
cat <<EOM
Next steps:
1. Get your Gemini API key from: https://makersuite.google.com/app/apikey
2. Configure Claude Desktop with your API key (see README.md)
3. Restart Claude Desktop

Note: The virtual environment has been activated for this session.
The run_gemini.sh script will automatically activate it when needed.
EOM 