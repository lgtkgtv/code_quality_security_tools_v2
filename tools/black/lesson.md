# Black Code Formatter Learning Resources

## What is Black?
Black is an opinionated Python code formatter that automatically formats your code according to a consistent style. It aims to produce code that looks like it was written by a single programmer, regardless of how many people actually worked on it.

## Key Features
- **Automatic Formatting**: Reformats code without manual intervention
- **Consistent Style**: Enforces a single, consistent code style
- **Opinionated**: Makes formatting decisions for you
- **Fast**: Written in Python with performance optimizations
- **Deterministic**: Same input always produces same output

## What Black Fixes
- **Line Length**: Breaks long lines at 88 characters (configurable)
- **Quotes**: Standardizes to double quotes (except when single quotes reduce escapes)
- **Spacing**: Consistent spacing around operators and after commas
- **Parentheses**: Adds/removes parentheses for clarity
- **Trailing Commas**: Adds trailing commas in multi-line structures
- **String Formatting**: Consistent string concatenation and formatting

## Black's Philosophy
1. **Readability First**: Code should be easy to read and understand
2. **Consistency**: All code should look like it was written by one person
3. **Minimize Diffs**: Changes should be minimal and focused
4. **Automated**: No manual formatting decisions needed

## Configuration
Create a `pyproject.toml` file in your project root:

```toml
[tool.black]
line-length = 88
target-version = ['py38']
include = '\.pyi?$'
extend-exclude = '''
/(
    \.eggs
  | \.git
  | \.mypy_cache
  | \.pytest_cache
  | \.venv
  | _build
  | build
  | dist
)/
'''
```

## Usage Examples
```bash
# Check if files would be reformatted
black --check .

# Show what would change without modifying files
black --diff .

# Format files in place
black .

# Format specific file
black script.py

# Check specific file
black --check --diff script.py
```

## Integration
Add black to your development workflow:

```bash
# Install
pip install black

# Pre-commit hook
pip install pre-commit
# Add to .pre-commit-config.yaml:
repos:
  - repo: https://github.com/psf/black
    rev: 22.3.0
    hooks:
      - id: black

# GitHub Actions
name: Lint
on: [push, pull_request]
jobs:
  lint:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - uses: actions/setup-python@v2
      - run: pip install black
      - run: black --check .
```

## Benefits
- **Saves Time**: No more formatting discussions or manual formatting
- **Reduces Diffs**: Formatting changes don't clutter code reviews
- **Team Consistency**: Everyone uses the same formatting style
- **Focus on Logic**: Spend time on functionality, not formatting
- **Tool Integration**: Works with most editors and IDEs

## Working with Other Tools
- **flake8**: Configure to ignore E203, W503 (conflicts with black)
- **isort**: Use `profile = "black"` for compatibility
- **mypy**: Generally compatible, no special configuration needed
- **pre-commit**: Include black in your pre-commit hooks

## Further Reading
- [Black Documentation](https://black.readthedocs.io/)
- [Black Playground](https://black.vercel.app/) - Try black online
- [Black Code Style](https://black.readthedocs.io/en/stable/the_black_code_style/index.html)