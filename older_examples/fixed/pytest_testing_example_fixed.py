#!/usr/bin/env python3
"""
GOOD CODE EXAMPLE - Proper Testing with pytest
==============================================

This file demonstrates proper code with comprehensive pytest testing.
This is the FIXED version with correct logic and thorough tests.

Run: pytest pytest_testing_example_fixed.py (should pass all tests)
"""

import re
from typing import Dict, List, Optional, Union


def calculate_discount(price: float, discount_percent: float) -> float:
    """Calculate discounted price with proper validation."""
    if price < 0:
        raise ValueError("Price cannot be negative")
    if not (0 <= discount_percent <= 100):
        raise ValueError("Discount percent must be between 0 and 100")

    discount_amount = price * (discount_percent / 100)
    return round(price - discount_amount, 2)


def is_valid_email(email: Optional[str]) -> bool:
    """Check if email is valid with comprehensive validation."""
    if not email or not isinstance(email, str):
        return False

    # Basic regex pattern for email validation
    pattern = r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$"
    return bool(re.match(pattern, email.lower()))


class ShoppingCart:
    """Shopping cart class with proper validation and error handling."""

    def __init__(self):
        self.items: List[Dict[str, Union[str, float]]] = []

    def add_item(self, item: str, price: float, quantity: int = 1) -> None:
        """Add item to cart with validation."""
        if not item or not isinstance(item, str):
            raise ValueError("Item name must be a non-empty string")
        if price < 0:
            raise ValueError("Price cannot be negative")
        if quantity <= 0:
            raise ValueError("Quantity must be positive")

        self.items.append(
            {"item": item.strip(), "price": round(price, 2), "quantity": quantity}
        )

    def get_total(self) -> float:
        """Calculate total with proper error handling."""
        if not self.items:
            return 0.0

        total = 0.0
        for item in self.items:
            total += item["price"] * item["quantity"]
        return round(total, 2)

    def apply_bulk_discount(self) -> None:
        """Apply 10% discount for 5+ items - corrected logic."""
        if len(self.items) >= 5:  # Fixed: correct comparison
            # Create new items to avoid side effects
            for item in self.items:
                item["price"] = round(item["price"] * 0.9, 2)

    def get_item_count(self) -> int:
        """Get total number of items in cart."""
        return len(self.items)

    def clear(self) -> None:
        """Clear all items from cart."""
        self.items = []


def process_payment(amount: float, payment_method: str) -> Dict[str, str]:
    """Process payment with proper validation and error handling."""
    if amount <= 0:
        raise ValueError("Payment amount must be positive")

    if not payment_method or not isinstance(payment_method, str):
        raise ValueError("Payment method must be a non-empty string")

    method = payment_method.lower().strip()

    if method == "credit":
        return {"status": "success", "transaction_id": "CC_12345"}
    elif method == "debit":
        return {"status": "success", "transaction_id": "DB_67890"}
    elif method == "cash":
        return {"status": "success", "transaction_id": "CASH_99999"}
    else:
        raise ValueError(f"Unsupported payment method: {payment_method}")


# COMPREHENSIVE PYTEST TESTS
def test_calculate_discount_valid_inputs():
    """Test discount calculation with valid inputs."""
    assert calculate_discount(100, 10) == 90.0
    assert calculate_discount(50, 20) == 40.0
    assert calculate_discount(100, 0) == 100.0
    assert calculate_discount(100, 100) == 0.0


def test_calculate_discount_edge_cases():
    """Test discount calculation edge cases."""
    assert calculate_discount(0, 10) == 0.0
    assert calculate_discount(1.99, 5) == 1.89


def test_calculate_discount_invalid_inputs():
    """Test discount calculation with invalid inputs."""
    import pytest

    with pytest.raises(ValueError, match="Price cannot be negative"):
        calculate_discount(-10, 5)

    with pytest.raises(ValueError, match="Discount percent must be between"):
        calculate_discount(100, -5)

    with pytest.raises(ValueError, match="Discount percent must be between"):
        calculate_discount(100, 150)


def test_is_valid_email_valid_emails():
    """Test email validation with valid emails."""
    assert is_valid_email("user@example.com") is True
    assert is_valid_email("test.email@domain.co.uk") is True
    assert is_valid_email("User@Example.Com") is True  # Case insensitive


