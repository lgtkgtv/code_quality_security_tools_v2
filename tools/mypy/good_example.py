#!/usr/bin/env python3
"""
GOOD CODE EXAMPLE - Type-Safe Code for mypy
===========================================

This file demonstrates proper type annotations and type-safe code.
This should pass all mypy checks with zero issues.

Run: mypy good_example.py (should show no issues)
"""

import json
from typing import Any, Callable, Dict, List, Optional, Union


def process_numbers(numbers: List[Union[int, float]]) -> Union[int, float]:
    """Function with proper type hints for mypy."""
    total: Union[int, float] = 0
    for num in numbers:
        # Type safe: all items are numeric
        total += num
    return total


def get_user_name(user_id: int) -> Optional[str]:
    """Function properly handles Optional return type."""
    users: Dict[int, str] = {1: "Alice", 2: "Bob"}
    # Correct: returns Optional[str] as declared
    return users.get(user_id)


def calculate_average(numbers: List[Union[int, float]]) -> Optional[float]:
    """Properly handles edge cases with Optional return type."""
    if len(numbers) == 0:
        # Correct: returning None is allowed by Optional[float]
        return None
    
    total = sum(numbers)
    # Safe: we've already checked for empty list
    return total / len(numbers)


class User:
    def __init__(self, name: str, age: int) -> None:
        self.name = name
        self.age = age
    
    def get_info(self) -> Dict[str, str]:
        """Correct: all dict values are strings."""
        return {
            "name": self.name,
            "age": str(self.age)  # Convert int to str
        }


def process_users(users: List[User]) -> List[str]:
    """Type-safe list operations and attribute access."""
    names: List[str] = []
    
    for user in users:
        # Correct: accessing existing attribute
        names.append(user.name)
    
    # Correct: consistent return type
    if not names:
        return []  # Return empty List[str], not string
    
    return names


def safe_operations() -> tuple[str, int, int, int]:
    """Type-safe operations with proper type handling."""
    # Correct: compatible types
    result = "Hello" + " World"
    
    # Safe: check for None before calling methods
    text: Optional[str] = "example"
    length = len(text) if text is not None else 0
    
    # Correct: proper index type
    items = [1, 2, 3, 4, 5]
    index = 2  # int, not string
    value = items[index]
    
    # Correct: compatible assignment
    number: int = 42
    
    return result, length, value, number


def work_with_typed_data() -> tuple[str, int, str, str]:
    """Proper handling of typed data instead of Any."""
    data = get_typed_data()  # Returns proper type
    
    # These operations are type-safe
    name = data["name"]
    age = data["age"]
    email = data.get("email", "unknown@example.com")
    status = data.get("status", "active")
    
    return name, age, email, status


def get_typed_data() -> Dict[str, Union[str, int]]:
    """Function with proper return type annotation."""
    data: Dict[str, Union[str, int]] = {
        "name": "John",
        "age": 30,
        "status": "active"
    }
    return data


# Correct: variable annotation matches assignment
numbers: List[int] = [1, 2, 3]

# Correct: function call with proper argument types
result = process_numbers([1, 2, 3, 4.5])

# Create user with all required attributes
user = User("Alice", 25)


def callback_example(callback: Callable[[str, int], str]) -> str:
    """Proper type hints for callback function."""
    # Type safe: we know the callback signature
    return callback("hello", 42)


# Example callback function
def example_callback(text: str, number: int) -> str:
    return f"{text} - {number}"


# Safe comparison with compatible types
if len("string") > 42:
    print("This comparison makes sense")


def reachable_code_example() -> str:
    """All code is reachable."""
    result = "processed"
    print("This code is reachable")
    return result


def safe_dict_access() -> tuple[str, str]:
    """Safe dictionary access with proper error handling."""
    data: Dict[str, Union[str, int]] = {"name": "John", "age": 30}
    
    # Safe: handle missing keys
    name = data.get("name", "Unknown")
    if isinstance(name, str):
        name_str = name
    else:
        name_str = str(name)
    
    # Safe: handle type conversion
    age_value = data.get("age", 0)
    age_str = str(age_value)
    
    return name_str, age_str


def safe_list_operations() -> List[str]:
    """Type-safe list operations."""
    items: List[str] = ["a", "b", "c"]
    
    # Correct: appending correct type
    items.append("d")
    
    # Correct: extending with correct type
    items.extend(["e", "f", "g"])
    
    return items


# Correct class inheritance with matching signatures
class GoodInheritance:
    def method(self, x: int) -> str:
        return str(x)


class GoodChild(GoodInheritance):
    # Correct: signature matches parent
    def method(self, x: int) -> str:
        return f"Child: {str(x)}"


# Optional type handling
def handle_optional(value: Optional[str]) -> str:
    """Proper handling of Optional types."""
    if value is None:
        return "No value provided"
    return value.upper()  # Safe: we've checked for None


# Union type handling
def handle_union(value: Union[str, int]) -> str:
    """Proper handling of Union types."""
    if isinstance(value, str):
        return value.upper()
    else:
        return str(value)


# Generic type example
from typing import TypeVar, Generic

T = TypeVar('T')

class Container(Generic[T]):
    def __init__(self, item: T) -> None:
        self.item = item
    
    def get(self) -> T:
        return self.item


# Usage examples
if __name__ == "__main__":
    # Safe usage with type checking
    user_name = get_user_name(1)
    if user_name is not None:
        print(f"User: {user_name}")
    
    average = calculate_average([1, 2, 3, 4, 5])
    if average is not None:
        print(f"Average: {average}")
    
    users = [User("Alice", 25), User("Bob", 30)]
    names = process_users(users)
    print(f"Names: {names}")
    
    # Callback usage
    result_callback = callback_example(example_callback)
    print(f"Callback result: {result_callback}")
    
    # Container usage
    string_container: Container[str] = Container("hello")
    number_container: Container[int] = Container(42)
    
    print(f"String: {string_container.get()}")
    print(f"Number: {number_container.get()}")