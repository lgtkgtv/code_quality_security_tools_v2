#!/usr/bin/env python3
"""
GOOD CODE EXAMPLE - Type Safety with mypy
=========================================

This file demonstrates proper type hints and type-safe code.
This is the FIXED version with correct type annotations.

Run: mypy mypy_type_example_fixed.py (should show no errors)
"""

from typing import List, Dict, Optional, Union, Callable, Any
import json


def process_numbers(numbers: List[Union[int, float]]) -> Union[int, float]:
    """Function with proper type hints for parameters and return value."""
    total: Union[int, float] = 0
    for num in numbers:
        total += num
    return total


def get_user_name(user_id: int) -> Optional[str]:
    """Function correctly indicates it might return None."""
    users: Dict[int, str] = {1: "Alice", 2: "Bob"}
    return users.get(user_id)  # Correctly typed as Optional[str]


def calculate_average(numbers: List[int]) -> Optional[float]:
    """Properly handles edge case and returns correct type."""
    if len(numbers) == 0:
        return None  # Correctly typed as Optional[float]
    
    total = sum(numbers)
    return total / len(numbers)


class User:
    """User class with proper type annotations."""
    
    def __init__(self, name: str, age: int, email: Optional[str] = None):
        self.name = name
        self.age = age
        self.email = email
    
    def get_info(self) -> Dict[str, Union[str, int]]:
        """Returns dict with mixed value types properly annotated."""
        info: Dict[str, Union[str, int]] = {
            "name": self.name,
            "age": self.age
        }
        if self.email:
            info["email"] = self.email
        return info
    
    @property
    def full_name(self) -> str:
        """Property that was missing in the bad example."""
        return f"{self.name} (age {self.age})"


def process_users(users: List[User]) -> Union[List[str], str]:
    """Properly typed function that can return different types."""
    if not users:
        return "No users found"
    
    names: List[str] = []
    for user in users:
        names.append(user.full_name)  # Now this attribute exists
    
    return names


def safe_operations() -> tuple[str, Optional[str], int, int]:
    """Type-safe operations with proper error handling."""
    # Fixed: proper string concatenation
    result = "Hello " + str(42)
    
    # Fixed: check for None before calling methods
    text: Optional[str] = None
    length: Optional[str] = text.upper() if text is not None else None
    
    # Fixed: proper type for list indexing
    items = [1, 2, 3, 4, 5]
    index = 2  # Correct int type
    value = items[index]
    
    # Fixed: correct type assignment
    number: int = 42  # Actually an int
    
    return result, length, value, number


def work_with_json_data() -> Dict[str, Any]:
    """Properly typed function for dynamic data."""
    data = get_typed_json_data()
    
    # Now we know data is a dict and can work with it safely
    if isinstance(data, dict):
        return data
    else:
        return {}


def get_typed_json_data() -> Dict[str, Any]:
    """Function with proper return type annotation."""
    raw_data = json.loads('{"key": "value"}')
    # Type assertion to help mypy understand the structure
    return raw_data if isinstance(raw_data, dict) else {}


# Fixed: correct type annotation
numbers: List[int] = [1, 2, 3]  # Actually ints, not strings

# Fixed: convert strings to ints before processing
string_numbers = ["1", "2", "3"]
converted_numbers = [int(x) for x in string_numbers]
result = process_numbers(converted_numbers)

# Fixed: create user properly and check for attribute
user = User("Alice", 25, "alice@example.com")
if user.email:
    print(user.email)


# Proper callback type annotation
CallbackType = Callable[[str, int], str]


def callback_example(callback: CallbackType) -> str:
    """Properly typed callback function."""
    return callback("hello", 42)


def sample_callback(text: str, number: int) -> str:
    """Sample callback implementation."""
    return f"{text}: {number}"


# Fixed: use proper comparison types
if len("string") > 42:
    print("Comparing length with number makes sense")


def no_unreachable_code_example() -> str:
    """Fixed: removed unreachable code."""
    print("This code runs before return")
    return "proper return"


# Example of proper optional handling
def safe_user_operation(user_id: int) -> Optional[str]:
    """Demonstrates safe handling of optional values."""
    name = get_user_name(user_id)
    if name is not None:
        return name.upper()
    return None


# Example usage with proper type checking
if __name__ == "__main__":
    # Demonstrate proper usage
    users = [
        User("Alice", 25, "alice@example.com"),
        User("Bob", 30)
    ]
    
    result = process_users(users)
    print(f"Result type: {type(result)}, value: {result}")
    
    # Safe callback usage
    result_callback = callback_example(sample_callback)
    print(f"Callback result: {result_callback}")