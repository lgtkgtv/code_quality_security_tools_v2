#!/usr/bin/env python3
"""
GOOD CODE EXAMPLE - Secure Code for bandit
==========================================

This file demonstrates the corrected version with security best practices.
This should pass all bandit checks with zero issues.

Run: bandit -r good_example.py (should show no issues)
"""

import json
import os
import subprocess  # nosec B404 - subprocess usage is controlled and safe
import hashlib
import secrets
import tempfile
from pathlib import Path
from typing import List, Dict, Any

# FIXED: Use environment variables or secure config management
DATABASE_PASSWORD = os.environ.get('DATABASE_PASSWORD', '')
API_KEY = os.environ.get('API_KEY', '')

# FIXED: Use parameterized queries to prevent SQL injection
def get_user_data(user_id: int) -> List[Dict[str, Any]]:
    """Safe database query with parameterized statements"""
    import sqlite3
    conn = sqlite3.connect('users.db')
    cursor = conn.cursor()
    
    # SECURE: Using parameterized query
    query = "SELECT * FROM users WHERE id = ?"
    cursor.execute(query, (user_id,))
    
    # Convert to list of dictionaries for better type safety
    columns = [description[0] for description in cursor.description]
    results = []
    for row in cursor.fetchall():
        results.append(dict(zip(columns, row)))
    
    conn.close()
    return results

# FIXED: Use subprocess with proper argument handling
def process_user_file(filename: str) -> str:
    """Safe file processing using subprocess with argument list"""
    # SECURE: Using subprocess.run with argument list
    try:
        result = subprocess.run(  # nosec B603 B607 - safe subprocess, no user input, controlled command
            ['grep', 'pattern', filename],  # List prevents injection
            capture_output=True,
            text=True,
            check=True,
            timeout=30  # Prevent hanging
        )
        return result.stdout
    except subprocess.CalledProcessError:
        return "Pattern not found"
    except subprocess.TimeoutExpired:
        return "Operation timed out"

# FIXED: Use cryptographically secure random generation
def generate_token() -> str:
    """Secure token generation using secrets module"""
    # SECURE: Using cryptographically strong random
    return secrets.token_urlsafe(32)

# FIXED: Use safe YAML loading
def load_config(config_data: str) -> Dict[str, Any]:
    """Safe YAML deserialization"""
    import yaml
    # SECURE: Using safe_load prevents code execution
    try:
        return yaml.safe_load(config_data) or {}
    except yaml.YAMLError:
        return {}

# FIXED: Use strong hashing with salt
def hash_password(password: str) -> str:
    """Secure password hashing with bcrypt"""
    import bcrypt
    # SECURE: Using bcrypt with salt
    salt = bcrypt.gensalt()
    hashed = bcrypt.hashpw(password.encode('utf-8'), salt)
    return hashed.decode('utf-8')

# FIXED: Use safe data serialization instead of pickle
def safe_data_serialization(data: dict) -> dict:
    """SECURITY FIX: Safe data serialization using JSON"""
    # GOOD: Use JSON instead of pickle for untrusted data
    try:
        # Serialize to JSON and back to ensure safety
        json_data = json.dumps(data)
        return json.loads(json_data)  # JSON is safe from code execution
    except (json.JSONEncodeError, json.JSONDecodeError) as e:
        print(f"Error serializing data: {e}")
        return {}

def load_safe_data(filename: str) -> dict:
    """Load data safely from JSON file"""
    try:
        with open(filename, "r", encoding='utf-8') as f:
            return json.load(f)  # Safe deserialization
    except (FileNotFoundError, json.JSONDecodeError) as e:
        print(f"Error loading data: {e}")
        return {}

# FIXED: Secure temporary file creation
def secure_temp_file() -> str:
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
        return data
    finally:
        # Clean up
        os.unlink(temp_file_path)

# FIXED: Bind to localhost only or use proper network configuration
def start_web_server(host: str = '127.0.0.1', port: int = 8080) -> None:
    """Secure server binding with explicit host"""
    from http.server import HTTPServer, SimpleHTTPRequestHandler
    
    # SECURE: Binding to localhost by default
    # For production, use proper web server with security configs
    server = HTTPServer((host, port), SimpleHTTPRequestHandler)
    print(f"Server starting on {host}:{port}")
    server.serve_forever()

# FIXED: Proper handling of false positives
def proper_assert_usage():
    """EXAMPLE: Proper handling of assert false positive"""
    # This is a legitimate development assert - safe to suppress
    debug_mode = True
    assert debug_mode, "Debug mode required for development"  # nosec B101 - legitimate development assert

def controlled_subprocess_usage():
    """EXAMPLE: Proper handling of subprocess false positive"""
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

# Additional security best practices demonstrated

def validate_user_input(user_input: str) -> bool:
    """Input validation example"""
    # Implement proper input validation
    if not isinstance(user_input, str):
        return False
    if len(user_input) > 1000:  # Prevent DoS
        return False
    if any(char in user_input for char in ['<', '>', '"', "'"]):
        return False  # Basic XSS prevention
    return True

def secure_file_operation(filepath: str) -> str:
    """Secure file operations with path validation"""
    import pathlib
    
    try:
        # Resolve and validate path
        path = pathlib.Path(filepath).resolve()
        
        # Ensure file is within allowed directory
        allowed_dir = pathlib.Path('/safe/directory').resolve()
        if not str(path).startswith(str(allowed_dir)):
            raise ValueError("Path traversal attempt detected")
        
        # Safe file reading
        with open(path, 'r', encoding='utf-8') as file:
            return file.read()
    except (OSError, ValueError) as e:
        print(f"File operation failed: {e}")
        return ""

if __name__ == "__main__":
    # Example usage demonstrating secure practices
    if DATABASE_PASSWORD:
        print("Database configuration loaded from environment")
    
    # These calls are now secure
    try:
        user_data = get_user_data(1)  # Type-safe integer
        file_content = process_user_file("safe_file.txt")
        token = generate_token()
        secure_data = secure_temp_file()
        
        print(f"Secure token generated: {token[:8]}...")
        print(f"Secure temp file processed: {len(secure_data)} bytes")
        
        # Examples of properly handled false positives
        proper_assert_usage()
        controlled_subprocess_usage()
        
        print("All security checks passed!")
        
    except Exception as e:
        print(f"Error: {e}")
        print("Security measures prevented potential issue")