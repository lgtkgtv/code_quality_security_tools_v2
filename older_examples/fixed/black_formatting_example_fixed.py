#!/usr/bin/env python3
"""
GOOD CODE EXAMPLE - Consistent Formatting with Black
====================================================

This file demonstrates consistent formatting applied by black.
This is the FIXED version with proper formatting.

Run: black --check black_formatting_example_fixed.py (should show no changes needed)
"""


def calculate_total(items, tax_rate=0.1, discount=0.05):
    """Calculate total with tax and discount applied."""
    subtotal = 0
    for item in items:
        price = item["price"]
        quantity = item["quantity"]
        subtotal += price * quantity

    tax = subtotal * tax_rate
    discount_amount = subtotal * discount
    total = subtotal + tax - discount_amount

    return total


class ProductManager:
    """Manages product inventory and operations."""

    def __init__(self, products):
        self.products = products
        self.status = "active"
        self.version = "1.0"

    def find_product(self, product_id):
        """Find product by ID."""
        for product in self.products:
            if product["id"] == product_id:
                return product
        return None

    def create_product(
        self,
        name,
        description,
        price,
        category,
        tags,
        in_stock,
        supplier_info,
    ):
        """Create a new product with proper formatting."""
        product = {
            "id": len(self.products) + 1,
            "name": name,
            "description": description,
            "price": price,
            "category": category,
            "tags": tags,
            "in_stock": in_stock,
            "supplier": supplier_info,
            "created_at": "2024-01-01",
        }

        required_fields = ["name", "price", "category"]

        if name and price and category and price > 0:
            self.products.append(product)
            return product
        else:
            return None

    def calculate_inventory_value(self):
        """Calculate total inventory value."""
        total_value = sum(
            [
                product["price"] * product.get("quantity", 0)
                for product in self.products
                if product["in_stock"]
            ]
        )
        return total_value


def process_order(
    customer_id,
    items,
    shipping_address,
    billing_address,
    payment_method,
    special_instructions=None,
    priority="normal",
    gift_wrap=False,
):
    """Process customer order with proper parameter formatting."""
    order = {
        "customer_id": customer_id,
        "items": items,
        "shipping": shipping_address,
        "billing": billing_address,
        "payment": payment_method,
        "instructions": special_instructions,
        "priority": priority,
        "gift_wrap": gift_wrap,
        "status": "pending",
        "total": 0,
    }

    order_total = sum([item["price"] * item["quantity"] for item in items])
    order["total"] = order_total

    return order


# Properly formatted nested data structures
configuration = {
    "database": {
        "host": "localhost",
        "port": 5432,
        "name": "mydb",
        "user": "admin",
        "password": "secret",
    },
    "api": {
        "version": "v1",
        "timeout": 30,
        "retries": 3,
        "endpoints": ["users", "products", "orders"],
    },
    "features": {"logging": True, "caching": False, "notifications": True},
}

# Properly formatted lambda functions
sort_by_price = lambda products: sorted(products, key=lambda p: p["price"])
filter_in_stock = lambda products: [p for p in products if p["in_stock"]]


def risky_operation():
    """Properly formatted exception handling."""
    try:
        result = dangerous_function()
        return result
    except Exception as e:
        print("Error occurred:", str(e))
        return None
    finally:
        cleanup()
