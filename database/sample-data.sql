PRAGMA foreign_keys = ON;

-- Test customers
INSERT INTO customers (id, name, email) VALUES
(1, 'Alice', 'alice@example.com'),
(2, 'Bob', 'bob@example.com'),
(3, 'Charlie', 'charlie@example.com'),
(4, 'Diana', 'diana@example.com');

-- Test products
INSERT INTO products (id, product_name, price, stock) VALUES
(1, 'Laptop', 1200, 5),
(2, 'Mouse', 25, 30),
(3, 'Keyboard', 75, 12),
(4, 'Monitor', 300, 8),
(5, 'Webcam', 150, 0);

-- Test orders
INSERT INTO orders (id, customer_id, product_id, quantity, total) VALUES
(101, 1, 2, 2, 50),
(102, 2, 3, 1, 75),
(103, 1, 4, 1, 300),
(104, 3, 1, 1, 1200),
(105, 2, 2, 3, 75);
