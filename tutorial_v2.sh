#!/bin/bash
# Simplified Tutorial Orchestrator - Clean Architecture
# Automatically discovers and runs tool tutorials

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Simple logging functions
log_info() { echo -e "${BLUE}ℹ️  $1${NC}"; }
log_success() { echo -e "${GREEN}✅ $1${NC}"; }
log_warning() { echo -e "${YELLOW}⚠️  $1${NC}"; }
log_error() { echo -e "${RED}❌ $1${NC}"; }
print_header() { 
    echo -e "\n${CYAN}════════════════════════════════════════════════════════════${NC}"
    echo -e "${CYAN}  $1${NC}"
    echo -e "${CYAN}════════════════════════════════════════════════════════════${NC}\n"
}

# Discover available tools based on directory structure
discover_tools() {
    local tools=()
    for dir in tools/*/; do
        if [[ -d "$dir" && "$dir" != "tools/template/" ]]; then
            # Check if required files exist
            if [[ -f "$dir/config.yaml" && -f "$dir/bad_example.py" && -f "$dir/good_example.py" ]]; then
                tool_name=$(basename "$dir")
                tools+=("$tool_name")
            fi
        fi
    done
    echo "${tools[@]}"
}

# Read tool description from file
get_tool_description() {
    local tool=$1
    if [[ -f "tools/$tool/description.txt" ]]; then
        head -1 "tools/$tool/description.txt"
    else
        echo "No description available"
    fi
}

# Run tool command dynamically
run_tool_command() {
    local tool=$1
    local file=$2
    
    case $tool in
        bandit)
            bandit -r "$file" 2>/dev/null | head -20 || true
            ;;
        flake8)
            flake8 "$file" 2>/dev/null | head -20 || true
            ;;
        black)
            black --check --diff "$file" 2>/dev/null | head -20 || true
            ;;
        mypy)
            mypy "$file" --ignore-missing-imports 2>/dev/null | head -20 || true
            ;;
        isort)
            isort --check-only --diff "$file" 2>/dev/null | head -20 || true
            ;;
        pytest)
            pytest "$file" -v 2>/dev/null | head -20 || true
            ;;
        *)
            # Try to read command from config.yaml
            if [[ -f "tools/$tool/config.yaml" ]]; then
                local check_cmd=$(grep "check_command:" "tools/$tool/config.yaml" | cut -d'"' -f2)
                if [[ -n "$check_cmd" ]]; then
                    # Replace tool-name placeholder with actual tool name
                    check_cmd=${check_cmd//tool-name/$tool}
                    eval "$check_cmd \"$file\"" 2>/dev/null | head -20 || true
                else
                    log_warning "No check_command found in config for $tool"
                fi
            else
                log_warning "Tool runner not implemented for $tool"
            fi
            ;;
    esac
}

# Run educational tutorial for a specific tool
run_tool_tutorial() {
    local tool=$1
    local tool_dir="tools/$tool"
    
    # Check for enhanced interactive tutorial
    if [[ -x "$tool_dir/run_interactive_tutorial.sh" ]]; then
        log_info "Running enhanced interactive tutorial for $tool..."
        echo
        bash "$tool_dir/run_interactive_tutorial.sh"
        return
    fi
    
    # Fallback to basic tutorial
    print_header "🎓 $tool Tutorial"
    
    # Show description
    log_info "$(get_tool_description $tool)"
    echo
    
    echo "Tutorial Mode Options:"
    echo "1. Interactive mode (recommended for learning)"
    echo "2. Basic mode (quick overview)"
    echo
    read -p "Choose mode [1-2]: " mode
    
    case "$mode" in
        "1"|"")
            run_interactive_tutorial "$tool" "$tool_dir"
            ;;
        "2")
            run_basic_tutorial "$tool" "$tool_dir"
            ;;
        *)
            log_warning "Invalid choice, using basic mode"
            run_basic_tutorial "$tool" "$tool_dir"
            ;;
    esac
}

# Enhanced interactive tutorial mode
run_interactive_tutorial() {
    local tool=$1
    local tool_dir=$2
    
    clear
    print_header "🎓 $tool Interactive Tutorial"
    
    # Step 1: Code examination
    echo "Step 1: Examining Problematic Code"
    echo "──────────────────────────────────"
    log_info "File: $tool_dir/bad_example.py"
    echo
    read -p "View the problematic code? [Y/n]: " view_code
    
    if [[ "$view_code" != "n" && "$view_code" != "N" ]]; then
        echo
        head -30 "$tool_dir/bad_example.py"
        echo "..."
        echo
        read -p "Press Enter to continue..."
    fi
    
    # Step 2: Configuration
    echo
    echo "Step 2: Understanding Tool Configuration"  
    echo "───────────────────────────────────────"
    if [[ -f "$tool_dir/config.yaml" ]]; then
        log_info "Configuration: $tool_dir/config.yaml"
        echo
        read -p "View configuration details? [y/N]: " view_config
        if [[ "$view_config" == "y" || "$view_config" == "Y" ]]; then
            cat "$tool_dir/config.yaml"
            echo
            read -p "Press Enter to continue..."
        fi
    fi
    
    # Step 3: Run analysis
    echo
    echo "Step 3: Running $tool Analysis"
    echo "$(printf '─%.0s' {1..40})"
    log_info "Scanning problematic code for issues..."
    echo
    run_tool_command "$tool" "$tool_dir/bad_example.py"
    echo
    read -p "Press Enter to continue..."
    
    # Step 4: Understanding issues
    echo
    echo "Step 4: Understanding the Issues"
    echo "───────────────────────────────"
    echo "The scan found several issues. Let's examine what each means:"
    echo
    
    # Show specific explanations based on tool
    case "$tool" in
        "bandit")
            echo "🔒 Security vulnerabilities found:"
            echo "• Hardcoded passwords expose secrets"
            echo "• Command injection risks allow arbitrary execution"
            echo "• Weak randomness makes tokens predictable"
            ;;
        "flake8")
            echo "📏 Style issues found:"
            echo "• PEP8 violations make code hard to read"
            echo "• Missing imports reduce functionality"
            echo "• Line length issues affect maintainability"
            ;;
        "mypy")
            echo "🔍 Type errors found:"
            echo "• Missing type hints reduce code clarity"
            echo "• Type mismatches can cause runtime errors"
            echo "• None handling prevents crashes"
            ;;
        *)
            echo "Issues found that affect code quality and maintainability."
            ;;
    esac
    
    echo
    read -p "Press Enter to see the fixed version..."
    
    # Step 5: Show fixed version
    echo
    echo "Step 5: Comparing with Fixed Version"
    echo "────────────────────────────────────"
    log_info "Scanning the corrected code..."
    echo
    run_tool_command "$tool" "$tool_dir/good_example.py"
    echo
    
    if [[ -f "$tool_dir/good_example.py" ]]; then
        read -p "View key differences in the fixed code? [Y/n]: " view_diff
        if [[ "$view_diff" != "n" && "$view_diff" != "N" ]]; then
            echo
            echo "Key improvements made:"
            case "$tool" in
                "bandit")
                    echo "• Passwords moved to environment variables"
                    echo "• SQL queries use parameterized statements"  
                    echo "• Commands use subprocess with argument lists"
                    echo "• Cryptographically secure random generation"
                    ;;
                "flake8")
                    echo "• Fixed import organization and spacing"
                    echo "• Corrected line lengths and indentation"
                    echo "• Removed unused variables and imports"
                    ;;
                "mypy")
                    echo "• Added comprehensive type hints"
                    echo "• Fixed return type mismatches"
                    echo "• Proper None handling and Optional types"
                    ;;
                *)
                    echo "• Code now follows best practices"
                    echo "• Issues have been resolved"
                    ;;
            esac
        fi
    fi
    
    # Educational resources
    echo
    echo "📚 Learn More"
    echo "─────────────"
    if [[ -f "$tool_dir/lesson.md" ]]; then
        head -5 "$tool_dir/lesson.md"
    else
        case "$tool" in
            "bandit")
                echo "🔗 Python Security: https://python-security.readthedocs.io/"
                echo "🔗 Bandit Docs: https://bandit.readthedocs.io/"
                ;;
            "flake8")  
                echo "🔗 PEP8 Style Guide: https://pep8.org/"
                echo "🔗 Flake8 Docs: https://flake8.pycqa.org/"
                ;;
            "mypy")
                echo "🔗 Python Type Hints: https://docs.python.org/3/library/typing.html"
                echo "🔗 MyPy Docs: https://mypy.readthedocs.io/"
                ;;
        esac
    fi
    
    echo
    log_success "Tutorial completed! You now understand how to use $tool effectively."
    read -p "Press Enter to return to main menu..."
}

# Basic tutorial mode (original simple version)
run_basic_tutorial() {
    local tool=$1
    local tool_dir=$2
    
    # Show bad example
    echo "📋 Examining problematic code:"
    echo "───────────────────────────────"
    head -20 "$tool_dir/bad_example.py"
    echo "..."
    echo
    
    # Run tool on bad example
    log_info "Running $tool on problematic code..."
    run_tool_command "$tool" "$tool_dir/bad_example.py"
    echo
    
    # Show good example
    echo "✅ Fixed version available:"
    echo "───────────────────────────"
    echo "The file $tool_dir/good_example.py contains the corrected code."
    echo
    
    # Show lesson if available
    if [[ -f "$tool_dir/lesson.md" ]]; then
        echo "📚 Learning Resources:"
        echo "───────────────────────"
        head -10 "$tool_dir/lesson.md"
        echo "..."
    fi
    
    echo
    read -p "Press Enter to continue..."
}

# Main menu
show_main_menu() {
    print_header "🚀 Python Code Quality Tools Tutorial"
    
    echo "Available Tools:"
    echo "────────────────"
    
    local tools=($(discover_tools))
    local i=1
    for tool in "${tools[@]}"; do
        printf "  %2d. %-10s - %s\n" "$i" "$tool" "$(get_tool_description $tool)"
        ((i++))
    done
    
    echo
    echo "   a. Run all tools in sequence"
    echo "   q. Quit"
    echo
}

# Setup virtual environment if needed
setup_environment() {
    if [[ ! -d "venv" ]]; then
        log_info "Creating virtual environment..."
        python3 -m venv venv
    fi
    
    source venv/bin/activate
    
    log_info "Installing/updating tools..."
    pip install -q --upgrade pip
    pip install -q bandit flake8 black mypy isort pytest
    
    log_success "Environment ready!"
}

# Main execution
main() {
    setup_environment
    
    while true; do
        show_main_menu
        
        read -p "Select option: " choice
        
        case $choice in
            q|Q)
                log_info "Goodbye!"
                exit 0
                ;;
            a|A)
                local tools=($(discover_tools))
                for tool in "${tools[@]}"; do
                    run_tool_tutorial "$tool"
                done
                ;;
            [0-9]*)
                local tools=($(discover_tools))
                local index=$((choice - 1))
                if [[ $index -ge 0 && $index -lt ${#tools[@]} ]]; then
                    run_tool_tutorial "${tools[$index]}"
                else
                    log_error "Invalid selection"
                fi
                ;;
            *)
                log_error "Invalid option"
                ;;
        esac
    done
}

# Run main function
main "$@"