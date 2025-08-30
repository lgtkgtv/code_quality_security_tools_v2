#!/usr/bin/env python3
"""
BAD CODE EXAMPLE - Security Issues Detected by Bandit
=====================================================

This file demonstrates common security vulnerabilities that bandit detects.
DO NOT FIX - This file is intentionally broken for educational purposes.

Run: bandit bandit_security_example_donot_fixme.py
"""

import os
import pickle
import random
import subprocess


def unsafe_shell_execution():
    """SECURITY ISSUE: Shell injection vulnerability"""
    # BAD: User input directly used in shell command
    user_input = input("Enter filename: ")
    # This allows shell injection: user could input "; rm -rf /"
    command = f"cat {user_input}"
    os.system(command)  # bandit B602: subprocess_popen_with_shell_equals_true


def weak_random_generation():
    """SECURITY ISSUE: Cryptographically weak random number generation"""
    # BAD: Using random module for security-sensitive operations
    # random is predictable and not cryptographically secure
    session_token = random.randint(1000000, 9999999)  # bandit B311
    api_key = str(random.random())  # bandit B311
    return session_token, api_key


def unsafe_pickle_usage():
    """SECURITY ISSUE: Unsafe deserialization"""
    # BAD: pickle.loads() can execute arbitrary code
    # Malicious pickle data can run any Python code
    with open('user_data.pkl', 'rb') as f:
        untrusted_data = f.read()
    user_data = pickle.loads(untrusted_data)  # bandit B301
    return user_data


def hardcoded_credentials():
    """SECURITY ISSUE: Hardcoded passwords and secrets"""
    # BAD: Secrets in source code
    DATABASE_PASSWORD = "super_secret_123"  # bandit B105
    API_KEY = "sk-1234567890abcdef"  # bandit B105
    
    # BAD: Hardcoded bind to all interfaces
    app.run(host='0.0.0.0', debug=True)  # bandit B104, B201


def unsafe_temp_file():
    """SECURITY ISSUE: Insecure temporary file creation"""
    # BAD: Predictable temp file names, race condition vulnerability
    temp_file = "/tmp/app_data_" + str(random.randint(1, 1000))  # bandit B108
    with open(temp_file, 'w') as f:
        f.write("sensitive data")


def sql_injection_risk():
    """SECURITY ISSUE: SQL injection vulnerability pattern"""
    # BAD: String formatting in SQL queries
    user_id = input("Enter user ID: ")
    # This pattern is vulnerable to SQL injection
    query = f"SELECT * FROM users WHERE id = {user_id}"  # bandit would flag similar patterns
    return query


def legitimate_assert_usage():
    """FALSE POSITIVE EXAMPLE: Assert used for development debugging"""
    # This is a legitimate use of assert for development/debugging
    # In production, asserts are disabled with -O flag anyway
    debug_mode = True
    assert debug_mode, "Debug mode should be enabled during development"  # bandit B101 - FALSE POSITIVE


def safe_subprocess_usage():
    """FALSE POSITIVE EXAMPLE: Subprocess with validated, safe command"""
    # This subprocess call is actually safe - we control the command completely
    import subprocess
    log_file = "/var/log/myapp.log"
    
    # Safe subprocess - we control all arguments, no user input
    # This might trigger B603 or B607 but is actually secure
    try:
        result = subprocess.run(["/usr/bin/tail", "-10", log_file], 
                               capture_output=True, check=True)  # bandit might flag this - FALSE POSITIVE
        return result.stdout
    except subprocess.CalledProcessError:
        print("Log file not accessible")
        return None


if __name__ == "__main__":
    # All these functions contain security vulnerabilities
    unsafe_shell_execution()
    weak_random_generation()
    unsafe_pickle_usage()
    hardcoded_credentials()
    unsafe_temp_file()
    sql_injection_risk()
    
    # These are examples of false positives
    legitimate_assert_usage()
    safe_subprocess_usage()
    
    print("Security vulnerabilities and false positive examples demonstrated")