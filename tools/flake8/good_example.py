#!/usr/bin/env python3
"""
GOOD CODE EXAMPLE - Clean PEP8 Compliant Code for flake8
========================================================

This file demonstrates proper Python coding style that passes flake8.
This should pass all flake8 checks with zero issues.

Run: flake8 good_example.py (should show no issues)
"""

from typing import Dict, List, Tuple


class GoodExample:
    """A properly formatted class that follows PEP8 guidelines."""

    def __init__(self, name: str, age: int):
        """Initialize with proper spacing and type hints."""
        self.name = name  # Proper spacing around operators
        self.age = age

    def get_info(self) -> str:
        """Return formatted information string."""
        return f"Name: {self.name}, Age: {self.age}"

    def function_with_parameters(
        self,
        param1: str,
        param2: int,
        param3: float,
    ) -> str:
        """Function with parameters properly formatted."""
        result = (
            str(param1) + str(param2) + str(param3)
        )
        return result

    def proper_spacing(self) -> Tuple[int, List[int], Dict[str, int]]:
        """Demonstrate correct spacing around operators and brackets."""
        x = 1 + 2 * 3 / 4 - 5  # Proper operator spacing
        y = [1, 2, 3, 4, 5]    # Proper list formatting
        z = {'a': 1, 'b': 2}   # Proper dict formatting
        return x, y, z

    def proper_variable_usage(self) -> int:
        """Only define variables that are actually used."""
        result = 10 + 20
        return result


def global_function() -> str:
    """Demonstrate proper conditional patterns."""
    if True:  # Better: just use the condition directly
        result = "condition met"
    else:
        result = "condition not met"

    # Proper None comparison
    something = None
    if something is None:
        result += " - something is None"

    return result


def another_function() -> List[str]:
    """Demonstrate proper string handling and variable naming."""
    # Proper string continuation without backslash
    long_string = (
        "This is a very long string that "
        "continues on the next line"
    )

    # Clear, unambiguous variable names
    items = [1, 2, 3]        # Instead of 'l'
    count = 0                # Instead of 'O'
    index = 1                # Instead of 'I'

    return [long_string, str(items), str(count), str(index)]


def proper_exception_handling() -> bool:
    """Demonstrate correct exception handling patterns."""
    try:
        result = risky_operation()
        return bool(result)
    except ValueError as e:
        print(f"Value error occurred: {e}")
        return False
    except Exception as e:
        print(f"Unexpected error: {e}")
        return False


def risky_operation() -> int:
    """Simulate a function that might raise an exception."""
    return 42 // 2


# Proper spacing before main execution block
if __name__ == "__main__":
    example = GoodExample("John", 25)
    print(example.get_info())

    # Proper spacing around operators in conditionals
    if 1 + 1 == 2:
        print("Math works")

    # Proper exception handling
    if proper_exception_handling():
        print("Operation completed successfully")
    else:
        print("Operation failed")

    # Demonstrate other functions
    print(global_function())
    print(another_function())
