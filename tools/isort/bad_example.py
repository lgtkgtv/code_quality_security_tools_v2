#!/usr/bin/env python3
"""
BAD CODE EXAMPLE - Import Issues Detected by isort
==================================================

This file demonstrates poorly organized imports that isort will fix.
DO NOT FIX - This file is intentionally badly organized for educational purposes.

Run: isort --check-only --diff bad_example.py
"""

# BAD: Mixed import styles and wrong order
import sys
from os.path import join, dirname
import json
from typing import Dict, List, Optional
import os
from collections import defaultdict, OrderedDict
import requests  # Third-party import mixed with standard library
import sqlite3
from urllib.parse import urlparse
import datetime
from dataclasses import dataclass
import numpy as np  # Third-party import in wrong place
from pathlib import Path
import re
from flask import Flask, jsonify  # Third-party imports scattered
import asyncio
from concurrent.futures import ThreadPoolExecutor
import pandas as pd  # Another third-party import
from myapp.models import User  # Local import mixed in
import threading
from myapp.utils import helper_function  # Another local import
import time
from django.db import models  # Third-party framework import
from myapp.config import DATABASE_URL  # Local config import
import logging
from myapp.views import UserView  # Local view import
import uuid
from sqlalchemy import Column, Integer, String  # Third-party ORM


@dataclass
class BadImportExample:
    """Example class demonstrating the import organization issues above."""
    
    def __init__(self):
        # Using imports from various categories mixed above
        self.logger = logging.getLogger(__name__)
        self.session_id = str(uuid.uuid4())
        self.current_time = datetime.datetime.now()
    
    def process_data(self):
        """Method using the poorly organized imports."""
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


# Example usage showing how mixed imports affect readability
if __name__ == "__main__":
    example = BadImportExample()
    
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