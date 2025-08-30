# isort Import Sorter Learning Resources

## What is isort?
isort is a Python utility that automatically sorts and organizes your imports according to PEP8 guidelines and configurable rules. It helps maintain clean, readable, and consistent import sections in your Python files.

## Benefits of Organized Imports
- **Improved Readability**: Easy to scan and understand dependencies
- **Reduced Conflicts**: Consistent ordering reduces merge conflicts
- **Better Maintenance**: Easier to spot unused or missing imports
- **Team Consistency**: Everyone follows the same import organization
- **Code Quality**: Professional-looking, well-organized code

## Import Organization Rules
isort organizes imports into sections (in order):
1. **Standard Library**: Built-in Python modules
2. **Third Party**: External packages installed via pip
3. **Local Application**: Your project's own modules
4. **Relative Imports**: Relative imports within packages

Within each section, imports are sorted alphabetically.

## Common Import Issues isort Fixes
- **Mixed Import Styles**: `import os, sys` vs `import os` + `import sys`
- **Wrong Section Order**: Third-party imports before standard library
- **Alphabetical Sorting**: Imports not in alphabetical order
- **Inconsistent Spacing**: Wrong blank lines between sections
- **Mixed Import Types**: Regular imports mixed with from imports

## Configuration
Create a `.isort.cfg` file or add to `pyproject.toml`:

### .isort.cfg
```ini
[settings]
profile = black
multi_line_output = 3
include_trailing_comma = true
force_grid_wrap = 0
use_parentheses = true
ensure_newline_before_comments = true
line_length = 88
```

### pyproject.toml
```toml
[tool.isort]
profile = "black"
multi_line_output = 3
line_length = 88
include_trailing_comma = true
force_grid_wrap = 0
use_parentheses = true
src_paths = ["src", "tests"]
```

## Usage Examples
```bash
# Check if imports are sorted
isort --check-only file.py

# Show what changes would be made
isort --diff file.py

# Sort imports in place
isort file.py

# Sort all Python files in directory
isort .

# Sort with specific profile
isort --profile black file.py
```

## Import Organization Examples

### Before (Bad)
```python
import sys
from os.path import join
import requests
import os
from myapp.models import User
import json
from typing import List
```

### After (Good)
```python
# Standard library
import json
import os
import sys
from os.path import join
from typing import List

# Third-party
import requests

# Local application
from myapp.models import User
```

## Common Profiles
- **black**: Compatible with Black formatter
- **django**: Django project settings
- **pycharm**: PyCharm IDE compatible
- **google**: Google style guide
- **pep8**: Strict PEP8 compliance

## Advanced Features
### Custom Sections
```toml
[tool.isort]
known_first_party = ["myapp"]
known_third_party = ["requests", "flask"]
sections = ["FUTURE", "STDLIB", "THIRDPARTY", "FIRSTPARTY", "LOCALFOLDER"]
```

### Skip Files/Lines
```python
# isort:skip_file  # Skip entire file

import wrongly_ordered_import  # isort:skip
```

### Multi-line Import Styles
```python
# Style 0: Grid
from mypackage import (
    item1, item2, item3,
    item4, item5
)

# Style 3: Vertical hanging indent
from mypackage import (
    item1,
    item2,
    item3,
)
```

## Integration
Add isort to your development workflow:

```bash
# Install
pip install isort

# Pre-commit hook
repos:
  - repo: https://github.com/pycqa/isort
    rev: 5.10.1
    hooks:
      - id: isort

# With Black compatibility
pip install isort[colors]
isort --profile black .
```

## Best Practices
1. **Use Profiles**: Choose a profile (like 'black') for consistency
2. **Configure Once**: Set up configuration file for project-wide rules
3. **Group Related**: Keep related imports together within sections
4. **Avoid Star Imports**: Use specific imports instead of `from module import *`
5. **Document Exceptions**: Comment when breaking rules for good reasons
6. **Check Regularly**: Run isort checks in CI/CD pipeline

## Common Patterns
### Conditional Imports
```python
try:
    import ujson as json
except ImportError:
    import json
```

### Type Checking Imports
```python
from typing import TYPE_CHECKING

if TYPE_CHECKING:
    from myapp.types import ComplexType
```

### Relative Imports
```python
# Within a package
from . import sibling_module
from .. import parent_module
from ...utils import helper
```

## Troubleshooting
- **Import not recognized**: Add to `known_first_party` or `known_third_party`
- **Wrong section**: Check module classification in configuration
- **Conflicts with Black**: Use `profile = "black"` setting
- **Line length issues**: Set consistent `line_length` with other tools

## Further Reading
- [isort Documentation](https://pycqa.github.io/isort/)
- [PEP 8 Import Guidelines](https://pep8.org/#imports)
- [Import Organization Best Practices](https://realpython.com/python-import/)