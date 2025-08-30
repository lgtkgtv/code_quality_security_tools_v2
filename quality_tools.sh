#!/bin/bash
# Python Code Quality Tools - Unified Entry Point
# Supports both educational tutorials and real project scanning

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

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

# Show main menu
show_main_menu() {
    print_header "🚀 Python Code Quality Tools"
    
    echo "Choose your purpose:"
    echo "──────────────────────"
    echo "  1. 📚 Learn Tools (Interactive Educational Tutorials)"
    echo "  2. 🔍 Scan Project (Analyze Real Code & Generate Reports)"
    echo "  3. ❓ Help & Documentation"
    echo "  4. 🚪 Exit"
    echo
}

# Show help
show_help() {
    print_header "📖 Help & Documentation"
    
    cat << EOF
This tool provides two main functions:

🎓 EDUCATIONAL TUTORIALS (Option 1)
  • Interactive, one-tool-at-a-time learning experience
  • Shows problematic code examples and tool output
  • Demonstrates best practices with fixed examples
  • Great for learning how each tool works

🔍 PROJECT SCANNING (Option 2)
  • Analyze real codebases (local files/dirs or git repos)
  • Run all quality tools automatically
  • Generate detailed markdown reports
  • Perfect for code reviews and CI/CD integration

SUPPORTED TOOLS:
  • bandit   - Security vulnerability scanner
  • flake8   - PEP8 style checker
  • black    - Code formatter
  • mypy     - Static type checker
  • isort    - Import sorter
  • pytest   - Unit test runner

EXAMPLES:
  # Learn about tools interactively
  ./quality_tools.sh
  
  # Scan a git repository
  ./quality_tools.sh scan https://github.com/user/repo.git
  
  # Scan a local directory
  ./quality_tools.sh scan /path/to/project
  
  # Scan a single file
  ./quality_tools.sh scan script.py

ADDING NEW TOOLS:
  1. Copy tools/template/ to tools/your-tool/
  2. Update config.yaml with tool-specific settings
  3. Create bad_example.py and good_example.py
  4. Tools are automatically discovered and included

For more information, see the README.md files in each tool directory.
EOF
    
    echo
    read -p "Press Enter to continue..."
}

# Main execution
main() {
    # Check for direct scan command
    if [[ $# -ge 2 && "$1" == "scan" ]]; then
        ./scan_project.sh "$2"
        exit 0
    fi
    
    # Check for help flag
    if [[ $# -ge 1 && ("$1" == "-h" || "$1" == "--help" || "$1" == "help") ]]; then
        show_help
        exit 0
    fi
    
    # Interactive menu
    while true; do
        show_main_menu
        
        read -p "Select option (1-4): " choice
        
        case $choice in
            1)
                log_info "Starting educational tutorials..."
                ./tutorial_v2.sh
                ;;
            2)
                echo
                read -p "Enter target (git URL, directory, or file): " target
                if [[ -n "$target" ]]; then
                    ./scan_project.sh "$target"
                else
                    log_error "No target specified"
                fi
                ;;
            3)
                show_help
                ;;
            4|q|Q|exit)
                log_info "Goodbye!"
                exit 0
                ;;
            *)
                log_error "Invalid option. Please choose 1-4."
                ;;
        esac
        
        echo
        read -p "Press Enter to return to main menu..."
    done
}

# Run main function
main "$@"