#!/bin/bash

# Bandit Security Scanner - Enhanced Interactive Educational Tutorial
# Matches the interactive style and educational depth of the older system

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
SHIELD="🔒"
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
    printf " $SHIELD %-*s $SHIELD\n" $((width-6)) "$title"
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

# Function to display issue summary table
show_issue_table() {
    local issues_file="$1"
    
    if [[ -f "$issues_file" ]]; then
        cat "$issues_file"
    else
        echo "No issue summary available"
    fi
}

# Function to run bandit and capture results
run_bandit_scan() {
    local target_file="$1"
    local output_format="${2:-txt}"
    
    echo "${GEAR} Scanning for security issues..."
    echo ""
    
    # Run bandit and capture output
    local temp_output=$(mktemp)
    bandit -f "$output_format" "$target_file" > "$temp_output" 2>&1
    local exit_code=$?
    
    # Parse and display results
    if [[ $exit_code -eq 0 ]]; then
        echo "${CHECK_MARK} ${CHECK_MARK} No security issues found!"
        echo "${GREEN}🎉 All security checks passed!${NC}"
    else
        # Count issues by severity
        local high_count=$(grep -c "High" "$temp_output" || echo "0")
        local medium_count=$(grep -c "Medium" "$temp_output" || echo "0") 
        local low_count=$(grep -c "Low" "$temp_output" || echo "0")
        local total_issues=$((high_count + medium_count + low_count))
        
        echo "${WARNING} Found $total_issues security issues:"
        echo "  ${FIRE} High severity:   $high_count issues"
        echo "  ${ORANGE} Medium severity: $medium_count issues"
        echo "  ${YELLOW_CIRCLE} Low severity:    $low_count issues"
        echo ""
        
        # Show confidence levels
        local high_conf=$(grep -c "Confidence: High" "$temp_output" || echo "0")
        local med_conf=$(grep -c "Confidence: Medium" "$temp_output" || echo "0")
        local low_conf=$(grep -c "Confidence: Low" "$temp_output" || echo "0")
        
        echo "  Confidence levels:"
        echo "  ${TARGET} High confidence:   $high_conf issues"
        echo "  ${TARGET} Medium confidence: $med_conf issues"
        echo "  ${TARGET} Low confidence:    $low_conf issues"
    fi
    
    # Save output for later use
    cp "$temp_output" "/tmp/bandit_results.txt"
    rm "$temp_output"
    
    return $exit_code
}

# Function to explain security issues with examples
explain_security_issues() {
    echo "${INFO} Let's examine each type of security issue found with specific code examples:"
    echo ""
    
    # Hardcoded passwords
    echo "${SHIELD} ${BOLD}HARDCODED PASSWORDS (B105)${NC}"
    echo "───────────────────────────────────────────"
    echo "${CROSS_MARK} Problematic code (line 17-18):"
    echo "   DATABASE_PASSWORD = \"super_secret_123\"  # BAD: Exposed in code"
    echo "   API_KEY = \"sk-1234567890abcdef\""
    echo ""
    echo "${CHECK_MARK} Secure alternative:"
    echo "   DATABASE_PASSWORD = os.getenv(\"DATABASE_PASSWORD\")"
    echo "   if not DATABASE_PASSWORD:"
    echo "       raise ValueError(\"DATABASE_PASSWORD environment variable required\")"
    echo ""
    echo "${INFO} Why this matters: Hardcoded secrets can be discovered by anyone with code access"
    pause
    
    # Command injection
    echo "${FIRE} ${BOLD}COMMAND INJECTION (B602/B605)${NC}"
    echo "───────────────────────────────────────────"
    echo "${CROSS_MARK} Problematic code (line 37):"
    echo "   os.system(command)  # BAD: Can execute arbitrary commands"
    echo ""
    echo "${CHECK_MARK} Secure alternative:"
    echo "   # Use subprocess with list arguments"
    echo "   subprocess.run([\"cat\", safe_filename], check=True)"
    echo "   # Or better yet, use Python built-ins:"
    echo "   with open(safe_filename, \"r\") as f:"
    echo "       content = f.read()"
    echo ""
    echo "${INFO} Why this matters: User input like '; rm -rf /' could destroy the system"
    pause
    
    # Unsafe deserialization
    echo "${ORANGE} ${BOLD}UNSAFE DESERIALIZATION (B301)${NC}"
    echo "───────────────────────────────────────────"
    echo "${CROSS_MARK} Problematic code (line 70):"
    echo "   user_data = pickle.loads(untrusted_data)  # BAD: Can execute code"
    echo ""
    echo "${CHECK_MARK} Secure alternative:"
    echo "   import json"
    echo "   user_data = json.loads(untrusted_data)  # Safe for data only"
    echo "   # Or validate the source before unpickling"
    echo ""
    echo "${INFO} Why this matters: Malicious pickle data can run arbitrary Python code"
    pause
    
    # Weak random generation
    echo "${YELLOW_CIRCLE} ${BOLD}WEAK RANDOM GENERATION (B311)${NC}"
    echo "───────────────────────────────────────────"
    echo "${CROSS_MARK} Problematic code (line 43):"
    echo "   session_token = random.randint(1000000, 9999999)  # BAD: Predictable"
    echo "   api_key = str(random.random())"
    echo ""
    echo "${CHECK_MARK} Secure alternative:"
    echo "   import secrets"
    echo "   session_token = secrets.randbelow(9000000) + 1000000"
    echo "   api_key = secrets.token_urlsafe(32)"
    echo ""
    echo "${INFO} Why this matters: Predictable tokens can be guessed by attackers"
    pause
}

