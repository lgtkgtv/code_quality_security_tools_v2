#!/bin/bash

# Python Code Quality Tools Interactive Tutorial Runner
# Modular, extensible tutorial system for code quality tools

set -e

# Get script directory for relative paths
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Source the helper modules
source "$SCRIPT_DIR/lib/tutorial_helpers.sh"
source "$SCRIPT_DIR/lib/tool_runner.sh"
source "$SCRIPT_DIR/lib/bandit_educational.sh"
source "$SCRIPT_DIR/lib/flake8_educational.sh"
source "$SCRIPT_DIR/lib/black_educational.sh"
source "$SCRIPT_DIR/lib/mypy_educational.sh"
source "$SCRIPT_DIR/lib/isort_educational.sh"
source "$SCRIPT_DIR/lib/pytest_educational.sh"

# Configuration
CONFIG_FILE="$SCRIPT_DIR/config/tools.conf"
INDIVIDUAL_TOOLS_CONFIG="$SCRIPT_DIR/config/individual_tools.conf"
TUTORIAL_MODE="${1:-interactive}"

# Export configuration paths for child scripts
export SCRIPT_DIR
export INDIVIDUAL_TOOLS_CONFIG

# Source individual tool runner after exporting variables
source "$SCRIPT_DIR/lib/individual_tool_runner.sh"

# Main tutorial orchestrator
run_interactive_tutorial() {
    print_header "🚀 Python Code Quality Tools Tutorial"
    log_info "Master the essential tools for writing secure, maintainable Python code!"
    
    print_subheader "Tools covered"
    log_info "bandit (security), flake8 (style), black (formatting)"
    log_info "mypy (types), isort (imports), pytest (testing)"
    
    if confirm "Ready to begin?" "y"; then
        setup_tutorial_environment
        demonstrate_tools_individually  
        run_comprehensive_analysis_demo
        show_integration_workflows
        create_learning_resources
        wrap_up_tutorial
    else
        log_info "Tutorial cancelled. Run again when ready!"
    fi
}

# Environment setup with virtual environment
setup_tutorial_environment() {
    print_subheader "Environment Setup"
    
    start_timer
    
    # Load configuration
    load_config "$CONFIG_FILE"
    
    # Setup virtual environment and install tools
    setup_venv "$VENV_NAME" "$REQUIREMENTS_FILE"
    
    # Verify all tools are working
    log_step "Verifying tool installation"
    for tool in bandit flake8 black mypy isort pytest; do
        if check_command "$tool"; then
            local version=$(get_tool_version "$tool")
            log_success "$tool v$version installed"
        else
            log_error "Failed to install $tool"
            exit 1
        fi
    done
    
    end_timer "Environment setup"
}

# Individual tool demonstrations
demonstrate_tools_individually() {
    print_header "Individual Tool Demonstrations"
    
    log_info "Each tool will be demonstrated with intentionally problematic code"
    log_info "This shows you exactly what each tool catches and fixes"
    
    # Show bad code examples first
    show_example_files
    
    # Run each tool demo using the modular system
    run_tool_suite "$CONFIG_FILE"
}

# Show the example files that contain issues
show_example_files() {
    print_subheader "Example Files with Issues"
    
    local example_files=(
        "examples/bandit_security_example_donot_fixme.py:Security Issues"
        "examples/flake8_style_example_donot_fixme.py:Style Violations"
        "examples/mypy_type_example_donot_fixme.py:Type Problems"
        "examples/pytest_testing_example_donot_fixme.py:Test Failures"
    )
    
    for file_info in "${example_files[@]}"; do
        IFS=':' read -r file_path description <<< "$file_info"
        
        log_step "Examining: $description"
        log_info "File: $file_path"
        
        if check_file "$file_path"; then
            echo "Preview (first 10 lines):"
            head -10 "$file_path" | nl -v 1 -s ": "
            echo "..."
        fi
        echo ""
    done
    
    if [ "$TUTORIAL_MODE" = "interactive" ]; then
        confirm "Ready to run the tools on these files?" "y"
    fi
}

