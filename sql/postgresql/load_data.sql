-- E-Commerce Platform - Sample Data Loading Script
-- Created by: Sajid
-- Date: October 9, 2025
-- This script loads data from CSV files into the database

-- Note: Adjust file paths according to your system
-- When running from the repository root, relative paths work with \COPY.
-- Use absolute paths when executing from another directory or host.

-- =====================================
-- LOAD DATA FROM CSV FILES
-- =====================================

-- Load Categories
\COPY categories(category_id, category_name, description, parent_id, image_url, is_active, created_at) FROM 'datasets/categories.csv' WITH (FORMAT CSV, HEADER true);

-- Load Customers
\COPY customers(customer_id, first_name, last_name, email, phone, password_hash, date_of_birth, account_status, loyalty_points, total_spent, registration_date, last_login, created_at) FROM 'datasets/customers.csv' WITH (FORMAT CSV, HEADER true);

-- Load Products
\COPY products(product_id, product_name, sku, category_id, description, price, cost_price, stock_quantity, reorder_level, brand, weight_kg, dimensions, is_active, featured, average_rating, total_reviews, created_at) FROM 'datasets/products.csv' WITH (FORMAT CSV, HEADER true);

-- Load Product Images
\COPY product_images(image_id, product_id, image_url, alt_text, is_primary, display_order, created_at) FROM 'datasets/product_images.csv' WITH (FORMAT CSV, HEADER true);

-- Load Reviews
\COPY reviews(review_id, product_id, customer_id, rating, review_title, review_text, is_verified_purchase, helpful_count, created_at) FROM 'datasets/reviews.csv' WITH (FORMAT CSV, HEADER true);

-- Load Shipping Addresses
\COPY shipping_addresses(address_id, customer_id, address_type, recipient_name, street_address, city, state, postal_code, country, phone, is_default, created_at) FROM 'datasets/shipping_addresses.csv' WITH (FORMAT CSV, HEADER true);

-- Load Orders
\COPY orders(order_id, customer_id, order_date, order_status, subtotal, tax_amount, shipping_cost, total_amount, payment_method, shipping_address_id, tracking_number, estimated_delivery, actual_delivery, created_at) FROM 'datasets/orders.csv' WITH (FORMAT CSV, HEADER true);

-- Load Order Items
\COPY order_items(order_item_id, order_id, product_id, quantity, unit_price, discount_amount, subtotal, created_at) FROM 'datasets/order_items.csv' WITH (FORMAT CSV, HEADER true);

-- Load Cart Items
\COPY cart_items(cart_item_id, customer_id, product_id, quantity, added_at, updated_at) FROM 'datasets/cart_items.csv' WITH (FORMAT CSV, HEADER true);

-- Load Payment Transactions
\COPY payment_transactions(transaction_id, order_id, payment_method, transaction_amount, transaction_status, payment_gateway, gateway_transaction_id, card_last_four, transaction_date, created_at) FROM 'datasets/payment_transactions.csv' WITH (FORMAT CSV, HEADER true);

-- Load Audit Log
\COPY audit_log(log_id, table_name, operation, record_id, old_values, new_values, changed_by, changed_at) FROM 'datasets/audit_log.csv' WITH (FORMAT CSV, HEADER true);

-- =====================================
-- UPDATE SEQUENCES
-- =====================================

-- Update sequence values to match the loaded data
SELECT setval('categories_category_id_seq', COALESCE((SELECT MAX(category_id) FROM categories), 0));
SELECT setval('customers_customer_id_seq', COALESCE((SELECT MAX(customer_id) FROM customers), 0));
SELECT setval('products_product_id_seq', COALESCE((SELECT MAX(product_id) FROM products), 0));
SELECT setval('product_images_image_id_seq', COALESCE((SELECT MAX(image_id) FROM product_images), 0));
SELECT setval('reviews_review_id_seq', COALESCE((SELECT MAX(review_id) FROM reviews), 0));
SELECT setval('shipping_addresses_address_id_seq', COALESCE((SELECT MAX(address_id) FROM shipping_addresses), 0));
SELECT setval('orders_order_id_seq', COALESCE((SELECT MAX(order_id) FROM orders), 0));
SELECT setval('order_items_order_item_id_seq', COALESCE((SELECT MAX(order_item_id) FROM order_items), 0));
SELECT setval('cart_items_cart_item_id_seq', COALESCE((SELECT MAX(cart_item_id) FROM cart_items), 0));
SELECT setval('payment_transactions_transaction_id_seq', COALESCE((SELECT MAX(transaction_id) FROM payment_transactions), 0));
SELECT setval('audit_log_log_id_seq', COALESCE((SELECT MAX(log_id) FROM audit_log), 0));

-- =====================================
-- VERIFICATION QUERIES
-- =====================================

-- Verify data was loaded correctly
SELECT 'categories' AS table_name, COUNT(*) AS record_count FROM categories
UNION ALL
SELECT 'customers', COUNT(*) FROM customers
UNION ALL
SELECT 'products', COUNT(*) FROM products
UNION ALL
SELECT 'product_images', COUNT(*) FROM product_images
UNION ALL
SELECT 'reviews', COUNT(*) FROM reviews
UNION ALL
SELECT 'shipping_addresses', COUNT(*) FROM shipping_addresses
UNION ALL
SELECT 'orders', COUNT(*) FROM orders
UNION ALL
SELECT 'order_items', COUNT(*) FROM order_items
UNION ALL
SELECT 'cart_items', COUNT(*) FROM cart_items
UNION ALL
SELECT 'payment_transactions', COUNT(*) FROM payment_transactions
UNION ALL
SELECT 'audit_log', COUNT(*) FROM audit_log
ORDER BY table_name;

-- Verify foreign key relationships
SELECT 
    'Products without categories' AS check_name,
    COUNT(*) AS count
FROM products p
LEFT JOIN categories c ON p.category_id = c.category_id
WHERE c.category_id IS NULL

UNION ALL

SELECT 
    'Reviews from non-existent customers',
    COUNT(*)
FROM reviews r
LEFT JOIN customers cu ON r.customer_id = cu.customer_id
WHERE cu.customer_id IS NULL

UNION ALL

SELECT 
    'Orders without customers',
    COUNT(*)
FROM orders o
LEFT JOIN customers cu ON o.customer_id = cu.customer_id
WHERE cu.customer_id IS NULL;

-- Display summary statistics
SELECT 
    'Total Revenue' AS metric,
    TO_CHAR(SUM(total_amount), 'FM$999,999,999.00') AS value
FROM orders
WHERE order_status NOT IN ('Cancelled', 'Refunded')

UNION ALL

SELECT 
    'Total Orders',
    COUNT(*)::TEXT
FROM orders

UNION ALL

SELECT 
    'Active Customers',
    COUNT(*)::TEXT
FROM customers
WHERE account_status = 'Active'

UNION ALL

SELECT 
    'Products in Catalog',
    COUNT(*)::TEXT
FROM products
WHERE is_active = TRUE

UNION ALL

SELECT 
    'Average Rating',
    TO_CHAR(AVG(average_rating), 'FM9.99')
FROM products
WHERE average_rating IS NOT NULL;

\echo 'Data loading completed successfully!';
