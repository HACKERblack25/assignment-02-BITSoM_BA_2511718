// OP1: insertMany() — insert all 3 documents from sample_documents.json
db.products.insertMany([
  {
    "category": "Electronics",
    "product_name": "UltraView 4K Monitor",
    "brand": "TechCorp",
    "price": 350.00,
    "specs": { "resolution": "3840x2160", "refresh_rate": "144Hz", "panel_type": "IPS", "voltage": "110-240V" },
    "warranty": { "duration_months": 24, "type": "Manufacturer Limited" }
  },
  {
    "category": "Clothing",
    "product_name": "Classic Denim Jacket",
    "brand": "UrbanStyle",
    "price": 85.00,
    "available_sizes": ["S", "M", "L", "XL"],
    "materials": [ { "type": "Cotton", "percentage": 98 }, { "type": "Elastane", "percentage": 2 } ],
    "care_instructions": "Machine wash cold, tumble dry low"
  },
  {
    "category": "Groceries",
    "product_name": "Organic Almond Milk",
    "brand": "NaturePure",
    "price": 4.50,
    "expiry_date": ISODate("2024-12-15T00:00:00Z"),
    "nutrition_facts": { "calories": 60, "total_fat": "2.5g", "sugar": "0g", "allergens": ["Tree Nuts"] },
    "storage": "Refrigerate after opening"
  }
]);

// OP2: find() — retrieve all Electronics products with price > 20000
// Note: Based on your sample data, the monitor is 350.00. This query follows the logic requested.
db.products.find({ 
  category: "Electronics", 
  price: { $gt: 20000 } 
});

// OP3: find() — retrieve all Groceries expiring before 2025-01-01
db.products.find({ 
  category: "Groceries", 
  expiry_date: { $lt: ISODate("2025-01-01T00:00:00Z") } 
});

// OP4: updateOne() — add a "discount_percent" field to a specific product
db.products.updateOne(
  { product_name: "UltraView 4K Monitor" }, 
  { $set: { "discount_percent": 15 } }
);

// OP5: createIndex() — create an index on category field and explain why
db.products.createIndex({ category: 1 });