# Comprehensive analysis demonstration
run_comprehensive_analysis_demo() {
    print_header "Comprehensive Analysis Demo"
    
    log_info "Running all tools together on the example codebase"
    log_step "This simulates a real-world code review process"
    
    # Generate comprehensive report
    generate_report "analysis_output/comprehensive_report.md"
    
    log_success "Analysis complete! Check analysis_output/ directory"
    
    if [ "$TUTORIAL_MODE" = "interactive" ]; then
        log_info "Key findings:"
        
        # Show summary of major issues found
        for tool in "${TOOL_ORDER[@]}"; do
            local result="${TOOL_RESULTS[$tool]}"
            local status=$(echo "$result" | cut -d'|' -f1)
            local details=$(echo "$result" | cut -d'|' -f2-)
            
            case "$status" in
                "fail") log_error "$tool: $details" ;;
                "warning") log_warning "$tool: $details" ;;
                "pass") log_success "$tool: $details" ;;
            esac
        done
        
        echo ""
        confirm "Continue to see how to fix these issues?" "y"
    fi
}

# Show integration workflows and automation
show_integration_workflows() {
    print_header "Integration & Automation"
    
    create_integration_examples
    demonstrate_fix_workflow
    show_ci_cd_integration
}

# Create example integration files
create_integration_examples() {
    print_subheader "Creating Integration Examples"
    
    local examples_dir="$OUTPUT_DIR/integration_examples"
    mkdir -p "$examples_dir"
    
    # Pre-commit configuration
    create_precommit_config "$examples_dir"
    
    # GitHub Actions workflow
    create_github_actions_workflow "$examples_dir"
    
    # Makefile for common tasks
    create_project_makefile "$examples_dir"
    
    # VS Code settings
    create_vscode_settings "$examples_dir"
    
    log_success "Integration examples created in $examples_dir"
}

# Create pre-commit configuration
create_precommit_config() {
    local output_dir="$1"
    
    cat > "$output_dir/.pre-commit-config.yaml" << 'EOF'
repos:
  - repo: https://github.com/psf/black
    rev: 24.1.1
    hooks:
      - id: black
        language_version: python3.8
  - repo: https://github.com/pycqa/isort
    rev: 5.13.2
    hooks:
      - id: isort
        args: ["--profile", "black"]
  - repo: https://github.com/pycqa/flake8
    rev: 7.0.0
    hooks:
      - id: flake8
        additional_dependencies: [flake8-docstrings]
  - repo: https://github.com/pre-commit/mirrors-mypy
    rev: v1.8.0
    hooks:
      - id: mypy
        additional_dependencies: [types-requests]
  - repo: https://github.com/PyCQA/bandit
    rev: 1.7.5
    hooks:
      - id: bandit
        args: ["-c", "pyproject.toml"]
EOF
    
    log_info "Created: .pre-commit-config.yaml"
}

# Create GitHub Actions workflow
create_github_actions_workflow() {
    local output_dir="$1"
    mkdir -p "$output_dir/.github/workflows"
    
    cat > "$output_dir/.github/workflows/quality.yml" << 'EOF'
name: Code Quality

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main ]

jobs:
  quality:
    runs-on: ubuntu-latest
    strategy:
      matrix:
        python-version: [3.8, 3.9, "3.10", "3.11"]

    steps:
    - uses: actions/checkout@v4
    
    - name: Set up Python ${{ matrix.python-version }}
      uses: actions/setup-python@v4
      with:
        python-version: ${{ matrix.python-version }}
    
    - name: Install dependencies
      run: |
        python -m pip install --upgrade pip
        pip install -r requirements.txt
    
    - name: Security scan with bandit
      run: bandit -r . -f json -o bandit-report.json
      continue-on-error: true
    
    - name: Lint with flake8
      run: flake8 . --count --show-source --statistics
    
    - name: Check formatting with black
      run: black --check --diff .
    
    - name: Check import sorting with isort
      run: isort --check-only --diff .
    
    - name: Type check with mypy
      run: mypy . --ignore-missing-imports
    
    - name: Test with pytest
      run: pytest tests/ -v --cov=. --cov-report=xml
    
    - name: Upload coverage reports
      uses: codecov/codecov-action@v3
      with:
        file: ./coverage.xml
EOF
    
    log_info "Created: .github/workflows/quality.yml"
}

# Create project Makefile
create_project_makefile() {
    local output_dir="$1"
    
    cat > "$output_dir/Makefile" << 'EOF'
.PHONY: install format lint typecheck security test quality clean help

PYTHON := python3
PIP := pip3

help: ## Show this help message
	@echo 'Usage: make [target]'
	@echo ''
	@echo 'Targets:'
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "  %-15s %s\n", $$1, $$2}' $(MAKEFILE_LIST)

