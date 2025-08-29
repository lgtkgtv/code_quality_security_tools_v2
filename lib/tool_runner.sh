#!/bin/bash
# Tool Runner Module
# Provides standardized tool execution and result processing

# Source the helper library
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/tutorial_helpers.sh"

# Global variables for results tracking
declare -A TOOL_RESULTS
declare -a TOOL_ORDER

# Tool execution framework
run_tool() {
    local tool_name="$1"
    local tool_command="$2"
    local input_files="$3"
    local expected_issues="${4:-0}"
    local description="$5"
    
    log_step "Running $tool_name analysis"
    
    start_timer
    
    # Execute the tool
    local output_file="/tmp/${tool_name}_output.txt"
    local exit_code=0
    
    eval "$tool_command" > "$output_file" 2>&1 || exit_code=$?
    
    # Process results
    local result=$(process_tool_result "$tool_name" "$output_file" "$exit_code" "$expected_issues")
    TOOL_RESULTS["$tool_name"]="$result"
    TOOL_ORDER+=("$tool_name")
    
    # Display result
    local status=$(echo "$result" | cut -d'|' -f1)
    local details=$(echo "$result" | cut -d'|' -f2-)
    format_tool_result "$tool_name" "$status" "$details"
    
    end_timer "$tool_name analysis"
    
    # Clean up
    rm -f "$output_file"
}

# Process tool-specific results
process_tool_result() {
    local tool_name="$1"
    local output_file="$2"
    local exit_code="$3"
    local expected_issues="$4"
    
    case "$tool_name" in
        "bandit")
            process_bandit_result "$output_file" "$exit_code" "$expected_issues"
            ;;
        "flake8")
            process_flake8_result "$output_file" "$exit_code" "$expected_issues"
            ;;
        "black")
            process_black_result "$output_file" "$exit_code"
            ;;
        "mypy")
            process_mypy_result "$output_file" "$exit_code" "$expected_issues"
            ;;
        "isort")
            process_isort_result "$output_file" "$exit_code"
            ;;
        "pytest")
            process_pytest_result "$output_file" "$exit_code"
            ;;
        *)
            echo "unknown|Tool result processing not implemented"
            ;;
    esac
}

# Tool-specific result processors
process_bandit_result() {
    local output_file="$1"
    local exit_code="$2"
    local expected_issues="$3"
    
    local issues=$(grep -c "Issue:" "$output_file" 2>/dev/null || echo "0")
    local high_severity=$(grep -c "Severity: High" "$output_file" 2>/dev/null || echo "0")
    local medium_severity=$(grep -c "Severity: Medium" "$output_file" 2>/dev/null || echo "0")
    
    if [ "$issues" -eq 0 ]; then
        echo "pass|No security issues found"
    elif [ "$issues" -le "$expected_issues" ]; then
        echo "warning|Found $issues security issues ($high_severity high, $medium_severity medium)"
    else
        echo "fail|Found $issues security issues (expected ≤$expected_issues)"
    fi
}

process_flake8_result() {
    local output_file="$1"
    local exit_code="$2"
    local expected_issues="$3"
    
    local issues=$(wc -l < "$output_file" 2>/dev/null || echo "0")
    local errors=$(grep -c ": E" "$output_file" 2>/dev/null || echo "0")
    local warnings=$(grep -c ": W" "$output_file" 2>/dev/null || echo "0")
    
    if [ "$issues" -eq 0 ]; then
        echo "pass|Code follows PEP8 standards"
    elif [ "$issues" -le "$expected_issues" ]; then
        echo "warning|Found $issues style issues ($errors errors, $warnings warnings)"
    else
        echo "fail|Found $issues style issues (expected ≤$expected_issues)"
    fi
}

process_black_result() {
    local output_file="$1"
    local exit_code="$2"
    
    if [ "$exit_code" -eq 0 ]; then
        echo "pass|Code is properly formatted"
    else
        local reformatted=$(grep -c "reformatted" "$output_file" 2>/dev/null || echo "0")
        if [ "$reformatted" -gt 0 ]; then
            echo "warning|Would reformat $reformatted files"
        else
            echo "fail|Formatting check failed"
        fi
    fi
}

process_mypy_result() {
    local output_file="$1"
    local exit_code="$2"
    local expected_issues="$3"
    
    local errors=$(grep -c "error:" "$output_file" 2>/dev/null || echo "0")
    local warnings=$(grep -c "warning:" "$output_file" 2>/dev/null || echo "0")
    local notes=$(grep -c "note:" "$output_file" 2>/dev/null || echo "0")
    
    if [ "$errors" -eq 0 ] && [ "$warnings" -eq 0 ]; then
        echo "pass|No type errors found"
    elif [ "$errors" -le "$expected_issues" ]; then
        echo "warning|Found $errors type errors, $warnings warnings"
    else
        echo "fail|Found $errors type errors (expected ≤$expected_issues)"
    fi
}

