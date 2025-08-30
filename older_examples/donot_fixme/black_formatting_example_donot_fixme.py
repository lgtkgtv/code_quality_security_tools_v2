#!/usr/bin/env python3
"""
BAD CODE EXAMPLE - Formatting Issues Fixed by Black
===================================================

This file demonstrates inconsistent formatting that black automatically fixes.
DO NOT FIX - This file is intentionally poorly formatted for educational purposes.

Run: black --diff black_formatting_example_donot_fixme.py (to see what would change)
Run: black black_formatting_example_donot_fixme.py (to actually format)
"""

# Inconsistent spacing around operators and commas
def calculate_total(items,tax_rate=0.1,discount= 0.05):
    # Inconsistent spacing around operators
    subtotal=0
    for item in items:
        price=item[ 'price' ]  # Inconsistent spacing in brackets
        quantity =item['quantity']
        subtotal+= price*quantity
    
    # Inconsistent line breaks and spacing
    tax=subtotal*tax_rate
    discount_amount   =   subtotal   *   discount
    total = subtotal+tax-discount_amount
    
    return total

# Inconsistent string quotes (mix of single and double)
class ProductManager:
    def __init__(self,products):
        self.products= products
        self.status ='active'
        self.version= "1.0"  # Mixed quotes
    
    # Inconsistent method formatting
    def find_product(self,product_id):
        for product in self.products:
            if product['id']==product_id:
                return product
        return None
    
    # Poor formatting of long function signatures
    def create_product(self,name,description,price,category,tags,in_stock,supplier_info):
        # Long dictionary formatting
        product = {'id':len(self.products)+1,'name':name,'description':description,'price':price,'category':category,'tags':tags,'in_stock':in_stock,'supplier':supplier_info,'created_at':'2024-01-01'}
        
        # Poor list formatting
        required_fields = ['name','price','category']
        
        # Poor conditional formatting
        if name and price and category and price>0:
            self.products.append(product)
            return product
        else:
            return None

    # Inconsistent spacing in complex expressions
    def calculate_inventory_value(self):
        total_value=sum([product['price']*product.get('quantity',0) for product in self.products if product['in_stock']])
        return total_value

# Poor function parameter formatting
def process_order(customer_id,items,shipping_address,billing_address,payment_method,special_instructions=None,priority='normal',gift_wrap=False):
    # Poor dictionary formatting
    order={'customer_id':customer_id,'items':items,'shipping':shipping_address,'billing':billing_address,'payment':payment_method,'instructions':special_instructions,'priority':priority,'gift_wrap':gift_wrap,'status':'pending','total':0}
    
    # Poor list comprehension formatting
    order_total=sum([item['price']*item['quantity'] for item in items])
    order['total']=order_total
    
    return order

# Poor formatting of nested data structures
configuration={
    'database':{'host':'localhost','port':5432,'name':'mydb','user':'admin','password':'secret'},
    'api':{'version':'v1','timeout':30,'retries':3,'endpoints':['users','products','orders']},
    'features':{'logging':True,'caching':False,'notifications':True}
}

# Poor lambda formatting
sort_by_price=lambda products:sorted(products,key=lambda p:p['price'])
filter_in_stock=lambda products:[p for p in products if p['in_stock']]

# Poor exception handling formatting
def risky_operation():
    try:
        result=dangerous_function()
        return result
    except Exception as e:
        print("Error occurred:",str(e))
        return None
    finally:
        cleanup()