install: ## Install dependencies
	$(PIP) install -r requirements.txt

format: ## Format code with black and isort
	black .
	isort .

lint: ## Run flake8 linting
	flake8 .

typecheck: ## Run mypy type checking
	mypy . --ignore-missing-imports

security: ## Run bandit security scanning
	bandit -r . -ll

test: ## Run pytest tests
	pytest tests/ -v

quality: format lint typecheck security test ## Run all quality checks
	@echo "All quality checks passed! ✨"

clean: ## Clean up generated files
	find . -type f -name "*.pyc" -delete
	find . -type d -name "__pycache__" -delete
	find . -type d -name "*.egg-info" -exec rm -rf {} +
	rm -rf .pytest_cache .mypy_cache .coverage htmlcov/

# Development workflow targets
dev-setup: install ## Set up development environment
	pre-commit install
	@echo "Development environment ready!"

check: ## Quick quality check (fast)
	black --check .
	isort --check-only .
	flake8 . --count

fix: ## Auto-fix issues where possible
	black .
	isort .
	@echo "Auto-fixes applied. Run 'make check' to verify."
EOF
    
    log_info "Created: Makefile"
}

# Create VS Code settings
create_vscode_settings() {
    local output_dir="$1"
    mkdir -p "$output_dir/.vscode"
    
    cat > "$output_dir/.vscode/settings.json" << 'EOF'
{
    "python.defaultInterpreterPath": "./venv/bin/python",
    "python.formatting.provider": "black",
    "python.linting.enabled": true,
    "python.linting.flake8Enabled": true,
    "python.linting.mypyEnabled": true,
    "python.linting.banditEnabled": true,
    "python.sortImports.provider": "isort",
    "python.sortImports.args": ["--profile", "black"],
    "editor.formatOnSave": true,
    "editor.codeActionsOnSave": {
        "source.organizeImports": true
    },
    "python.linting.flake8Args": [
        "--max-line-length=88",
        "--extend-ignore=E203,W503"
    ],
    "python.linting.mypyArgs": [
        "--ignore-missing-imports",
        "--follow-imports=silent",
        "--show-column-numbers"
    ],
    "files.associations": {
        "*.py": "python"
    },
    "python.testing.pytestEnabled": true,
    "python.testing.pytestArgs": [
        "tests/"
    ]
}
EOF
    
    log_info "Created: .vscode/settings.json"
}

# Demonstrate the fix workflow
demonstrate_fix_workflow() {
    print_subheader "Automatic Fix Demonstration"
    
    if confirm "Run auto-fix mode demonstration?" "y"; then
        run_fix_mode "$CONFIG_FILE"
    else
        log_info "Skipping auto-fix demonstration"
    fi
}

# Show CI/CD integration patterns  
show_ci_cd_integration() {
    print_subheader "CI/CD Integration Patterns"
    
    log_info "Quality gates in continuous integration:"
    echo "  • Pre-commit hooks catch issues early"
    echo "  • Pull request checks enforce standards"  
    echo "  • Automated security scanning"
    echo "  • Coverage requirements"
    echo "  • Performance regression detection"
    
    log_info "Best practices:"
    echo "  • Fail fast on security issues"
    echo "  • Allow formatting fixes automatically"
    echo "  • Gradual type checking adoption"
    echo "  • Comprehensive test coverage"
}

# Create learning resources
create_learning_resources() {
    print_header "Learning Resources"
    
    create_cheat_sheet_advanced
    create_troubleshooting_guide
    create_configuration_templates
}

