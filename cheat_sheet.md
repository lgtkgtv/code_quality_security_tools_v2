# Python Code Quality Tools - Quick Reference

## 🛡️ Bandit (Security)
```bash
bandit file.py                    # Basic security scan
bandit -r project/                # Recursive scan
bandit -f json file.py            # JSON output
bandit -ll file.py                # Low confidence + low severity
bandit -s B101,B102 file.py       # Skip specific tests
```

## 🔍 Safety (Vulnerabilities)
```bash
safety check                      # Check installed packages
safety check -r requirements.txt # Check requirements file
safety check --json              # JSON output
safety check --ignore 12345      # Ignore specific vulnerability
```

## 📏 Flake8 (Style)
```bash
flake8 file.py                    # Basic style check
flake8 --statistics file.py       # Show statistics
flake8 --show-source file.py      # Show source code
flake8 --max-line-length=88 .     # Set line length
```

## 🎨 Black (Formatting)
```bash
black file.py                     # Format file
black --diff file.py              # Show changes
black --check file.py             # Check only (no changes)
black --line-length 100 file.py   # Set line length
```

## 📚 isort (Imports)
```bash
isort file.py                     # Sort imports
isort --diff file.py              # Show changes
isort --check-only file.py        # Check only
isort --profile black file.py     # Use Black profile
```

## 🎯 MyPy (Types)
```bash
mypy file.py                      # Type check
mypy --strict file.py             # Strict mode
mypy --ignore-missing-imports .   # Ignore missing stubs
mypy --install-types file.py      # Install type stubs
```

## 🔧 Combined Workflows
```bash
# Format and organize
black . && isort .

# Full quality check
flake8 . && mypy . && bandit -r . && pytest tests/

# Pre-commit setup
pre-commit install
pre-commit run --all-files
```
