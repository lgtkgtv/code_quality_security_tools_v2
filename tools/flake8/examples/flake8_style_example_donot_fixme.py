#!/usr/bin/env python3
"""
BAD CODE EXAMPLE - Style Issues Detected by Flake8
==================================================

This file demonstrates common style violations that flake8 detects.
DO NOT FIX - This file is intentionally broken for educational purposes.

Run: flake8 flake8_style_example_donot_fixme.py
"""

import json
import os  # E401: multiple imports on one line
import sys
from collections import *  # F403: star import

import unused_module  # F401: imported but unused


# E302: expected 2 blank lines, found 1
def bad_function_spacing():
    pass


class   BadClass:  # E271: multiple spaces after keyword
    # E111: indentation is not a multiple of four (but needs to be valid Python)
    def __init__(self):
        # E261: at least two spaces before inline comment
        self.value=42# missing spaces around operator and before comment
        # E501: line too long (>79 characters in default config)
        self.very_long_variable_name_that_exceeds_the_line_length_limit_and_makes_code_hard_to_read = "too long"
    
    # E303: too many blank lines (3)



    def method_with_issues(self,param1,param2):  # E999: missing spaces after commas
        # W292: no newline at end of file
        # E701: multiple statements on one line
        if param1>param2:return param1
        
        # E711: comparison to None should be 'is'
        if param2 == None:
            pass
            
        # E712: comparison to True should be 'is'
        if param1 == True:
            pass
            
        # F841: local variable assigned but never used
        unused_variable = "waste of space"
        
        # E225: missing whitespace around operator
        result=param1+param2
        
        # W391: blank line at end of file (when file ends with blank line)
        return result
    
    def method_with_complexity_issues(self, x):
        # C901: function is too complex (default limit: 10)
        # This method has high cyclomatic complexity
        if x > 0:
            if x > 10:
                if x > 20:
                    if x > 30:
                        if x > 40:
                            if x > 50:
                                if x > 60:
                                    if x > 70:
                                        if x > 80:
                                            if x > 90:
                                                return "very high"
                                            else:
                                                return "high"
                                        else:
                                            return "medium-high"
                                    else:
                                        return "medium"
                                else:
                                    return "medium-low"
                            else:
                                return "low-medium"
                        else:
                            return "low"
                    else:
                        return "very low"
                else:
                    return "minimal"
            else:
                return "tiny"
        else:
            return "negative"


# E305: expected 2 blank lines after class or function definition
def another_function():
    # F821: undefined name
    return undefined_variable

# W292 and other whitespace issues occur here