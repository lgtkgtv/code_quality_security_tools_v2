#!/usr/bin/env python3
"""
GOOD CODE EXAMPLE - Well-Tested Code for pytest
===============================================

This file demonstrates properly tested code with comprehensive test coverage.
This should pass all pytest tests with zero failures.

Run: pytest good_example.py (should show all tests passing)
"""

import math
import re
from contextlib import contextmanager
from typing import List, Optional, Union


def calculate_discount(price: float, discount_percent: float) -> float:
    """Calculate discounted price with proper validation."""
    if price < 0:
        raise ValueError("Price cannot be negative")
    if not 0 <= discount_percent <= 100:
        raise ValueError("Discount percent must be between 0 and 100")
    
    return price - (price * discount_percent / 100)


def is_valid_email(email: str) -> bool:
    """Check if email is valid with proper validation."""
    if email is None:
        return False
    
    if not isinstance(email, str):
        return False
    
    # Simple but more comprehensive email validation
    pattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$'
    return bool(re.match(pattern, email.strip().lower()))


def fibonacci(n: int) -> int:
    """Calculate nth Fibonacci number correctly."""
    if not isinstance(n, int):
        raise TypeError("Input must be an integer")
    if n < 0:
        raise ValueError("Input must be non-negative")
    
    if n == 0:
        return 0
    if n == 1:
        return 1
    
    a, b = 0, 1
    for _ in range(2, n + 1):
        a, b = b, a + b
    return b


def divide_numbers(a: Union[int, float], b: Union[int, float]) -> float:
    """Divide two numbers with proper error handling."""
    if b == 0:
        raise ZeroDivisionError("Cannot divide by zero")
    
    return float(a) / float(b)


def find_maximum(numbers: List[Union[int, float]]) -> Optional[float]:
    """Find maximum number in list with proper edge case handling."""
    if not numbers:
        return None
    
    # Filter out None values
    valid_numbers = [num for num in numbers if num is not None]
    
    if not valid_numbers:
        return None
    
    return float(max(valid_numbers))


def calculate_average(numbers: List[Union[int, float]]) -> Optional[float]:
    """Calculate average with proper validation."""
    if not numbers:
        return None
    
    # Filter out None values
    valid_numbers = [num for num in numbers if num is not None]
    
    if not valid_numbers:
        return None
    
    return sum(valid_numbers) / len(valid_numbers)


def is_prime(n: int) -> bool:
    """Check if number is prime with correct logic."""
    if not isinstance(n, int):
        raise TypeError("Input must be an integer")
    
    if n <= 1:
        return False
    if n == 2:
        return True
    if n % 2 == 0:
        return False
    
    # Check odd divisors up to sqrt(n)
    for i in range(3, int(math.sqrt(n)) + 1, 2):
        if n % i == 0:
            return False
    return True


def sort_list(items: List[int]) -> List[int]:
    """Sort list without modifying original."""
    if not isinstance(items, list):
        raise TypeError("Input must be a list")
    
    # Create a copy to avoid modifying original
    return sorted(items)


def factorial(n: int) -> int:
    """Calculate factorial with proper validation."""
    if not isinstance(n, int):
        raise TypeError("Input must be an integer")
    if n < 0:
        raise ValueError("Factorial is not defined for negative numbers")
    
    # Use iterative approach to avoid stack overflow
    result = 1
    for i in range(1, n + 1):
        result *= i
    return result


def parse_integer(text: str) -> int:
    """Parse string to integer with proper error handling."""
    if not isinstance(text, str):
        raise TypeError("Input must be a string")
    
    try:
        return int(text.strip())
    except ValueError:
        raise ValueError(f"Cannot convert '{text}' to integer")


@contextmanager
def get_file_content(filename: str):
    """Read file content with proper resource management."""
    if not isinstance(filename, str):
        raise TypeError("Filename must be a string")
    
    try:
        with open(filename, 'r', encoding='utf-8') as file:
            yield file.read()
    except FileNotFoundError:
        raise FileNotFoundError(f"File '{filename}' not found")
    except IOError as e:
        raise IOError(f"Error reading file '{filename}': {e}")


class ShoppingCart:
    """Shopping cart class with proper validation and error handling."""
    
    def __init__(self):
        self.items = []
    
    def add_item(self, item: str, price: float, quantity: int = 1):
        """Add item to cart with validation."""
        if not isinstance(item, str) or not item.strip():
            raise ValueError("Item name must be a non-empty string")
        if not isinstance(price, (int, float)) or price < 0:
            raise ValueError("Price must be a non-negative number")
        if not isinstance(quantity, int) or quantity <= 0:
            raise ValueError("Quantity must be a positive integer")
        
        self.items.append({
            "item": item.strip(),
            "price": float(price),
            "quantity": quantity
        })
    
    def get_total(self) -> float:
        """Calculate total with proper handling of empty cart."""
        return sum(item["price"] * item["quantity"] for item in self.items)
    
    def apply_bulk_discount(self, min_items: int = 5, discount_rate: float = 0.1):
        """Apply bulk discount without side effects."""
        if self.get_item_count() >= min_items:
            return self.get_total() * (1 - discount_rate)
        return self.get_total()
    
    def get_item_count(self) -> int:
        """Get total number of items in cart."""
        return sum(item["quantity"] for item in self.items)
    
    def clear(self):
        """Clear all items from cart."""
        self.items = []


