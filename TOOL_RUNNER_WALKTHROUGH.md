# 🚀 Tool Runner Module - Interactive Code Walkthrough

This document provides a comprehensive walkthrough of the `lib/tool_runner.sh` module, explaining how the modular tool execution system works and how to extend it.

---

## 📖 **Module Overview**

The `tool_runner.sh` module is the **heart** of our modular tutorial system. It provides:

- **Standardized tool execution** framework
- **Intelligent result processing** for different tool types
- **Professional reporting** with multiple output formats
- **Batch orchestration** capabilities
- **Auto-fix functionality** with safety features

---

## 🏗️ **Section 1: Module Foundation**

```bash
#!/bin/bash
# Tool Runner Module
# Provides standardized tool execution and result processing

# Source the helper library
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/tutorial_helpers.sh"

# Global variables for results tracking
declare -A TOOL_RESULTS  # Associative array to store results
declare -a TOOL_ORDER    # Regular array to maintain execution order
```

### 🔍 **What's Happening Here?**

- **Dynamic Path Resolution**: Gets the script's directory dynamically (works from anywhere)
- **Helper Integration**: Sources our rich helper library for logging/formatting functions
- **Result Storage System**: Sets up two global variables:
  - `TOOL_RESULTS`: Stores each tool's results in format `"status|details"`
  - `TOOL_ORDER`: Maintains execution order for consistent reports

---

## 🚀 **Section 2: The Core Execution Engine**

```bash
# Tool execution framework
run_tool() {
    local tool_name="$1"        # e.g., "bandit"
    local tool_command="$2"     # e.g., "bandit -r examples/"
    local input_files="$3"      # e.g., "examples/"
    local expected_issues="${4:-0}"  # Default to 0 if not provided
    local description="$5"      # Human-readable description
    
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
```

### 🎯 **The Execution Flow**

1. **📝 Logging & Timing**: Uses helper functions for consistent, professional output
2. **⚡ Command Execution**: 
   ```bash
   eval "$tool_command" > "$output_file" 2>&1 || exit_code=$?
   ```
   - Captures both `stdout` and `stderr`
   - Records exit code for intelligent analysis
   - Never crashes the system

3. **🧠 Result Processing**: Calls tool-specific processor for intelligent interpretation
4. **💾 Storage**: Saves results in global arrays for later use
5. **📊 Display**: Shows formatted results immediately for user feedback
6. **🧹 Cleanup**: Removes temporary files (no mess left behind)

### 💡 **Key Design Decisions**

- **Standardized Interface**: All tools use the same 5 parameters
- **Robust Error Handling**: Never crashes - always captures and processes errors
- **Immediate Feedback**: Shows results as each tool completes (not batched)
- **Clean Separation**: Execution logic separate from result interpretation

---

## 🔧 **Section 3: The Result Processing Router**

```bash
# Process tool-specific results
process_tool_result() {
    local tool_name="$1"      # Which tool ran?
    local output_file="$2"    # Where is its output stored?
    local exit_code="$3"      # What was the exit code?
    local expected_issues="$4" # How many issues are "acceptable"?
    
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
```

### 🎯 **Why This Dispatch Design?**

- **🔧 Tool-Specific Logic**: Each tool has different output formats and conventions
- **📈 Extensible Architecture**: Adding new tools just means adding a new case
- **🔄 Consistent Interface**: All processors return `"status|details"` format
- **🛡️ Graceful Degradation**: Unknown tools get a default handler

---

## 🛡️ **Section 4: Tool-Specific Intelligence**

### **Security Scanner Example: Bandit**

```bash
process_bandit_result() {
    local output_file="$1"
    local exit_code="$2"
    local expected_issues="$3"
    
    # Parse bandit-specific output patterns
    local issues=$(grep -c "Issue:" "$output_file" 2>/dev/null || echo "0")
    local high_severity=$(grep -c "Severity: High" "$output_file" 2>/dev/null || echo "0")
    local medium_severity=$(grep -c "Severity: Medium" "$output_file" 2>/dev/null || echo "0")
    
    # Apply intelligent decision logic
    if [ "$issues" -eq 0 ]; then
        echo "pass|No security issues found"
    elif [ "$issues" -le "$expected_issues" ]; then
        echo "warning|Found $issues security issues ($high_severity high, $medium_severity medium)"
    else
        echo "fail|Found $issues security issues (expected ≤$expected_issues)"
    fi
}
```

### **Style Checker Example: Flake8**

