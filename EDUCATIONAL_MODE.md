# 📚 Educational Mode for Code Quality Tools

## Overview

This tutorial has been redesigned with a focus on **learning** rather than just automation. Each tool now has an educational mode that:

1. **Shows the problematic code** with explanations
2. **Runs the tool** and explains what it found
3. **Reviews issues interactively** with fix suggestions
4. **Compares bad vs. fixed code** to reinforce learning

## 🔒 Bandit Security Scanner - Educational Features

### Interactive Learning Flow

1. **Step 1: Examine Bad Code**
   - View intentionally vulnerable code
   - Understand common security pitfalls
   - Learn what to look for

2. **Step 2: Configuration Understanding**
   - View and understand bandit.yaml
   - Learn about severity levels (LOW, MEDIUM, HIGH)
   - Understand confidence levels
   - See how to skip false positives

3. **Step 3: Run Security Scan**
   - See the exact command being run
   - Understand command-line options
   - Watch real-time scanning

4. **Step 4: Interactive Issue Review**
   - Review each security issue one by one
   - See severity and confidence levels
   - View the problematic code in context
   - Get specific fix suggestions

5. **Step 5: Compare with Fixed Version**
   - See how secure code looks
   - Understand the differences
   - Learn best practices

### Example Issues Detected

```python
# BAD: Hardcoded password
password = "admin123"

# GOOD: Environment variable
password = os.environ.get('DB_PASSWORD')
```

```python
# BAD: SQL injection vulnerability
query = f"SELECT * FROM users WHERE id = {user_id}"

# GOOD: Parameterized query
cursor.execute("SELECT * FROM users WHERE id = ?", (user_id,))
```

```python
# BAD: Command injection risk
os.system(f"ls {user_input}")

# GOOD: Safe subprocess call
subprocess.run(["ls", user_input], check=True)
```

## 🎯 Key Educational Benefits

### For Learning
- **See real issues** in intentionally vulnerable code
- **Understand severity** with color-coded output
- **Learn fixes** with specific suggestions
- **Compare approaches** between bad and good code

### For Practice
- **Safe environment** with isolated working directories
- **No risk** to production code
- **Preserved examples** for repeated learning
- **Interactive mode** for hands-on experience

## 🚀 Usage

### Interactive Learning Mode (Default)
```bash
./run_tutorial.sh tools
# Select 1 for bandit
# Follow the interactive prompts
```

### Automated Mode (Quick Review)
```bash
./run_tutorial.sh autofix
# Select 1 for bandit
# See automated analysis
```

## 📁 File Organization

```
tools/bandit/
├── config/
│   └── bandit.yaml          # Configuration with explanations
├── examples/
│   ├── *_donot_fixme.py    # Bad code (preserved)
│   └── *_fixed.py           # Good code (reference)
└── working_files/           # Temporary copies (git-ignored)
```

## 🔄 Workflow

1. **Original bad examples** stay untouched in `examples/`
2. **Copies made** to `working_files/` for analysis
3. **Tools run** on working copies
4. **Results shown** with educational context
5. **Working files** can be modified/discarded
6. **Git ignores** working_files - no accidental commits

## 📝 Next Steps

The same educational approach will be applied to:
- **flake8** - Style guide learning
- **black** - Code formatting understanding
- **mypy** - Type system education
- **isort** - Import organization
- **pytest** - Testing best practices

Each tool will have its own educational module focusing on:
- Understanding what the tool checks
- Learning why it matters
- Seeing real examples
- Practicing fixes
- Building good habits

## 🎓 Learning Philosophy

> "Show me the problem, explain why it matters, teach me how to fix it, and let me practice safely."

This approach ensures users not only run the tools but understand:
- **What** each tool does
- **Why** it's important
- **How** to fix issues
- **When** to apply fixes
- **Where** to learn more

The goal is to build intuition and understanding, not just automate fixes!