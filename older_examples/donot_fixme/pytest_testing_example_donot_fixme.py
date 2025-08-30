#!/usr/bin/env python3
"""
BAD CODE EXAMPLE - Logic Issues Detected by pytest Testing
==========================================================

This file demonstrates code with logic errors that pytest testing reveals.
DO NOT FIX - This file is intentionally broken for educational purposes.

Run: pytest pytest_testing_example_donot_fixme.py (would fail with proper tests)
"""


def calculate_discount(price, discount_percent):
    """Calculate discounted price - CONTAINS BUGS!"""
    # BUG 1: No input validation - crashes with negative values
    # BUG 2: Division by 100 missing for percentage
    # BUG 3: No handling of edge cases (0, None, etc.)
    return price - (price * discount_percent)


def is_valid_email(email):
    """Check if email is valid - INCOMPLETE LOGIC!"""
    # BUG 1: Oversimplified validation - many false positives/negatives
    # BUG 2: No handling of None input
    # BUG 3: Case sensitivity issues
    return "@" in email and "." in email


class ShoppingCart:
    """Shopping cart class - MULTIPLE BUGS!"""
    
    def __init__(self):
        self.items = []
        # BUG 1: No total tracking
    
    def add_item(self, item, price):
        """Add item to cart - MISSING VALIDATION!"""
        # BUG 1: No price validation (can be negative!)
        # BUG 2: No item validation (can be empty/None!)
        # BUG 3: No quantity handling
        self.items.append({"item": item, "price": price})
    
    def get_total(self):
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


def process_payment(amount, payment_method):
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
    
    # These would crash but we don't test them:
    # print(f"Empty cart total: ${ShoppingCart().get_total()}")  # CRASH!
    # print(f"Invalid email: {is_valid_email(None)}")  # CRASH!
    # print(f"Negative discount: ${calculate_discount(100, -50)}")  # WRONG!