# Create advanced cheat sheet
create_cheat_sheet_advanced() {
    local cheat_sheet="$OUTPUT_DIR/advanced_cheat_sheet.md"
    
    log_step "Creating advanced cheat sheet"
    
    cat > "$cheat_sheet" << 'EOF'
# Python Code Quality Tools - Advanced Cheat Sheet

## Quick Commands

### Format & Fix
```bash
make format          # Auto-format with black + isort
make fix            # Apply all auto-fixes
make check          # Quick format/style check
```

### Analysis
```bash
make quality        # Full quality suite
make security       # Security scan only
make typecheck      # Type checking only
```

### Integration
```bash
pre-commit install                    # Set up git hooks
pre-commit run --all-files           # Run on all files
pre-commit autoupdate                # Update hook versions
```

## Tool-Specific Advanced Usage

### Bandit (Security)
```bash
bandit -r . -ll -i                   # Interactive mode
bandit -r . -f json -o report.json   # JSON report
bandit -r . --skip B101,B601         # Skip specific checks
bandit -c bandit.yaml -r .           # Custom config
```

### Flake8 (Style)
```bash
flake8 --statistics                  # Show error statistics  
flake8 --show-source                 # Show source code
flake8 --max-complexity=10           # Complexity limit
flake8 --benchmark                   # Performance timing
```

### Black (Formatting)
```bash
black --fast .                       # Skip string normalization
black --target-version py38          # Python version target
black --include="\.pyi?$"            # Include pattern
black --experimental-string-processing # Experimental features
```

### MyPy (Type Checking)
```bash
mypy --strict                        # Strictest checking
mypy --install-types                 # Install missing stubs
mypy --show-error-codes              # Show error codes
mypy --cache-dir=/tmp/mypy           # Custom cache location
```

### isort (Import Sorting)
```bash
isort --profile black                # Black compatibility
isort --multi-line=3                 # Multi-line style
isort --force-alphabetical-sort      # Alphabetical sorting
isort --check-only --diff            # Show what would change
```

### pytest (Testing)
```bash
pytest -x                           # Stop on first failure
pytest --lf                         # Run last failed tests
pytest --cov=src --cov-report=html  # Coverage with HTML report
pytest -k "test_security"           # Run specific test pattern
```

## Configuration Examples

### pyproject.toml (Modern Python)
```toml
[tool.black]
line-length = 88
target-version = ['py38']
extend-exclude = '''
/(
  | migrations
  | .venv
)/
'''

[tool.isort]
profile = "black"
multi_line_output = 3
line_length = 88
known_first_party = ["myproject"]

[tool.mypy]
python_version = "3.8"
strict = true
warn_return_any = true
warn_unused_configs = true

[tool.bandit]
exclude_dirs = ["tests", "migrations"]
skips = ["B101", "B601"]

[tool.pytest.ini_options]
minversion = "7.0"
addopts = "-ra -q --strict-markers"
testpaths = ["tests"]
```

### setup.cfg (Legacy)
```ini
[flake8]
max-line-length = 88
extend-ignore = E203, W503
max-complexity = 10
exclude = .git,__pycache__,migrations

[coverage:run]
source = src/
omit = */tests/*,*/migrations/*

[coverage:report]  
exclude_lines =
    pragma: no cover
    def __repr__
    raise AssertionError
```

## Troubleshooting

### Common Issues
- **Black vs Flake8 conflicts**: Use `extend-ignore = E203, W503`
- **Import order conflicts**: Use `isort --profile black` 
- **MyPy missing stubs**: Run `mypy --install-types`
- **Bandit false positives**: Use `# nosec` comments carefully

### Performance Tips
- Use `--fast` flag for Black in development
- Configure exclude patterns to skip irrelevant files
- Use parallel execution where available
- Cache type checking results with MyPy

### Integration Debugging
- Check tool versions compatibility
- Verify configuration file precedence
- Use `--verbose` flags for detailed output
- Test configurations on small files first
EOF
    
    log_success "Advanced cheat sheet created: $cheat_sheet"
}