# Function to explain false positives
explain_false_positives() {
    echo "${BOLD}🏷️  FALSE POSITIVES DETECTED${NC}"
    echo "───────────────────────────────────────────"
    echo "The code contains examples of false positives that bandit flagged:"
    echo ""
    
    echo "${TARGET} ${BOLD}B101 - Assert Statement:${NC}"
    echo "   ${CROSS_MARK} Flagged: assert debug_mode, \"Debug mode should be enabled...\""
    echo "   ${CHECK_MARK} Reality: Legitimate development assert, safe to suppress"
    echo "   ${GEAR} Fix: # nosec B101 - legitimate development assert"
    echo ""
    
    echo "${TARGET} ${BOLD}B603/B607 - Subprocess Usage:${NC}"
    echo "   ${CROSS_MARK} Flagged: subprocess.run([\"/usr/bin/tail\", \"-10\", log_file])"
    echo "   ${CHECK_MARK} Reality: Safe subprocess - no user input, controlled command"
    echo "   ${GEAR} Fix: # nosec B603 B607 - safe subprocess usage, no user input"
    echo ""
    
    echo "${INFO} ${BOLD}When to use #nosec:${NC}"
    echo "   ${CHECK_MARK} You've analyzed the code and confirmed it's actually safe"
    echo "   ${CHECK_MARK} The flagged code serves a legitimate purpose"
    echo "   ${CHECK_MARK} You include a comment explaining WHY it's safe"
    echo ""
    
    echo "${WARNING} ${BOLD}When NOT to use #nosec:${NC}"
    echo "   ${CROSS_MARK} You're unsure if the code is safe"
    echo "   ${CROSS_MARK} There's a safer alternative available"
    echo "   ${CROSS_MARK} The code handles untrusted user input"
    pause
}

