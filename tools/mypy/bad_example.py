#!/usr/bin/env python3
"""
BAD CODE EXAMPLE - Type Issues Detected by mypy
===============================================

This file demonstrates common type issues that mypy detects.
DO NOT FIX - This file is intentionally broken for educational purposes.

Run: mypy bad_example.py
"""

from typing import Dict, List, Optional


def process_numbers(numbers):
    """Function missing type hints - mypy can't infer parameter/return types."""
    total = 0
    for num in numbers:
        # Type error: trying to add potentially incompatible types
        total += num
    return total


def get_user_name(user_id: int) -> str:
    """Function promises to return string but might return None."""
    users = {1: "Alice", 2: "Bob"}
    # Type error: Dict.get() returns Optional[str], not str
    return users.get(user_id)  # Could return None


def calculate_average(numbers: List[int]) -> float:
    """Type error: division by zero not handled, and wrong return type."""
    if len(numbers) == 0:
        # Type error: returning None when function promises float
        return None
    
    total = sum(numbers)
    # Type error: could divide by zero
    return total / len(numbers)


class User:
    def __init__(self, name: str, age: int):
        self.name = name
        self.age = age
    
    def get_info(self) -> Dict[str, str]:
        """Type error: age is int but dict expects all str values."""
        return {
            "name": self.name,
            "age": self.age  # Type error: int provided where str expected
        }


def process_users(users: List[User]) -> List[str]:
    """Type errors with list operations and attribute access."""
    names = []
    
    for user in users:
        # Type error: accessing non-existent attribute
        names.append(user.full_name)  # User has no 'full_name' attribute
    
    # Type error: might return wrong type
    if not names:
        return "No users found"  # Should return List[str], not str
    
    return names


def unsafe_operations():
    """Multiple type safety issues."""
    # Type error: mixing incompatible types
    result = "Hello" + 42
    
    # Type error: calling method on possibly None value
    text: Optional[str] = None
    length = text.upper()  # Could be None
    
    # Type error: list index with wrong type
    items = [1, 2, 3, 4, 5]
    index = "2"  # String instead of int
    value = items[index]
    
    # Type error: incompatible assignment
    number: int = "not a number"
    
    return result, length, value, number


def work_with_any():
    """Issues with Any type and dynamic operations."""
    data = get_dynamic_data()  # Returns Any
    
    # These operations are all unchecked with Any
    result1 = data.some_method()
    result2 = data + "string"
    result3 = data[42]
    result4 = data.non_existent_attr
    
    return result1, result2, result3, result4


def get_dynamic_data():
    """Function with no return type annotation."""
    import json

    # Could return anything - mypy treats as Any
    return json.loads('{"key": "value"}')


# Type error: variable annotation doesn't match assignment
numbers: List[int] = ["1", "2", "3"]  # List of strings, not ints

# Type error: function call with wrong argument types
result = process_numbers("not a list")

# Type error: accessing attributes that don't exist
user = User("Alice", 25)
print(user.email)  # User has no email attribute


def callback_example(callback):
    """Missing type hints for callback function."""
    # Type error: calling unknown callable with unknown parameters
    return callback("hello", 42)


# Type error: incompatible types in comparison
if "string" > 42:
    print("This comparison doesn't make sense")


# Type error: unreachable code
def unreachable_code_example():
    return "early return"
    print("This code is unreachable")  # mypy detects this


def dict_access_issues():
    """Dictionary access type issues."""
    data = {"name": "John", "age": 30}
    
    # Type error: KeyError not handled
    name = data["nonexistent_key"]
    
    # Type error: wrong type assumption
    age_str: str = data["age"]  # age is int, not str
    
    return name, age_str


def list_operations():
    """List operation type errors."""
    items: List[str] = ["a", "b", "c"]
    
    # Type error: appending wrong type
    items.append(42)  # Should be str, not int
    
    # Type error: extending with wrong type
    items.extend([1, 2, 3])  # Should be List[str], not List[int]
    
    return items


# Type error in class inheritance
class BadInheritance:
    def method(self, x: int) -> str:
        return str(x)


class BadChild(BadInheritance):
    # Type error: signature doesn't match parent
    def method(self, x: str) -> int:
        return int(x)