def process_payment(amount: float, payment_method: str) -> dict:
    """Process payment with proper validation and error handling."""
    if not isinstance(amount, (int, float)) or amount <= 0:
        raise ValueError("Amount must be a positive number")
    
    if not isinstance(payment_method, str) or not payment_method.strip():
        raise ValueError("Payment method must be a non-empty string")
    
    method = payment_method.strip().lower()
    
    if method == "credit":
        return {"status": "success", "transaction_id": "CC12345", "method": "credit"}
    elif method == "debit":
        return {"status": "success", "transaction_id": "DB67890", "method": "debit"}
    elif method == "paypal":
        return {"status": "success", "transaction_id": "PP11111", "method": "paypal"}
    else:
        raise ValueError(f"Unsupported payment method: {payment_method}")


# ==========================================
# COMPREHENSIVE TESTS
# ==========================================

import pytest


class TestCalculateDiscount:
    """Tests for calculate_discount function."""
    
    def test_valid_discount(self):
        assert calculate_discount(100, 10) == 90.0
        assert calculate_discount(50, 20) == 40.0
        assert calculate_discount(200, 0) == 200.0
    
    def test_negative_price(self):
        with pytest.raises(ValueError, match="Price cannot be negative"):
            calculate_discount(-100, 10)
    
    def test_invalid_discount_percent(self):
        with pytest.raises(ValueError, match="Discount percent must be between 0 and 100"):
            calculate_discount(100, -10)
        
        with pytest.raises(ValueError, match="Discount percent must be between 0 and 100"):
            calculate_discount(100, 150)


class TestIsValidEmail:
    """Tests for is_valid_email function."""
    
    def test_valid_emails(self):
        assert is_valid_email("user@example.com")
        assert is_valid_email("test.email+tag@domain.org")
        assert is_valid_email("user123@test-domain.co.uk")
    
    def test_invalid_emails(self):
        assert not is_valid_email("invalid-email")
        assert not is_valid_email("@domain.com")
        assert not is_valid_email("user@")
        assert not is_valid_email("")
        assert not is_valid_email(None)


class TestFibonacci:
    """Tests for fibonacci function."""
    
    def test_fibonacci_sequence(self):
        assert fibonacci(0) == 0
        assert fibonacci(1) == 1
        assert fibonacci(2) == 1
        assert fibonacci(3) == 2
        assert fibonacci(5) == 5
        assert fibonacci(10) == 55
    
    def test_negative_input(self):
        with pytest.raises(ValueError, match="Input must be non-negative"):
            fibonacci(-1)
    
    def test_non_integer_input(self):
        with pytest.raises(TypeError, match="Input must be an integer"):
            fibonacci(3.14)


class TestDivideNumbers:
    """Tests for divide_numbers function."""
    
    def test_division(self):
        assert divide_numbers(10, 2) == 5.0
        assert divide_numbers(7, 2) == 3.5
        assert divide_numbers(-10, 2) == -5.0
    
    def test_division_by_zero(self):
        with pytest.raises(ZeroDivisionError, match="Cannot divide by zero"):
            divide_numbers(10, 0)


class TestFindMaximum:
    """Tests for find_maximum function."""
    
    def test_find_maximum(self):
        assert find_maximum([1, 2, 3, 4, 5]) == 5.0
        assert find_maximum([5, 1, 3, 2, 4]) == 5.0
        assert find_maximum([-1, -2, -3]) == -1.0
    
    def test_empty_list(self):
        assert find_maximum([]) is None
    
    def test_list_with_none(self):
        assert find_maximum([1, None, 3]) == 3.0
        assert find_maximum([None, None]) is None


class TestShoppingCart:
    """Tests for ShoppingCart class."""
    
    def test_empty_cart(self):
        cart = ShoppingCart()
        assert cart.get_total() == 0.0
        assert cart.get_item_count() == 0
    
    def test_add_item(self):
        cart = ShoppingCart()
        cart.add_item("Apple", 1.50, 2)
        assert cart.get_total() == 3.0
        assert cart.get_item_count() == 2
    
    def test_bulk_discount(self):
        cart = ShoppingCart()
        for i in range(5):
            cart.add_item(f"Item{i}", 10.0)
        
        # Should apply discount for 5+ items
        discounted_total = cart.apply_bulk_discount()
        assert discounted_total == 45.0  # 50 * 0.9
    
    def test_invalid_item_name(self):
        cart = ShoppingCart()
        with pytest.raises(ValueError, match="Item name must be a non-empty string"):
            cart.add_item("", 10.0)
    
    def test_negative_price(self):
        cart = ShoppingCart()
        with pytest.raises(ValueError, match="Price must be a non-negative number"):
            cart.add_item("Apple", -5.0)


class TestProcessPayment:
    """Tests for process_payment function."""
    
    def test_valid_payments(self):
        result = process_payment(100.0, "credit")
        assert result["status"] == "success"
        assert result["method"] == "credit"
        
        result = process_payment(50.0, "debit")
        assert result["status"] == "success"
        assert result["method"] == "debit"
    
    def test_invalid_amount(self):
        with pytest.raises(ValueError, match="Amount must be a positive number"):
            process_payment(0, "credit")
        
        with pytest.raises(ValueError, match="Amount must be a positive number"):
            process_payment(-100, "credit")
    
    def test_invalid_payment_method(self):
        with pytest.raises(ValueError, match="Unsupported payment method"):
            process_payment(100, "bitcoin")


if __name__ == "__main__":
    # Run tests with pytest
    pytest.main([__file__, "-v"])