# Bandit Security Scanner Learning Resources

## What is Bandit?
Bandit is a security linter for Python that scans code for common security issues. It uses an AST (Abstract Syntax Tree) to analyze code and detect patterns that could lead to security vulnerabilities.

## Common Security Issues Detected
- **Hardcoded passwords/secrets**: Credentials embedded directly in code
- **SQL injection**: Unsafe database query construction 
- **Command injection**: Unsafe shell command execution
- **Insecure randomness**: Using predictable random number generators
- **Unsafe deserialization**: YAML/pickle loading that can execute code
- **Weak cryptography**: Using broken hash algorithms like MD5
- **Network security**: Binding servers to all interfaces (0.0.0.0)

## Best Practices
1. **Secret Management**: Use environment variables or dedicated secret stores
2. **Input Validation**: Always validate and sanitize user inputs
3. **Parameterized Queries**: Use prepared statements for database operations
4. **Subprocess Safety**: Use argument lists instead of shell strings
5. **Cryptographic Security**: Use strong, modern algorithms and libraries
6. **Network Configuration**: Bind services appropriately for your environment

## Configuration
Bandit can be configured with a `.bandit` file or bandit.yaml:

```yaml
# Example bandit.yaml
tests:
  - B101  # Test for use of assert
  - B102  # Test for exec used
  
skips:
  - B404  # Consider possible security implications of subprocess

exclude_dirs:
  - '/tests'
  - '/venv'
```

## Suppressing False Positives
Use `# nosec` comments for legitimate cases:

```python
import subprocess  # nosec B404 - subprocess usage is validated
result = subprocess.run(['safe', 'command'])  # nosec B603 - controlled input
```

## Integration
Add bandit to your development workflow:

```bash
# Install
pip install bandit

# Basic scan
bandit -r your_project/

# Generate report
bandit -r your_project/ -f json -o security_report.json

# Pre-commit hook
pip install pre-commit
# Add to .pre-commit-config.yaml
```

## Further Reading
- [Bandit Documentation](https://bandit.readthedocs.io/)
- [OWASP Python Security](https://owasp.org/www-project-python-security/)
- [Python Security Best Practices](https://python-security.readthedocs.io/)