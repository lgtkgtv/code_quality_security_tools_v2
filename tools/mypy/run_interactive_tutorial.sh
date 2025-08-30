#!/bin/bash

# MyPy Type Checker - Enhanced Interactive Educational Tutorial
# Focused on type safety and static analysis

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
MAGNIFY="🔍"
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
    printf " $MAGNIFY %-*s $MAGNIFY\n" $((width-6)) "$title"
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

# Function to run mypy and capture results
run_mypy_scan() {
    local target_file="$1"
    
    echo "${GEAR} Analyzing types with mypy..."
    echo ""
    
    # Run mypy and capture output
    local temp_output=$(mktemp)
    mypy "$target_file" > "$temp_output" 2>&1
    local exit_code=$?
    local error_count=$(grep -c "error:" "$temp_output" || echo "0")
    
    # Parse and display results
    if [[ $exit_code -eq 0 ]]; then
        echo "${CHECK_MARK} ${CHECK_MARK} No type errors found!"
        echo "${GREEN}🎉 All type annotations are correct!${NC}"
    else
        echo "${WARNING} Found $error_count type errors:"
        echo ""
        
        # Categorize errors by type
        local missing_hints=$(grep -c "has no attribute\|Missing return statement\|Function is missing a type annotation" "$temp_output" || echo "0")
        local type_mismatches=$(grep -c "Incompatible types\|Argument.*has incompatible type" "$temp_output" || echo "0")
        local optional_errors=$(grep -c "None.*not compatible\|Optional\|Union" "$temp_output" || echo "0")
        local return_type_errors=$(grep -c "Missing return statement\|Incompatible return value type" "$temp_output" || echo "0")
        
        echo "Type Error Categories:"
        echo "  ${FIRE} Missing type hints:  $missing_hints errors"
        echo "  ${ORANGE} Type mismatches:     $type_mismatches errors"
        echo "  ${YELLOW_CIRCLE} Optional/None issues: $optional_errors errors"
        echo "  ${TARGET} Return type errors:  $return_type_errors errors"
        echo ""
        
        # Show first 8 errors as examples
        echo "Example errors (first 8):"
        grep "error:" "$temp_output" | head -8
        if [[ $error_count -gt 8 ]]; then
            echo "... and $((error_count - 8)) more type errors"
        fi
    fi
    
    # Save output for later use
    cp "$temp_output" "/tmp/mypy_results.txt"
    rm "$temp_output"
    
    return $exit_code
}

