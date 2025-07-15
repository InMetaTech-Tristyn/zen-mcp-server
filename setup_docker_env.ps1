# Setup .env for Gemini MCP Server Docker (PowerShell)
$CURRENT_DIR = Get-Location

# Check if .env already exists
if (Test-Path .env) {
    Write-Host "⚠️  .env file already exists! Skipping creation."
    Write-Host ""
} else {
    $API_KEY_VALUE = $env:GEMINI_API_KEY
    if (-not $API_KEY_VALUE) {
        $API_KEY_VALUE = "your-gemini-api-key-here"
    } else {
        Write-Host "✅ Found existing GEMINI_API_KEY in environment"
    }
    @(
        "# Gemini MCP Server Docker Environment Configuration"
        "# Generated on $(Get-Date)"
        ""
        "# Your Gemini API key (get one from https://makersuite.google.com/app/apikey)"
        "# IMPORTANT: Replace this with your actual API key"
        "GEMINI_API_KEY=$API_KEY_VALUE"
    ) | Set-Content .env
    Write-Host "✅ Created .env file"
    Write-Host ""
}

Write-Host "Next steps:"
if ($API_KEY_VALUE -eq "your-gemini-api-key-here") {
    Write-Host "1. Edit .env and replace 'your-gemini-api-key-here' with your actual Gemini API key"
    Write-Host "2. Copy this configuration to your Claude Desktop config:"
} else {
    Write-Host "1. Copy this configuration to your Claude Desktop config:"
}
Write-Host ""
Write-Host "===== COPY BELOW THIS LINE ====="
Write-Host "{"
Write-Host "  \"mcpServers\": {"
Write-Host "    \"gemini\": {"
Write-Host "      \"command\": \"docker\"," 
Write-Host "      \"args\": ["
Write-Host "        \"run\"," 
Write-Host "        \"--rm\"," 
Write-Host "        \"-i\"," 
Write-Host "        \"--env-file\", \"$CURRENT_DIR\.env\"," 
Write-Host "        \"-e\", \"WORKSPACE_ROOT=%USERPROFILE%\"," 
Write-Host "        \"-v\", \"%USERPROFILE%:/workspace:ro\"," 
Write-Host "        \"gemini-mcp-server:latest\""
Write-Host "      ]"
Write-Host "    }"
Write-Host "  }"
Write-Host "}"
Write-Host "===== COPY ABOVE THIS LINE ====="
Write-Host ""
Write-Host "Config file location:"
Write-Host "  macOS: ~/Library/Application Support/Claude/claude_desktop_config.json"
Write-Host "  Windows: %APPDATA%\Claude\claude_desktop_config.json"
Write-Host ""
Write-Host "Note: This configuration mounts your home directory (%USERPROFILE%)."
Write-Host "Docker can access any file within your home directory."
Write-Host ""
Write-Host "If you want to restrict access to a specific directory:"
Write-Host "Change both the mount (-v) and WORKSPACE_ROOT to match:"
Write-Host "Example: -v \"$CURRENT_DIR:/workspace:ro\" and WORKSPACE_ROOT=$CURRENT_DIR"
Write-Host "The container will automatically use /workspace as the sandbox boundary."