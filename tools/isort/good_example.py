#!/usr/bin/env python3
"""
GOOD CODE EXAMPLE - Properly Organized Imports for isort
========================================================

This file demonstrates properly organized imports that follow isort standards.
This should pass all isort checks with zero issues.

Run: isort --check-only good_example.py (should show no issues)
"""

# SECTION 1: Standard Library Imports (alphabetically sorted)
import asyncio
import datetime
import json
import logging
import os
import re
import sqlite3
import sys
import threading
import time
import uuid
from collections import OrderedDict, defaultdict
from concurrent.futures import ThreadPoolExecutor
from dataclasses import dataclass
from os.path import dirname, join
from pathlib import Path
from typing import Dict, List, Optional
from urllib.parse import urlparse

# SECTION 2: Third-Party Library Imports (alphabetically sorted)
import numpy as np
import pandas as pd
import requests
from django.db import models
from flask import Flask, jsonify
from sqlalchemy import Column, Integer, String

# SECTION 3: Local Application Imports (alphabetically sorted)
from myapp.config import DATABASE_URL
from myapp.models import User
from myapp.utils import helper_function
from myapp.views import UserView


@dataclass
class GoodImportExample:
    """Example class demonstrating proper import organization."""
    
    def __init__(self):
        # Using imports from properly organized sections above
        self.logger = logging.getLogger(__name__)
        self.session_id = str(uuid.uuid4())
        self.current_time = datetime.datetime.now()
    
    def process_data(self):
        """Method using the properly organized imports."""
        # Standard library usage
        data_path = join(dirname(__file__), "data.json")
        
        # Third-party library usage
        df = pd.DataFrame({"col1": [1, 2, 3]})
        arr = np.array([1, 2, 3, 4, 5])
        
        # Local imports usage
        user = User("example")
        config_url = DATABASE_URL
        
        return {
            "path": data_path,
            "dataframe_shape": df.shape,
            "array_sum": arr.sum(),
            "user": user,
            "config": config_url
        }
    
    def make_request(self):
        """Method using web-related imports."""
        try:
            response = requests.get("https://api.example.com/data")
            parsed_url = urlparse(response.url)
            return {
                "status": response.status_code,
                "host": parsed_url.netloc
            }
        except Exception as e:
            self.logger.error(f"Request failed: {e}")
            return None
    
    def database_operations(self):
        """Method using database-related imports."""
        # SQLite operations
        conn = sqlite3.connect(":memory:")
        cursor = conn.cursor()
        
        # SQLAlchemy model definition (normally would be in separate file)
        class ExampleModel:
            id = Column(Integer, primary_key=True)
            name = Column(String(50))
        
        return {"connection": conn, "model": ExampleModel}
    
    async def async_operation(self):
        """Async method using concurrency imports."""
        with ThreadPoolExecutor(max_workers=2) as executor:
            future = executor.submit(time.sleep, 1)
            await asyncio.sleep(0.1)
            return future.result()


# Example usage showing how organized imports improve readability
if __name__ == "__main__":
    example = GoodImportExample()
    
    # Standard library operations
    current_dir = dirname(__file__)
    thread_id = threading.current_thread().ident
    
    # Third-party operations
    app = Flask(__name__)
    
    @app.route("/data")
    def get_data():
        return jsonify(example.process_data())
    
    # Local import operations  
    view = UserView()
    helper_result = helper_function()
    
    print(f"Example initialized in directory: {current_dir}")
    print(f"Thread ID: {thread_id}")
    print(f"Helper result: {helper_result}")


# Additional examples of good import organization patterns

# Example 1: Conditional imports (when needed for optional dependencies)
try:
    import matplotlib.pyplot as plt
    HAS_MATPLOTLIB = True
except ImportError:
    HAS_MATPLOTLIB = False

# Example 2: Imports for type checking only
from typing import TYPE_CHECKING

if TYPE_CHECKING:
    from myapp.advanced_types import ComplexType

# Example 3: Relative imports (when used within a package)
# from .models import LocalModel
# from ..utils import package_helper
# from ...config import global_config

# Example 4: Star imports (generally avoided, but when necessary)
# Should be at the end and well-documented
# from myapp.constants import *  # noqa: F401,F403