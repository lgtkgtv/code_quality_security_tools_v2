#!/usr/bin/env python3
"""
GOOD CODE EXAMPLE - Security Issues Fixed
=========================================

This file demonstrates secure alternatives to common vulnerabilities.
This is the FIXED version of the security issues.

Run: bandit bandit_security_example_fixed.py (should show no issues)
"""

import json
import os
import secrets
import sqlite3
import subprocess  # nosec B404 - subprocess usage is validated and safe in this context
import tempfile
from pathlib import Path
import shutil


def safe_shell_execution():
    """SECURITY FIX: Input validation and safe subprocess usage"""
    user_input = input("Enter filename: ")

    # GOOD: Validate input
    safe_path = Path(user_input).resolve()
    if not safe_path.exists() or not safe_path.is_file():
        raise ValueError("Invalid file path")

    # GOOD: Use built-in functions instead of subprocess for simple operations
    try:
        with open(safe_path, 'r', encoding='utf-8') as f:
            content = f.read()
            print(content)
    except (OSError, UnicodeDecodeError) as e:
        print(f"Error reading file: {e}")


def secure_random_generation():
    """SECURITY FIX: Cryptographically secure random generation"""
    # GOOD: Using secrets module for cryptographically secure random
    session_token = secrets.randbelow(9000000) + 1000000
    api_key = secrets.token_urlsafe(32)
    return session_token, api_key


def safe_data_serialization():
    """SECURITY FIX: Safe data serialization using JSON"""
    # GOOD: Use JSON instead of pickle for untrusted data
    try:
        with open("user_data.json", "r") as f:
            user_data = json.load(f)  # JSON is safe from code execution
        return user_data
    except (FileNotFoundError, json.JSONDecodeError) as e:
        print(f"Error loading data: {e}")
        return {}


def secure_credentials():
    """SECURITY FIX: Environment variables for credentials"""
    # GOOD: Read secrets from environment variables
    database_password = os.getenv("DATABASE_PASSWORD")
    api_key = os.getenv("API_KEY")

    if not database_password or not api_key:
        raise ValueError("Required environment variables not set")

    # GOOD: Bind to localhost only, disable debug in production
    # app.run(host='127.0.0.1', debug=False)
    return database_password, api_key


def secure_temp_file():
    """SECURITY FIX: Secure temporary file creation"""
    # GOOD: Use tempfile module for secure temp file creation
    with tempfile.NamedTemporaryFile(
        mode="w", delete=False, prefix="app_data_", suffix=".tmp"
    ) as f:
        f.write("sensitive data")
        temp_file_path = f.name

    try:
        # Use the temporary file
        with open(temp_file_path, "r") as f:
            data = f.read()
    finally:
        # Clean up
        os.unlink(temp_file_path)


def safe_database_query():
    """SECURITY FIX: Parameterized queries prevent SQL injection"""
    user_id = input("Enter user ID: ")

    # GOOD: Validate input
    try:
        user_id = int(user_id)
    except ValueError:
        raise ValueError("User ID must be a number")

    # GOOD: Use parameterized query
    conn = sqlite3.connect("database.db")
    cursor = conn.cursor()

    # Parameterized query prevents SQL injection
    cursor.execute("SELECT * FROM users WHERE id = ?", (user_id,))
    result = cursor.fetchall()

    conn.close()
    return result


def proper_assert_usage():
    """EXAMPLE: Proper handling of assert false positive"""
    # This is a legitimate development assert - safe to suppress
    debug_mode = True
    assert debug_mode, "Debug mode required for development"  # nosec B101 - legitimate development assert


def controlled_subprocess_usage():
    """EXAMPLE: Proper handling of subprocess false positive"""
    import subprocess  # nosec B404 - subprocess usage is validated and safe in this context
    log_file = "/var/log/myapp.log"
    
    # This is safe - we control all arguments, no user input involved
    try:
        result = subprocess.run(  # nosec B603 - safe subprocess usage, no user input
            ["/usr/bin/tail", "-10", log_file],  # nosec B607 - controlled command path
            capture_output=True, 
            check=True
        )
        return result.stdout.decode('utf-8')
    except (subprocess.CalledProcessError, FileNotFoundError):
        return "Log file not accessible"


if __name__ == "__main__":
    # All these functions use secure patterns
    try:
        safe_shell_execution()
        secure_random_generation()
        safe_data_serialization()
        secure_credentials()
        secure_temp_file()
        safe_database_query()
        
        # Examples of properly handled false positives
        proper_assert_usage()
        controlled_subprocess_usage()
        
        print("All security checks passed!")
    except Exception as e:
        print(f"Error: {e}")