```bash
process_flake8_result() {
    local output_file="$1"
    local exit_code="$2"
    local expected_issues="$3"
    
    # Flake8 outputs one issue per line
    local issues=$(wc -l < "$output_file" 2>/dev/null || echo "0")
    local errors=$(grep -c ": E" "$output_file" 2>/dev/null || echo "0")     # E-codes = errors
    local warnings=$(grep -c ": W" "$output_file" 2>/dev/null || echo "0")   # W-codes = warnings
    
    if [ "$issues" -eq 0 ]; then
        echo "pass|Code follows PEP8 standards"
    elif [ "$issues" -le "$expected_issues" ]; then
        echo "warning|Found $issues style issues ($errors errors, $warnings warnings)"
    else
        echo "fail|Found $issues style issues (expected ≤$expected_issues)"
    fi
}
```

### **Formatter Example: Black**

```bash
process_black_result() {
    local output_file="$1"
    local exit_code="$2"
    # Note: No expected_issues parameter for formatters!
    
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
```

### 🧠 **Different Tool Categories Handled Intelligently**

| Category | Tools | Logic | Threshold Usage |
|----------|-------|--------|-----------------|
| **🛡️ Analyzers** | bandit, flake8, mypy | Count issues, compare to threshold | ✅ Uses expected_issues |
| **🎨 Formatters** | black, isort | Exit code based, count files to fix | ❌ Threshold not applicable |
| **🧪 Test Runners** | pytest | Count passed/failed tests | ❌ Binary pass/fail |

### 💡 **The Intelligence in Each Processor**

- **🔍 Tool-Aware Parsing**: Knows each tool's specific output format
- **📊 Metric Extraction**: Pulls meaningful numbers (counts, severities, types)
- **🎯 Context-Aware Decisions**: Uses expected issues threshold intelligently
- **📝 Rich Details**: Provides human-readable, actionable information
- **🔄 Consistent Output**: Always returns the same `"status|details"` format

---

## 🚀 **Section 5: The Orchestration Engine**

```bash
# Batch tool execution
run_tool_suite() {
    local config_file="$1"
    
    log_step "Loading tool configuration"
    
    # Clear previous results for fresh run
    TOOL_RESULTS=()
    TOOL_ORDER=()
    
    # Source the tool configuration
    source "$config_file"      # Loads TOOLS array from config
    
    print_header "Running Code Quality Analysis Suite"
    
    # Progress tracking setup
    local total_tools=${#TOOLS[@]}
    local current=0
    
    # Execute each tool in the configuration
    for tool_config in "${TOOLS[@]}"; do
        current=$((current + 1))
        
        # Parse the pipe-delimited configuration
        IFS='|' read -r name command files expected_issues description <<< "$tool_config"
        
        # Show progress and execute
        show_progress $current $total_tools "$name"
        run_tool "$name" "$command" "$files" "$expected_issues" "$description"
        echo ""  # Spacing between tools
    done
    
    # Display comprehensive summary
    print_summary_table TOOL_RESULTS
}
```

### 🎯 **Configuration-Driven Execution**

The system reads tool definitions from `config/tools.conf`:

```bash
# Tool definitions in pipe-delimited format
TOOLS=(
    "bandit|bandit -r examples/ -f json -o $OUTPUT_DIR/bandit_report.json|examples/|10|Security vulnerability scanner"
    "flake8|flake8 examples/ --output-file=$OUTPUT_DIR/flake8_report.txt|examples/|15|PEP8 style checker"
    "black|black --check --diff examples/|examples/|0|Code formatter (check mode)"
    "mypy|mypy examples/ --ignore-missing-imports|examples/|8|Static type checker"
    "isort|isort --check-only --diff examples/|examples/|0|Import sorter (check mode)"
    "pytest|pytest tests/ -v --tb=short|tests/|0|Unit test runner"
)
```

### 📊 **Configuration Format Breakdown**

| Position | Field | Example | Purpose |
|----------|-------|---------|---------|
| 1 | `name` | `"bandit"` | Display name and processor key |
| 2 | `command` | `"bandit -r examples/"` | Full command with options |
| 3 | `files` | `"examples/"` | Input files/directories |
| 4 | `expected_issues` | `"10"` | Acceptable threshold |
| 5 | `description` | `"Security scanner"` | Human description |

---

## 📊 **Section 6: Professional Report Generation**

```bash
# Generate detailed report
generate_report() {
    local report_file="${1:-analysis_report.md}"
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    
    log_step "Generating detailed report: $report_file"
    
    # Create professional header with environment info
    cat > "$report_file" << EOF
# Code Quality Analysis Report

**Generated:** $timestamp  
**Environment:** $(python --version), $(pip --version)  
**Working Directory:** $(pwd)

## Tool Results Summary

| Tool | Status | Details |
|------|--------|---------|
EOF

    # Process each tool's results in execution order
    for tool in "${TOOL_ORDER[@]}"; do
        local result="${TOOL_RESULTS[$tool]}"
        local status=$(echo "$result" | cut -d'|' -f1)
        local details=$(echo "$result" | cut -d'|' -f2-)
        
        # Add appropriate status icon
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
    
    # Add tool versions section
    cat >> "$report_file" << EOF

## Tool Versions

EOF
    
    for tool in python pip bandit flake8 black mypy isort pytest; do
        local version=$(get_tool_version "$tool")
        echo "- **$tool:** $version" >> "$report_file"
    done
    
    # Add actionable recommendations
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
```

