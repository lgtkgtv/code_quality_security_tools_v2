#!/bin/bash
# Tutorial Helper Library
# Provides reusable functions for formatting, logging, and common operations

# Color codes and formatting (check if not already defined)
[[ -z "${RED:-}" ]] && declare -r RED='\033[0;31m'
[[ -z "${GREEN:-}" ]] && declare -r GREEN='\033[0;32m'
[[ -z "${YELLOW:-}" ]] && declare -r YELLOW='\033[1;33m'
[[ -z "${BLUE:-}" ]] && declare -r BLUE='\033[0;34m'
[[ -z "${CYAN:-}" ]] && declare -r CYAN='\033[0;36m'
[[ -z "${PURPLE:-}" ]] && declare -r PURPLE='\033[0;35m'
[[ -z "${BOLD:-}" ]] && declare -r BOLD='\033[1m'
[[ -z "${NC:-}" ]] && declare -r NC='\033[0m' # No Color

# Icons and symbols (check if not already defined)
[[ -z "${CHECKMARK:-}" ]] && declare -r CHECKMARK="✅"
[[ -z "${CROSS:-}" ]] && declare -r CROSS="❌"
[[ -z "${WARNING:-}" ]] && declare -r WARNING="⚠️"
[[ -z "${INFO:-}" ]] && declare -r INFO="ℹ️"
[[ -z "${ROCKET:-}" ]] && declare -r ROCKET="🚀"
[[ -z "${GEAR:-}" ]] && declare -r GEAR="⚙️"
[[ -z "${MAGNIFY:-}" ]] && declare -r MAGNIFY="🔍"
[[ -z "${BULB:-}" ]] && declare -r BULB="💡"
[[ -z "${BOOK:-}" ]] && declare -r BOOK="📚"
[[ -z "${WRENCH:-}" ]] && declare -r WRENCH="🔧"

# Logging functions
log_info() {
    echo -e "${BLUE}${INFO} $1${NC}"
}

log_success() {
    echo -e "${GREEN}${CHECKMARK} $1${NC}"
}

log_warning() {
    echo -e "${YELLOW}${WARNING} $1${NC}"
}

log_error() {
    echo -e "${RED}${CROSS} $1${NC}"
}

log_step() {
    echo -e "${CYAN}${GEAR} $1${NC}"
}

log_analyzing() {
    echo -e "${PURPLE}${MAGNIFY} $1${NC}"
}

# Section headers
print_header() {
    local title="$1"
    local width=${2:-60}
    echo ""
    echo -e "${BLUE}$(printf '═%.0s' $(seq 1 $width))${NC}"
    echo -e "${BLUE}${BOLD} $title ${NC}"
    echo -e "${BLUE}$(printf '═%.0s' $(seq 1 $width))${NC}"
    echo ""
}

print_subheader() {
    local title="$1"
    echo ""
    echo -e "${CYAN}${BOLD}── $title ──${NC}"
    echo ""
}

# Progress indicators
show_progress() {
    local current=$1
    local total=$2
    local task="$3"
    local percent=$((current * 100 / total))
    local filled=$((percent / 5))
    local empty=$((20 - filled))
    
    printf "\r${BLUE}Progress: ["
    printf "%*s" $filled | tr ' ' '█'
    printf "%*s" $empty | tr ' ' '░'
    printf "] %d%% - %s${NC}" $percent "$task"
    
    if [ $current -eq $total ]; then
        echo ""
    fi
}

# File operations
backup_file() {
    local file="$1"
    local backup_dir="${2:-backups}"
    
    if [ -f "$file" ]; then
        mkdir -p "$backup_dir"
        local backup_name="$(basename "$file").$(date +%Y%m%d_%H%M%S).bak"
        cp "$file" "$backup_dir/$backup_name"
        log_info "Backed up $file to $backup_dir/$backup_name"
    fi
}

# Environment checks
check_command() {
    local cmd="$1"
    local package="${2:-$cmd}"
    
    if command -v "$cmd" >/dev/null 2>&1; then
        return 0
    else
        log_error "$cmd not found. Please install: $package"
        return 1
    fi
}

check_python_package() {
    local package="$1"
    if python -c "import $package" 2>/dev/null; then
        return 0
    else
        log_error "Python package '$package' not found"
        return 1
    fi
}

check_file() {
    local file="$1"
    local description="${2:-File}"
    
    if [ -f "$file" ]; then
        log_success "$description found: $file"
        return 0
    else
        log_error "$description not found: $file"
        return 1
    fi
}

# Virtual environment operations
setup_venv() {
    local venv_name="${1:-venv}"
    local requirements_file="${2:-requirements.txt}"
    
    log_step "Setting up virtual environment: $venv_name"
    
    if [ ! -d "$venv_name" ]; then
        python -m venv "$venv_name"
        log_success "Created virtual environment"
    fi
    
    source "$venv_name/bin/activate"
    log_success "Activated virtual environment"
    
    if [ -f "$requirements_file" ]; then
        log_step "Installing dependencies from $requirements_file"
        pip install -r "$requirements_file" >/dev/null 2>&1
        log_success "Dependencies installed"
    fi
}

