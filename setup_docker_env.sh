#!/usr/bin/env bash
# Setup .env for Gemini MCP Server Docker (Bash)
set -e

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

CURRENT_DIR="$(pwd)"

# Check if .env already exists
if [ -f .env ]; then
    echo -e "${YELLOW}⚠️  .env file already exists! Skipping creation.${NC}"
    echo
else
    if [ -n "$GEMINI_API_KEY" ]; then
        API_KEY_VALUE="$GEMINI_API_KEY"
        echo -e "${GREEN}✅ Found existing GEMINI_API_KEY in environment${NC}"
    else
        API_KEY_VALUE="your-gemini-api-key-here"
    fi
    cat > .env <<EOF
# Gemini MCP Server Docker Environment Configuration
# Generated on $(date)

# Your Gemini API key (get one from https://makersuite.google.com/app/apikey)
# IMPORTANT: Replace this with your actual API key
GEMINI_API_KEY=$API_KEY_VALUE
EOF
    echo -e "${GREEN}✅ Created .env file${NC}"
    echo
fi

echo "Next steps:"
if [ "$API_KEY_VALUE" = "your-gemini-api-key-here" ]; then
    echo "1. Edit .env and replace 'your-gemini-api-key-here' with your actual Gemini API key"
    echo "2. Copy this configuration to your Claude Desktop config:"
else
    echo "1. Copy this configuration to your Claude Desktop config:"
fi
echo
cat <<EOC
===== COPY BELOW THIS LINE =====
{
  "mcpServers": {
    "gemini": {
      "command": "docker",
      "args": [
        "run",
        "--rm",
        "-i",
        "--env-file", "$CURRENT_DIR/.env",
        "-e", "WORKSPACE_ROOT=\$HOME",
        "-v", "\$HOME:/workspace:ro",
        "gemini-mcp-server:latest"
      ]
    }
  }
}
===== COPY ABOVE THIS LINE =====
EOC
echo
cat <<EOM
Config file location:
  macOS: ~/Library/Application Support/Claude/claude_desktop_config.json
  Linux: ~/.config/Claude/claude_desktop_config.json

Note: This configuration mounts your home directory (\$HOME).
Docker can access any file within your home directory.

If you want to restrict access to a specific directory:
Change both the mount (-v) and WORKSPACE_ROOT to match:
Example: -v "$CURRENT_DIR:/workspace:ro" and WORKSPACE_ROOT=$CURRENT_DIR
The container will automatically use /workspace as the sandbox boundary.
EOM 