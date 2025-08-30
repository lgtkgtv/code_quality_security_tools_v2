#!/usr/bin/env python3
"""
BAD CODE EXAMPLE - Logic Issues Detected by pytest Testing
==========================================================

This file demonstrates code with logic errors that pytest testing reveals.
DO NOT FIX - This file is intentionally broken for educational purposes.

Run: pytest bad_example.py (would fail with proper tests)
"""

import math
import random
from typing import List, Optional


def calculate_discount(price: float, discount_percent: float) -> float:
    """Calculate discounted price - CONTAINS BUGS!"""
    # BUG 1: No input validation - crashes with negative values
    # BUG 2: Division by 100 missing for percentage
    # BUG 3: No handling of edge cases (0, None, etc.)
    return price - (price * discount_percent)


def is_valid_email(email: str) -> bool:
    """Check if email is valid - INCOMPLETE LOGIC!"""
    # BUG 1: Oversimplified validation - many false positives/negatives
    # BUG 2: No handling of None input
    # BUG 3: Case sensitivity issues
    if email is None:
        return False
    return "@" in email and "." in email


def fibonacci(n: int) -> int:
    """Calculate nth Fibonacci number - OFF BY ONE ERROR!"""
    # BUG: Returns wrong values for edge cases
    if n <= 0:
        return 0
    if n == 1:
        return 0  # WRONG: Should be 1
    
    a, b = 0, 1
    for i in range(2, n + 1):  # BUG: Wrong range
        a, b = b, a + b
    return a  # BUG: Should return b


def divide_numbers(a: float, b: float) -> float:
    """Divide two numbers - NO ERROR HANDLING!"""
    # BUG 1: No division by zero check
    # BUG 2: No input validation
    return a / b


def find_maximum(numbers: List[float]) -> Optional[float]:
    """Find maximum number in list - CRASHES ON EDGE CASES!"""
    # BUG 1: Crashes on empty list
    # BUG 2: Doesn't handle None values properly
    if not numbers:
        return numbers[0]  # CRASH: IndexError on empty list
    
    max_val = numbers[0]
    for num in numbers:
        if num > max_val:  # BUG: Doesn't handle None values
            max_val = num
    return max_val


def calculate_average(numbers: List[float]) -> float:
    """Calculate average - MULTIPLE BUGS!"""
    # BUG 1: Division by zero on empty list
    # BUG 2: No input validation
    # BUG 3: Wrong calculation
    total = sum(numbers)
    return total / len(numbers) * 2  # BUG: Extra *2 multiplication


def is_prime(n: int) -> bool:
    """Check if number is prime - LOGIC ERRORS!"""
    # BUG 1: Wrong logic for edge cases
    # BUG 2: Inefficient and incorrect algorithm
    if n <= 1:
        return True  # WRONG: 0 and 1 are not prime
    if n == 2:
        return False  # WRONG: 2 is prime
    
    # BUG 3: Wrong range and logic
    for i in range(2, n):  # Inefficient: should be sqrt(n)
        if n % i != 0:  # WRONG: Should be == 0
            return False
    return True


def sort_list(items: List[int]) -> List[int]:
    """Sort list in ascending order - MODIFIES ORIGINAL!"""
    # BUG 1: Modifies original list (side effect)
    # BUG 2: Wrong sorting logic
    for i in range(len(items)):
        for j in range(i + 1, len(items)):
            if items[i] > items[j]:
                items[i], items[j] = items[j], items[i]
    # BUG 3: Doesn't return anything
    # return items  # Missing return statement


def factorial(n: int) -> int:
    """Calculate factorial - STACK OVERFLOW RISK!"""
    # BUG 1: No base case check for negative numbers
    # BUG 2: No input validation
    # BUG 3: Can cause stack overflow for large numbers
    if n == 0:
        return 1
    return n * factorial(n - 1)  # No check for n < 0


def parse_integer(text: str) -> int:
    """Parse string to integer - NO ERROR HANDLING!"""
    # BUG 1: No exception handling
    # BUG 2: No input validation
    # BUG 3: Doesn't handle whitespace
    return int(text)


def get_file_content(filename: str) -> str:
    """Read file content - RESOURCE LEAK!"""
    # BUG 1: File not closed properly (resource leak)
    # BUG 2: No error handling for missing files
    # BUG 3: No encoding specified
    file = open(filename, 'r')
    content = file.read()
    # BUG: File never closed
    return content


class ShoppingCart:
    """Shopping cart class - MULTIPLE BUGS!"""
    
    def __init__(self):
        self.items = []
        # BUG 1: No total tracking
    
    def add_item(self, item: str, price: float):
        """Add item to cart - MISSING VALIDATION!"""
        # BUG 1: No price validation (can be negative!)
        # BUG 2: No item validation (can be empty/None!)
        # BUG 3: No quantity handling
        self.items.append({"item": item, "price": price})
    
    def get_total(self) -> float:
        """Calculate total - DIVISION BY ZERO RISK!"""
        # BUG 1: Empty cart causes issues
        # BUG 2: No error handling
        if len(self.items) == 0:
            return 1 / 0  # DELIBERATE BUG: Division by zero!
        
        total = 0
        for item in self.items:
            total += item["price"]
        return total
    
    def apply_bulk_discount(self):
        """Apply 10% discount for 5+ items - LOGIC ERROR!"""
        # BUG 1: Wrong comparison operator
        # BUG 2: Modifies prices in place (side effects!)
        if len(self.items) < 5:  # SHOULD BE >= 5
            for item in self.items:
                item["price"] = item["price"] * 0.9


def process_payment(amount: float, payment_method: str) -> Optional[dict]:
    """Process payment - NO ERROR HANDLING!"""
    # BUG 1: No validation of amount (can be negative!)
    # BUG 2: No validation of payment method
    # BUG 3: No error handling for failed payments
    
    if payment_method == "credit":
        # Simulate credit card processing
        return {"status": "success", "transaction_id": "12345"}
    elif payment_method == "debit":
        # Simulate debit card processing
        return {"status": "success", "transaction_id": "67890"}
    else:
        # BUG: Should handle unknown payment methods
        pass  # Returns None - causes errors downstream!


# MISSING TESTS ENTIRELY!
# pytest would reveal all these bugs through proper test coverage
if __name__ == "__main__":
    # Some basic usage that seems to work but hides bugs
    cart = ShoppingCart()
    cart.add_item("Apple", 1.50)
    cart.add_item("Banana", 0.75)
    
    print(f"Total: ${cart.get_total()}")
    print(f"Email valid: {is_valid_email('user@example.com')}")
    print(f"Discount: ${calculate_discount(100, 10)}")  # Wrong result!
    print(f"Fibonacci(5): {fibonacci(5)}")  # Wrong result!
    
    # These would crash but we don't test them:
    # print(f"Empty cart total: ${ShoppingCart().get_total()}")  # CRASH!
    # print(f"Invalid email: {is_valid_email(None)}")  # CRASH!
    # print(f"Negative discount: ${calculate_discount(100, -50)}")  # WRONG!
    # print(f"Divide by zero: {divide_numbers(10, 0)}")  # CRASH!
    # print(f"Max of empty list: {find_maximum([])}")  # CRASH!