### 📋 **Generated Report Features**

- **📅 Timestamp & Environment**: Captures when and where analysis ran
- **📊 Status Summary**: Professional table with visual status icons
- **🔧 Tool Versions**: Complete version inventory for reproducibility
- **💡 Actionable Recommendations**: Specific next steps categorized by urgency
- **🚀 Integration Guidance**: CI/CD setup suggestions

---

## 🔧 **Section 7: Intelligent Auto-Fix System**

```bash
# Fix mode - automatically apply fixes where possible
run_fix_mode() {
    local config_file="$1"
    
    print_header "Running Auto-Fix Mode"
    log_warning "This will modify your files. Make sure you have backups!"
    
    # Safety first - require user confirmation
    if ! confirm "Continue with auto-fix?"; then
        log_info "Auto-fix cancelled"
        return 0
    fi
    
    # Create comprehensive backups before any changes
    log_step "Creating backups"
    for file in $(find . -name "*.py" -type f); do
        backup_file "$file"    # Uses helper function to create timestamped backups
    done
    
    # Apply only safe, reversible fixes
    log_step "Applying automatic fixes"
    
    # Black formatting (safe - only formatting changes)
    if command -v black >/dev/null 2>&1; then
        log_info "Applying black formatting..."
        black . >/dev/null 2>&1 || true
    fi
    
    # Import sorting (safe - only import organization)
    if command -v isort >/dev/null 2>&1; then
        log_info "Sorting imports..."
        isort . >/dev/null 2>&1 || true
    fi
    
    log_success "Auto-fix completed"
    log_info "Re-run analysis to see improvements"
}
```

### 🛡️ **Safety-First Design**

- **⚠️ User Confirmation**: Requires explicit consent before making changes
- **💾 Automatic Backups**: Creates timestamped backups of all Python files
- **✅ Only Safe Fixes**: Applies only formatting and import organization
- **🚫 No Security Fixes**: Security issues require human review and judgment
- **🔄 Verification Suggestion**: Recommends re-running analysis to see improvements

### 🎯 **What Gets Fixed Automatically**

| Tool | Auto-Fix | Reason |
|------|----------|--------|
| **🎨 Black** | ✅ Yes | Formatting is always safe |
| **📚 isort** | ✅ Yes | Import sorting is safe |
| **🛡️ Bandit** | ❌ No | Security requires human judgment |
| **📏 Flake8** | ❌ No | Style issues may affect logic |
| **🎯 MyPy** | ❌ No | Type issues need careful consideration |

---

## 🎯 **Section 8: Adding New Tools - The Complete Guide**

### **Step 1: Update Configuration**

Add your tool to `config/tools.conf`:

```bash
TOOLS=(
    # Existing tools...
    "pylint|pylint examples/ --output-format=text --reports=no|examples/|20|Advanced static analysis"
)
```

### **Step 2: Add Result Processor**

Add to `lib/tool_runner.sh`:

```bash
process_pylint_result() {
    local output_file="$1"
    local exit_code="$2"
    local expected_issues="$3"
    
    # Parse pylint's output format
    local issues=$(grep -c ": " "$output_file" 2>/dev/null || echo "0")
    local errors=$(grep -c "E[0-9][0-9][0-9][0-9]:" "$output_file" 2>/dev/null || echo "0")
    local warnings=$(grep -c "W[0-9][0-9][0-9][0-9]:" "$output_file" 2>/dev/null || echo "0")
    local conventions=$(grep -c "C[0-9][0-9][0-9][0-9]:" "$output_file" 2>/dev/null || echo "0")
    
    if [ "$issues" -eq 0 ]; then
        echo "pass|Code meets all pylint standards"
    elif [ "$issues" -le "$expected_issues" ]; then
        echo "warning|Found $issues issues ($errors errors, $warnings warnings, $conventions conventions)"
    else
        echo "fail|Found $issues issues (expected ≤$expected_issues)"
    fi
}
```

### **Step 3: Add to Dispatcher**

Update the `process_tool_result()` case statement:

```bash
case "$tool_name" in
    # Existing cases...
    "pylint")
        process_pylint_result "$output_file" "$exit_code" "$expected_issues"
        ;;
esac
```

