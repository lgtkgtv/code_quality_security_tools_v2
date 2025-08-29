#!/usr/bin/env python3
"""
GOOD CODE EXAMPLE - Proper Import Organization with isort
=========================================================

This file demonstrates proper import organization following isort standards.
This is the FIXED version with correctly organized imports.

Run: isort --check-only isort_import_example_fixed.py (should show no changes needed)
"""

# SECTION 1: Standard library imports (alphabetically sorted)
import asyncio
import datetime
import hashlib
import json
import logging
import os
import re
import sqlite3
import sys
import tempfile
from collections import defaultdict
from concurrent.futures import ThreadPoolExecutor
from pathlib import Path
from typing import Dict, List
from urllib.parse import urlparse

# SECTION 2: Third-party imports (alphabetically sorted)
import click
import numpy as np
import pandas as pd
import requests
from django.conf import settings
from elasticsearch import Elasticsearch
from flask import Flask, request

# SECTION 3: Local application imports (alphabetically sorted)
from ..services.auth import authenticate_user
from ..utils import database_utils
from .config import DATABASE_URL
from .local_module import helper_function
from .models import Product, User


def example_function():
    """Example function using the properly organized imports."""
    # Using standard library
    current_time = datetime.datetime.now()
    temp_dir = tempfile.mkdtemp()

    # Using third-party packages
    response = requests.get("https://api.example.com")
    df = pd.DataFrame({"data": [1, 2, 3]})

    # Using local imports
    user = User("example")
    auth_result = authenticate_user("token")

    return {
        "time": current_time,
        "temp": temp_dir,
        "response": response.status_code,
        "data": df,
        "user": user,
        "auth": auth_result,
    }


def demonstrate_import_benefits():
    """
    Benefits of proper import organization:

    1. READABILITY: Easy to see what dependencies the module has
    2. MAINTAINABILITY: Easy to add/remove imports in the right place
    3. CONFLICT AVOIDANCE: Reduces naming conflicts between modules
    4. STANDARDS COMPLIANCE: Follows PEP 8 and community best practices
    5. TOOL COMPATIBILITY: Works well with IDEs and other tools
    """

    # Standard library usage examples
    data_dict = defaultdict(list)
    current_path = Path(__file__)

    # Third-party usage examples
    array_data = np.array([1, 2, 3, 4, 5])
    web_response = requests.get("https://httpbin.org/json")

    # Local module usage examples
    helper_result = helper_function()
    user_obj = User("test_user")

    return {
        "dict": data_dict,
        "path": current_path,
        "array": array_data,
        "response": web_response,
        "helper": helper_result,
        "user": user_obj,
    }


# The imports above follow isort principles:
# 1. Correct order: standard library → third-party → local
# 2. Blank lines separating each section
# 3. Alphabetical sorting within each section
# 4. Consistent style (from imports after regular imports)
# 5. Clear separation makes dependencies obvious
