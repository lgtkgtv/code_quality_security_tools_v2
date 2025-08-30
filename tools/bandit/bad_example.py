#!/usr/bin/env python3
"""
BAD CODE EXAMPLE - Security Issues Detected by bandit
====================================================

This file demonstrates security vulnerabilities that bandit detects.
DO NOT FIX - This file is intentionally broken for educational purposes.

Run: bandit -r bad_example.py
"""

import os
import subprocess
import hashlib
import pickle
import random
import tempfile

# SECURITY ISSUE 1: Hardcoded password (HIGH severity)
DATABASE_PASSWORD = "super_secret_123"
API_KEY = "sk-1234567890abcdef"

# SECURITY ISSUE 2: SQL Injection vulnerability
def get_user_data(user_id):
    """Unsafe database query - SQL injection risk"""
    import sqlite3
    conn = sqlite3.connect('users.db')
    cursor = conn.cursor()
    
    # VULNERABLE: Direct string interpolation in SQL
    query = f"SELECT * FROM users WHERE id = '{user_id}'"
    cursor.execute(query)
    return cursor.fetchall()

# SECURITY ISSUE 3: Command injection vulnerability  
def process_user_file(filename):
    """Unsafe command execution - command injection risk"""
    # VULNERABLE: User input directly in shell command
    command = f"cat {filename} | grep 'pattern'"
    os.system(command)

# SECURITY ISSUE 4: Insecure random number generation
def generate_token():
    """Insecure token generation"""
    import random
    # VULNERABLE: Using predictable random
    return str(random.randint(1000000, 9999999))

# SECURITY ISSUE 5: Unsafe YAML loading
def load_config(config_data):
    """Unsafe YAML deserialization"""
    import yaml
    # VULNERABLE: yaml.load can execute arbitrary code
    return yaml.load(config_data)

# SECURITY ISSUE 6: Insecure hash algorithm
def hash_password(password):
    """Insecure password hashing"""
    # VULNERABLE: MD5 is cryptographically broken
    return hashlib.md5(password.encode()).hexdigest()

# SECURITY ISSUE 7: Unsafe pickle deserialization
def unsafe_pickle_usage():
    """SECURITY ISSUE: Unsafe deserialization"""
    # BAD: pickle.loads() can execute arbitrary code
    # Malicious pickle data can run any Python code
    try:
        with open('user_data.pkl', 'rb') as f:
            untrusted_data = f.read()
        user_data = pickle.loads(untrusted_data)  # bandit B301
        return user_data
    except FileNotFoundError:
        return {}

# SECURITY ISSUE 8: Insecure temporary file creation
def unsafe_temp_file():
    """SECURITY ISSUE: Insecure temporary file creation"""
    # BAD: Predictable temp file names, race condition vulnerability
    temp_file = "/tmp/app_data_" + str(random.randint(1, 1000))  # bandit B108
    with open(temp_file, 'w') as f:
        f.write("sensitive data")
    return temp_file

# SECURITY ISSUE 9: Binding to all interfaces
def start_web_server():
    """Insecure server binding"""
    from http.server import HTTPServer, SimpleHTTPRequestHandler
    # VULNERABLE: Binding to 0.0.0.0 exposes to all networks
    server = HTTPServer(('0.0.0.0', 8080), SimpleHTTPRequestHandler)
    server.serve_forever()

# FALSE POSITIVE EXAMPLES (legitimate code that bandit flags)
def legitimate_assert_usage():
    """FALSE POSITIVE EXAMPLE: Assert used for development debugging"""
    # This is a legitimate use of assert for development/debugging
    # In production, asserts are disabled with -O flag anyway
    debug_mode = True
    assert debug_mode, "Debug mode should be enabled during development"  # bandit B101 - FALSE POSITIVE

def safe_subprocess_usage():
    """FALSE POSITIVE EXAMPLE: Subprocess with validated, safe command"""
    # This subprocess call is actually safe - we control the command completely
    log_file = "/var/log/myapp.log"
    
    # Safe subprocess - we control all arguments, no user input
    # This might trigger B603 or B607 but is actually secure
    try:
        result = subprocess.run(["/usr/bin/tail", "-10", log_file], 
                               capture_output=True, check=True)  # bandit might flag this - FALSE POSITIVE
        return result.stdout.decode('utf-8')
    except subprocess.CalledProcessError:
        print("Log file not accessible")
        return None

if __name__ == "__main__":
    # Example usage that demonstrates the vulnerabilities
    print(f"Database password: {DATABASE_PASSWORD}")
    
    # These calls would trigger security issues
    user_data = get_user_data("1'; DROP TABLE users; --")
    process_user_file("file.txt; rm -rf /")
    token = generate_token()
    temp_file = unsafe_temp_file()
    
    print(f"Generated token: {token}")
    print(f"Password hash: {hash_password('password123')}")
    print(f"Temp file created: {temp_file}")
    
    # These are examples of false positives
    legitimate_assert_usage()
    safe_subprocess_usage()
    
    print("Security vulnerabilities and false positive examples demonstrated")