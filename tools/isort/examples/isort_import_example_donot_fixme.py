#!/usr/bin/env python3
"""
BAD CODE EXAMPLE - Import Organization Issues Detected by isort
==============================================================

This file demonstrates poor import organization that isort fixes.
DO NOT FIX - This file is intentionally disorganized for educational purposes.

Run: isort --diff isort_import_example_donot_fixme.py (to see what would change)
Run: isort isort_import_example_donot_fixme.py (to actually organize)
"""

# WRONG: Single import after from imports
import asyncio
import datetime
# WRONG: More standard library
import hashlib
import json
import logging
import os
# WRONG: Standard library import after third-party
import re
# WRONG: More mixing of import types
import sqlite3
import sys
# WRONG: More standard library mixed in
import tempfile
from collections import defaultdict
from concurrent.futures import ThreadPoolExecutor
from pathlib import Path
from typing import Dict, List
from urllib.parse import urlparse

# WRONG: More third-party
import click
import numpy as np
# WRONG: More third-party imports after standard library
import pandas as pd
# WRONG ORDER: Third-party imports should come after standard library
import requests
from django.conf import settings
from elasticsearch import Elasticsearch
from flask import Flask, request

from ..services.auth import authenticate_user
# WRONG: Another local import in wrong place
from ..utils import database_utils
# WRONG: More local imports
from .config import DATABASE_URL
# WRONG: Local imports mixed with standard library
from .local_module import helper_function
from .models import Product, User


def example_function():
    """Example function using the imports."""
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
        "auth": auth_result
    }


# The imports above violate several isort principles:
# 1. Wrong order (should be: standard library, third-party, local)
# 2. Mixed import styles (import vs from import) within sections
# 3. No blank lines separating import sections
# 4. Inconsistent sorting within sections
# 5. Local imports scattered throughout instead of grouped