### **Step 4: Update Requirements** (Optional)

Add to `requirements.txt`:

```
pylint>=2.15.0
```

### **Step 5: Add Version Detection** (Optional)

Update `get_tool_version()` in `lib/tutorial_helpers.sh`:

```bash
case "$tool" in
    # Existing cases...
    "pylint")
        pylint --version | head -1 | cut -d' ' -f2
        ;;
esac
```

---

## 🚀 **Section 9: The Complete Execution Flow**

Here's how everything works together when you run `./run_tutorial.sh`:

```mermaid
flowchart TD
    A[run_tutorial.sh] --> B[load config/tools.conf]
    B --> C[run_tool_suite]
    C --> D[for each TOOL in TOOLS array]
    D --> E[parse tool config]
    E --> F[run_tool]
    F --> G[execute command]
    G --> H[capture output & exit code]
    H --> I[process_tool_result]
    I --> J[tool-specific processor]
    J --> K[return status|details]
    K --> L[store in TOOL_RESULTS]
    L --> M[display formatted result]
    M --> N[next tool or summary]
    N --> O[generate_report]
    O --> P[create professional markdown report]
```

### 🔄 **Data Flow**

1. **Configuration** → `TOOLS` array with pipe-delimited definitions
2. **Execution** → Each tool runs through standardized `run_tool()`
3. **Processing** → Tool-specific processors interpret outputs
4. **Storage** → Results stored in `TOOL_RESULTS` associative array
5. **Display** → Immediate feedback with formatted output
6. **Reporting** → Professional markdown reports generated

---

## 💡 **Advanced Features & Customization**

### **Custom Tool Configurations**

```bash
# In config/tools.conf
declare -A TOOL_CONFIGS
TOOL_CONFIGS["bandit"]="--skip B101,B601"  # Skip assert and shell injection
TOOL_CONFIGS["flake8"]="--max-line-length=88 --extend-ignore=E203,W503"
TOOL_CONFIGS["mypy"]="--python-version=3.8 --strict-optional"
```

### **Environment Variables**

```bash
# Automatically set by configuration
export PYTHONPATH="${PYTHONPATH}:$(pwd)"
export MYPYPATH="${MYPYPATH}:$(pwd)"
export ANSIBLE_CONFIG="$(pwd)/ansible/ansible.cfg"
```

### **Threshold Configuration**

```bash
# Configurable thresholds for non-strict mode
MAX_SECURITY_ISSUES=10
MAX_STYLE_ISSUES=15
MAX_TYPE_ERRORS=8
MAX_TEST_FAILURES=0
```

---

## 🛠️ **Troubleshooting & Best Practices**

### **Common Issues**

**Tool Not Found After Adding**
```bash
# Ensure tool is installed and in PATH
pip install your-tool-package
which your-tool
```

**Result Parsing Fails**
```bash
# Debug tool output format
your-tool examples/ > debug_output.txt
cat debug_output.txt  # Examine actual output format
```

**Configuration Not Loading**
```bash
# Check configuration syntax
bash -n config/tools.conf
source config/tools.conf && echo "Config OK"
```

### **Best Practices for Tool Integration**

- **📊 Consistent Exit Codes**: Use 0 for success, non-zero for issues
- **💬 Meaningful Messages**: Provide actionable error descriptions  
- **🔧 Dual Modes**: Support both check and fix modes where applicable
- **🛡️ Graceful Handling**: Handle missing files without crashing
- **📝 Documentation**: Update README when adding tools

---

## 🎉 **Summary: Why This Architecture Works**

### **🏗️ Modular Design Benefits**

- **Easy Maintenance**: Each component has a single responsibility
- **Simple Extension**: Adding tools requires minimal code changes
- **Consistent Experience**: All tools get the same professional treatment
- **Robust Error Handling**: Individual tool failures don't crash the system

### **🎯 Key Architectural Strengths**

1. **Configuration-Driven**: Tools defined in simple, readable format
2. **Intelligent Processing**: Each tool type handled with appropriate logic
3. **Professional Output**: Consistent formatting, progress tracking, comprehensive reports
4. **Safety Features**: Backups, confirmations, and graceful error handling
5. **Extensible Framework**: New tools integrate seamlessly

### **🚀 The Result**

What was once a monolithic 765-line script is now a clean, modular system where:

- **Adding a tool** takes 5 minutes instead of hours
- **Maintaining code** is straightforward with clear separation
- **User experience** is consistent and professional across all tools
- **Error handling** is robust and informative
- **Reporting** provides actionable insights

The modular architecture transforms complexity into simplicity, making the tutorial system both powerful for users and maintainable for developers! 🎯