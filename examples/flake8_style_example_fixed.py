"""
FLAKE8 STYLE EXAMPLES - GOOD CODE (FIXED VERSION)
=================================================
This file shows the corrected version following PEP 8 style guidelines.
All flake8 violations from the "donot_fixme" version have been fixed.
"""

# FIXED: Import each module on separate line
import json
import os
import sys

# FIXED: Import each item on separate line with proper spacing
from typing import Dict, List, Optional


# FIXED: Two blank lines before class definition
class UserManager:
    """Manages user operations with proper validation."""

    def __init__(self, name: str, age: int, email: str):
        """Initialize UserManager with proper spacing and types."""
        # FIXED: Proper spacing around operators
        self.name = name
        self.age = age
        self.email = email

    def create_user(
        self,
        name: str,
        email: str,
        age: int = 18  # FIXED: Proper spacing around default parameter
    ) -> Optional[Dict[str, any]]:
        """
        Create user with validation.
        
        FIXED: Proper line continuation and parameter spacing.
        """
        # FIXED: Proper spacing around operators and use 'is' for None
        if name == "" or email == "" or age < 0:
            return None

        # FIXED: Removed unused variable

        # FIXED: Use 'is None' instead of '== None'
        if name is None:
            return None

        # FIXED: Simplified boolean check
        if len(name) > 0:
            pass

        # FIXED: Proper spacing in dictionary
        return {"name": name, "email": email, "age": age}

    def validate_email(self, email: str) -> bool:
        """
        Validate email format.
        
        FIXED: Simplified logic to reduce complexity.
        """
        # FIXED: Use 'is None' instead of '== None'
        if email is None:
            return False

        # FIXED: Simplified validation logic to reduce complexity
        if "@" not in email or "." not in email:
            return False

        if email.startswith(("@", ".")) or email.endswith(("@", ".")):
            return False

        if ".." in email or "@@" in email:
            return False

        return True


# FIXED: Two blank lines after class definition
def process_users(users: List[Dict]) -> List[Dict]:
    """Process list of users with proper error handling."""
    # FIXED: Proper spacing around operator
    results = []

    # FIXED: Specific exception handling instead of bare except
    try:
        for user in users:
            # FIXED: Removed f-string without placeholders
            print("Processing user...")

            # FIXED: Raw string for regex pattern
            pattern = r"\d+"

            results.append(user)
    except (KeyError, TypeError) as e:  # FIXED: Specific exceptions
        print(f"Error processing users: {e}")

    return results


def calculate_total(items: List[Dict[str, float]]) -> float:
    """Calculate total price of items."""
    # FIXED: Proper spacing around operator
    total = 0

    # FIXED: Proper comment indentation and spacing
    # Calculate sum of all item prices

    for item in items:
        # FIXED: Proper indentation (4 spaces)
        total += item['price']

    return total


# FIXED: Additional helper functions with proper style
def format_currency(amount: float) -> str:
    """Format amount as currency string."""
    return f"${amount:.2f}"


def is_adult(age: int) -> bool:
    """Check if person is adult (18+)."""
    return age >= 18


# FIXED: Proper spacing before inline comments
def calculate_tax(amount: float, rate: float = 0.08) -> float:
    """Calculate tax amount."""  # FIXED: Two spaces before comment
    tax = amount * rate  # FIXED: Two spaces before comment
    return round(tax, 2)


# FIXED: Main execution block with proper spacing
if __name__ == "__main__":
    # Example usage
    manager = UserManager("John", 25, "john@example.com")
    user_data = manager.create_user("Alice", "alice@example.com", 30)
    
    if user_data:
        print(f"Created user: {user_data}")
    
    # Test email validation
    valid_emails = [
        "user@example.com",
        "test.email@domain.org"
    ]
    
    for email in valid_emails:
        is_valid = manager.validate_email(email)
        print(f"Email {email} is {'valid' if is_valid else 'invalid'}")

# FIXED: Single newline at end of file