# app.py - Simple data generator for our pipeline
import json
import random
from datetime import datetime

def generate_sales_data():
    """Generates fake sales data"""
    products = ["Laptop", "Phone", "Tablet", "Monitor", "Keyboard"]
    
    data = {
        "product": random.choice(products),
        "quantity": random.randint(1, 5),
        "price": round(random.uniform(100, 1500), 2),
        "timestamp": datetime.now().isoformat(),
        "region": random.choice(["East", "West", "North", "South"])
    }
    
    print("✅ Generated sales data:")
    print(json.dumps(data, indent=2))
    return data

# Run it
if __name__ == "__main__":
    generate_sales_data()
