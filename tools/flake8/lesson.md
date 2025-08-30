# Flake8 Style Checker Learning Resources

## What is Flake8?
Flake8 is a popular Python linting tool that combines pycodestyle (PEP8), pyflakes, and McCabe complexity checker. It helps ensure your Python code follows style guidelines and catches common errors.

## Common Issues Detected
- **PEP8 Violations**: Line length, spacing, indentation issues
- **Import Problems**: Unused imports, multiple imports on one line
- **Variable Issues**: Unused variables, ambiguous names
- **Logic Errors**: Undefined variables, unreachable code
- **Complexity**: Functions that are too complex
- **Style Issues**: Trailing whitespace, missing newlines

## Error Code Categories
- **E**: PEP8 style errors (E201, E302, E501, etc.)
- **W**: PEP8 style warnings (W291, W503, etc.) 
- **F**: PyFlakes errors (F401, F821, F841, etc.)
- **C**: McCabe complexity warnings (C901)

## Best Practices
1. **Line Length**: Keep lines under 79-88 characters
2. **Imports**: One import per line, organize properly
3. **Spacing**: Consistent spacing around operators and after commas
4. **Variables**: Use descriptive names, avoid unused variables
5. **Functions**: Keep complexity reasonable
6. **Formatting**: Consistent indentation, proper blank lines

## Configuration
Create a `.flake8` file in your project root:

```ini
[flake8]
max-line-length = 88
exclude = 
    .git,
    __pycache__,
    .pytest_cache,
    venv,
    .venv
extend-ignore = 
    E203,  # Whitespace before ':' (conflicts with black)
    W503   # Line break before binary operator
```

## Integration
Add flake8 to your development workflow:

```bash
# Install
pip install flake8

# Basic check
flake8 your_file.py

# Check entire project
flake8 .

# Show statistics
flake8 --statistics .

# Pre-commit hook
pip install pre-commit
# Add to .pre-commit-config.yaml
```

## Common Fixes
- **Long lines**: Break into multiple lines or use parentheses
- **Import order**: Group standard library, third-party, local imports
- **Spacing**: Add spaces around operators and after commas
- **Unused imports/variables**: Remove or prefix with underscore
- **Complex functions**: Break into smaller functions

## Further Reading
- [Flake8 Documentation](https://flake8.pycqa.org/)
- [PEP 8 Style Guide](https://pep8.org/)
- [Error Code Reference](https://flake8.pycqa.org/en/latest/user/error-codes.html)