# Pytest Testing Framework Learning Resources

## What is Pytest?
Pytest is a powerful and popular testing framework for Python that makes it easy to write simple and scalable tests. It supports unit tests, integration tests, and functional tests with minimal boilerplate code.

## Benefits of Testing with Pytest
- **Easy to Start**: Simple syntax, minimal setup required
- **Powerful Features**: Fixtures, parametrization, plugins
- **Great Reporting**: Clear, detailed test output
- **Flexible**: Works with unittest, doctest, and custom tests
- **Extensible**: Rich ecosystem of plugins
- **Test Discovery**: Automatically finds and runs tests

## Key Pytest Concepts
- **Test Functions**: Functions starting with `test_`
- **Test Classes**: Classes starting with `Test`
- **Fixtures**: Reusable test setup and teardown
- **Parametrization**: Run same test with different inputs
- **Markers**: Tag and categorize tests
- **Plugins**: Extend functionality

## Common Issues Pytest Helps Detect
- **Logic Errors**: Incorrect calculations or algorithms
- **Edge Cases**: Empty inputs, null values, boundary conditions
- **Exception Handling**: Unhandled errors and exceptions
- **Side Effects**: Functions modifying global state
- **Integration Issues**: Components not working together
- **Performance Problems**: Slow or inefficient code

## Basic Test Structure
```python
def test_function_name():
    # Arrange
    input_value = "test"
    expected = "TEST"
    
    # Act
    result = my_function(input_value)
    
    # Assert
    assert result == expected
```

## Pytest Assertions
```python
# Basic assertions
assert value == expected
assert value != unexpected
assert value > threshold
assert value in collection
assert callable(function)

# Exception testing
with pytest.raises(ValueError):
    risky_function()

# Approximate comparisons
assert abs(result - expected) < 0.001
# Or use pytest.approx
assert result == pytest.approx(expected)
```

## Fixtures
Fixtures provide reusable setup and teardown:

```python
import pytest

@pytest.fixture
def user_data():
    return {"name": "John", "age": 30}

@pytest.fixture
def database_connection():
    conn = create_connection()
    yield conn  # This is what gets passed to tests
    conn.close()  # Cleanup after test

def test_user_creation(user_data):
    user = User(user_data["name"], user_data["age"])
    assert user.name == "John"
```

## Parametrized Tests
Run the same test with different inputs:

```python
@pytest.mark.parametrize("input,expected", [
    (1, 1),
    (2, 4),
    (3, 9),
    (4, 16),
])
def test_square(input, expected):
    assert square(input) == expected
```

## Test Organization
```
project/
├── src/
│   └── mymodule.py
├── tests/
│   ├── __init__.py
│   ├── test_mymodule.py
│   └── conftest.py
└── pytest.ini
```

## Configuration
Create a `pytest.ini` file:

```ini
[tool:pytest]
testpaths = tests
python_files = test_*.py *_test.py
python_classes = Test*
python_functions = test_*
addopts = 
    -v
    --tb=short
    --strict-markers
    --disable-warnings
markers =
    slow: marks tests as slow
    integration: marks tests as integration tests
```

## Common Usage
```bash
# Run all tests
pytest

# Run specific test file
pytest test_module.py

# Run specific test
pytest test_module.py::test_function

# Run tests matching pattern
pytest -k "test_user"

# Run tests with coverage
pytest --cov=src

# Run with verbose output
pytest -v

# Run only failed tests
pytest --lf

# Stop after first failure
pytest -x
```

## Test Types with Pytest
### Unit Tests
```python
def test_calculate_tax():
    assert calculate_tax(100, 0.1) == 10
    assert calculate_tax(0, 0.1) == 0
```

### Integration Tests
```python
def test_user_registration_flow(database):
    user = register_user("test@example.com", "password")
    assert user.id is not None
    assert user.email == "test@example.com"
```

### Functional Tests
```python
def test_api_endpoint(client):
    response = client.get("/api/users/1")
    assert response.status_code == 200
    assert "name" in response.json
```

## Mocking and Patching
```python
from unittest.mock import Mock, patch

def test_external_api_call():
    with patch('requests.get') as mock_get:
        mock_get.return_value.json.return_value = {"status": "ok"}
        result = fetch_data_from_api()
        assert result["status"] == "ok"
```

## Test-Driven Development (TDD)
1. **Red**: Write failing test first
2. **Green**: Write minimal code to pass
3. **Refactor**: Improve code while keeping tests green

```python
# Step 1: Write failing test
def test_add_user():
    user_service = UserService()
    user = user_service.add_user("John", "john@example.com")
    assert user.name == "John"
    assert user.email == "john@example.com"

# Step 2: Implement minimal code
class UserService:
    def add_user(self, name, email):
        return User(name, email)

# Step 3: Refactor with validation, database, etc.
```

## Best Practices
1. **One Assertion Per Test**: Keep tests focused and simple
2. **Descriptive Names**: Test names should describe what they test
3. **Arrange-Act-Assert**: Structure tests clearly
4. **Independent Tests**: Tests shouldn't depend on each other
5. **Use Fixtures**: Share setup code efficiently
6. **Test Edge Cases**: Empty inputs, None values, boundaries
7. **Mock External Dependencies**: Keep tests fast and reliable

## Common Patterns
### Testing Exceptions
```python
def test_division_by_zero():
    with pytest.raises(ZeroDivisionError):
        divide(10, 0)

def test_specific_exception_message():
    with pytest.raises(ValueError, match="must be positive"):
        validate_age(-1)
```

### Testing with Temporary Files
```python
def test_file_processing(tmp_path):
    test_file = tmp_path / "test.txt"
    test_file.write_text("test content")
    
    result = process_file(str(test_file))
    assert result == "processed: test content"
```

## Integration with Other Tools
- **Coverage**: `pytest-cov` for test coverage reports
- **xdist**: `pytest-xdist` for parallel test execution
- **mock**: Built-in mocking support
- **doctests**: Run doctests with pytest
- **CI/CD**: Easy integration with GitHub Actions, Jenkins, etc.

## Debugging Tests
```bash
# Drop into debugger on failure
pytest --pdb

# Print statements (use -s to see output)
pytest -s

# Only run specific test for debugging
pytest test_file.py::test_function -v
```

## Further Reading
- [Pytest Documentation](https://docs.pytest.org/)
- [Test-Driven Development with Python](https://www.obeythetestinggoat.com/)
- [Effective Python Testing](https://realpython.com/pytest-python-testing/)