# Function to explain type issues with examples
explain_type_issues() {
    echo "${INFO} Let's examine the most common type safety issues:"
    echo ""
    
    # Missing type hints
    echo "${MAGNIFY} ${BOLD}MISSING TYPE HINTS${NC}"
    echo "───────────────────────────────────────────"
    echo "${CROSS_MARK} Problematic code:"
    echo "   def process_numbers(numbers):  # Missing parameter and return types"
    echo "       total = 0"
    echo "       for num in numbers:"
    echo "           total += num  # MyPy can't verify num is a number"
    echo "       return total"
    echo ""
    echo "${CHECK_MARK} Type-safe alternative:"
    echo "   def process_numbers(numbers: List[int]) -> int:"
    echo "       total = 0"
    echo "       for num in numbers:"
    echo "           total += num  # Now mypy knows num is an int"
    echo "       return total"
    echo ""
    echo "${INFO} Why this matters: Type hints catch errors before runtime and improve code clarity"
    pause
    
    # Return type mismatches
    echo "${FIRE} ${BOLD}RETURN TYPE MISMATCHES${NC}"
    echo "───────────────────────────────────────────"
    echo "${CROSS_MARK} Problematic code:"
    echo "   def get_user_name(user_id: int) -> str:  # Promises to return str"
    echo "       users = {1: 'Alice', 2: 'Bob'}"
    echo "       return users.get(user_id)  # But get() returns Optional[str]!"
    echo ""
    echo "${CHECK_MARK} Type-safe alternative:"
    echo "   def get_user_name(user_id: int) -> Optional[str]:"
    echo "       users = {1: 'Alice', 2: 'Bob'}"
    echo "       return users.get(user_id)  # Correct return type"
    echo ""
    echo "   # Or handle None case:"
    echo "   def get_user_name(user_id: int) -> str:"
    echo "       users = {1: 'Alice', 2: 'Bob'}"
    echo "       return users.get(user_id, 'Unknown')  # Always returns str"
    echo ""
    echo "${INFO} Why this matters: Prevents None-related runtime crashes"
    pause
    
    # Type compatibility errors
    echo "${ORANGE} ${BOLD}TYPE COMPATIBILITY ISSUES${NC}"
    echo "───────────────────────────────────────────"
    echo "${CROSS_MARK} Problematic code:"
    echo "   def get_info(self) -> Dict[str, str]:  # All values must be str"
    echo "       return {"
    echo "           'name': self.name,    # str - OK"
    echo "           'age': self.age       # int - ERROR! Expected str"
    echo "       }"
    echo ""
    echo "${CHECK_MARK} Type-safe alternatives:"
    echo "   # Option 1: Fix the return type"
    echo "   def get_info(self) -> Dict[str, Union[str, int]]:"
    echo "       return {'name': self.name, 'age': self.age}"
    echo ""
    echo "   # Option 2: Convert to string"
    echo "   def get_info(self) -> Dict[str, str]:"
    echo "       return {'name': self.name, 'age': str(self.age)}"
    echo ""
    echo "${INFO} Why this matters: Ensures data structure consistency"
    pause
    
    # None handling
    echo "${YELLOW_CIRCLE} ${BOLD}OPTIONAL/NONE HANDLING${NC}"
    echo "───────────────────────────────────────────"
    echo "${CROSS_MARK} Problematic code:"
    echo "   text: Optional[str] = None"
    echo "   length = text.upper()  # ERROR: text might be None!"
    echo ""
    echo "${CHECK_MARK} Type-safe alternatives:"
    echo "   # Option 1: Check for None"
    echo "   if text is not None:"
    echo "       length = text.upper()"
    echo ""
    echo "   # Option 2: Use default value"
    echo "   length = (text or '').upper()"
    echo ""
    echo "   # Option 3: Use type assertion (if you're certain)"
    echo "   assert text is not None"
    echo "   length = text.upper()"
    echo ""
    echo "${INFO} Why this matters: Eliminates AttributeError on None values"
    pause
    
    # Variable annotations
    echo "${TARGET} ${BOLD}VARIABLE ANNOTATIONS${NC}"
    echo "───────────────────────────────────────────"
    echo "${CROSS_MARK} Problematic code:"
    echo "   numbers = ['1', '2', '3']  # MyPy infers List[str]"
    echo "   numbers: List[int] = ['1', '2', '3']  # ERROR: annotation mismatch"
    echo ""
    echo "${CHECK_MARK} Type-safe alternatives:"
    echo "   # Option 1: Fix the annotation"
    echo "   numbers: List[str] = ['1', '2', '3']"
    echo ""
    echo "   # Option 2: Convert the data"
    echo "   numbers: List[int] = [1, 2, 3]"
    echo ""
    echo "   # Option 3: Convert at runtime"
    echo "   str_numbers = ['1', '2', '3']"
    echo "   numbers: List[int] = [int(x) for x in str_numbers]"
    echo ""
    echo "${INFO} Why this matters: Ensures variable types match their intended use"
    pause
}

