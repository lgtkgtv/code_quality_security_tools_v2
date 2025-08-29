#!/usr/bin/env python3
"""
GOOD CODE EXAMPLE - Security Issues Fixed
=========================================

This file demonstrates secure alternatives to common vulnerabilities.
This is the FIXED version of the security issues.

Run: bandit bandit_security_example_fixed.py (should show no issues)
"""

import os
import subprocess
import json
import secrets
import tempfile
import sqlite3
from pathlib import Path


def safe_shell_execution():
    """SECURITY FIX: Input validation and safe subprocess usage"""
    user_input = input("Enter filename: ")
    
    # GOOD: Validate input
    safe_path = Path(user_input).resolve()
    if not safe_path.exists() or not safe_path.is_file():
        raise ValueError("Invalid file path")
    
    # GOOD: Use subprocess with list of arguments (no shell injection)
    try:
        result = subprocess.run(['cat', str(safe_path)], 
                              capture_output=True, text=True, check=True)
        print(result.stdout)
    except subprocess.CalledProcessError as e:
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
        with open('user_data.json', 'r') as f:
            user_data = json.load(f)  # JSON is safe from code execution
        return user_data
    except (FileNotFoundError, json.JSONDecodeError) as e:
        print(f"Error loading data: {e}")
        return {}


def secure_credentials():
    """SECURITY FIX: Environment variables for credentials"""
    # GOOD: Read secrets from environment variables
    database_password = os.getenv('DATABASE_PASSWORD')
    api_key = os.getenv('API_KEY')
    
    if not database_password or not api_key:
        raise ValueError("Required environment variables not set")
    
    # GOOD: Bind to localhost only, disable debug in production
    # app.run(host='127.0.0.1', debug=False)
    return database_password, api_key


def secure_temp_file():
    """SECURITY FIX: Secure temporary file creation"""
    # GOOD: Use tempfile module for secure temp file creation
    with tempfile.NamedTemporaryFile(mode='w', delete=False, 
                                   prefix='app_data_', suffix='.tmp') as f:
        f.write("sensitive data")
        temp_file_path = f.name
    
    try:
        # Use the temporary file
        with open(temp_file_path, 'r') as f:
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
    conn = sqlite3.connect('database.db')
    cursor = conn.cursor()
    
    # Parameterized query prevents SQL injection
    cursor.execute("SELECT * FROM users WHERE id = ?", (user_id,))
    result = cursor.fetchall()
    
    conn.close()
    return result


if __name__ == "__main__":
    # All these functions use secure patterns
    try:
        safe_shell_execution()
        secure_random_generation()
        safe_data_serialization()
        secure_credentials()
        secure_temp_file()
        safe_database_query()
        print("All security checks passed!")
    except Exception as e:
        print(f"Error: {e}")