# Create troubleshooting guide
create_troubleshooting_guide() {
    local guide="$OUTPUT_DIR/troubleshooting_guide.md"
    
    log_step "Creating troubleshooting guide"
    
    cat > "$guide" << 'EOF'
# Code Quality Tools - Troubleshooting Guide

## Common Issues & Solutions

### Installation Problems

**Issue**: Tool not found after installation
```bash
# Solution: Ensure virtual environment is active
source venv/bin/activate
which python  # Should point to venv
```

**Issue**: Permission errors during installation
```bash
# Solution: Use virtual environment (never sudo pip)
python -m venv venv
source venv/bin/activate
pip install -r requirements.txt
```

### Configuration Conflicts

**Issue**: Black and flake8 disagree on line length
```ini
# In setup.cfg or .flake8
[flake8]
max-line-length = 88
extend-ignore = E203, W503
```

**Issue**: isort changes imports that Black reformats
```toml
# In pyproject.toml
[tool.isort]
profile = "black"
multi_line_output = 3
```

### Performance Issues

**Issue**: MyPy is too slow on large codebases
```bash
# Solutions:
mypy --cache-dir=/tmp/mypy .     # Custom cache location
mypy --follow-imports=silent .   # Skip following imports
mypy src/ --ignore-missing-imports  # Focus on your code
```

**Issue**: Bandit scanning takes too long
```yaml
# In bandit.yaml
exclude_dirs: 
  - tests
  - migrations
  - .venv
```

### False Positives

**Issue**: Bandit flags test code as insecure
```python
# Use nosec comment for test files
password = "test_password_123"  # nosec B105
```

**Issue**: MyPy complains about third-party libraries
```bash
# Ignore missing imports temporarily
mypy --ignore-missing-imports .

# Or install type stubs
mypy --install-types
```

### CI/CD Issues

**Issue**: Tests pass locally but fail in CI
```yaml
# Ensure consistent Python versions
strategy:
  matrix:
    python-version: [3.8, 3.9]  # Match local development
```

**Issue**: Pre-commit hooks are slow
```yaml
# In .pre-commit-config.yaml
default_stages: [commit, push]  # Skip some stages
```

## Tool-Specific Debugging

### Black
```bash
black --diff .           # See what would change
black --check .          # Check only (exit code indicates changes needed)
black --verbose .        # Detailed output
```

### Flake8  
```bash
flake8 --statistics .    # Show error counts
flake8 --show-source .   # Show problematic source code
flake8 --benchmark .     # Performance information
```

### MyPy
```bash
mypy --show-error-codes .     # Show specific error codes
mypy --show-traceback .       # Full traceback on crash  
mypy --verbose .              # Detailed processing info
```

### Bandit
```bash
bandit -v .              # Verbose output
bandit --debug .         # Debug information
bandit -f json .         # Machine-readable output
```

## Getting Help

### Command Line Help
```bash
black --help
flake8 --help  
mypy --help
bandit --help
isort --help
pytest --help
```

### Version Information
```bash
# Check versions for compatibility
black --version
flake8 --version
mypy --version
bandit --version
isort --version
pytest --version
```

### Configuration Discovery
```bash
# Find which config files are being used
flake8 --version --verbose    # Shows config file locations
black --verbose .             # Shows what files are processed
mypy --config-file mypy.ini --verbose .
```
EOF
    
    log_success "Troubleshooting guide created: $guide"
}

# Create configuration templates
create_configuration_templates() {
    local templates_dir="$OUTPUT_DIR/config_templates"
    mkdir -p "$templates_dir"
    
    log_step "Creating configuration templates"
    
    # Create various configuration file templates
    # (Implementation would create pyproject.toml, setup.cfg, etc. templates)
    
    log_success "Configuration templates created in $templates_dir"
}

# Tutorial wrap-up
wrap_up_tutorial() {
    print_header "🎉 Tutorial Complete!"
    
    log_success "Congratulations! You've mastered Python code quality tools"
    
    echo ""
    log_info "Skills acquired:"
    echo "  🛡️  Security scanning with bandit"
    echo "  📏 Code style enforcement with flake8"
    echo "  🎨 Automatic formatting with black"
    echo "  🎯 Type checking with mypy"
    echo "  📚 Import organization with isort"
    echo "  🧪 Testing with pytest"
    
    echo ""
    log_info "Resources created:"
    echo "  📊 Comprehensive analysis reports"
    echo "  🔧 Integration examples and configurations"
    echo "  📋 Advanced cheat sheets and guides"
    echo "  🛠️  Ready-to-use CI/CD workflows"
    
    echo ""
    log_info "Next steps:"
    echo "  • Apply these tools to your existing projects"
    echo "  • Set up pre-commit hooks"
    echo "  • Configure your IDE for automatic checks"
    echo "  • Add quality gates to your CI/CD pipeline"
    echo "  • Gradually adopt stricter configurations"
    
    echo ""
    log_success "Happy coding with high-quality, secure Python! 🚀"
}

# Non-interactive mode for automated execution
run_automated_mode() {
    print_header "🤖 Automated Analysis Mode"
    
    # Use the new automated tools configuration
    local automated_config="$SCRIPT_DIR/config/automated_tools.conf"
    
    # Load the automated configuration
    if [ -f "$automated_config" ]; then
        source "$automated_config"
        log_success "Loaded automated mode configuration"
    else
        # Fallback to legacy configuration
        automated_config="$CONFIG_FILE"
        log_warning "Using legacy configuration"
    fi
    
    setup_tutorial_environment
    
    # Prepare all working directories with example files
    if declare -f prepare_all_working_dirs >/dev/null; then
        log_step "Preparing working directories"
        prepare_all_working_dirs
        log_success "Working directories prepared with example files"
    fi
    
    log_step "Running comprehensive analysis"
    run_tool_suite "$automated_config"
    
    log_step "Generating reports"
    generate_report
    
    log_success "Automated analysis complete"
}

