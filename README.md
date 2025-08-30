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

## 🔄 Migration from Old System

The new system replaces the complex multi-file architecture with:
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

## 📜 License

This educational tool is designed for learning Python code quality and security practices.
