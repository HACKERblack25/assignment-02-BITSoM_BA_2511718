## Anomaly Analysis

### Insert Anomaly
A new product cannot be inserted into the system unless an order exists for it. In the dataset, product information only appears along with order details such as order_id and customer data. This means a new product cannot be added independently without creating a dummy order entry.

### Update Anomaly
Customer details such as city are repeated across multiple rows. For example, the same customer (Neha Gupta) appears in multiple rows with repeated city information. If the customer’s city changes, all rows must be updated. If even one row is missed, it will lead to inconsistent data.
ROW A4 and A6 are the example of it.

### Delete Anomaly
If a row corresponding to an order is deleted, all related information such as customer details, product details, and sales representative data may also be lost. For example, if a customer has only one order and that row is deleted, all information about that customer is permanently removed from the system.


## Normalization Justification
Keeping everything in a single table may seem simpler at first, but it leads to serious issues such as data redundancy, update anomalies, and inconsistency. For example, if customer details like name and address are stored repeatedly with every order, any change in a customer’s address must be updated in multiple rows. If even one row is missed, the database becomes inconsistent.

In the given dataset, a customer can place multiple orders. If we store all order and customer information in one table, the same customer data would repeat across multiple rows. This not only wastes storage but also creates update and delete anomalies. For instance, deleting an order could unintentionally remove the only record of a customer if that customer has only one order in the system.

Normalization solves these issues by breaking the data into logical tables such as customers, orders, products, and order_items. This ensures that each piece of information is stored only once. For example, customer details are stored in the customers table and referenced using a customer_id in the orders table. This eliminates duplication and ensures consistency across the database.

Additionally, normalization improves data integrity and makes queries more efficient and meaningful. For example, calculating total sales or identifying top products becomes easier and more reliable when data is structured properly.

Therefore, while a single-table approach may appear simpler, normalization is essential for maintaining scalability, consistency, and data accuracy in real-world systems. It is not over-engineering but a necessary design principle for efficient database management.