# Main entry point
main() {
    case "${TUTORIAL_MODE}" in
        "interactive"|""|"menu")
            handle_main_menu
            ;;
        "full"|"tutorial")
            run_interactive_tutorial
            ;;
        "tools"|"individual")
            setup_individual_tools_environment
            run_interactive_tool_selection false
            ;;
        "autofix")
            setup_individual_tools_environment
            run_interactive_tool_selection true
            ;;
        "automated"|"auto")
            run_automated_mode
            ;;
        "fix")
            setup_tutorial_environment
            run_fix_mode "$CONFIG_FILE"
            ;;
        "--help"|"-h"|"help")
            show_usage
            ;;
        *)
            log_error "Unknown mode: $TUTORIAL_MODE"
            show_usage
            exit 1
            ;;
    esac
}

# Main menu for tutorial modes
show_main_menu() {
    print_header "🚀 Python Code Quality Tools Tutorial"
    
    echo "Tutorial Modes:"
    echo "  1. Full Tutorial    - Complete guided tutorial with explanations"
    echo "  2. Individual Tools - Select and run specific tools interactively"  
    echo "  3. Autofix Mode     - Individual tools with automatic fixing enabled"
    echo "  4. Automated Run    - Run all tools without interaction"
    echo "  5. Help            - Show detailed usage information"
    echo ""
    echo "  0. Exit"
    echo ""
}

# Handle main menu selection
handle_main_menu() {
    while true; do
        show_main_menu
        echo -n "Select mode: "
        read -r choice
        echo ""
        
        case "$choice" in
            1|"full"|"tutorial")
                run_interactive_tutorial
                break
                ;;
            2|"individual"|"tools")
                setup_individual_tools_environment
                run_interactive_tool_selection false
                break
                ;;
            3|"autofix")
                setup_individual_tools_environment  
                run_interactive_tool_selection true
                break
                ;;
            4|"automated"|"auto")
                run_automated_mode
                break
                ;;
            5|"help")
                show_usage
                echo ""
                echo "Press Enter to continue..."
                read -r
                ;;
            0|"exit"|"quit")
                log_info "Goodbye!"
                exit 0
                ;;
            *)
                log_error "Invalid selection: $choice"
                echo ""
                echo "Press Enter to continue..."
                read -r
                ;;
        esac
    done
}

# Setup environment for individual tools mode
setup_individual_tools_environment() {
    print_subheader "Environment Setup"
    
    # Load individual tools configuration
    if [ -f "$INDIVIDUAL_TOOLS_CONFIG" ]; then
        source "$INDIVIDUAL_TOOLS_CONFIG"
        log_success "Loaded individual tools configuration"
    else
        log_error "Individual tools configuration not found: $INDIVIDUAL_TOOLS_CONFIG"
        exit 1
    fi
    
    # Setup virtual environment and install tools (reuse existing function)
    setup_venv "$VENV_NAME" "$REQUIREMENTS_FILE"
    
    # Create analysis output directories
    for tool in bandit flake8 black mypy isort pytest; do
        mkdir -p "${TOOL_OUTPUT_DIRS[$tool]}"
    done
    
    log_success "Environment ready for individual tool analysis"
    echo ""
}

# Show usage information
show_usage() {
    cat << EOF
Python Code Quality Tools Tutorial

Usage: $0 [mode]

Modes:
  interactive  Show main menu for mode selection (default)
  full         Complete guided tutorial with explanations  
  tools        Interactive individual tool selection
  autofix      Individual tools with automatic fixing enabled
  automated    Run all tools without interaction
  fix          Legacy auto-fix mode
  help         Show this help message

Examples:
  $0                    # Show interactive main menu
  $0 full              # Run complete tutorial
  $0 tools             # Select individual tools interactively
  $0 autofix           # Individual tools with autofix enabled
  $0 automated         # Run all tools automatically

Features:
  - Tool-specific directories with isolated examples
  - Safe autofix (preserves original bad examples)
  - Individual tool configuration files
  - Comprehensive output and reporting

The tutorial covers bandit, flake8, black, mypy, isort, and pytest.
All output is saved to tool-specific directories in analysis_output/.
EOF
}

# Error handling setup
set_error_handling

# Run the main function
main "$@"