# Main tutorial function
run_tutorial() {
    clear
    
    # Header
    print_section "🔒 Bandit Security Scanner - Educational Mode"
    
    # Step 1: Examine bad code
    print_subsection "Step 1: Examining Code with Security Issues"
    
    echo "${INFO} File: tools/bandit/bad_example.py"
    echo ""
    echo "This file intentionally contains security vulnerabilities for learning:"
    echo "• Hardcoded passwords"
    echo "• SQL injection vulnerabilities" 
    echo "• Command injection risks"
    echo "• Insecure random number generation"
    echo "• Unsafe deserialization"
    echo "• Insecure temporary files"
    echo "• False positive examples"
    echo ""
    
    if ask_yn "View the problematic code?" "y"; then
        show_code "$BAD_EXAMPLE" 1 50
        pause
    fi
    
    # Step 2: Show configuration
    print_subsection "Step 2: Understanding Bandit Configuration"
    
    echo "${INFO} Configuration file: tools/bandit/config.yaml"
    echo ""
    echo "Key configuration options:"
    echo "• Format: Text output for readability"
    echo "• Recursive scanning of Python files"
    echo "• Severity levels: LOW, MEDIUM, HIGH"
    echo "• Confidence levels: LOW, MEDIUM, HIGH"
    echo ""
    
    if ask_yn "View the configuration details?" "n"; then
        if [[ -f "$CONFIG_FILE" ]]; then
            cat "$CONFIG_FILE"
        else
            echo "Configuration file not found"
        fi
        pause
    fi
    
    # Step 3: Run security scan
    print_subsection "Step 3: Running Bandit Security Scan"
    
    echo "${INFO} Command: bandit -f txt $BAD_EXAMPLE"
    echo ""
    echo "Options explained:"
    echo "• -f txt: Output format (text for readability)"
    echo "• Shows all issues (including false positives for educational purposes)"
    echo ""
    
    # Run the scan
    run_bandit_scan "$BAD_EXAMPLE" "txt"
    echo ""
    
    # Create and show issue summary table
    echo "Issue Summary:"
    # Create a simple table format
    cat << 'EOF'
┌──────────┬────────────┬──────────────────────────────────────────┬──────────────────────────────────────────────────────────────┐
│ Severity │ Confidence │ Issue ID                                 │ Description                                                      │
├──────────┼────────────┼──────────────────────────────────────────┼──────────────────────────────────────────────────────────────┤
│ 🟡 Low   │ High       │ B404:blacklist                           │ Consider possible security implications associated with pickle   │
│ 🔴 High  │ High       │ B602:subprocess_popen_with_shell         │ Starting a process with a shell, possible injection detected    │
│ 🟡 Low   │ High       │ B311:blacklist                           │ Standard pseudo-random generators not suitable for security     │
│ 🟠 Med   │ High       │ B301:blacklist                           │ Pickle can be unsafe when used to deserialize untrusted data    │
│ 🟡 Low   │ Medium     │ B105:hardcoded_password_string           │ Possible hardcoded password detected                            │
│ 🟠 Med   │ Medium     │ B108:hardcoded_tmp_directory             │ Probable insecure usage of temp file/directory                  │
│ 🟡 Low   │ High       │ B101:assert_used                         │ Use of assert detected (disabled in optimized mode)            │
│ 🟡 Low   │ High       │ B603:subprocess_without_shell_equals     │ subprocess call - check for execution of untrusted input        │
└──────────┴────────────┴──────────────────────────────────────────┴──────────────────────────────────────────────────────────────┘
EOF
    echo ""
    pause
    
    # Step 4: Understanding and fixing issues
    print_subsection "Step 4: Understanding and Fixing Security Issues"
    
    if ask_yn "View specific fixes for each type of security issue?" "y"; then
        explain_security_issues
        explain_false_positives
    fi
    
    # Step 5: Compare with secure version
    print_subsection "Step 5: Comparing with Secure Version"
    
    echo "${INFO} Fixed file: tools/bandit/good_example.py"
    echo ""
    run_bandit_scan "$GOOD_EXAMPLE" "txt"
    echo ""
    
    if ask_yn "View key differences between bad and fixed code?" "y"; then
        echo ""
        echo "${INFO} Key Security Fixes Applied:"
        echo ""
        echo "1. Hardcoded Passwords → Environment Variables"
        echo "   BAD:  password = 'admin123'"
        echo "   GOOD: password = os.environ.get('DB_PASSWORD')"
        echo ""
        echo "2. SQL Injection → Parameterized Queries"
        echo "   BAD:  query = f'SELECT * FROM users WHERE id = {user_id}'"
        echo "   GOOD: cursor.execute('SELECT * FROM users WHERE id = ?', (user_id,))"
        echo ""
        echo "3. Command Injection → Safe Subprocess"
        echo "   BAD:  os.system(f'ls {user_input}')"
        echo "   GOOD: subprocess.run(['ls', user_input], check=True)"
        echo ""
        echo "4. Weak Randomness → Cryptographic Random"
        echo "   BAD:  import random; token = random.randint(1000, 9999)"
        echo "   GOOD: import secrets; token = secrets.token_hex(16)"
        echo ""
        echo "5. Unsafe Deserialization → Safe Alternatives"
        echo "   BAD:  pickle.loads(user_input)"
        echo "   GOOD: json.loads(user_input)  # or avoid entirely"
        echo ""
        echo "6. False Positives → Proper #nosec Usage"
        echo "   GOOD: subprocess.run([...])  # nosec B603 - safe subprocess usage"
        pause
    fi
    
    # Educational resources
    print_subsection "${BOOK} Learn More About Python Security"
    
    echo "${LINK} Bandit Documentation: https://bandit.readthedocs.io/"
    echo "${LINK} Python Security Guide: https://python-security.readthedocs.io/"
    echo "${LINK} OWASP Python Security: https://owasp.org/www-project-python-security/"
    echo ""
    echo "${INFO} ${INFO} These resources explain Python-specific security vulnerabilities in detail"
    echo ""
    
    # Conclusion
    print_section "🎓 Tutorial Complete - Security Knowledge Gained!"
    echo "${CHECK_MARK} You've learned how to:"
    echo "• Identify common Python security vulnerabilities"
    echo "• Use bandit to scan for security issues"
    echo "• Fix security problems with secure alternatives"
    echo "• Handle false positives appropriately"
    echo "• Apply security best practices in Python code"
    echo ""
    echo "${SHIELD} ${BOLD}Remember: Security is an ongoing process, not a one-time check!${NC}"
    echo ""
}

# Check if bandit is installed
if ! command -v bandit &> /dev/null; then
    echo "${CROSS_MARK} Bandit is not installed. Please run: pip install bandit"
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