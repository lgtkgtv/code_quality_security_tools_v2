#!/bin/bash

# Generic Interactive Educational Tutorial Template
# This template can be adapted for any code quality tool

# Color definitions for enhanced presentation
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
BOLD='\033[1m'
NC='\033[0m' # No Color

# Emoji definitions for visual appeal
CHECK_MARK="✅"
CROSS_MARK="❌"
WARNING="⚠️"
INFO="ℹ️"
GEAR="⚙️"
TOOL_EMOJI="🔧"  # Override this in specific tool implementations
FIRE="🔴"
ORANGE="🟠"
YELLOW_CIRCLE="🟡"
TARGET="🎯"
BOOK="📚"
LINK="🔗"

# Tool-specific configuration - Override these in each tool's version
TOOL_NAME="Generic Tool"
TOOL_DESCRIPTION="Generic code quality tool"
TOOL_COMMAND="tool"
TOOL_EMOJI="🔧"
TOOL_DOCS_URL="https://example.com"
TOOL_CATEGORY="quality"

# Tool paths
TOOL_DIR="$(dirname "$0")"
BAD_EXAMPLE="$TOOL_DIR/bad_example.py"
GOOD_EXAMPLE="$TOOL_DIR/good_example.py"
CONFIG_FILE="$TOOL_DIR/config.yaml"

# Function to pause and wait for user input
pause() {
    echo ""
    read -p "Press Enter to continue..."
    echo ""
}

# Function to ask yes/no questions
ask_yn() {
    local prompt="$1"
    local default="${2:-n}"
    
    if [[ "$default" == "y" ]]; then
        prompt="$prompt [Y/n]: "
    else
        prompt="$prompt [y/N]: "
    fi
    
    read -p "$prompt" response
    response=${response:-$default}
    
    [[ "$response" =~ ^[Yy] ]]
}

# Function to display code with line numbers
show_code() {
    local file="$1"
    local start_line="${2:-1}"
    local end_line="${3:-50}"
    
    echo ""
    if [[ -f "$file" ]]; then
        cat -n "$file" | sed -n "${start_line},${end_line}p"
    else
        echo "File not found: $file"
    fi
    echo ""
}

# Function to create bordered sections
print_section() {
    local title="$1"
    local width=80
    
    echo ""
    printf "═%.0s" $(seq 1 $width)
    echo ""
    printf " $TOOL_EMOJI %-*s $TOOL_EMOJI\n" $((width-6)) "$title"
    printf "═%.0s" $(seq 1 $width)
    echo ""
    echo ""
}

# Function to create subsection headers
print_subsection() {
    local title="$1"
    echo ""
    echo "── $title ──"
    echo ""
}

# Function to run tool and capture results
run_tool_scan() {
    local target_file="$1"
    local tool_args="${2:-}"
    
    echo "${GEAR} Analyzing code with $TOOL_NAME..."
    echo ""
    
    # Run tool and capture output
    local temp_output=$(mktemp)
    $TOOL_COMMAND $tool_args "$target_file" > "$temp_output" 2>&1
    local exit_code=$?
    
    # Display results based on exit code
    if [[ $exit_code -eq 0 ]]; then
        echo "${CHECK_MARK} ${CHECK_MARK} No issues found!"
        echo "${GREEN}🎉 All checks passed!${NC}"
    else
        # Tool-specific result parsing
        parse_tool_results "$temp_output"
    fi
    
    # Save output for later use
    cp "$temp_output" "/tmp/${TOOL_NAME}_results.txt"
    rm "$temp_output"
    
    return $exit_code
}

# Function to parse tool-specific results - Override this in each tool
parse_tool_results() {
    local results_file="$1"
    echo "${WARNING} Issues found - see detailed output:"
    cat "$results_file"
}

# Function to explain tool-specific issues - Override this in each tool
explain_issues() {
    echo "${INFO} This tool helps identify and fix code quality issues."
    echo "Review the output above to understand what needs to be fixed."
}

# Function to show tool-specific fixes - Override this in each tool
show_fixes() {
    echo "${INFO} Key improvements made in the fixed version:"
    echo "• Code now follows best practices"
    echo "• Issues have been resolved"
    echo "• Code quality has been improved"
}

