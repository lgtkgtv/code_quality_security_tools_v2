#!/bin/bash
# Project Scanner - Analyze real codebases with quality tools
# Supports local files, directories, and git repositories

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Configuration
SCAN_DIR="scans"
REPORT_DIR="reports"
TEMP_DIR="tmp"

# Logging functions
log_info() { echo -e "${BLUE}ℹ️  $1${NC}"; }
log_success() { echo -e "${GREEN}✅ $1${NC}"; }
log_warning() { echo -e "${YELLOW}⚠️  $1${NC}"; }
log_error() { echo -e "${RED}❌ $1${NC}"; }
print_header() { 
    echo -e "\n${CYAN}════════════════════════════════════════════════════════════${NC}"
    echo -e "${CYAN}  $1${NC}"
    echo -e "${CYAN}════════════════════════════════════════════════════════════${NC}\n"
}

# Initialize directories
initialize() {
    mkdir -p "$SCAN_DIR" "$REPORT_DIR" "$TEMP_DIR"
    
    # Setup virtual environment if needed
    if [[ ! -d "venv" ]]; then
        log_info "Creating virtual environment..."
        python3 -m venv venv
    fi
    
    source venv/bin/activate
    
    log_info "Installing/updating tools..."
    pip install -q --upgrade pip
    pip install -q bandit flake8 black mypy isort pytest
}

