#!/usr/bin/env python3
"""
BAD CODE EXAMPLE - Formatting Issues Detected by black
======================================================

This file demonstrates inconsistent formatting that black will fix.
DO NOT FIX - This file is intentionally badly formatted for educational purposes.

Run: black --check --diff bad_example.py
"""

import os,sys
import   json
from typing import Dict,List,Tuple

# Inconsistent spacing and formatting
def badly_formatted_function(param1,param2,param3):
    if(param1>0and param2<10):
        result={'key1':param1,'key2':param2,'key3':param3}
        return result
    else:
        return None

class   BadlyFormattedClass:
    def __init__(   self,name,age,email   ):
        self.name=name
        self.age = age
        self.email    = email
    
    def get_data(self)->Dict[str,str]:
        return {'name':self.name,'age':str(self.age),'email':self.email}

# Bad string formatting
long_string="This is a very long string that should probably be broken up into multiple lines for better readability and maintainability"

# Bad list/dict formatting  
messy_list=[
1,2,3,4,5,6,7,8,9,10,11,12,13,14,15
]

messy_dict={
'key1':'value1','key2':'value2','key3':'value3','key4':'value4','key5':'value5'
}

# Bad function calls
result=badly_formatted_function(1,2,3)
print(result)

# Inconsistent quotes
mixed_quotes = 'This uses single quotes'
more_mixed = "This uses double quotes"
nested_quotes = 'This has "nested" quotes'

# Bad comprehensions
list_comp=[x*2for x in range(10)if x%2==0]
dict_comp={k:v*2for k,v in{'a':1,'b':2,'c':3}.items()if v>1}

# Bad lambda formatting
bad_lambda=lambda x,y:x+y if x>y else x-y

# Bad mathematical expressions
calculation=1+2*3/4-5+6*7/8-9+10
complex_calc=(  1 + 2  )*( 3 - 4 )/( 5 + 6 )

# Bad boolean operations
condition=True and False or True and not False

# Bad function definition with long parameters
def function_with_very_long_parameter_list(param1,param2,param3,param4,param5,param6,param7,param8):
    return param1+param2+param3+param4+param5+param6+param7+param8

# Bad multiline strings
multiline="""This is a
multiline string that
has inconsistent
    indentation and
formatting"""

# Bad exception handling
try:
    risky_operation()
except(ValueError,TypeError)as e:
    print("Error:",e)
except Exception as e:
    print("Unexpected error:",e)

def risky_operation():
    return 42/0

# Bad trailing commas and spacing
tuple_data=(
    'item1',
    'item2',
    'item3'
)

list_data=[
    'item1',
    'item2', 
    'item3'
]

# Bad function annotations
def annotated_function(param1:str,param2:int)->List[str]:
    return[param1]*param2

if __name__=="__main__":
    example=BadlyFormattedClass("John",25,"john@example.com")
    data=example.get_data()
    print(data)
    
    # More bad formatting
    if(len(data)>0):
        for key,value in data.items():
            print(f"{key}:{value}")
    
    result=annotated_function("test",3)
    print(result)