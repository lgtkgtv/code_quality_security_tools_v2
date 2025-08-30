#!/usr/bin/env python3
"""
GOOD CODE EXAMPLE - Properly Formatted Code for black
=====================================================

This file demonstrates consistent formatting that black produces.
This should pass all black checks with zero issues.

Run: black --check good_example.py (should show no issues)
"""

import json
import os
import sys
from typing import Dict, List, Tuple


# Consistent spacing and formatting
def properly_formatted_function(param1, param2, param3):
    if param1 > 0 and param2 < 10:
        result = {"key1": param1, "key2": param2, "key3": param3}
        return result
    else:
        return None


class ProperlyFormattedClass:
    def __init__(self, name, age, email):
        self.name = name
        self.age = age
        self.email = email

    def get_data(self) -> Dict[str, str]:
        return {"name": self.name, "age": str(self.age), "email": self.email}


# Properly formatted string
long_string = (
    "This is a very long string that should probably be broken up into "
    "multiple lines for better readability and maintainability"
)

# Properly formatted collections
neat_list = [
    1,
    2,
    3,
    4,
    5,
    6,
    7,
    8,
    9,
    10,
    11,
    12,
    13,
    14,
    15,
]

neat_dict = {
    "key1": "value1",
    "key2": "value2", 
    "key3": "value3",
    "key4": "value4",
    "key5": "value5",
}

# Proper function calls
result = properly_formatted_function(1, 2, 3)
print(result)

# Consistent quotes (black prefers double quotes)
consistent_quotes = "This uses double quotes"
more_consistent = "This also uses double quotes"
nested_quotes = 'This has "nested" quotes'

# Properly formatted comprehensions
list_comp = [x * 2 for x in range(10) if x % 2 == 0]
dict_comp = {k: v * 2 for k, v in {"a": 1, "b": 2, "c": 3}.items() if v > 1}

# Properly formatted lambda
good_lambda = lambda x, y: x + y if x > y else x - y

# Properly spaced mathematical expressions
calculation = 1 + 2 * 3 / 4 - 5 + 6 * 7 / 8 - 9 + 10
complex_calc = (1 + 2) * (3 - 4) / (5 + 6)

# Properly spaced boolean operations
condition = True and False or True and not False


# Properly formatted function with long parameters
def function_with_very_long_parameter_list(
    param1, param2, param3, param4, param5, param6, param7, param8
):
    return param1 + param2 + param3 + param4 + param5 + param6 + param7 + param8


# Properly formatted multiline string
multiline = """This is a
multiline string that
has consistent
    indentation and
formatting"""


# Properly formatted exception handling
def risky_operation():
    return 42 / 0


try:
    risky_operation()
except (ValueError, TypeError) as e:
    print("Error:", e)
except Exception as e:
    print("Unexpected error:", e)


# Properly formatted trailing commas and spacing
tuple_data = (
    "item1",
    "item2",
    "item3",
)

list_data = [
    "item1",
    "item2",
    "item3",
]


# Properly formatted function annotations
def annotated_function(param1: str, param2: int) -> List[str]:
    return [param1] * param2


if __name__ == "__main__":
    example = ProperlyFormattedClass("John", 25, "john@example.com")
    data = example.get_data()
    print(data)

    # More properly formatted code
    if len(data) > 0:
        for key, value in data.items():
            print(f"{key}: {value}")

    result = annotated_function("test", 3)
    print(result)