
-- =========================================
-- 1. CREATE TABLE: Кестелер құру
-- =========================================

CREATE TABLE customers (
    customer_id INTEGER PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    phone VARCHAR(20) UNIQUE NOT NULL,
    address VARCHAR(255) NOT NULL
);

CREATE TABLE couriers (
    courier_id INTEGER PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    phone VARCHAR(20) UNIQUE NOT NULL
);

CREATE TABLE orders (
    order_id INTEGER PRIMARY KEY,
    customer_id INTEGER NOT NULL,
    courier_id INTEGER,
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    delivery_address VARCHAR(255) NOT NULL,
    status VARCHAR(20) DEFAULT 'New'
        CHECK (status IN
        ('New', 'Processing', 'Delivering', 'Delivered', 'Cancelled')),
    total_amount NUMERIC(10, 2) NOT NULL
        CHECK (total_amount >= 0),

    FOREIGN KEY (customer_id)
        REFERENCES customers(customer_id),

    FOREIGN KEY (courier_id)
        REFERENCES couriers(courier_id)
);

CREATE TABLE order_items (
    item_id INTEGER PRIMARY KEY,
    order_id INTEGER NOT NULL,
    product_name VARCHAR(100) NOT NULL,
    quantity INTEGER NOT NULL CHECK (quantity > 0),
    price NUMERIC(10, 2) NOT NULL CHECK (price >= 0),

    FOREIGN KEY (order_id)
        REFERENCES orders(order_id)
        ON DELETE CASCADE
);

CREATE TABLE payments (
    payment_id INTEGER PRIMARY KEY,
    order_id INTEGER NOT NULL UNIQUE,
    amount NUMERIC(10, 2) NOT NULL CHECK (amount >= 0),
    payment_method VARCHAR(20) NOT NULL
        CHECK (payment_method IN ('Cash', 'Card', 'Online')),
    payment_status VARCHAR(20) DEFAULT 'Pending'
        CHECK (payment_status IN ('Pending', 'Paid', 'Failed')),

    FOREIGN KEY (order_id)
        REFERENCES orders(order_id)
        ON DELETE CASCADE
);


-- =========================================
-- 2. INSERT: Мәліметтер енгізу
-- =========================================

INSERT INTO customers
(customer_id, full_name, phone, address)
VALUES
(1, 'Aruzhan Sadykova', '+77010000001', 'Almaty, Abay 10'),
(2, 'Dias Nurlybek', '+77010000002', 'Almaty, Satpayev 25'),
(3, 'Aigerim Bekova', '+77010000003', 'Almaty, Dostyk 15');

INSERT INTO couriers
(courier_id, full_name, phone)
VALUES
(1, 'Nurlan Askarov', '+77020000001'),
(2, 'Alikhan Serik', '+77020000002');

INSERT INTO orders
(order_id, customer_id, courier_id,
 delivery_address, status, total_amount)
VALUES
(1, 1, 1, 'Almaty, Abay 10', 'Delivered', 3500.00),
(2, 2, 2, 'Almaty, Satpayev 25', 'Processing', 5000.00),
(3, 3, NULL, 'Almaty, Dostyk 15', 'New', 1200.00);

INSERT INTO order_items
(item_id, order_id, product_name, quantity, price)
VALUES
(1, 1, 'Book', 1, 2000.00),
(2, 1, 'Notebook', 3, 500.00),
(3, 2, 'Headphones', 1, 5000.00),
(4, 3, 'Pen', 2, 600.00);

INSERT INTO payments
(payment_id, order_id, amount, payment_method, payment_status)
VALUES
(1, 1, 3500.00, 'Card', 'Paid'),
(2, 2, 5000.00, 'Online', 'Pending'),
(3, 3, 1200.00, 'Cash', 'Pending');


-- =========================================
-- 3. UPDATE: Мәліметтерді өзгерту
-- =========================================

UPDATE customers
SET address = 'Almaty, Abay 20'
WHERE customer_id = 1;

UPDATE orders
SET status = 'Delivering'
WHERE order_id = 2;

UPDATE payments
SET payment_status = 'Paid'
WHERE payment_id = 2;


-- =========================================
-- 4. DELETE: Мәліметтерді жою
-- =========================================

DELETE FROM order_items
WHERE item_id = 3;


-- =========================================
-- 5. SELECT: Нәтижелерді тексеру
-- =========================================

SELECT * FROM customers;
SELECT * FROM couriers;
SELECT * FROM orders;
SELECT * FROM order_items;
SELECT * FROM payments;

-- Клиенттер мен олардың тапсырыстарын байланыстырып көрсету
SELECT
    customers.full_name,
    orders.order_id,
    orders.status,
    orders.total_amount
FROM customers
JOIN orders
    ON customers.customer_id = orders.customer_id;