process_isort_result() {
    local output_file="$1"
    local exit_code="$2"
    
    if [ "$exit_code" -eq 0 ]; then
        echo "pass|Import statements are properly sorted"
    else
        local fixed=$(grep -c "Fixing" "$output_file" 2>/dev/null || echo "0")
        if [ "$fixed" -gt 0 ]; then
            echo "warning|Would sort imports in $fixed files"
        else
            echo "fail|Import sorting check failed"
        fi
    fi
}

process_pytest_result() {
    local output_file="$1"
    local exit_code="$2"
    
    local passed=$(grep -o "[0-9]\+ passed" "$output_file" | cut -d' ' -f1 || echo "0")
    local failed=$(grep -o "[0-9]\+ failed" "$output_file" | cut -d' ' -f1 || echo "0")
    local errors=$(grep -o "[0-9]\+ error" "$output_file" | cut -d' ' -f1 || echo "0")
    
    if [ "$exit_code" -eq 0 ]; then
        echo "pass|All tests passed ($passed tests)"
    else
        echo "fail|Tests failed ($failed failed, $errors errors)"
    fi
}

# Batch tool execution
run_tool_suite() {
    local config_file="$1"
    
    log_step "Loading tool configuration"
    
    # Clear previous results
    TOOL_RESULTS=()
    TOOL_ORDER=()
    
    # Source the tool configuration
    source "$config_file"
    
    print_header "Running Code Quality Analysis Suite"
    
    local total_tools=${#TOOLS[@]}
    local current=0
    
    for tool_config in "${TOOLS[@]}"; do
        current=$((current + 1))
        
        # Parse tool configuration
        IFS='|' read -r name command files expected_issues description <<< "$tool_config"
        
        show_progress $current $total_tools "$name"
        run_tool "$name" "$command" "$files" "$expected_issues" "$description"
        echo ""
    done
    
    # Print summary
    print_summary_table TOOL_RESULTS
}

# Generate detailed report
generate_report() {
    local report_file="${1:-analysis_report.md}"
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    
    log_step "Generating detailed report: $report_file"
    
    cat > "$report_file" << EOF
# Code Quality Analysis Report

**Generated:** $timestamp  
**Environment:** $(python --version), $(pip --version)  
**Working Directory:** $(pwd)

## Tool Results Summary

| Tool | Status | Details |
|------|--------|---------|
EOF

    for tool in "${TOOL_ORDER[@]}"; do
        local result="${TOOL_RESULTS[$tool]}"
        local status=$(echo "$result" | cut -d'|' -f1)
        local details=$(echo "$result" | cut -d'|' -f2-)
        
        case "$status" in
            "pass")
                echo "| $tool | ✅ PASS | $details |" >> "$report_file"
                ;;
            "fail")
                echo "| $tool | ❌ FAIL | $details |" >> "$report_file"
                ;;
            "warning")
                echo "| $tool | ⚠️ WARN | $details |" >> "$report_file"
                ;;
        esac
    done
    
    cat >> "$report_file" << EOF

## Tool Versions

EOF
    
    for tool in python pip bandit flake8 black mypy isort pytest; do
        local version=$(get_tool_version "$tool")
        echo "- **$tool:** $version" >> "$report_file"
    done
    
    cat >> "$report_file" << EOF

## Recommendations

### Immediate Actions
- Fix all failing tools marked with ❌
- Address security issues found by bandit
- Resolve type errors found by mypy

### Code Quality Improvements
- Run \`black .\` to format code automatically
- Run \`isort .\` to sort imports
- Add type hints where missing

### Continuous Integration
Consider adding these tools to your CI/CD pipeline:
\`\`\`bash
# Pre-commit hooks
pip install pre-commit
pre-commit install
\`\`\`

---
*Report generated by Code Quality Tutorial Suite*
EOF
    
    log_success "Report saved to: $report_file"
}

# Fix mode - automatically apply fixes where possible
run_fix_mode() {
    local config_file="$1"
    
    print_header "Running Auto-Fix Mode"
    log_warning "This will modify your files. Make sure you have backups!"
    
    if ! confirm "Continue with auto-fix?"; then
        log_info "Auto-fix cancelled"
        return 0
    fi
    
    # Create backups
    log_step "Creating backups"
    for file in $(find . -name "*.py" -type f); do
        backup_file "$file"
    done
    
    # Apply fixes
    log_step "Applying automatic fixes"
    
    # Black formatting
    if command -v black >/dev/null 2>&1; then
        log_info "Applying black formatting..."
        black . >/dev/null 2>&1 || true
    fi
    
    # Import sorting
    if command -v isort >/dev/null 2>&1; then
        log_info "Sorting imports..."
        isort . >/dev/null 2>&1 || true
    fi
    
    log_success "Auto-fix completed"
    log_info "Re-run analysis to see improvements"
}