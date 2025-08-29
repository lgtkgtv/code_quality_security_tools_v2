"""A simple calculator module."""

from typing import Union

Number = Union[int, float]

def add(a: Number, b: Number) -> Number:
    """Add two numbers."""
    return a + b

def divide(a: Number, b: Number) -> Number:
    """Divide two numbers."""
    if b == 0:
        raise ValueError("Cannot divide by zero")
    return a / b