# Function to get tool-specific resources - Override this in each tool
get_resources() {
    echo "${LINK} Documentation: $TOOL_DOCS_URL"
    echo "${LINK} Best Practices: https://pep8.org/"
}

# Main tutorial function
run_tutorial() {
    clear
    
    # Header
    print_section "$TOOL_EMOJI $TOOL_NAME - Educational Mode"
    
    # Step 1: Examine bad code
    print_subsection "Step 1: Examining Code with Issues"
    
    echo "${INFO} File: $(basename $BAD_EXAMPLE)"
    echo ""
    echo "This file intentionally contains issues for learning purposes."
    get_issue_description  # Override this function in each tool
    echo ""
    
    if ask_yn "View the problematic code?" "y"; then
        show_code "$BAD_EXAMPLE" 1 50
        pause
    fi
    
    # Step 2: Show configuration
    print_subsection "Step 2: Understanding $TOOL_NAME Configuration"
    
    if [[ -f "$CONFIG_FILE" ]]; then
        echo "${INFO} Configuration file: $(basename $CONFIG_FILE)"
        echo ""
        get_config_description  # Override this function in each tool
        echo ""
        
        if ask_yn "View the configuration details?" "n"; then
            cat "$CONFIG_FILE"
            pause
        fi
    fi
    
    # Step 3: Run analysis
    print_subsection "Step 3: Running $TOOL_NAME Analysis"
    
    echo "${INFO} Command: $TOOL_COMMAND $(basename $BAD_EXAMPLE)"
    echo ""
    get_command_description  # Override this function in each tool
    echo ""
    
    # Run the scan
    run_tool_scan "$BAD_EXAMPLE"
    echo ""
    pause
    
    # Step 4: Understanding and fixing issues
    print_subsection "Step 4: Understanding and Fixing Issues"
    
    if ask_yn "View detailed explanations for each issue type?" "y"; then
        explain_issues
        pause
    fi
    
    # Step 5: Compare with secure version
    print_subsection "Step 5: Comparing with Fixed Version"
    
    echo "${INFO} Fixed file: $(basename $GOOD_EXAMPLE)"
    echo ""
    run_tool_scan "$GOOD_EXAMPLE"
    echo ""
    
    if ask_yn "View key differences between problematic and fixed code?" "y"; then
        echo ""
        show_fixes
        pause
    fi
    
    # Educational resources
    print_subsection "${BOOK} Learn More About $TOOL_NAME"
    
    get_resources
    echo ""
    echo "${INFO} ${INFO} These resources provide comprehensive guidance for using $TOOL_NAME effectively"
    echo ""
    
    # Conclusion
    print_section "🎓 Tutorial Complete - Knowledge Gained!"
    echo "${CHECK_MARK} You've learned how to:"
    echo "• Identify common code quality issues"
    echo "• Use $TOOL_NAME to analyze your code"
    echo "• Fix issues using best practices"
    echo "• Apply $TOOL_CATEGORY standards effectively"
    echo ""
    echo "${TOOL_EMOJI} ${BOLD}Remember: Code quality is an ongoing practice!${NC}"
    echo ""
}

# Override these functions in tool-specific implementations
get_issue_description() {
    echo "Various code quality issues that $TOOL_NAME can detect and help fix."
}

get_config_description() {
    echo "Key configuration options:"
    echo "• Analysis settings"
    echo "• Output formatting"
    echo "• Rule configuration"
}

get_command_description() {
    echo "Options explained:"
    echo "• Analyzes the specified file"
    echo "• Reports issues found"
}

# Check if tool is installed
if ! command -v $TOOL_COMMAND &> /dev/null; then
    echo "${CROSS_MARK} $TOOL_NAME is not installed. Please install it first."
    exit 1
fi

# Check if example files exist
if [[ ! -f "$BAD_EXAMPLE" ]]; then
    echo "${CROSS_MARK} Bad example file not found: $BAD_EXAMPLE"
    exit 1
fi

if [[ ! -f "$GOOD_EXAMPLE" ]]; then
    echo "${CROSS_MARK} Good example file not found: $GOOD_EXAMPLE"
    exit 1
fi

# Run the tutorial
run_tutorial