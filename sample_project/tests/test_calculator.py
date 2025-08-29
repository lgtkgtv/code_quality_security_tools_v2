"""Tests for calculator module."""

import pytest
from src.calculator import add, divide

def test_add():
    """Test addition."""
    assert add(2, 3) == 5
    assert add(-1, 1) == 0

def test_divide():
    """Test division."""
    assert divide(10, 2) == 5
    assert divide(7, 2) == 3.5

def test_divide_by_zero():
    """Test division by zero."""
    with pytest.raises(ValueError):
        divide(5, 0)
