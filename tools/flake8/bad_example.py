#!/usr/bin/env python3
"""
BAD CODE EXAMPLE - Style Issues Detected by flake8
==================================================

This file demonstrates common PEP8 and style issues that flake8 detects.
DO NOT FIX - This file is intentionally broken for educational purposes.

Run: flake8 bad_example.py
"""

import os,sys,re # E401: Multiple imports on one line
import json
import unused_module # F401: Imported but unused

# E302: Expected 2 blank lines before class definition
class BadExample:
    def __init__(self,name,age): # E201: Whitespace after '(', E201: Whitespace before ')'
        # E261: At least two spaces before inline comment
        self.name=name #Missing space around operator
        self.age = age
    
    def get_info(self):# E701: Multiple statements on one line
        return f"Name: {self.name}, Age: {self.age}"
    
    # E303: Too many blank lines
    
    
    def long_function_with_many_parameters(self,param1,param2,param3,param4,param5,param6): # E501: Line too long
        """This function has a very long line that exceeds the recommended 79 character limit and will trigger flake8 warnings"""
        # E127: Continuation line over-indented for visual indent
        result = param1 + param2 + param3 + param4 + param5 + param6
        return result
    
    def bad_spacing(self ):  # E201: Whitespace before ')'
        x=1+2*3/4-5 # E225: Missing whitespace around operator
        y = [ 1,2,3,4,5 ] # E201, E202: Whitespace issues in brackets
        z = { 'a':1,'b':2 } # E231: Missing whitespace after ','
        return x,y,z
    
    def unused_variables(self):
        x = 10 # F841: Local variable assigned but never used
        y = 20 # F841: Local variable assigned but never used  
        return 5

# E302: Expected 2 blank lines before function definition
def global_function():
    if True: # E712: Comparison to True should be 'if cond is True:' or 'if cond:'
        pass
    if False:# E261: At least two spaces before inline comment
        pass
    
    # E711: Comparison to None should be 'if cond is None:'
    if something == None:
        print("This is bad")
    
    # W503: Line break before binary operator (deprecated but still flagged)
    result = (some_very_long_variable_name 
              + another_very_long_variable_name
              + yet_another_long_name)
    
    return result

# E305: Expected 2 blank lines after class or function definition
def another_function():
    # E502: Backslash is redundant between brackets
    long_string = "This is a very long string that " \
                  "continues on the next line"
    
    # E741: Ambiguous variable name
    l = [1, 2, 3]  # 'l' looks like '1'
    O = 0          # 'O' looks like '0'
    I = 1          # 'I' looks like '1'
    
    # F821: Undefined name
    return undefined_variable

# E302: Expected 2 blank lines
def trailing_whitespace():    # W291: Trailing whitespace
    x = 1   # W291: Trailing whitespace
    return x

# W292: No newline at end of file
if __name__ == "__main__":
    example = BadExample("John",25)
    print(example.get_info())
    
    # E225: Missing whitespace around operators
    if 1+1==2:
        print("Math works")
    
    # E722: Do not use bare 'except:'
    try:
        risky_operation()
    except:
        pass
    
    # F405: Name may be undefined due to star import
    from os import *
    print(environ)