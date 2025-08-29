# Modular Tutorial System

This tutorial system has been refactored into a modular, extensible architecture that makes it easy to add new tools and modify existing functionality.

## Architecture Overview

```
code_quality_security_tools/
├── run_tutorial.sh           # Main orchestrator script
├── lib/                      # Reusable modules
│   ├── tutorial_helpers.sh   # Common functions (logging, formatting, etc.)
│   └── tool_runner.sh        # Tool execution and result processing
├── config/                   # Configuration files
│   └── tools.conf           # Tool definitions and settings
├── examples/                 # Example code files for demonstration
├── tests/                   # Test files
└── analysis_output/         # Generated reports and results
```

## Key Features

### 🔧 Easy Tool Addition
Adding a new tool requires minimal changes:

1. **Add tool to configuration** (config/tools.conf)
2. **Add result processor** (lib/tool_runner.sh)
3. **Update requirements** (requirements.txt)

### 📊 Comprehensive Reporting
- Standardized result processing
- Multiple output formats (markdown, JSON, console)
- Progress tracking and timing

### 🎨 Rich Formatting
- Consistent color scheme and icons
- Progress bars and status indicators
- Professional presentation

### 🚀 Multiple Execution Modes
- Interactive tutorial mode (default)
- Automated analysis mode
- Fix-only mode
- Help and usage information

## Adding a New Tool

### Step 1: Update Tool Configuration

Edit `config/tools.conf` and add your tool to the `TOOLS` array:

```bash
TOOLS=(
    # Existing tools...
    "your_tool|your_command_here|input_files|expected_issues|description"
)
```

Format explanation:
- `tool_name`: Name displayed to users
- `command`: Command to execute (can include options)
- `input_files`: Files/directories to analyze
- `expected_issues`: Number of expected issues (for pass/fail logic)
- `description`: Human-readable description

### Step 2: Add Result Processor

Edit `lib/tool_runner.sh` and add a processor function:

```bash
process_your_tool_result() {
    local output_file="$1"
    local exit_code="$2"
    local expected_issues="$3"
    
    # Parse tool output and determine status
    local issues=$(grep -c "error:" "$output_file" 2>/dev/null || echo "0")
    
    if [ "$issues" -eq 0 ]; then
        echo "pass|No issues found"
    elif [ "$issues" -le "$expected_issues" ]; then
        echo "warning|Found $issues issues (within expected range)"
    else
        echo "fail|Found $issues issues (expected ≤$expected_issues)"
    fi
}
```

Then add the case to `process_tool_result()`:

```bash
case "$tool_name" in
    # Existing cases...
    "your_tool")
        process_your_tool_result "$output_file" "$exit_code" "$expected_issues"
        ;;
esac
```

### Step 3: Update Requirements

Add your tool to `requirements.txt`:

```
your-tool-package>=1.0.0
```

### Step 4: Add Version Detection (Optional)

Update `get_tool_version()` in `lib/tutorial_helpers.sh`:

```bash
case "$tool" in
    # Existing cases...
    "your_tool")
        your_tool --version | cut -d' ' -f2
        ;;
esac
```

## Example: Adding Pylint

Here's a complete example of adding pylint:

### config/tools.conf
```bash
TOOLS=(
    # Existing tools...
    "pylint|pylint examples/ --output-format=text --reports=no|examples/|20|Static code analysis"
)
```

### lib/tool_runner.sh
```bash
process_pylint_result() {
    local output_file="$1"
    local exit_code="$2"
    local expected_issues="$3"
    
    local issues=$(grep -c ": " "$output_file" 2>/dev/null || echo "0")
    local errors=$(grep -c "E[0-9][0-9][0-9][0-9]:" "$output_file" 2>/dev/null || echo "0")
    local warnings=$(grep -c "W[0-9][0-9][0-9][0-9]:" "$output_file" 2>/dev/null || echo "0")
    
    if [ "$issues" -eq 0 ]; then
        echo "pass|No issues found"
    elif [ "$issues" -le "$expected_issues" ]; then
        echo "warning|Found $issues issues ($errors errors, $warnings warnings)"
    else
        echo "fail|Found $issues issues (expected ≤$expected_issues)"
    fi
}

# Add to process_tool_result() function:
case "$tool_name" in
    # Existing cases...
    "pylint")
        process_pylint_result "$output_file" "$exit_code" "$expected_issues"
        ;;
esac
```

### lib/tutorial_helpers.sh
```bash
case "$tool" in
    # Existing cases...
    "pylint")
        pylint --version | head -1 | cut -d' ' -f2
        ;;
esac
```

### requirements.txt
```
pylint>=2.15.0
```

## Configuration Options

The `config/tools.conf` file supports extensive customization:

```bash
# Tutorial settings
TUTORIAL_NAME="Your Custom Tutorial"
VENV_NAME="custom_venv"
OUTPUT_DIR="custom_output"

# Tool-specific configurations
declare -A TOOL_CONFIGS
TOOL_CONFIGS["your_tool"]="--custom-option --another-option"

# Thresholds
MAX_YOUR_TOOL_ISSUES=15

# Environment variables
export YOUR_TOOL_CONFIG="path/to/config"
```

## Helper Functions Available

The `lib/tutorial_helpers.sh` module provides many reusable functions:

### Logging Functions
```bash
log_info "Information message"
log_success "Success message"
log_warning "Warning message"
log_error "Error message"
log_step "Current step"
```

### Progress and Timing
```bash
start_timer
# ... do work ...
end_timer "Task description"

show_progress 3 10 "Processing files"
```

### File Operations
```bash
backup_file "important.py"
check_file "config.json" "Configuration file"
cleanup_temp_files
```

### Environment Checks
```bash
check_command "your_tool"
check_python_package "your_package"
setup_venv "venv_name" "requirements.txt"
```

## Testing Your Changes

1. **Syntax Check**: `bash -n run_tutorial.sh`
2. **Help Test**: `./run_tutorial.sh --help`
3. **Dry Run**: `echo "n" | ./run_tutorial.sh`
4. **Full Test**: `./run_tutorial.sh automated`

## Best Practices

### Tool Integration
- Use consistent exit codes (0 = success, non-zero = issues)
- Provide meaningful error messages
- Support both check and fix modes where applicable
- Handle missing files gracefully

### Configuration
- Use sensible defaults
- Document all configuration options
- Validate configuration at startup
- Provide clear error messages for misconfigurations

### Error Handling
- Always check command availability before execution
- Provide helpful error messages
- Clean up temporary files
- Exit gracefully on errors

### Documentation
- Update README when adding tools
- Document configuration options
- Provide examples for complex setups
- Include troubleshooting guidance

## Troubleshooting

### Common Issues

**Tool not found after adding**
```bash
# Ensure tool is in requirements.txt and installed
pip install your-tool-package
which your-tool
```

**Result parsing fails**
```bash
# Debug tool output format
your-tool examples/ > debug_output.txt
cat debug_output.txt  # Examine actual output format
```

**Configuration not loading**
```bash
# Check configuration syntax
bash -n config/tools.conf
source config/tools.conf && echo "Config OK"
```

**Permission errors**
```bash
# Ensure scripts are executable
chmod +x run_tutorial.sh lib/*.sh
```

This modular system makes it easy to maintain, extend, and customize the tutorial for different needs while maintaining a professional, consistent user experience.