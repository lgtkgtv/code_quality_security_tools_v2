#!/bin/bash

# Flake8 Style Checker - Enhanced Interactive Educational Tutorial
# Adapted from the template for PEP8 style checking

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
RULER="📏"
FIRE="🔴"
ORANGE="🟠"
YELLOW_CIRCLE="🟡"
TARGET="🎯"
BOOK="📚"
LINK="🔗"

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
    printf " $RULER %-*s $RULER\n" $((width-6)) "$title"
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

# Function to run flake8 and capture results
run_flake8_scan() {
    local target_file="$1"
    
    echo "${GEAR} Checking code style with flake8..."
    echo ""
    
    # Run flake8 and capture output
    local temp_output=$(mktemp)
    flake8 "$target_file" > "$temp_output" 2>&1
    local exit_code=$?
    local issue_count=$(wc -l < "$temp_output")
    
    # Parse and display results
    if [[ $exit_code -eq 0 ]]; then
        echo "${CHECK_MARK} ${CHECK_MARK} No style issues found!"
        echo "${GREEN}🎉 Code follows PEP8 guidelines perfectly!${NC}"
    else
        echo "${WARNING} Found $issue_count style issues:"
        echo ""
        
        # Categorize issues by type
        local import_issues=$(grep -c "^.*:.*:.*: E401\|F401" "$temp_output" || echo "0")
        local spacing_issues=$(grep -c "^.*:.*:.*: E[12][0-9][0-9]" "$temp_output" || echo "0")
        local line_length_issues=$(grep -c "^.*:.*:.*: E501" "$temp_output" || echo "0")
        local blank_line_issues=$(grep -c "^.*:.*:.*: E[23][0-9][0-9]" "$temp_output" || echo "0")
        local naming_issues=$(grep -c "^.*:.*:.*: E741\|N" "$temp_output" || echo "0")
        
        echo "Issue Categories:"
        echo "  ${FIRE} Import problems:   $import_issues issues"
        echo "  ${ORANGE} Spacing violations: $spacing_issues issues"
        echo "  ${YELLOW_CIRCLE} Line length issues: $line_length_issues issues"
        echo "  ${TARGET} Blank line errors: $blank_line_issues issues"
        echo "  ${PURPLE} Naming problems:  $naming_issues issues"
        echo ""
        
        # Show first 10 issues as examples
        echo "Example issues (first 10):"
        head -10 "$temp_output"
        if [[ $issue_count -gt 10 ]]; then
            echo "... and $((issue_count - 10)) more issues"
        fi
    fi
    
    # Save output for later use
    cp "$temp_output" "/tmp/flake8_results.txt"
    rm "$temp_output"
    
    return $exit_code
}

# Function to explain PEP8 issues with examples
explain_style_issues() {
    echo "${INFO} Let's examine the most common PEP8 style violations:"
    echo ""
    
    # Import issues
    echo "${RULER} ${BOLD}IMPORT ORGANIZATION (E401, F401)${NC}"
    echo "───────────────────────────────────────────"
    echo "${CROSS_MARK} Problematic code:"
    echo "   import os,sys,re  # E401: Multiple imports on one line"
    echo "   import unused_module  # F401: Imported but unused"
    echo ""
    echo "${CHECK_MARK} Proper style:"
    echo "   import os"
    echo "   import re"
    echo "   import sys"
    echo "   # Remove unused imports entirely"
    echo ""
    echo "${INFO} Why this matters: Clear imports improve code readability and maintainability"
    pause
    
    # Spacing issues
    echo "${ORANGE} ${BOLD}SPACING AND OPERATORS (E2xx)${NC}"
    echo "───────────────────────────────────────────"
    echo "${CROSS_MARK} Problematic code:"
    echo "   def function(param1,param2):  # E201: Missing space after comma"
    echo "       x=1+2*3  # E225: Missing whitespace around operators"
    echo "       y = [ 1,2,3 ]  # E201, E202: Extra spaces in brackets"
    echo ""
    echo "${CHECK_MARK} Proper style:"
    echo "   def function(param1, param2):"
    echo "       x = 1 + 2 * 3"
    echo "       y = [1, 2, 3]"
    echo ""
    echo "${INFO} Why this matters: Consistent spacing makes code easier to read"
    pause
    
    # Line length issues
    echo "${YELLOW_CIRCLE} ${BOLD}LINE LENGTH LIMITS (E501)${NC}"
    echo "───────────────────────────────────────────"
    echo "${CROSS_MARK} Problematic code:"
    echo "   # Lines over 79 characters are flagged"
    echo "   very_long_function_call_with_many_parameters(param1, param2, param3, param4, param5)"
    echo ""
    echo "${CHECK_MARK} Proper style:"
    echo "   # Break long lines properly"
    echo "   very_long_function_call_with_many_parameters("
    echo "       param1, param2, param3,"
    echo "       param4, param5"
    echo "   )"
    echo ""
    echo "${INFO} Why this matters: Shorter lines fit on all screens and improve readability"
    pause
    
    # Blank line issues
    echo "${TARGET} ${BOLD}BLANK LINE CONVENTIONS (E3xx)${NC}"
    echo "───────────────────────────────────────────"
    echo "${CROSS_MARK} Problematic code:"
    echo "   def function1():"
    echo "       pass"
    echo "   def function2():  # E302: Missing 2 blank lines"
    echo ""
    echo "${CHECK_MARK} Proper style:"
    echo "   def function1():"
    echo "       pass"
    echo ""
    echo ""
    echo "   def function2():  # Two blank lines before top-level functions"
    echo ""
    echo "${INFO} Why this matters: Blank lines provide visual structure to code"
    pause
    
    # Variable naming
    echo "${PURPLE} ${BOLD}VARIABLE NAMING (E741)${NC}"
    echo "───────────────────────────────────────────"
    echo "${CROSS_MARK} Problematic code:"
    echo "   l = [1, 2, 3]  # E741: 'l' looks like '1'"
    echo "   O = 0          # E741: 'O' looks like '0'"
    echo "   I = 1          # E741: 'I' looks like '1'"
    echo ""
    echo "${CHECK_MARK} Proper style:"
    echo "   items = [1, 2, 3]  # Clear, descriptive names"
    echo "   count = 0"
    echo "   index = 1"
    echo ""
    echo "${INFO} Why this matters: Clear variable names prevent confusion and errors"
    pause
}

