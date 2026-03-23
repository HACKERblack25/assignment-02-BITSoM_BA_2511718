## Anomaly Analysis

### Insert Anomaly
A new product cannot be inserted into the system unless an order exists for it. In the dataset, product information only appears along with order details such as order_id and customer data. This means a new product cannot be added independently without creating a dummy order entry.

### Update Anomaly
Customer details such as city are repeated across multiple rows. For example, the same customer (Neha Gupta) appears in multiple rows with repeated city information. If the customer’s city changes, all rows must be updated. If even one row is missed, it will lead to inconsistent data.

### Delete Anomaly
If a row corresponding to an order is deleted, all related information such as customer details, product details, and sales representative data may also be lost. For example, if a customer has only one order and that row is deleted, all information about that customer is permanently removed from the system.