# Discover available tools
discover_tools() {
    local tools=()
    for dir in tools/*/; do
        if [[ -d "$dir" && "$dir" != "tools/template/" ]]; then
            if [[ -f "$dir/config.yaml" ]]; then
                tool_name=$(basename "$dir")
                tools+=("$tool_name")
            fi
        fi
    done
    echo "${tools[@]}"
}

# Clone or prepare project for scanning
prepare_project() {
    local target=$1
    local scan_path=""
    
    if [[ "$target" =~ ^https?://|^git@ ]]; then
        # Git repository
        local repo_name=$(basename "$target" .git)
        scan_path="$SCAN_DIR/$repo_name"
        
        if [[ -d "$scan_path" ]]; then
            log_warning "Directory $scan_path already exists"
            read -p "Overwrite? (y/N): " -n 1 -r
            echo
            if [[ $REPLY =~ ^[Yy]$ ]]; then
                rm -rf "$scan_path"
                log_info "Cloning repository..."
                git clone "$target" "$scan_path"
            fi
        else
            log_info "Cloning repository..."
            git clone "$target" "$scan_path"
        fi
        
    elif [[ -f "$target" ]]; then
        # Single file
        scan_path="$TEMP_DIR/$(basename "$target")"
        cp "$target" "$scan_path"
        
    elif [[ -d "$target" ]]; then
        # Directory
        scan_path="$target"
        
    else
        log_error "Invalid target: $target"
        return 1
    fi
    
    echo "$scan_path"
}

# Run all tools on project
scan_project() {
    local project_path=$1
    local project_name=$(basename "$project_path")
    local timestamp=$(date '+%Y%m%d_%H%M%S')
    local report_file="$REPORT_DIR/${project_name}_${timestamp}.md"
    
    print_header "🔍 Scanning Project: $project_name"
    
    # Initialize report
    generate_report_header "$project_name" "$project_path" "$report_file"
    
    local tools=($(discover_tools))
    local total_issues=0
    
    for tool in "${tools[@]}"; do
        log_info "Running $tool..."
        
        local tool_output=$(mktemp)
        local tool_status="PASS"
        local issue_count=0
        
        # Run tool and capture output
        case $tool in
            bandit)
                if bandit -r "$project_path" -f json > "$tool_output" 2>/dev/null; then
                    issue_count=$(jq '.results | length' "$tool_output" 2>/dev/null || echo "0")
                else
                    bandit -r "$project_path" > "$tool_output" 2>&1 || true
                    issue_count=$(grep -c "Issue:" "$tool_output" 2>/dev/null || echo "0")
                fi
                ;;
            flake8)
                flake8 "$project_path" > "$tool_output" 2>&1 || true
                issue_count=$(wc -l < "$tool_output")
                ;;
            black)
                black --check --diff "$project_path" > "$tool_output" 2>&1 || true
                if grep -q "would reformat" "$tool_output" 2>/dev/null; then
                    issue_count=1
                else
                    issue_count=0
                fi
                ;;
            mypy)
                mypy "$project_path" --ignore-missing-imports > "$tool_output" 2>&1 || true
                issue_count=$(grep -c "error:" "$tool_output" 2>/dev/null || echo "0")
                ;;
            isort)
                isort --check-only --diff "$project_path" > "$tool_output" 2>&1 || true
                if grep -q "Fixing\|would reformat" "$tool_output" 2>/dev/null; then
                    issue_count=1
                else
                    issue_count=0
                fi
                ;;
            pytest)
                if [[ -d "$project_path" ]]; then
                    cd "$project_path"
                    pytest --tb=short > "$tool_output" 2>&1 || true
                    cd - > /dev/null
                else
                    pytest "$project_path" --tb=short > "$tool_output" 2>&1 || true
                fi
                issue_count=$(grep -c "FAILED" "$tool_output" 2>/dev/null || echo "0")
                ;;
        esac
        
        issue_count=$(echo "$issue_count" | tr -d '\n')
        if [[ $issue_count -gt 0 ]]; then
            tool_status="FAIL"
            total_issues=$((total_issues + issue_count))
        fi
        
        # Add to report
        add_tool_result "$report_file" "$tool" "$tool_status" "$issue_count" "$tool_output"
        
        rm -f "$tool_output"
    done
    
    # Finalize report
    finalize_report "$report_file" "$total_issues"
    
    log_success "Scan complete! Report saved to: $report_file"
    echo "Total issues found: $total_issues"
}

# Generate report header
generate_report_header() {
    local project_name=$1
    local project_path=$2
    local report_file=$3
    
    cat > "$report_file" << EOF
# Code Quality Scan Report

**Project:** $project_name  
**Scanned Path:** $project_path  
**Generated:** $(date '+%Y-%m-%d %H:%M:%S')  
**Environment:** $(python3 --version), $(pip --version | cut -d' ' -f1,2)

## Tool Results Summary

| Tool | Status | Issues | Description |
|------|--------|--------|-------------|
EOF
}

# Add tool result to report
add_tool_result() {
    local report_file=$1
    local tool=$2
    local status=$3
    local count=$4
    local output_file=$5
    
    local status_icon=""
    case $status in
        PASS) status_icon="✅ PASS" ;;
        FAIL) status_icon="❌ FAIL" ;;
        WARN) status_icon="⚠️  WARN" ;;
    esac
    
    local description=""
    if [[ -f "tools/$tool/description.txt" ]]; then
        description=$(head -1 "tools/$tool/description.txt")
    fi
    
    # Add to summary table
    printf "| %-8s | %-10s | %-6s | %-40s |\n" "$tool" "$status_icon" "$count" "$description" >> "$report_file"
    
    # Add detailed output if there are issues
    if [[ $count -gt 0 && -f "$output_file" ]]; then
        cat >> "$report_file" << EOF

### $tool Details

\`\`\`
$(head -50 "$output_file")
\`\`\`

EOF
    fi
}

# Finalize report
finalize_report() {
    local report_file=$1
    local total_issues=$2
    
    cat >> "$report_file" << EOF

## Summary

**Total Issues:** $total_issues

## Recommendations

EOF
    
    if [[ $total_issues -eq 0 ]]; then
        echo "🎉 Great! No issues found. Your code quality is excellent!" >> "$report_file"
    else
        cat >> "$report_file" << EOF
### Immediate Actions
- Review and fix issues found by failing tools
- Run tools individually for more detailed information
- Consider integrating tools into your CI/CD pipeline

### Code Quality Improvements
- Run \`black .\` to format code automatically
- Run \`isort .\` to sort imports
- Add type hints where missing
- Improve test coverage

### Integration
Consider adding these tools to your development workflow:
\`\`\`bash
# Install pre-commit hooks
pip install pre-commit
pre-commit install
\`\`\`
EOF
    fi
    
    echo "" >> "$report_file"
    echo "---" >> "$report_file"
    echo "*Report generated by Python Code Quality Scanner*" >> "$report_file"
}

# Show usage
show_usage() {
    cat << EOF
Usage: $0 [target]

Scan Python code with quality tools and generate detailed reports.

Supported targets:
  - Git repository URL (https or ssh)
  - Local directory path
  - Single Python file

Examples:
  $0 https://github.com/user/project.git
  $0 /path/to/local/project
  $0 script.py

Reports are saved in the 'reports/' directory.
EOF
}

# Main execution
main() {
    if [[ $# -eq 0 ]]; then
        show_usage
        exit 1
    fi
    
    local target=$1
    
    initialize
    
    print_header "🚀 Python Code Quality Scanner"
    
    local scan_path=$(prepare_project "$target")
    if [[ $? -ne 0 ]]; then
        exit 1
    fi
    
    scan_project "$scan_path"
}

# Run main function
main "$@"