# Result formatting
format_tool_result() {
    local tool_name="$1"
    local status="$2"
    local details="$3"
    local file_count="${4:-}"
    
    printf "  %-12s " "$tool_name:"
    
    case "$status" in
        "pass")
            echo -e "${GREEN}PASS${NC} $details"
            ;;
        "fail")
            echo -e "${RED}FAIL${NC} $details"
            ;;
        "warning")
            echo -e "${YELLOW}WARN${NC} $details"
            ;;
        "skip")
            echo -e "${CYAN}SKIP${NC} $details"
            ;;
        *)
            echo -e "${NC}$status${NC} $details"
            ;;
    esac
    
    if [ -n "$file_count" ]; then
        echo "              ${CYAN}Files processed: $file_count${NC}"
    fi
}

# Summary table
print_summary_table() {
    local -n results_ref=$1
    
    print_subheader "Summary"
    
    printf "%-15s %-8s %-40s\n" "Tool" "Status" "Details"
    printf "%-15s %-8s %-40s\n" "$(printf -- '-%.0s' {1..15})" "$(printf -- '-%.0s' {1..8})" "$(printf -- '-%.0s' {1..40})"
    
    for tool in "${!results_ref[@]}"; do
        local result="${results_ref[$tool]}"
        local status=$(echo "$result" | cut -d'|' -f1)
        local details=$(echo "$result" | cut -d'|' -f2-)
        
        case "$status" in
            "pass")
                printf "%-15s ${GREEN}%-8s${NC} %-40s\n" "$tool" "PASS" "$details"
                ;;
            "fail")
                printf "%-15s ${RED}%-8s${NC} %-40s\n" "$tool" "FAIL" "$details"
                ;;
            "warning")
                printf "%-15s ${YELLOW}%-8s${NC} %-40s\n" "$tool" "WARN" "$details"
                ;;
        esac
    done
    echo ""
}

# Execution timing
start_timer() {
    TIMER_START=$(date +%s)
}

end_timer() {
    local task_name="$1"
    local end_time=$(date +%s)
    local duration=$((end_time - TIMER_START))
    log_info "$task_name completed in ${duration}s"
}

# Cleanup functions
cleanup_temp_files() {
    local temp_dir="${1:-.}"
    find "$temp_dir" -name "*.pyc" -delete 2>/dev/null || true
    find "$temp_dir" -name "__pycache__" -type d -exec rm -rf {} + 2>/dev/null || true
    log_info "Cleaned up temporary files"
}

# Error handling
handle_error() {
    local exit_code=$?
    local line_number=$1
    local command="$2"
    
    if [ $exit_code -ne 0 ]; then
        log_error "Command failed on line $line_number: $command"
        log_error "Exit code: $exit_code"
        exit $exit_code
    fi
}

# Set error trap
set_error_handling() {
    set -eE
    trap 'handle_error ${LINENO} "$BASH_COMMAND"' ERR
}

# Interactive prompts
confirm() {
    local prompt="$1"
    local default="${2:-n}"
    
    if [ "$default" = "y" ]; then
        prompt="$prompt [Y/n]: "
    else
        prompt="$prompt [y/N]: "
    fi
    
    read -p "$prompt" answer
    case "$answer" in
        [Yy]* ) return 0;;
        [Nn]* ) return 1;;
        "" ) 
            if [ "$default" = "y" ]; then
                return 0
            else
                return 1
            fi
            ;;
        * ) return 1;;
    esac
}

# Version information
get_tool_version() {
    local tool="$1"
    
    case "$tool" in
        "python")
            python --version 2>&1 | cut -d' ' -f2
            ;;
        "pip")
            pip --version | cut -d' ' -f2
            ;;
        "bandit")
            bandit --version 2>&1 | grep "bandit" | cut -d' ' -f2 || echo "unknown"
            ;;
        "flake8")
            flake8 --version | cut -d' ' -f1
            ;;
        "black")
            black --version | cut -d' ' -f3
            ;;
        "mypy")
            mypy --version | cut -d' ' -f2
            ;;
        "isort")
            isort --version | grep VERSION | cut -d' ' -f2
            ;;
        "pytest")
            pytest --version | head -1 | cut -d' ' -f2
            ;;
        *)
            echo "unknown"
            ;;
    esac
}

# Configuration loading
load_config() {
    local config_file="${1:-config/tools.conf}"
    
    if [ -f "$config_file" ]; then
        source "$config_file"
        log_success "Loaded configuration from $config_file"
    else
        log_warning "Configuration file not found: $config_file"
        log_info "Using default settings"
    fi
}