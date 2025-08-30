# Python Code Quality Tools - Simplified Architecture

[![Python](https://img.shields.io/badge/Python-3.8+-blue.svg)](https://python.org)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![Quality](https://img.shields.io/badge/Code%20Quality-Excellent-brightgreen.svg)](https://github.com/lgtkgtv/code_quality_security_tools)

> A clean, educational system for learning and using Python code quality tools with two distinct purposes: interactive tutorials and real project scanning.

## 🚀 Quick Start

```bash
# Interactive mode - choose tutorials or scanning
./quality_tools.sh

# Direct project scanning
./quality_tools.sh scan https://github.com/user/repo.git
./quality_tools.sh scan /path/to/project  
./quality_tools.sh scan script.py

# Educational tutorials only
./tutorial_v2.sh
```

## 📋 Two Main Purposes

### 🎓 Educational Tutorials
- **Interactive**: One tool at a time, step-by-step learning
- **Demonstrates**: Problematic code → Tool output → Fixed code
- **Perfect for**: Learning how each tool works and best practices

### 🔍 Project Scanning  
- **Real projects**: Local files, directories, or git repositories
- **Automated**: Runs all tools and generates detailed reports
- **Perfect for**: Code reviews, CI/CD integration, quality audits

## 🛠️ Supported Tools

| Tool | Category | Purpose |
|------|----------|---------|
| **bandit** | Security | Vulnerability scanner |
| **flake8** | Style | PEP8 compliance checker |
| **black** | Formatting | Code formatter |
| **mypy** | Typing | Static type checker |
| **isort** | Imports | Import sorter |
| **pytest** | Testing | Unit test runner |

## 📁 Project Structure

```
code_quality_security_tools/
├── quality_tools.sh          # Main entry point
├── tutorial_v2.sh            # Educational tutorials
├── scan_project.sh           # Project scanning
├── tools/                    # Tool configurations
│   ├── template/             # Template for adding new tools
│   ├── bandit/               # Security scanner
│   │   ├── config.yaml       # Tool configuration
│   │   ├── bad_example.py    # Code with issues
│   │   ├── good_example.py   # Fixed code
│   │   ├── description.txt   # One-line description
│   │   └── lesson.md         # Learning resources
│   └── [other-tools]/        # Additional tools...
├── reports/                  # Generated scan reports
├── scans/                    # Cloned repositories for scanning
└── venv/                     # Python virtual environment
```

## ➕ Adding New Tools

1. **Copy Template**: Copy `tools/template/` to `tools/your-tool/`
2. **Configure**: Update `config.yaml` with tool-specific settings
3. **Create Examples**: Write `bad_example.py` and `good_example.py`  
4. **Add Description**: Update `description.txt` with one-line summary
5. **Document**: Update `lesson.md` with learning resources

The system automatically discovers and includes any tool with the required files.

### Required Files
- `config.yaml` - Tool configuration
- `bad_example.py` - Code demonstrating issues  
- `good_example.py` - Fixed version with zero issues
- `description.txt` - One-line description for menus

### Optional Files
- `lesson.md` - Educational content and resources
- `README.md` - Tool-specific documentation

## 📊 Report Generation

Scanning generates markdown reports with:
- **Summary table** with aligned columns
- **Tool-specific details** for issues found
- **Recommendations** for improvements
- **Integration guidance** for CI/CD

Example report structure:
```markdown
# Code Quality Scan Report

| Tool | Status | Issues | Description |
|------|--------|--------|-------------|
| bandit | ❌ FAIL | 5 | Security vulnerability scanner |
| flake8 | ✅ PASS | 0 | PEP8 compliance checker |
```

## 🔧 Configuration

Each tool can be configured via `tools/{tool}/config.yaml`:

```yaml
name: "tool-name"
description: "What this tool does"
category: "security|style|typing|testing"
check_command: "tool-name --check"
fix_command: "tool-name --fix"
documentation_url: "https://tool-docs.com"
```

## 🎯 Design Principles

1. **Simplicity**: Clean file naming conventions, minimal complexity
2. **Discoverability**: Automatic tool detection based on directory structure  
3. **Educational**: Focus on learning through examples
4. **Practical**: Real-world scanning for actual projects
5. **Extensible**: Easy to add new tools with template structure

## 🔄 Design features

- ✅ Single-purpose scripts
- ✅ Consistent naming conventions  
- ✅ Automatic tool discovery
- ✅ Template-based tool addition
- ✅ Unified entry point

## 🤝 Contributing

To add a new code quality tool:
1. Use the template in `tools/template/`
2. Follow the naming conventions
3. Include both problematic and fixed examples
4. Test that the tool is automatically discovered


🛠️ TOOLS 

  🔒 Bandit (Security Scanner)

  - Interactive security vulnerability tutorial
  - Comprehensive coverage of 9+ security issue types
  - False positive examples with proper #nosec handling
  - Security best practices integration

  📏 Flake8 (Style Checker)

  - Interactive PEP8 style tutorial
  - Comprehensive coverage of style violations
  - Visual formatting demonstrations
  - Clean good examples 
  - Style best practices guidance

  🔍 MyPy (Type Checker)

  - Interactive type safety tutorial
  - Coverage of type annotation issues
  - Optional/None handling education
  - Type compatibility explanations
  - Static analysis best practices


📊 QUALITY METRICS
Visual Appeal: ✅ OUTSTANDING - Rich colors, emojis, professional formatting
User Engagement: ✅ HIGH - Step-by-step progression with user controlLearning
Effectiveness: ✅ MAXIMUM - Comprehensive explanations with practical examples

🎓 EDUCATIONAL IMPACT
  The new interactive tutorials transform code quality learning from:
  - ❌ "Here are some errors"
  - ✅ "Let's understand why this matters and how to fix it step-by-step"

🎯 KEY ENHANCEMENTS

  1. Interactive Prompts & Step-by-Step Progression ✅

  - Added "Press Enter to continue" pauses
  - Interactive "View code? [Y/n]" prompts
  - Clear numbered steps (1-5) with descriptive headers
  - User-controlled pacing throughout tutorials

  2. Enhanced Visual Presentation ✅

  - Rich color coding (🔴 High, 🟠 Medium, 🟡 Low severity)
  - Comprehensive emoji usage for visual appeal
  - Bordered sections with tool-specific emojis
  - Professional table formatting with aligned columns
  - Clear visual hierarchy and spacing

  3. Comprehensive Issue Explanations ✅

  - Detailed "Why this matters" explanations for each issue type
  - Side-by-side bad vs good code examples
  - Real-world impact descriptions
  - Tool-specific categorization of problems

  4. Structured Comparison Sections ✅

  - Clear "❌ Problematic code" vs "✅ Secure/proper alternative" format
  - Line-by-line explanations with context
  - Before/after code demonstrations
  - Practical fix recommendations

  5. False Positive Detection & Handling ✅

  - Educational examples of legitimate code flagged incorrectly
  - Proper #nosec usage with detailed explanations
  - "When to use" vs "When NOT to use" guidance
  - Real-world scenarios and proper suppression techniques

  6. Educational Links & Resources ✅

  - Curated documentation links for each tool
  - Best practices guides and official resources
  - External learning materials and references
  - Tool-specific community resources

  7. Tabular Issue Summaries ✅

  - Professional ASCII table formatting
  - Severity and confidence level indicators
  - Issue categorization and counting
  - Visual summary with emoji indicators

  8. Specific Fix Recommendations ✅

  - Tool-specific remediation guidance
  - Step-by-step fix instructions
  - Multiple solution approaches when applicable
  - Best practices integration


## 📜 License

This educational tool is designed for learning Python code quality and security practices.