# Main tutorial function
run_tutorial() {
    clear
    
    # Header
    print_section "🔍 MyPy Type Checker - Educational Mode"
    
    # Step 1: Examine bad code
    print_subsection "Step 1: Examining Code with Type Issues"
    
    echo "${INFO} File: tools/mypy/bad_example.py"
    echo ""
    echo "This file intentionally contains type safety issues for learning:"
    echo "• Missing type annotations"
    echo "• Return type mismatches"
    echo "• Optional/None handling errors"
    echo "• Type compatibility problems"
    echo "• Variable annotation mistakes"
    echo "• Attribute access errors"
    echo ""
    
    if ask_yn "View the problematic code?" "y"; then
        show_code "$BAD_EXAMPLE" 1 50
        pause
    fi
    
    # Step 2: Show configuration
    print_subsection "Step 2: Understanding MyPy Configuration"
    
    echo "${INFO} Configuration file: tools/mypy/config.yaml"
    echo ""
    echo "Key configuration options:"
    echo "• Strictness level (--strict mode recommended)"
    echo "• Type checking options"
    echo "• Error reporting settings"
    echo "• Module inclusion/exclusion rules"
    echo ""
    
    if ask_yn "View the configuration details?" "n"; then
        if [[ -f "$CONFIG_FILE" ]]; then
            cat "$CONFIG_FILE"
        else
            echo "Configuration file not found"
        fi
        pause
    fi
    
    # Step 3: Run type check
    print_subsection "Step 3: Running MyPy Type Analysis"
    
    echo "${INFO} Command: mypy bad_example.py"
    echo ""
    echo "Options explained:"
    echo "• Performs static type analysis"
    echo "• Reports type errors and inconsistencies"
    echo "• Checks function signatures and return types"
    echo "• Validates variable assignments"
    echo ""
    
    # Run the scan
    run_mypy_scan "$BAD_EXAMPLE"
    echo ""
    pause
    
    # Step 4: Understanding and fixing issues
    print_subsection "Step 4: Understanding and Fixing Type Issues"
    
    if ask_yn "View specific fixes for each type of issue?" "y"; then
        explain_type_issues
    fi
    
    # Step 5: Compare with fixed version
    print_subsection "Step 5: Comparing with Type-Safe Version"
    
    echo "${INFO} Fixed file: tools/mypy/good_example.py"
    echo ""
    run_mypy_scan "$GOOD_EXAMPLE"
    echo ""
    
    if ask_yn "View key differences between problematic and type-safe code?" "y"; then
        echo ""
        echo "${INFO} Key Type Safety Fixes Applied:"
        echo ""
        echo "1. Missing Type Hints → Complete Annotations"
        echo "   BAD:  def process_numbers(numbers):"
        echo "   GOOD: def process_numbers(numbers: List[int]) -> int:"
        echo ""
        echo "2. Return Type Errors → Proper Optional Handling"
        echo "   BAD:  def get_user(id: int) -> str:  # Can return None"
        echo "   GOOD: def get_user(id: int) -> Optional[str]:"
        echo ""
        echo "3. Type Mismatches → Compatible Types"
        echo "   BAD:  age: str = 25  # int assigned to str annotation"
        echo "   GOOD: age: int = 25  # Matching types"
        echo ""
        echo "4. None Handling → Safe Access Patterns"
        echo "   BAD:  text.upper()  # text might be None"
        echo "   GOOD: text.upper() if text else ''  # Safe access"
        echo ""
        echo "5. Generic Types → Specific Parameterization"
        echo "   BAD:  items: List = [1, 2, 3]  # Missing type parameter"
        echo "   GOOD: items: List[int] = [1, 2, 3]  # Complete type info"
        pause
    fi
    
    # Educational resources
    print_subsection "${BOOK} Learn More About Python Type Safety"
    
    echo "${LINK} MyPy Documentation: https://mypy.readthedocs.io/"
    echo "${LINK} Python Type Hints: https://docs.python.org/3/library/typing.html"
    echo "${LINK} Type Checking Guide: https://realpython.com/python-type-checking/"
    echo "${LINK} PEP 484 (Type Hints): https://peps.python.org/pep-0484/"
    echo ""
    echo "${INFO} ${INFO} These resources provide comprehensive guidance on Python type systems"
    echo ""
    
    # Conclusion
    print_section "🎓 Tutorial Complete - Type Safety Mastery!"
    echo "${CHECK_MARK} You've learned how to:"
    echo "• Add comprehensive type annotations to Python code"
    echo "• Use mypy to catch type errors before runtime"
    echo "• Handle Optional types and None values safely"
    echo "• Fix type compatibility issues"
    echo "• Understand Python's gradual typing system"
    echo "• Apply static type checking best practices"
    echo ""
    echo "${MAGNIFY} ${BOLD}Remember: Type hints make code more reliable and self-documenting!${NC}"
    echo ""
}

# Check if mypy is installed
if ! command -v mypy &> /dev/null; then
    echo "${CROSS_MARK} MyPy is not installed. Please run: pip install mypy"
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