def test_is_valid_email_invalid_emails():
    """Test email validation with invalid emails."""
    assert is_valid_email("invalid-email") is False
    assert is_valid_email("@domain.com") is False
    assert is_valid_email("user@") is False
    assert is_valid_email("user@domain") is False
    assert is_valid_email("") is False
    assert is_valid_email(None) is False
    assert is_valid_email(123) is False


def test_shopping_cart_basic_operations():
    """Test shopping cart basic operations."""
    cart = ShoppingCart()
    assert cart.get_total() == 0.0
    assert cart.get_item_count() == 0

    cart.add_item("Apple", 1.50)
    assert cart.get_total() == 1.50
    assert cart.get_item_count() == 1

    cart.add_item("Banana", 0.75, 2)
    assert cart.get_total() == 3.0
    assert cart.get_item_count() == 2


def test_shopping_cart_bulk_discount():
    """Test shopping cart bulk discount functionality."""
    cart = ShoppingCart()

    # Add 5 items to trigger bulk discount
    for i in range(5):
        cart.add_item(f"Item{i}", 10.0)

    original_total = cart.get_total()  # 50.0
    cart.apply_bulk_discount()
    discounted_total = cart.get_total()  # 45.0

    assert discounted_total == original_total * 0.9


def test_shopping_cart_no_bulk_discount():
    """Test that bulk discount doesn't apply with fewer than 5 items."""
    cart = ShoppingCart()

    # Add only 4 items
    for i in range(4):
        cart.add_item(f"Item{i}", 10.0)

    original_total = cart.get_total()
    cart.apply_bulk_discount()

    assert cart.get_total() == original_total  # No discount applied


def test_shopping_cart_invalid_inputs():
    """Test shopping cart with invalid inputs."""
    import pytest

    cart = ShoppingCart()

    with pytest.raises(ValueError, match="Item name must be"):
        cart.add_item("", 10.0)

    with pytest.raises(ValueError, match="Price cannot be negative"):
        cart.add_item("Item", -5.0)

    with pytest.raises(ValueError, match="Quantity must be positive"):
        cart.add_item("Item", 10.0, 0)


def test_process_payment_valid():
    """Test payment processing with valid inputs."""
    result = process_payment(100.0, "credit")
    assert result["status"] == "success"
    assert "CC_" in result["transaction_id"]

    result = process_payment(50.0, "debit")
    assert result["status"] == "success"
    assert "DB_" in result["transaction_id"]


def test_process_payment_invalid():
    """Test payment processing with invalid inputs."""
    import pytest

    with pytest.raises(ValueError, match="Payment amount must be positive"):
        process_payment(0, "credit")

    with pytest.raises(ValueError, match="Payment amount must be positive"):
        process_payment(-50, "credit")

    with pytest.raises(ValueError, match="Payment method must be"):
        process_payment(100, "")

    with pytest.raises(ValueError, match="Unsupported payment method"):
        process_payment(100, "bitcoin")


# Integration test
def test_complete_shopping_workflow():
    """Test complete shopping workflow."""
    cart = ShoppingCart()

    # Add items
    cart.add_item("Apple", 1.50, 3)
    cart.add_item("Banana", 0.75, 2)
    cart.add_item("Orange", 2.00, 1)

    total = cart.get_total()
    assert total == 8.0  # (1.50*3) + (0.75*2) + (2.00*1)

    # Process payment
    payment_result = process_payment(total, "credit")
    assert payment_result["status"] == "success"


if __name__ == "__main__":
    # Example usage - all operations now work correctly
    cart = ShoppingCart()
    cart.add_item("Apple", 1.50)
    cart.add_item("Banana", 0.75)

    print(f"Total: ${cart.get_total()}")
    print(f"Email valid: {is_valid_email('user@example.com')}")
    print(f"Discount: ${calculate_discount(100, 10)}")  # Now correct: $90.00

    # These now work safely:
    print(f"Empty cart total: ${ShoppingCart().get_total()}")  # $0.0
    print(f"Invalid email: {is_valid_email(None)}")  # False
    print(f"Valid discount: ${calculate_discount(100, 15)}")  # $85.0