# Main tutorial function
run_tutorial() {
    clear
    
    # Header
    print_section "📏 Flake8 Style Checker - Educational Mode"
    
    # Step 1: Examine bad code
    print_subsection "Step 1: Examining Code with Style Issues"
    
    echo "${INFO} File: tools/flake8/bad_example.py"
    echo ""
    echo "This file intentionally contains PEP8 style violations for learning:"
    echo "• Import organization problems"
    echo "• Spacing and whitespace issues"
    echo "• Line length violations"
    echo "• Missing blank lines"
    echo "• Variable naming problems"
    echo "• Unused imports and variables"
    echo ""
    
    if ask_yn "View the problematic code?" "y"; then
        show_code "$BAD_EXAMPLE" 1 50
        pause
    fi
    
    # Step 2: Show configuration
    print_subsection "Step 2: Understanding Flake8 Configuration"
    
    echo "${INFO} Configuration file: tools/flake8/config.yaml"
    echo ""
    echo "Key configuration options:"
    echo "• Max line length (default: 79 characters)"
    echo "• Ignored error codes"
    echo "• Excluded directories"
    echo "• Output formatting options"
    echo ""
    
    if ask_yn "View the configuration details?" "n"; then
        if [[ -f "$CONFIG_FILE" ]]; then
            cat "$CONFIG_FILE"
        else
            echo "Configuration file not found"
        fi
        pause
    fi
    
    # Step 3: Run style check
    print_subsection "Step 3: Running Flake8 Style Analysis"
    
    echo "${INFO} Command: flake8 bad_example.py"
    echo ""
    echo "Options explained:"
    echo "• Checks PEP8 style compliance"
    echo "• Reports line-by-line violations"
    echo "• Shows error codes for each issue"
    echo ""
    
    # Run the scan
    run_flake8_scan "$BAD_EXAMPLE"
    echo ""
    pause
    
    # Step 4: Understanding and fixing issues
    print_subsection "Step 4: Understanding and Fixing Style Issues"
    
    if ask_yn "View specific fixes for each type of style issue?" "y"; then
        explain_style_issues
    fi
    
    # Step 5: Compare with fixed version
    print_subsection "Step 5: Comparing with Fixed Version"
    
    echo "${INFO} Fixed file: tools/flake8/good_example.py"
    echo ""
    run_flake8_scan "$GOOD_EXAMPLE"
    echo ""
    
    if ask_yn "View key differences between bad and fixed code?" "y"; then
        echo ""
        echo "${INFO} Key Style Fixes Applied:"
        echo ""
        echo "1. Import Organization → Proper Separation"
        echo "   BAD:  import os,sys,re"
        echo "   GOOD: import os"
        echo "         import re"
        echo "         import sys"
        echo ""
        echo "2. Operator Spacing → Consistent Whitespace"
        echo "   BAD:  x=1+2*3"
        echo "   GOOD: x = 1 + 2 * 3"
        echo ""
        echo "3. Line Length → Proper Breaking"
        echo "   BAD:  very_long_function_call(param1, param2, param3, param4, param5)"
        echo "   GOOD: very_long_function_call("
        echo "             param1, param2, param3,"
        echo "             param4, param5"
        echo "         )"
        echo ""
        echo "4. Blank Lines → Visual Structure"
        echo "   BAD:  Missing blank lines between functions"
        echo "   GOOD: Two blank lines before top-level definitions"
        echo ""
        echo "5. Variable Names → Clear Identifiers"
        echo "   BAD:  l = [1, 2, 3]  # Ambiguous 'l'"
        echo "   GOOD: items = [1, 2, 3]  # Clear purpose"
        pause
    fi
    
    # Educational resources
    print_subsection "${BOOK} Learn More About Python Style"
    
    echo "${LINK} PEP8 Style Guide: https://pep8.org/"
    echo "${LINK} Flake8 Documentation: https://flake8.pycqa.org/"
    echo "${LINK} Python Code Quality: https://realpython.com/python-code-quality/"
    echo ""
    echo "${INFO} ${INFO} These resources provide comprehensive PEP8 style guidelines"
    echo ""
    
    # Conclusion
    print_section "🎓 Tutorial Complete - Style Mastery Achieved!"
    echo "${CHECK_MARK} You've learned how to:"
    echo "• Identify common PEP8 style violations"
    echo "• Use flake8 to check code style automatically"
    echo "• Fix style issues following Python best practices"
    echo "• Apply consistent formatting for better readability"
    echo "• Understand why style matters for code maintainability"
    echo ""
    echo "${RULER} ${BOLD}Remember: Good style makes code a joy to read and maintain!${NC}"
    echo ""
}

# Check if flake8 is installed
if ! command -v flake8 &> /dev/null; then
    echo "${CROSS_MARK} Flake8 is not installed. Please run: pip install flake8"
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