# Tool Template

This is a template directory for adding new tools to the educational system.

## How to Add a New Tool

1. **Copy Template**: Copy this entire `template/` directory to `tools/your-tool-name/`
2. **Update config.yaml**: Fill in all the tool-specific information
3. **Create bad_example.py**: Write code that demonstrates common issues your tool catches
4. **Create good_example.py**: Write the corrected version with zero issues
5. **Update description.txt**: Write a one-line description for the menu
6. **Update lesson.md**: Add educational content about the tool
7. **Test**: Run `./tutorial_v2.sh` to verify your tool appears and works

## File Structure Requirements

```
tools/your-tool-name/
├── config.yaml        # Tool configuration (required)
├── bad_example.py     # Code with issues (required)
├── good_example.py    # Fixed code (required)  
├── description.txt    # One-line description (required)
├── lesson.md         # Learning resources (optional)
└── README.md         # Tool-specific docs (optional)
```

## Naming Conventions

- **Tool directory**: Use the actual tool name (e.g., `bandit`, `flake8`, `mypy`)
- **Bad example**: Always name it `bad_example.py` 
- **Good example**: Always name it `good_example.py`
- **Config file**: Always name it `config.yaml`

The tutorial system will automatically discover and include any tool that has all required files.