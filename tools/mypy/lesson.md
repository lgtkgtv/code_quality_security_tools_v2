# MyPy Static Type Checker Learning Resources

## What is MyPy?
MyPy is a static type checker for Python that helps catch type-related bugs before runtime. It analyzes your code using type hints and ensures type safety throughout your program.

## Benefits of Static Type Checking
- **Catch Bugs Early**: Find type errors before code runs
- **Better IDE Support**: Enhanced autocomplete and refactoring
- **Documentation**: Type hints serve as inline documentation
- **Refactoring Safety**: Confident code changes with type guarantees
- **Team Communication**: Clear interfaces between code components

## Common Type Issues MyPy Detects
- **Missing Type Hints**: Functions without parameter/return types
- **Type Mismatches**: Assigning wrong types to variables
- **None Safety**: Accessing attributes on potentially None values
- **Attribute Errors**: Accessing non-existent attributes
- **Incompatible Returns**: Returning wrong types from functions
- **List/Dict Issues**: Wrong types in collections

## Key Type Concepts
- **Basic Types**: `int`, `str`, `float`, `bool`
- **Collections**: `List[T]`, `Dict[K, V]`, `Set[T]`, `Tuple[T, ...]`
- **Optional**: `Optional[T]` for values that can be None
- **Union**: `Union[T, U]` for values that can be multiple types
- **Any**: `Any` for dynamic typing (avoid when possible)
- **Callable**: `Callable[[Args], Return]` for function types

## Type Annotation Examples
```python
# Basic annotations
def greet(name: str) -> str:
    return f"Hello, {name}!"

# Collections
users: List[str] = ["Alice", "Bob"]
scores: Dict[str, int] = {"Alice": 95, "Bob": 87}

# Optional values
def find_user(id: int) -> Optional[User]:
    return users.get(id)

# Union types
def process(value: Union[str, int]) -> str:
    return str(value)

# Callable types
def apply_func(func: Callable[[int], str], value: int) -> str:
    return func(value)
```

## Configuration
Create a `mypy.ini` file in your project root:

```ini
[mypy]
python_version = 3.8
warn_return_any = true
warn_unused_configs = true
disallow_untyped_defs = true
disallow_incomplete_defs = true
check_untyped_defs = true
disallow_untyped_decorators = true
no_implicit_optional = true
warn_redundant_casts = true
warn_unused_ignores = true
warn_no_return = true
warn_unreachable = true
strict_equality = true

# Per-module options
[mypy-requests.*]
ignore_missing_imports = true
```

## Common Patterns
### Handling Optional Values
```python
def process_user(user: Optional[User]) -> str:
    if user is None:
        return "No user"
    return user.name  # Safe: we checked for None
```

### Type Guards
```python
def is_string(value: Any) -> bool:
    return isinstance(value, str)

if is_string(data):
    print(data.upper())  # MyPy knows data is str here
```

### Generic Types
```python
from typing import TypeVar, Generic

T = TypeVar('T')

class Stack(Generic[T]):
    def __init__(self) -> None:
        self._items: List[T] = []
    
    def push(self, item: T) -> None:
        self._items.append(item)
```

## Usage Commands
```bash
# Check specific file
mypy script.py

# Check entire project
mypy .

# Ignore missing imports
mypy --ignore-missing-imports script.py

# Show error codes
mypy --show-error-codes script.py

# Strict mode
mypy --strict script.py
```

## Integration
Add mypy to your development workflow:

```bash
# Install
pip install mypy

# Pre-commit hook
repos:
  - repo: https://github.com/pre-commit/mirrors-mypy
    rev: v0.910
    hooks:
      - id: mypy

# GitHub Actions
- name: Type check with mypy
  run: mypy .
```

## Best Practices
1. **Start Gradually**: Add type hints to new code first
2. **Use Strict Mode**: Enable strict checking for new projects
3. **Handle Optionals**: Always check for None before use
4. **Avoid Any**: Use specific types instead of Any when possible
5. **Type Stub Files**: Create .pyi files for untyped libraries
6. **Incremental Adoption**: Use `# type: ignore` temporarily

## Common Fixes
- **Add type hints**: Annotate function parameters and returns
- **Handle None**: Check Optional values before use
- **Fix return types**: Ensure functions return declared types
- **Import types**: Use `from typing import` for type annotations
- **Type assertions**: Use `cast()` for unavoidable type issues

## Further Reading
- [MyPy Documentation](https://mypy.readthedocs.io/)
- [Python Type Hints](https://docs.python.org/3/library/typing.html)
- [Gradual Typing](https://mypy.readthedocs.io/en/stable/getting_started.html)