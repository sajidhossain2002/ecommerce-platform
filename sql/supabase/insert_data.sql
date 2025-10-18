-- =====================================================
-- E-Commerce Platform - Supabase Data Population Script
-- =====================================================
-- Purpose: Insert comprehensive sample data for all tables
-- Total Records: 339
-- Deployment: Supabase SQL Editor
-- Author: SAJID
-- Date: October 2025
-- =====================================================

-- Temporarily disable RLS for bulk data insertion
ALTER TABLE IF EXISTS categories DISABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS customers DISABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS products DISABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS product_images DISABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS shipping_addresses DISABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS cart_items DISABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS orders DISABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS order_items DISABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS payment_transactions DISABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS reviews DISABLE ROW LEVEL SECURITY;
ALTER TABLE IF EXISTS audit_log DISABLE ROW LEVEL SECURITY;

-- =====================================================
-- SECTION 1: CATEGORIES (15 records)
-- =====================================================
-- Hierarchical product categorization structure

INSERT INTO categories (category_id, category_name, description, parent_id, image_url, is_active, created_at) VALUES
(1, 'Electronics', 'Electronic devices and accessories', NULL, 'https://example.com/img/electronics.jpg', TRUE, '2024-01-15 10:00:00'),
(2, 'Computers & Laptops', 'Desktop computers and laptops', 1, 'https://example.com/img/computers.jpg', TRUE, '2024-01-15 10:05:00'),
(3, 'Smartphones & Tablets', 'Mobile devices and tablets', 1, 'https://example.com/img/smartphones.jpg', TRUE, '2024-01-15 10:10:00'),
(4, 'Audio & Headphones', 'Headphones and audio equipment', 1, 'https://example.com/img/audio.jpg', TRUE, '2024-01-15 10:15:00'),
(5, 'Fashion & Apparel', 'Clothing and accessories', NULL, 'https://example.com/img/fashion.jpg', TRUE, '2024-01-15 10:20:00'),
(6, 'Men''s Clothing', 'Men''s fashion items', 5, 'https://example.com/img/mens.jpg', TRUE, '2024-01-15 10:25:00'),
(7, 'Women''s Clothing', 'Women''s fashion items', 5, 'https://example.com/img/womens.jpg', TRUE, '2024-01-15 10:30:00'),
(8, 'Accessories', 'Fashion accessories', 5, 'https://example.com/img/accessories.jpg', TRUE, '2024-01-15 10:35:00'),
(9, 'Home & Garden', 'Home improvement and garden supplies', NULL, 'https://example.com/img/home.jpg', TRUE, '2024-01-15 10:40:00'),
(10, 'Furniture', 'Home and office furniture', 9, 'https://example.com/img/furniture.jpg', TRUE, '2024-01-15 10:45:00'),
(11, 'Kitchen & Dining', 'Kitchenware and dining items', 9, 'https://example.com/img/kitchen.jpg', TRUE, '2024-01-15 10:50:00'),
(12, 'Sports & Outdoors', 'Sports equipment and outdoor gear', NULL, 'https://example.com/img/sports.jpg', TRUE, '2024-01-15 10:55:00'),
(13, 'Books & Media', 'Books and entertainment media', NULL, 'https://example.com/img/books.jpg', TRUE, '2024-01-15 11:00:00'),
(14, 'Health & Beauty', 'Health and beauty products', NULL, 'https://example.com/img/health.jpg', TRUE, '2024-01-15 11:05:00'),
(15, 'Gaming', 'Video games and gaming accessories', 1, 'https://example.com/img/gaming.jpg', TRUE, '2024-01-15 11:10:00');

-- =====================================================
-- SECTION 2: CUSTOMERS (20 records)
-- =====================================================
-- Registered customer accounts with loyalty tracking

INSERT INTO customers (customer_id, first_name, last_name, email, phone, password_hash, date_of_birth, account_status, loyalty_points, total_spent, registration_date, last_login, created_at) VALUES
(1, 'Sarah', 'Johnson', 'sarah.johnson@gmail.com', '+1-617-555-0101', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/', '1990-05-15', 'Active', 2450, 3567.89, '2023-03-15', '2024-10-08 15:30:00', '2023-03-15 09:00:00'),
(2, 'Michael', 'Chen', 'michael.chen@outlook.com', '+1-857-555-0102', '$2b$12$KNv4d2zrCXWIylf1MIBlDPZa7UuuyNKrsI9/', '1985-08-22', 'Active', 1890, 2134.50, '2023-05-20', '2024-10-07 11:20:00', '2023-05-20 14:30:00'),
(3, 'Emily', 'Rodriguez', 'emily.rodriguez@yahoo.com', '+1-617-555-0103', '$2b$12$MQx5e3AsrDYXJzmg2NJCmEPbZ8VvvzOLstJ0/', '1995-11-30', 'Active', 3100, 4523.75, '2023-01-10', '2024-10-09 08:45:00', '2023-01-10 10:15:00'),
(4, 'David', 'Thompson', 'david.thompson@gmail.com', '+1-781-555-0104', '$2b$12$NRy6f4BtsEZYKzAnh3OKDnFQcZ9WwwAzPMtuK1/', '1988-03-07', 'Active', 1250, 1876.20, '2023-07-12', '2024-10-06 19:30:00', '2023-07-12 16:45:00'),
(5, 'Jessica', 'Martinez', 'jessica.martinez@hotmail.com', '+1-617-555-0105', '$2b$12$OSz7g5CutFAZLzBoi4PLEoGRdAaXxxBaPNuvL2/', '1992-09-18', 'Active', 890, 1245.60, '2023-09-05', '2024-10-08 12:15:00', '2023-09-05 11:00:00'),
(6, 'James', 'Wilson', 'james.wilson@gmail.com', '+1-857-555-0106', '$2b$12$PTa8h6DvuGBaMAcpj5QMFpHSeBbYyyCbQOvwM3/', '1987-12-25', 'Active', 2670, 3789.90, '2023-02-28', '2024-10-09 07:30:00', '2023-02-28 13:20:00'),
(7, 'Amanda', 'Taylor', 'amanda.taylor@yahoo.com', '+1-617-555-0107', '$2b$12$QUb9i7EwvHCbNBdqk6RNGqITfCcZzzDcRPwxN4/', '1993-06-14', 'Active', 1540, 2234.30, '2023-06-18', '2024-10-05 16:45:00', '2023-06-18 09:30:00'),
(8, 'Robert', 'Anderson', 'robert.anderson@outlook.com', '+1-781-555-0108', '$2b$12$RVc0j8FxwIDcOCerL7SOHrJUgDdAaaEdSQxyO5/', '1991-01-09', 'Active', 780, 987.50, '2023-08-22', '2024-10-07 14:20:00', '2023-08-22 15:10:00'),
(9, 'Maria', 'Garcia', 'maria.garcia@gmail.com', '+1-617-555-0109', '$2b$12$SWd1k9GyxJEdPDfsM8TPIsKVhEeBbbFeTPyzP6/', '1989-04-21', 'Inactive', 450, 678.40, '2023-04-07', '2024-08-15 10:30:00', '2023-04-07 12:00:00'),
(10, 'Christopher', 'Lee', 'christopher.lee@gmail.com', '+1-857-555-0110', '$2b$12$TXe2l0HzyKFeQEgtN9UQJtLWiFfCccGfUQzaQ7/', '1994-10-03', 'Active', 1920, 2567.80, '2023-05-14', '2024-10-08 18:00:00', '2023-05-14 10:45:00'),
(11, 'Jennifer', 'White', 'jennifer.white@yahoo.com', '+1-617-555-0111', '$2b$12$UYf3m1IazLGfRFhuO0VRKuMXjGgDddHgVRabR8/', '1986-07-28', 'Active', 3340, 4876.20, '2023-02-05', '2024-10-09 09:15:00', '2023-02-05 14:30:00'),
(12, 'Daniel', 'Harris', 'daniel.harris@hotmail.com', '+1-781-555-0112', '$2b$12$VZg4n2JbaMLgSGivP1WSLvNYkHhEeeIhWSbcS9/', '1990-02-16', 'Active', 1100, 1534.70, '2023-07-30', '2024-10-06 13:45:00', '2023-07-30 11:20:00'),
(13, 'Ashley', 'Clark', 'ashley.clark@gmail.com', '+1-617-555-0113', '$2b$12$Wah5o3KcbNMhTHjwQ2XTMwOZlIiEffJiXTcdT0/', '1996-12-05', 'Active', 2180, 3012.90, '2023-03-22', '2024-10-08 20:30:00', '2023-03-22 16:00:00'),
(14, 'Matthew', 'Lewis', 'matthew.lewis@outlook.com', '+1-857-555-0114', '$2b$12$Xbi6p4LdcOMiUIkxR3YUNxPamJjFggKjYUdeU1/', '1988-08-11', 'Active', 950, 1289.50, '2023-09-18', '2024-10-07 08:20:00', '2023-09-18 13:45:00'),
(15, 'Nicole', 'Walker', 'nicole.walker@gmail.com', '+1-617-555-0115', '$2b$12$Ycj7q5MedPNjVJlyS4ZVOyQbnKkGhhLkZVefV2/', '1991-05-27', 'Active', 1670, 2345.60, '2023-04-25', '2024-10-09 10:00:00', '2023-04-25 09:15:00'),
(16, 'Ryan', 'Hall', 'ryan.hall@yahoo.com', '+1-781-555-0116', '$2b$12$Zdk8r6NfePOkWKmzT5aWPzRcoLlHiiMlaWfgW3/', '1987-11-19', 'Suspended', 0, 0.00, '2023-06-08', '2024-09-20 15:00:00', '2023-06-08 10:30:00'),
(17, 'Lauren', 'Young', 'lauren.young@gmail.com', '+1-617-555-0117', '$2b$12$Ael9s7OgfQPlXLnAU6bXQaSdpMmIjjNmbXghX4/', '1995-03-02', 'Active', 2890, 3998.40, '2023-01-28', '2024-10-08 17:45:00', '2023-01-28 12:00:00'),
(18, 'Kevin', 'King', 'kevin.king@hotmail.com', '+1-857-555-0118', '$2b$12$Bfm0t8PhgRQmYMoBV7cYRbTequNnJkkOncYhiY5/', '1989-09-23', 'Active', 1430, 2087.30, '2023-08-05', '2024-10-06 11:30:00', '2023-08-05 14:20:00'),
(19, 'Stephanie', 'Wright', 'stephanie.wright@gmail.com', '+1-617-555-0119', '$2b$12$Cgn1u9QihSRnZNpCW8dZScUfvOoOllPodZijZ6/', '1993-01-14', 'Active', 760, 1045.80, '2023-10-12', '2024-10-09 13:20:00', '2023-10-12 15:45:00'),
(20, 'Brandon', 'Lopez', 'brandon.lopez@outlook.com', '+1-781-555-0120', '$2b$12$Dho2v0RjiTSoaOqDX9eaTdVgwPpPmmQpeakja7/', '1992-06-08', 'Active', 2340, 3234.50, '2023-03-08', '2024-10-07 09:50:00', '2023-03-08 11:30:00');

-- =====================================================
-- SECTION 3: PRODUCTS (30 records)
-- =====================================================
-- Product catalog with pricing and inventory

INSERT INTO products (product_id, product_name, sku, category_id, description, price, cost_price, stock_quantity, reorder_level, brand, weight_kg, dimensions, is_active, featured, average_rating, total_reviews, created_at) VALUES
(1, 'MacBook Pro 16-inch M3', 'APPLE-MBP16-M3-2024', 2, 'Professional laptop with M3 chip, 16GB RAM, 512GB SSD. Perfect for developers and creative professionals.', 2499.00, 1899.00, 45, 10, 'Apple', 2.15, '35.9 x 24.8 x 1.7 cm', TRUE, TRUE, 4.8, 234, '2024-02-01 09:00:00'),
(2, 'Dell XPS 15 9530', 'DELL-XPS15-9530', 2, 'High-performance laptop with Intel i7, 16GB RAM, 1TB SSD, NVIDIA RTX 4050 graphics card.', 1899.00, 1399.00, 32, 8, 'Dell', 1.92, '34.4 x 23.0 x 1.8 cm', TRUE, TRUE, 4.6, 187, '2024-02-05 10:30:00'),
(3, 'iPhone 15 Pro Max', 'APPLE-IP15PM-256', 3, 'Latest iPhone with A17 Pro chip, 256GB storage, advanced camera system, titanium design.', 1199.00, 849.00, 120, 30, 'Apple', 0.221, '16.0 x 7.7 x 0.8 cm', TRUE, TRUE, 4.9, 512, '2024-03-10 11:00:00'),
(4, 'Samsung Galaxy S24 Ultra', 'SAMS-S24U-512', 3, 'Premium Android phone with S Pen, 512GB storage, 200MP camera, AI features.', 1299.00, 929.00, 89, 25, 'Samsung', 0.232, '16.3 x 7.9 x 0.9 cm', TRUE, TRUE, 4.7, 389, '2024-03-15 14:20:00'),
(5, 'Sony WH-1000XM5', 'SONY-WH1000XM5-BLK', 4, 'Industry-leading noise canceling wireless headphones with 30-hour battery life.', 399.00, 249.00, 156, 40, 'Sony', 0.250, '25.4 x 22.0 x 9.9 cm', TRUE, TRUE, 4.8, 891, '2024-01-20 09:45:00'),
(6, 'Apple AirPods Pro 2nd Gen', 'APPLE-APP2-USB', 4, 'Premium wireless earbuds with active noise cancellation and spatial audio.', 249.00, 179.00, 234, 60, 'Apple', 0.050, '6.0 x 4.5 x 2.1 cm', TRUE, TRUE, 4.7, 1243, '2024-01-25 10:15:00'),
(7, 'Men''s Levi''s 501 Original Jeans', 'LEVIS-501-BLUE-32X32', 6, 'Classic straight fit jeans in original blue denim, button fly, 100% cotton.', 69.99, 32.00, 450, 100, 'Levi''s', 0.680, 'Standard fit', TRUE, FALSE, 4.5, 567, '2024-02-10 13:00:00'),
(8, 'Nike Air Max 90', 'NIKE-AM90-WHT-10', 6, 'Iconic running shoes with Max Air cushioning, leather and textile upper.', 129.99, 65.00, 280, 75, 'Nike', 0.850, 'Standard shoe box', TRUE, TRUE, 4.6, 734, '2024-02-15 15:30:00'),
(9, 'Women''s Zara Floral Summer Dress', 'ZARA-FSD-BLU-M', 7, 'Elegant floral print midi dress, 100% cotton, perfect for summer occasions.', 79.99, 38.00, 180, 50, 'Zara', 0.320, 'Packaged flat', TRUE, TRUE, 4.4, 298, '2024-03-05 11:45:00'),
(10, 'Adidas Ultraboost 22 Women''s', 'ADIDAS-UB22-BLK-8', 7, 'Premium running shoes with Boost cushioning and Primeknit upper.', 189.99, 95.00, 145, 40, 'Adidas', 0.760, 'Standard shoe box', TRUE, FALSE, 4.7, 456, '2024-03-20 10:00:00'),
(11, 'Ray-Ban Aviator Sunglasses', 'RAYBAN-AVI-GLD', 8, 'Classic aviator sunglasses with gold frame and green polarized lenses.', 169.99, 85.00, 210, 50, 'Ray-Ban', 0.035, 'Case included', TRUE, TRUE, 4.8, 621, '2024-02-20 14:15:00'),
(12, 'Michael Kors Leather Handbag', 'MK-LHBG-BRN', 8, 'Genuine leather handbag with signature MK logo, multiple compartments.', 349.99, 175.00, 67, 20, 'Michael Kors', 0.890, '35 x 28 x 12 cm', TRUE, TRUE, 4.6, 189, '2024-02-25 16:00:00'),
(13, 'IKEA POÄNG Armchair', 'IKEA-POANG-BIRCH', 10, 'Comfortable armchair with layer-glued bentwood frame and cotton cushion.', 129.00, 65.00, 95, 25, 'IKEA', 10.50, '68 x 82 x 100 cm', TRUE, FALSE, 4.5, 423, '2024-01-15 09:30:00'),
(14, 'Herman Miller Aeron Chair', 'HM-AERON-MED-BLK', 10, 'Ergonomic office chair with PostureFit support and breathable mesh.', 1395.00, 795.00, 28, 8, 'Herman Miller', 21.30, '66 x 63 x 99 cm', TRUE, TRUE, 4.9, 512, '2024-01-18 11:00:00'),
(15, 'Cuisinart 14-Cup Food Processor', 'CUIS-FP14-CHR', 11, 'Powerful 720-watt food processor with stainless steel blade and large capacity.', 199.00, 99.00, 78, 20, 'Cuisinart', 5.80, '28 x 18 x 36 cm', TRUE, FALSE, 4.7, 389, '2024-02-12 10:45:00'),
(16, 'KitchenAid Stand Mixer 5Qt', 'KA-SM5Q-RED', 11, 'Professional 5-quart stand mixer with 10 speeds and tilt-head design.', 449.00, 269.00, 54, 15, 'KitchenAid', 10.20, '35 x 22 x 36 cm', TRUE, TRUE, 4.9, 892, '2024-02-18 13:20:00'),
(17, 'PlayStation 5 Console', 'SONY-PS5-DISC', 15, 'Next-gen gaming console with 4K gaming, 825GB SSD, DualSense controller.', 499.00, 399.00, 67, 20, 'Sony', 4.50, '39 x 26 x 10 cm', TRUE, TRUE, 4.8, 1567, '2024-01-22 15:00:00'),
(18, 'Nintendo Switch OLED', 'NINTENDO-SW-OLED', 15, 'Handheld gaming console with 7-inch OLED screen and enhanced audio.', 349.00, 279.00, 112, 30, 'Nintendo', 0.320, '24 x 10 x 14 cm', TRUE, TRUE, 4.7, 923, '2024-01-28 14:30:00'),
(19, 'The Midnight Library - Hardcover', 'BOOK-TML-HC', 13, 'Bestselling novel by Matt Haig about infinite possibilities and second chances.', 26.99, 12.00, 340, 80, 'Viking Press', 0.520, '24 x 16 x 3 cm', TRUE, FALSE, 4.6, 2341, '2024-01-10 09:00:00'),
(20, 'Atomic Habits by James Clear', 'BOOK-AH-HC', 13, 'Practical guide to building good habits and breaking bad ones.', 27.99, 13.00, 456, 100, 'Avery', 0.490, '24 x 16 x 3 cm', TRUE, TRUE, 4.9, 5678, '2024-01-12 10:30:00'),
(21, 'Fitbit Charge 6', 'FITBIT-C6-BLK', 14, 'Advanced fitness tracker with heart rate monitoring and GPS.', 159.00, 99.00, 189, 45, 'Fitbit', 0.029, '3.7 x 2.3 x 1.1 cm', TRUE, TRUE, 4.5, 734, '2024-03-01 11:15:00'),
(22, 'Neutrogena Hydro Boost Set', 'NEUTRO-HB-SET', 14, 'Complete skincare set with hyaluronic acid for deep hydration.', 39.99, 18.00, 267, 70, 'Neutrogena', 0.450, 'Standard packaging', TRUE, FALSE, 4.6, 456, '2024-03-05 13:45:00'),
(23, 'Wilson Evolution Basketball', 'WILSON-EVO-BBALL', 12, 'Official size basketball with moisture-wicking composite leather.', 64.99, 32.00, 145, 40, 'Wilson', 0.620, 'Boxed', TRUE, FALSE, 4.8, 891, '2024-02-08 10:00:00'),
(24, 'Yeti Rambler 30oz Tumbler', 'YETI-RAMB30-SS', 12, 'Insulated stainless steel tumbler keeps drinks cold for 24 hours.', 37.99, 19.00, 298, 75, 'Yeti', 0.340, '20 x 9 x 9 cm', TRUE, TRUE, 4.7, 1234, '2024-02-14 15:20:00'),
(25, 'Canon EOS R6 Mark II Body', 'CANON-R6M2-BODY', 1, 'Professional mirrorless camera with 24MP sensor and advanced autofocus.', 2499.00, 1899.00, 23, 6, 'Canon', 0.588, '13.8 x 9.8 x 8.8 cm', TRUE, TRUE, 4.9, 178, '2024-03-22 09:45:00'),
(26, 'Bose SoundLink Flex', 'BOSE-SLF-BLU', 4, 'Portable Bluetooth speaker with waterproof design and 12-hour battery.', 149.00, 89.00, 167, 45, 'Bose', 0.590, '20 x 9 x 5 cm', TRUE, FALSE, 4.6, 567, '2024-03-12 14:00:00'),
(27, 'Samsung 65-inch QLED 4K TV', 'SAMS-Q70C-65', 1, 'Smart TV with Quantum Dot technology, HDR10+, and 120Hz refresh rate.', 1299.00, 899.00, 34, 10, 'Samsung', 23.40, '144 x 83 x 6 cm', TRUE, TRUE, 4.7, 423, '2024-01-30 11:30:00'),
(28, 'Dyson V15 Detect Cordless', 'DYSON-V15-CORD', 9, 'Cordless vacuum with laser detection and advanced filtration system.', 749.00, 499.00, 56, 15, 'Dyson', 3.05, '125 x 25 x 25 cm', TRUE, TRUE, 4.8, 678, '2024-02-22 10:15:00'),
(29, 'Ninja Foodi 8-Qt Air Fryer', 'NINJA-AF8-BLK', 11, 'Multi-functional air fryer with 8-quart capacity and 8 cooking functions.', 179.00, 99.00, 89, 25, 'Ninja', 7.25, '32 x 38 x 33 cm', TRUE, FALSE, 4.7, 892, '2024-02-28 13:00:00'),
(30, 'Instant Pot Duo 7-in-1', 'INSTANT-DUO-6Q', 11, 'Multi-cooker: pressure cooker, slow cooker, rice cooker, and more.', 99.00, 59.00, 234, 60, 'Instant Pot', 5.80, '32 x 31 x 32 cm', TRUE, TRUE, 4.8, 3456, '2024-01-16 09:30:00');

-- =====================================================
-- SECTION 4: PRODUCT_IMAGES (44 records)
-- =====================================================
-- Product photography for catalog display

INSERT INTO product_images (image_id, product_id, image_url, alt_text, is_primary, display_order, created_at) VALUES
(1, 1, 'https://example.com/products/macbook-pro-16-main.jpg', 'MacBook Pro 16-inch M3 - Front View', TRUE, 1, '2024-02-01 09:00:00'),
(2, 1, 'https://example.com/products/macbook-pro-16-side.jpg', 'MacBook Pro 16-inch M3 - Side View', FALSE, 2, '2024-02-01 09:00:00'),
(3, 1, 'https://example.com/products/macbook-pro-16-keyboard.jpg', 'MacBook Pro 16-inch M3 - Keyboard Detail', FALSE, 3, '2024-02-01 09:00:00'),
(4, 2, 'https://example.com/products/dell-xps15-main.jpg', 'Dell XPS 15 9530 - Main Image', TRUE, 1, '2024-02-05 10:30:00'),
(5, 2, 'https://example.com/products/dell-xps15-display.jpg', 'Dell XPS 15 9530 - Display', FALSE, 2, '2024-02-05 10:30:00'),
(6, 3, 'https://example.com/products/iphone15pro-titanium.jpg', 'iPhone 15 Pro Max - Titanium Finish', TRUE, 1, '2024-03-10 11:00:00'),
(7, 3, 'https://example.com/products/iphone15pro-camera.jpg', 'iPhone 15 Pro Max - Camera System', FALSE, 2, '2024-03-10 11:00:00'),
(8, 3, 'https://example.com/products/iphone15pro-back.jpg', 'iPhone 15 Pro Max - Back View', FALSE, 3, '2024-03-10 11:00:00'),
(9, 4, 'https://example.com/products/galaxy-s24-ultra-main.jpg', 'Samsung Galaxy S24 Ultra - Main', TRUE, 1, '2024-03-15 14:20:00'),
(10, 4, 'https://example.com/products/galaxy-s24-ultra-spen.jpg', 'Samsung Galaxy S24 Ultra with S Pen', FALSE, 2, '2024-03-15 14:20:00'),
(11, 5, 'https://example.com/products/sony-wh1000xm5-black.jpg', 'Sony WH-1000XM5 Black Headphones', TRUE, 1, '2024-01-20 09:45:00'),
(12, 5, 'https://example.com/products/sony-wh1000xm5-side.jpg', 'Sony WH-1000XM5 Side View', FALSE, 2, '2024-01-20 09:45:00'),
(13, 6, 'https://example.com/products/airpods-pro-2-case.jpg', 'AirPods Pro 2nd Gen with Case', TRUE, 1, '2024-01-25 10:15:00'),
(14, 6, 'https://example.com/products/airpods-pro-2-ear.jpg', 'AirPods Pro 2nd Gen - Earbuds', FALSE, 2, '2024-01-25 10:15:00'),
(15, 7, 'https://example.com/products/levis-501-blue-front.jpg', 'Levi''s 501 Original Blue Jeans Front', TRUE, 1, '2024-02-10 13:00:00'),
(16, 7, 'https://example.com/products/levis-501-blue-back.jpg', 'Levi''s 501 Original Blue Jeans Back', FALSE, 2, '2024-02-10 13:00:00'),
(17, 8, 'https://example.com/products/nike-airmax90-white.jpg', 'Nike Air Max 90 White', TRUE, 1, '2024-02-15 15:30:00'),
(18, 8, 'https://example.com/products/nike-airmax90-side.jpg', 'Nike Air Max 90 Side Profile', FALSE, 2, '2024-02-15 15:30:00'),
(19, 9, 'https://example.com/products/zara-dress-floral.jpg', 'Zara Floral Summer Dress', TRUE, 1, '2024-03-05 11:45:00'),
(20, 10, 'https://example.com/products/adidas-ultraboost-22.jpg', 'Adidas Ultraboost 22 Women''s Black', TRUE, 1, '2024-03-20 10:00:00'),
(21, 11, 'https://example.com/products/rayban-aviator-gold.jpg', 'Ray-Ban Aviator Gold Frame', TRUE, 1, '2024-02-20 14:15:00'),
(22, 12, 'https://example.com/products/mk-handbag-brown.jpg', 'Michael Kors Leather Handbag Brown', TRUE, 1, '2024-02-25 16:00:00'),
(23, 13, 'https://example.com/products/ikea-poang-birch.jpg', 'IKEA POÄNG Armchair Birch', TRUE, 1, '2024-01-15 09:30:00'),
(24, 14, 'https://example.com/products/aeron-chair-black.jpg', 'Herman Miller Aeron Chair Black', TRUE, 1, '2024-01-18 11:00:00'),
(25, 14, 'https://example.com/products/aeron-chair-detail.jpg', 'Herman Miller Aeron Chair Details', FALSE, 2, '2024-01-18 11:00:00'),
(26, 15, 'https://example.com/products/cuisinart-processor.jpg', 'Cuisinart Food Processor', TRUE, 1, '2024-02-12 10:45:00'),
(27, 16, 'https://example.com/products/kitchenaid-mixer-red.jpg', 'KitchenAid Stand Mixer Red', TRUE, 1, '2024-02-18 13:20:00'),
(28, 16, 'https://example.com/products/kitchenaid-mixer-action.jpg', 'KitchenAid Stand Mixer In Use', FALSE, 2, '2024-02-18 13:20:00'),
(29, 17, 'https://example.com/products/ps5-console-main.jpg', 'PlayStation 5 Console', TRUE, 1, '2024-01-22 15:00:00'),
(30, 17, 'https://example.com/products/ps5-controller.jpg', 'PlayStation 5 DualSense Controller', FALSE, 2, '2024-01-22 15:00:00'),
(31, 18, 'https://example.com/products/switch-oled-main.jpg', 'Nintendo Switch OLED', TRUE, 1, '2024-01-28 14:30:00'),
(32, 19, 'https://example.com/products/midnight-library-cover.jpg', 'The Midnight Library Book Cover', TRUE, 1, '2024-01-10 09:00:00'),
(33, 20, 'https://example.com/products/atomic-habits-cover.jpg', 'Atomic Habits Book Cover', TRUE, 1, '2024-01-12 10:30:00'),
(34, 21, 'https://example.com/products/fitbit-charge6-black.jpg', 'Fitbit Charge 6 Black', TRUE, 1, '2024-03-01 11:15:00'),
(35, 22, 'https://example.com/products/neutrogena-hydroboost.jpg', 'Neutrogena Hydro Boost Set', TRUE, 1, '2024-03-05 13:45:00'),
(36, 23, 'https://example.com/products/wilson-basketball.jpg', 'Wilson Evolution Basketball', TRUE, 1, '2024-02-08 10:00:00'),
(37, 24, 'https://example.com/products/yeti-tumbler-steel.jpg', 'Yeti Rambler 30oz Tumbler', TRUE, 1, '2024-02-14 15:20:00'),
(38, 25, 'https://example.com/products/canon-r6m2-body.jpg', 'Canon EOS R6 Mark II Camera Body', TRUE, 1, '2024-03-22 09:45:00'),
(39, 25, 'https://example.com/products/canon-r6m2-sensor.jpg', 'Canon EOS R6 Mark II Sensor', FALSE, 2, '2024-03-22 09:45:00'),
(40, 26, 'https://example.com/products/bose-soundlink-blue.jpg', 'Bose SoundLink Flex Blue', TRUE, 1, '2024-03-12 14:00:00'),
(41, 27, 'https://example.com/products/samsung-qled-65.jpg', 'Samsung 65-inch QLED TV', TRUE, 1, '2024-01-30 11:30:00'),
(42, 28, 'https://example.com/products/dyson-v15-main.jpg', 'Dyson V15 Detect Cordless', TRUE, 1, '2024-02-22 10:15:00'),
(43, 29, 'https://example.com/products/ninja-airfryer-8qt.jpg', 'Ninja Foodi 8-Qt Air Fryer', TRUE, 1, '2024-02-28 13:00:00'),
(44, 30, 'https://example.com/products/instant-pot-duo.jpg', 'Instant Pot Duo 7-in-1', TRUE, 1, '2024-01-16 09:30:00');

-- =====================================================
-- SECTION 5: SHIPPING_ADDRESSES (25 records)
-- =====================================================
-- Customer delivery locations

INSERT INTO shipping_addresses (address_id, customer_id, address_type, recipient_name, street_address, city, state, postal_code, country, phone, is_default, created_at) VALUES
(1, 1, 'Home', 'Sarah Johnson', '123 Harvard Street', 'Cambridge', 'MA', '02138', 'USA', '+1-617-555-0101', TRUE, '2023-03-15 09:00:00'),
(2, 2, 'Home', 'Michael Chen', '456 Commonwealth Ave', 'Boston', 'MA', '02215', 'USA', '+1-857-555-0102', TRUE, '2023-05-20 14:30:00'),
(3, 3, 'Home', 'Emily Rodriguez', '789 Beacon Street', 'Boston', 'MA', '02215', 'USA', '+1-617-555-0103', TRUE, '2023-01-10 10:15:00'),
(4, 4, 'Home', 'David Thompson', '321 Newbury Street', 'Boston', 'MA', '02116', 'USA', '+1-781-555-0104', TRUE, '2023-07-12 16:45:00'),
(5, 5, 'Home', 'Jessica Martinez', '654 Boylston Street', 'Boston', 'MA', '02116', 'USA', '+1-617-555-0105', TRUE, '2023-09-05 11:00:00'),
(6, 6, 'Home', 'James Wilson', '987 Memorial Drive', 'Cambridge', 'MA', '02139', 'USA', '+1-857-555-0106', TRUE, '2023-02-28 13:20:00'),
(7, 7, 'Home', 'Amanda Taylor', '147 Mass Ave', 'Cambridge', 'MA', '02139', 'USA', '+1-617-555-0107', TRUE, '2023-06-18 09:30:00'),
(8, 8, 'Home', 'Robert Anderson', '258 Huntington Ave', 'Boston', 'MA', '02115', 'USA', '+1-781-555-0108', TRUE, '2023-08-22 15:10:00'),
(9, 9, 'Home', 'Maria Garcia', '369 Tremont Street', 'Boston', 'MA', '02116', 'USA', '+1-617-555-0109', TRUE, '2023-04-07 12:00:00'),
(10, 10, 'Home', 'Christopher Lee', '741 Washington Street', 'Boston', 'MA', '02111', 'USA', '+1-857-555-0110', TRUE, '2023-05-14 10:45:00'),
(11, 11, 'Home', 'Jennifer White', '852 Cambridge Street', 'Cambridge', 'MA', '02141', 'USA', '+1-617-555-0111', TRUE, '2023-02-05 14:30:00'),
(12, 12, 'Home', 'Daniel Harris', '963 Brighton Ave', 'Allston', 'MA', '02134', 'USA', '+1-781-555-0112', TRUE, '2023-07-30 11:20:00'),
(13, 13, 'Home', 'Ashley Clark', '159 Park Drive', 'Boston', 'MA', '02215', 'USA', '+1-617-555-0113', TRUE, '2023-03-22 16:00:00'),
(14, 14, 'Home', 'Matthew Lewis', '357 Longwood Ave', 'Boston', 'MA', '02115', 'USA', '+1-857-555-0114', TRUE, '2023-09-18 13:45:00'),
(15, 15, 'Home', 'Nicole Walker', '486 Summer Street', 'Boston', 'MA', '02210', 'USA', '+1-617-555-0115', TRUE, '2023-04-25 09:15:00'),
(16, 16, 'Home', 'Ryan Hall', '753 Atlantic Ave', 'Boston', 'MA', '02110', 'USA', '+1-781-555-0116', TRUE, '2023-06-08 10:30:00'),
(17, 17, 'Home', 'Lauren Young', '864 Charles Street', 'Boston', 'MA', '02114', 'USA', '+1-617-555-0117', TRUE, '2023-01-28 12:00:00'),
(18, 18, 'Home', 'Kevin King', '975 Brookline Ave', 'Brookline', 'MA', '02215', 'USA', '+1-857-555-0118', TRUE, '2023-08-05 14:20:00'),
(19, 19, 'Home', 'Stephanie Wright', '246 Main Street', 'Cambridge', 'MA', '02142', 'USA', '+1-617-555-0119', TRUE, '2023-10-12 15:45:00'),
(20, 20, 'Home', 'Brandon Lopez', '135 State Street', 'Boston', 'MA', '02109', 'USA', '+1-781-555-0120', TRUE, '2023-03-08 11:30:00'),
(21, 1, 'Work', 'Sarah Johnson', 'MIT Building 32', 'Cambridge', 'MA', '02139', 'USA', '+1-617-555-0199', FALSE, '2023-04-20 10:00:00'),
(22, 3, 'Work', 'Emily Rodriguez', 'Harvard Business School', 'Boston', 'MA', '02163', 'USA', '+1-617-555-0198', FALSE, '2023-02-15 14:30:00'),
(23, 6, 'Work', 'James Wilson', 'Boston University', 'Boston', 'MA', '02215', 'USA', '+1-857-555-0197', FALSE, '2023-03-10 11:45:00'),
(24, 11, 'Work', 'Jennifer White', 'Northeastern University', 'Boston', 'MA', '02115', 'USA', '+1-617-555-0196', FALSE, '2023-03-01 09:20:00'),
(25, 17, 'Work', 'Lauren Young', 'Tufts University', 'Medford', 'MA', '02155', 'USA', '+1-617-555-0195', FALSE, '2023-02-10 13:00:00');

-- =====================================================
-- SECTION 6: CART_ITEMS (11 records)
-- =====================================================
-- Active shopping cart contents

INSERT INTO cart_items (cart_id, customer_id, product_id, quantity, added_at) VALUES
(1, 2, 27, 1, '2024-10-01 14:30:00'),
(2, 5, 21, 1, '2024-10-02 10:15:00'),
(3, 8, 29, 1, '2024-10-03 16:45:00'),
(4, 10, 30, 2, '2024-10-04 11:20:00'),
(5, 12, 11, 1, '2024-10-05 09:00:00'),
(6, 14, 23, 1, '2024-10-05 13:30:00'),
(7, 15, 4, 1, '2024-10-06 15:00:00'),
(8, 17, 24, 2, '2024-10-07 10:45:00'),
(9, 19, 22, 1, '2024-10-08 14:15:00'),
(10, 20, 7, 2, '2024-10-09 11:30:00'),
(11, 3, 26, 1, '2024-10-09 16:00:00');

-- =====================================================
-- SECTION 7: ORDERS (40 records)
-- =====================================================
-- Customer purchase orders with tracking

INSERT INTO orders (order_id, customer_id, order_date, order_status, subtotal, tax_amount, shipping_cost, total_amount, payment_method, shipping_address_id, tracking_number, estimated_delivery, actual_delivery, created_at) VALUES
(1, 1, '2024-04-10', 'Delivered', 2499.00, 199.92, 0.00, 2698.92, 'Credit Card', 1, 'TRK1001234567890', '2024-04-15', '2024-04-14', '2024-04-10 10:30:00'),
(2, 2, '2024-04-12', 'Delivered', 1198.00, 95.84, 15.99, 1309.83, 'PayPal', 2, 'TRK1001234567891', '2024-04-17', '2024-04-16', '2024-04-12 14:20:00'),
(3, 3, '2024-04-15', 'Delivered', 648.00, 51.84, 0.00, 699.84, 'Credit Card', 3, 'TRK1001234567892', '2024-04-20', '2024-04-19', '2024-04-15 09:15:00'),
(4, 4, '2024-04-18', 'Delivered', 129.99, 10.40, 8.99, 149.38, 'Debit Card', 4, 'TRK1001234567893', '2024-04-23', '2024-04-22', '2024-04-18 11:45:00'),
(5, 5, '2024-04-20', 'Delivered', 79.99, 6.40, 5.99, 92.38, 'Credit Card', 5, 'TRK1001234567894', '2024-04-25', '2024-04-24', '2024-04-20 15:30:00'),
(6, 6, '2024-04-22', 'Delivered', 2898.00, 231.84, 0.00, 3129.84, 'Credit Card', 6, 'TRK1001234567895', '2024-04-27', '2024-04-26', '2024-04-22 10:00:00'),
(7, 7, '2024-04-25', 'Delivered', 1899.00, 151.92, 0.00, 2050.92, 'PayPal', 7, 'TRK1001234567896', '2024-04-30', '2024-04-29', '2024-04-25 13:15:00'),
(8, 8, '2024-04-28', 'Delivered', 349.99, 28.00, 12.99, 390.98, 'Credit Card', 8, 'TRK1001234567897', '2024-05-03', '2024-05-02', '2024-04-28 16:45:00'),
(9, 10, '2024-05-02', 'Delivered', 819.98, 65.60, 0.00, 885.58, 'Credit Card', 10, 'TRK1001234567898', '2024-05-07', '2024-05-06', '2024-05-02 09:30:00'),
(10, 11, '2024-05-05', 'Delivered', 1395.00, 111.60, 0.00, 1506.60, 'Credit Card', 11, 'TRK1001234567899', '2024-05-10', '2024-05-09', '2024-05-05 14:00:00'),
(11, 12, '2024-05-08', 'Delivered', 199.00, 15.92, 9.99, 224.91, 'Debit Card', 12, 'TRK1001234567900', '2024-05-13', '2024-05-12', '2024-05-08 11:20:00'),
(12, 13, '2024-05-12', 'Delivered', 2897.99, 231.84, 0.00, 3129.83, 'Credit Card', 13, 'TRK1001234567901', '2024-05-17', '2024-05-16', '2024-05-12 10:45:00'),
(13, 14, '2024-05-15', 'Delivered', 349.00, 27.92, 0.00, 376.92, 'PayPal', 14, 'TRK1001234567902', '2024-05-20', '2024-05-19', '2024-05-15 15:30:00'),
(14, 15, '2024-05-18', 'Delivered', 498.00, 39.84, 19.99, 557.83, 'Credit Card', 15, 'TRK1001234567903', '2024-05-23', '2024-05-22', '2024-05-18 13:00:00'),
(15, 17, '2024-05-22', 'Delivered', 1199.00, 95.92, 0.00, 1294.92, 'Credit Card', 17, 'TRK1001234567904', '2024-05-27', '2024-05-26', '2024-05-22 09:45:00'),
(16, 18, '2024-05-25', 'Delivered', 169.99, 13.60, 7.99, 191.58, 'Debit Card', 18, 'TRK1001234567905', '2024-05-30', '2024-05-29', '2024-05-25 16:15:00'),
(17, 19, '2024-05-28', 'Delivered', 159.00, 12.72, 8.99, 180.71, 'Credit Card', 19, 'TRK1001234567906', '2024-06-02', '2024-06-01', '2024-05-28 11:30:00'),
(18, 20, '2024-06-01', 'Delivered', 1299.00, 103.92, 0.00, 1402.92, 'PayPal', 20, 'TRK1001234567907', '2024-06-06', '2024-06-05', '2024-06-01 14:20:00'),
(19, 1, '2024-06-05', 'Delivered', 399.00, 31.92, 0.00, 430.92, 'Credit Card', 1, 'TRK1001234567908', '2024-06-10', '2024-06-09', '2024-06-05 10:00:00'),
(20, 2, '2024-06-08', 'Delivered', 249.00, 19.92, 5.99, 274.91, 'Credit Card', 2, 'TRK1001234567909', '2024-06-13', '2024-06-12', '2024-06-08 15:45:00'),
(21, 3, '2024-06-12', 'Delivered', 449.00, 35.92, 0.00, 484.92, 'Credit Card', 3, 'TRK1001234567910', '2024-06-17', '2024-06-16', '2024-06-12 09:30:00'),
(22, 6, '2024-06-15', 'Delivered', 648.00, 51.84, 0.00, 699.84, 'PayPal', 6, 'TRK1001234567911', '2024-06-20', '2024-06-19', '2024-06-15 13:15:00'),
(23, 7, '2024-06-18', 'Delivered', 27.99, 2.24, 4.99, 35.22, 'Credit Card', 7, 'TRK1001234567912', '2024-06-23', '2024-06-22', '2024-06-18 11:00:00'),
(24, 10, '2024-06-22', 'Delivered', 189.99, 15.20, 7.99, 213.18, 'Debit Card', 10, 'TRK1001234567913', '2024-06-27', '2024-06-26', '2024-06-22 14:30:00'),
(25, 11, '2024-06-25', 'Delivered', 749.00, 59.92, 0.00, 808.92, 'Credit Card', 11, 'TRK1001234567914', '2024-06-30', '2024-06-29', '2024-06-25 10:15:00'),
(26, 13, '2024-06-28', 'Delivered', 1299.00, 103.92, 0.00, 1402.92, 'Credit Card', 13, 'TRK1001234567915', '2024-07-03', '2024-07-02', '2024-06-28 15:00:00'),
(27, 15, '2024-07-02', 'Delivered', 498.00, 39.84, 19.99, 557.83, 'PayPal', 15, 'TRK1001234567916', '2024-07-07', '2024-07-06', '2024-07-02 09:45:00'),
(28, 17, '2024-07-05', 'Delivered', 2499.00, 199.92, 0.00, 2698.92, 'Credit Card', 17, 'TRK1001234567917', '2024-07-10', '2024-07-09', '2024-07-05 13:20:00'),
(29, 20, '2024-07-08', 'Delivered', 179.00, 14.32, 9.99, 203.31, 'Credit Card', 20, 'TRK1001234567918', '2024-07-13', '2024-07-12', '2024-07-08 11:45:00'),
(30, 1, '2024-07-12', 'Delivered', 54.98, 4.40, 0.00, 59.38, 'Credit Card', 1, 'TRK1001234567919', '2024-07-17', '2024-07-16', '2024-07-12 16:00:00'),
(31, 3, '2024-07-15', 'Delivered', 99.00, 7.92, 6.99, 113.91, 'Debit Card', 3, 'TRK1001234567920', '2024-07-20', '2024-07-19', '2024-07-15 10:30:00'),
(32, 6, '2024-07-18', 'Delivered', 339.98, 27.20, 0.00, 367.18, 'Credit Card', 6, 'TRK1001234567921', '2024-07-23', '2024-07-22', '2024-07-18 14:15:00'),
(33, 11, '2024-07-22', 'Delivered', 399.00, 31.92, 0.00, 430.92, 'PayPal', 11, 'TRK1001234567922', '2024-07-27', '2024-07-26', '2024-07-22 09:00:00'),
(34, 13, '2024-07-25', 'Delivered', 64.99, 5.20, 5.99, 76.18, 'Credit Card', 13, 'TRK1001234567923', '2024-07-30', '2024-07-29', '2024-07-25 15:45:00'),
(35, 2, '2024-08-01', 'Shipped', 499.00, 39.92, 0.00, 538.92, 'Credit Card', 2, 'TRK1001234567924', '2024-08-06', NULL, '2024-08-01 10:20:00'),
(36, 10, '2024-08-05', 'Processing', 149.00, 11.92, 8.99, 169.91, 'PayPal', 10, NULL, '2024-08-10', NULL, '2024-08-05 13:30:00'),
(37, 15, '2024-08-08', 'Shipped', 37.99, 3.04, 4.99, 46.02, 'Debit Card', 15, 'TRK1001234567925', '2024-08-13', NULL, '2024-08-08 11:15:00'),
(38, 20, '2024-09-15', 'Delivered', 848.00, 67.84, 0.00, 915.84, 'Credit Card', 20, 'TRK1001234567926', '2024-09-20', '2024-09-19', '2024-09-15 14:00:00'),
(39, 5, '2024-09-20', 'Delivered', 129.00, 10.32, 8.99, 148.31, 'Credit Card', 5, 'TRK1001234567927', '2024-09-25', '2024-09-24', '2024-09-20 10:45:00'),
(40, 7, '2024-09-25', 'Delivered', 26.99, 2.16, 4.99, 34.14, 'PayPal', 7, 'TRK1001234567928', '2024-09-30', '2024-09-29', '2024-09-25 15:20:00');

-- =====================================================
-- SECTION 8: ORDER_ITEMS (48 records)
-- =====================================================
-- Line items for each order

INSERT INTO order_items (order_item_id, order_id, product_id, quantity, unit_price, discount_amount, subtotal, created_at) VALUES
(1, 1, 1, 1, 2499.00, 0.00, 2499.00, '2024-04-10 10:30:00'),
(2, 2, 3, 1, 1199.00, 0.00, 1199.00, '2024-04-12 14:20:00'),
(3, 3, 5, 1, 399.00, 0.00, 399.00, '2024-04-15 09:15:00'),
(4, 3, 6, 1, 249.00, 0.00, 249.00, '2024-04-15 09:15:00'),
(5, 4, 8, 1, 129.99, 0.00, 129.99, '2024-04-18 11:45:00'),
(6, 5, 9, 1, 79.99, 0.00, 79.99, '2024-04-20 15:30:00'),
(7, 6, 1, 1, 2499.00, 0.00, 2499.00, '2024-04-22 10:00:00'),
(8, 6, 5, 1, 399.00, 0.00, 399.00, '2024-04-22 10:00:00'),
(9, 7, 2, 1, 1899.00, 0.00, 1899.00, '2024-04-25 13:15:00'),
(10, 8, 12, 1, 349.99, 0.00, 349.99, '2024-04-28 16:45:00'),
(11, 9, 11, 1, 169.99, 0.00, 169.99, '2024-05-02 09:30:00'),
(12, 9, 5, 1, 399.00, 50.00, 349.00, '2024-05-02 09:30:00'),
(13, 9, 30, 3, 99.00, 0.00, 297.00, '2024-05-02 09:30:00'),
(14, 10, 14, 1, 1395.00, 0.00, 1395.00, '2024-05-05 14:00:00'),
(15, 11, 15, 1, 199.00, 0.00, 199.00, '2024-05-08 11:20:00'),
(16, 12, 1, 1, 2499.00, 0.00, 2499.00, '2024-05-12 10:45:00'),
(17, 12, 5, 1, 399.00, 0.00, 399.00, '2024-05-12 10:45:00'),
(18, 13, 18, 1, 349.00, 0.00, 349.00, '2024-05-15 15:30:00'),
(19, 14, 17, 1, 499.00, 0.00, 499.00, '2024-05-18 13:00:00'),
(20, 15, 3, 1, 1199.00, 0.00, 1199.00, '2024-05-22 09:45:00'),
(21, 16, 11, 1, 169.99, 0.00, 169.99, '2024-05-25 16:15:00'),
(22, 17, 21, 1, 159.00, 0.00, 159.00, '2024-05-28 11:30:00'),
(23, 18, 4, 1, 1299.00, 0.00, 1299.00, '2024-06-01 14:20:00'),
(24, 19, 5, 1, 399.00, 0.00, 399.00, '2024-06-05 10:00:00'),
(25, 20, 6, 1, 249.00, 0.00, 249.00, '2024-06-08 15:45:00'),
(26, 21, 16, 1, 449.00, 0.00, 449.00, '2024-06-12 09:30:00'),
(27, 22, 6, 1, 249.00, 0.00, 249.00, '2024-06-15 13:15:00'),
(28, 22, 5, 1, 399.00, 0.00, 399.00, '2024-06-15 13:15:00'),
(29, 23, 20, 1, 27.99, 0.00, 27.99, '2024-06-18 11:00:00'),
(30, 24, 10, 1, 189.99, 0.00, 189.99, '2024-06-22 14:30:00'),
(31, 25, 28, 1, 749.00, 0.00, 749.00, '2024-06-25 10:15:00'),
(32, 26, 27, 1, 1299.00, 0.00, 1299.00, '2024-06-28 15:00:00'),
(33, 27, 17, 1, 499.00, 0.00, 499.00, '2024-07-02 09:45:00'),
(34, 28, 25, 1, 2499.00, 0.00, 2499.00, '2024-07-05 13:20:00'),
(35, 29, 29, 1, 179.00, 0.00, 179.00, '2024-07-08 11:45:00'),
(36, 30, 20, 1, 27.99, 0.00, 27.99, '2024-07-12 16:00:00'),
(37, 30, 19, 1, 26.99, 0.00, 26.99, '2024-07-12 16:00:00'),
(38, 31, 30, 1, 99.00, 0.00, 99.00, '2024-07-15 10:30:00'),
(39, 32, 11, 2, 169.99, 0.00, 339.98, '2024-07-18 14:15:00'),
(40, 33, 5, 1, 399.00, 0.00, 399.00, '2024-07-22 09:00:00'),
(41, 34, 23, 1, 64.99, 0.00, 64.99, '2024-07-25 15:45:00'),
(42, 35, 17, 1, 499.00, 0.00, 499.00, '2024-08-01 10:20:00'),
(43, 36, 26, 1, 149.00, 0.00, 149.00, '2024-08-05 13:30:00'),
(44, 37, 24, 1, 37.99, 0.00, 37.99, '2024-08-08 11:15:00'),
(45, 38, 17, 1, 499.00, 0.00, 499.00, '2024-09-15 14:00:00'),
(46, 38, 18, 1, 349.00, 0.00, 349.00, '2024-09-15 14:00:00'),
(47, 39, 13, 1, 129.00, 0.00, 129.00, '2024-09-20 10:45:00'),
(48, 40, 19, 1, 26.99, 0.00, 26.99, '2024-09-25 15:20:00');

-- =====================================================
-- SECTION 9: PAYMENT_TRANSACTIONS (40 records)
-- =====================================================
-- Payment processing records

INSERT INTO payment_transactions (transaction_id, order_id, payment_method, transaction_amount, transaction_status, payment_gateway, gateway_transaction_id, card_last_four, transaction_date, created_at) VALUES
(1, 1, 'Credit Card', 2698.92, 'Completed', 'Stripe', 'ch_3MtwBwLkdIwHu7ix0B3Tav1z', '4242', '2024-04-10 10:32:00', '2024-04-10 10:32:00'),
(2, 2, 'PayPal', 1309.83, 'Completed', 'PayPal', 'PAYID-MXVQ5TY8E123456789', NULL, '2024-04-12 14:22:00', '2024-04-12 14:22:00'),
(3, 3, 'Credit Card', 699.84, 'Completed', 'Stripe', 'ch_3MtwBwLkdIwHu7ix0B3Tav2a', '5555', '2024-04-15 09:17:00', '2024-04-15 09:17:00'),
(4, 4, 'Debit Card', 149.38, 'Completed', 'Stripe', 'ch_3MtwBwLkdIwHu7ix0B3Tav3b', '1234', '2024-04-18 11:47:00', '2024-04-18 11:47:00'),
(5, 5, 'Credit Card', 92.38, 'Completed', 'Stripe', 'ch_3MtwBwLkdIwHu7ix0B3Tav4c', '4242', '2024-04-20 15:32:00', '2024-04-20 15:32:00'),
(6, 6, 'Credit Card', 3129.84, 'Completed', 'Stripe', 'ch_3MtwBwLkdIwHu7ix0B3Tav5d', '8888', '2024-04-22 10:02:00', '2024-04-22 10:02:00'),
(7, 7, 'PayPal', 2050.92, 'Completed', 'PayPal', 'PAYID-MXVQ5TY8E123456790', NULL, '2024-04-25 13:17:00', '2024-04-25 13:17:00'),
(8, 8, 'Credit Card', 390.98, 'Completed', 'Stripe', 'ch_3MtwBwLkdIwHu7ix0B3Tav6e', '6011', '2024-04-28 16:47:00', '2024-04-28 16:47:00'),
(9, 9, 'Credit Card', 885.58, 'Completed', 'Stripe', 'ch_3MtwBwLkdIwHu7ix0B3Tav7f', '4242', '2024-05-02 09:32:00', '2024-05-02 09:32:00'),
(10, 10, 'Credit Card', 1506.60, 'Completed', 'Stripe', 'ch_3MtwBwLkdIwHu7ix0B3Tav8g', '5555', '2024-05-05 14:02:00', '2024-05-05 14:02:00'),
(11, 11, 'Debit Card', 224.91, 'Completed', 'Stripe', 'ch_3MtwBwLkdIwHu7ix0B3Tav9h', '3782', '2024-05-08 11:22:00', '2024-05-08 11:22:00'),
(12, 12, 'Credit Card', 3129.83, 'Completed', 'Stripe', 'ch_3MtwBwLkdIwHu7ix0B3Tav0i', '4242', '2024-05-12 10:47:00', '2024-05-12 10:47:00'),
(13, 13, 'PayPal', 376.92, 'Completed', 'PayPal', 'PAYID-MXVQ5TY8E123456791', NULL, '2024-05-15 15:32:00', '2024-05-15 15:32:00'),
(14, 14, 'Credit Card', 557.83, 'Completed', 'Stripe', 'ch_3MtwBwLkdIwHu7ix0B3Tav1j', '8888', '2024-05-18 13:02:00', '2024-05-18 13:02:00'),
(15, 15, 'Credit Card', 1294.92, 'Completed', 'Stripe', 'ch_3MtwBwLkdIwHu7ix0B3Tav2k', '4242', '2024-05-22 09:47:00', '2024-05-22 09:47:00'),
(16, 16, 'Debit Card', 191.58, 'Completed', 'Stripe', 'ch_3MtwBwLkdIwHu7ix0B3Tav3l', '1234', '2024-05-25 16:17:00', '2024-05-25 16:17:00'),
(17, 17, 'Credit Card', 180.71, 'Completed', 'Stripe', 'ch_3MtwBwLkdIwHu7ix0B3Tav4m', '5555', '2024-05-28 11:32:00', '2024-05-28 11:32:00'),
(18, 18, 'PayPal', 1402.92, 'Completed', 'PayPal', 'PAYID-MXVQ5TY8E123456792', NULL, '2024-06-01 14:22:00', '2024-06-01 14:22:00'),
(19, 19, 'Credit Card', 430.92, 'Completed', 'Stripe', 'ch_3MtwBwLkdIwHu7ix0B3Tav5n', '4242', '2024-06-05 10:02:00', '2024-06-05 10:02:00'),
(20, 20, 'Credit Card', 274.91, 'Completed', 'Stripe', 'ch_3MtwBwLkdIwHu7ix0B3Tav6o', '8888', '2024-06-08 15:47:00', '2024-06-08 15:47:00'),
(21, 21, 'Credit Card', 484.92, 'Completed', 'Stripe', 'ch_3MtwBwLkdIwHu7ix0B3Tav7p', '4242', '2024-06-12 09:32:00', '2024-06-12 09:32:00'),
(22, 22, 'PayPal', 699.84, 'Completed', 'PayPal', 'PAYID-MXVQ5TY8E123456793', NULL, '2024-06-15 13:17:00', '2024-06-15 13:17:00'),
(23, 23, 'Credit Card', 35.22, 'Completed', 'Stripe', 'ch_3MtwBwLkdIwHu7ix0B3Tav8q', '5555', '2024-06-18 11:02:00', '2024-06-18 11:02:00'),
(24, 24, 'Debit Card', 213.18, 'Completed', 'Stripe', 'ch_3MtwBwLkdIwHu7ix0B3Tav9r', '1234', '2024-06-22 14:32:00', '2024-06-22 14:32:00'),
(25, 25, 'Credit Card', 808.92, 'Completed', 'Stripe', 'ch_3MtwBwLkdIwHu7ix0B3Tav0s', '4242', '2024-06-25 10:17:00', '2024-06-25 10:17:00'),
(26, 26, 'Credit Card', 1402.92, 'Completed', 'Stripe', 'ch_3MtwBwLkdIwHu7ix0B3Tav1t', '8888', '2024-06-28 15:02:00', '2024-06-28 15:02:00'),
(27, 27, 'PayPal', 557.83, 'Completed', 'PayPal', 'PAYID-MXVQ5TY8E123456794', NULL, '2024-07-02 09:47:00', '2024-07-02 09:47:00'),
(28, 28, 'Credit Card', 2698.92, 'Completed', 'Stripe', 'ch_3MtwBwLkdIwHu7ix0B3Tav2u', '4242', '2024-07-05 13:22:00', '2024-07-05 13:22:00'),
(29, 29, 'Credit Card', 203.31, 'Completed', 'Stripe', 'ch_3MtwBwLkdIwHu7ix0B3Tav3v', '5555', '2024-07-08 11:47:00', '2024-07-08 11:47:00'),
(30, 30, 'Credit Card', 59.38, 'Completed', 'Stripe', 'ch_3MtwBwLkdIwHu7ix0B3Tav4w', '4242', '2024-07-12 16:02:00', '2024-07-12 16:02:00'),
(31, 31, 'Debit Card', 113.91, 'Completed', 'Stripe', 'ch_3MtwBwLkdIwHu7ix0B3Tav5x', '1234', '2024-07-15 10:32:00', '2024-07-15 10:32:00'),
(32, 32, 'Credit Card', 367.18, 'Completed', 'Stripe', 'ch_3MtwBwLkdIwHu7ix0B3Tav6y', '8888', '2024-07-18 14:17:00', '2024-07-18 14:17:00'),
(33, 33, 'PayPal', 430.92, 'Completed', 'PayPal', 'PAYID-MXVQ5TY8E123456795', NULL, '2024-07-22 09:02:00', '2024-07-22 09:02:00'),
(34, 34, 'Credit Card', 76.18, 'Completed', 'Stripe', 'ch_3MtwBwLkdIwHu7ix0B3Tav7z', '4242', '2024-07-25 15:47:00', '2024-07-25 15:47:00'),
(35, 35, 'Credit Card', 538.92, 'Pending', 'Stripe', 'ch_3MtwBwLkdIwHu7ix0B3Tav8a', '5555', '2024-08-01 10:22:00', '2024-08-01 10:22:00'),
(36, 36, 'PayPal', 169.91, 'Pending', 'PayPal', 'PAYID-MXVQ5TY8E123456796', NULL, '2024-08-05 13:32:00', '2024-08-05 13:32:00'),
(37, 37, 'Debit Card', 46.02, 'Pending', 'Stripe', 'ch_3MtwBwLkdIwHu7ix0B3Tav9b', '1234', '2024-08-08 11:17:00', '2024-08-08 11:17:00'),
(38, 38, 'Credit Card', 915.84, 'Completed', 'Stripe', 'ch_3MtwBwLkdIwHu7ix0B3Tav0c', '4242', '2024-09-15 14:02:00', '2024-09-15 14:02:00'),
(39, 39, 'Credit Card', 148.31, 'Completed', 'Stripe', 'ch_3MtwBwLkdIwHu7ix0B3Tav1d', '8888', '2024-09-20 10:47:00', '2024-09-20 10:47:00'),
(40, 40, 'PayPal', 34.14, 'Completed', 'PayPal', 'PAYID-MXVQ5TY8E123456797', NULL, '2024-09-25 15:22:00', '2024-09-25 15:22:00');

-- =====================================================
-- SECTION 10: REVIEWS (50 records)
-- =====================================================
-- Customer product reviews and ratings

INSERT INTO reviews (review_id, product_id, customer_id, rating, review_title, review_text, is_verified_purchase, helpful_count, created_at) VALUES
(1, 1, 3, 5, 'Best laptop I''ve ever owned', 'The MacBook Pro 16 with M3 chip is absolutely incredible. The performance is blazing fast, battery life easily lasts all day, and the display is stunning. Worth every penny for professional work.', TRUE, 45, '2024-04-15 14:30:00'),
(2, 1, 11, 5, 'Perfect for developers', 'As a software developer, this machine handles everything I throw at it. Multiple IDEs, Docker containers, virtual machines - no slowdown. The screen real estate is perfect.', TRUE, 32, '2024-05-22 10:15:00'),
(3, 1, 6, 4, 'Great but expensive', 'Amazing performance and build quality, but the price is quite steep. If you need the power it''s worth it, but consider the Air for lighter tasks.', TRUE, 18, '2024-06-10 16:45:00'),
(4, 2, 7, 5, 'Excellent Windows alternative', 'Coming from a MacBook, I was skeptical, but the XPS 15 exceeded expectations. Great display, solid performance, and better value than comparable Macs.', TRUE, 27, '2024-04-20 11:00:00'),
(5, 2, 13, 4, 'Good laptop with minor issues', 'Performance is excellent and the screen is beautiful. Only complaint is fan noise under heavy load and the webcam placement is awkward.', TRUE, 15, '2024-05-28 13:30:00'),
(6, 3, 2, 5, 'iPhone perfection', 'Upgraded from iPhone 12 Pro and the improvements are noticeable. Camera quality is outstanding, battery lasts all day, and the titanium design feels premium.', TRUE, 89, '2024-05-15 09:20:00'),
(7, 3, 10, 5, 'Best phone on the market', 'The A17 Pro chip is incredibly fast, cameras are versatile and powerful, and iOS 17 brings great features. Action button is more useful than expected.', TRUE, 67, '2024-06-05 15:40:00'),
(8, 3, 17, 4, 'Great phone but pricey', 'It''s an excellent phone in every way, but at $1200 it''s hard to justify unless you really need the Pro features. Regular iPhone 15 might be better value.', TRUE, 42, '2024-07-12 11:25:00'),
(9, 4, 15, 5, 'Android flagship excellence', 'The S Pen integration is fantastic, camera zoom capabilities are unmatched, and the AI features are genuinely useful. Battery easily lasts all day.', TRUE, 56, '2024-06-18 14:00:00'),
(10, 4, 20, 4, 'Powerful but heavy', 'Amazing specs and features, but it''s quite heavy and bulky. If you can handle the size, it''s the best Android phone available.', TRUE, 23, '2024-07-20 10:30:00'),
(11, 5, 1, 5, 'Best noise cancelling ever', 'These headphones are incredible. Noise cancellation is industry-leading, sound quality is superb, and they''re comfortable for hours. Worth the premium price.', TRUE, 134, '2024-03-25 16:15:00'),
(12, 5, 4, 5, 'Perfect for travel and work', 'I use these daily for work calls and travel. Battery lasts forever, comfort is excellent, and the noise cancellation makes flights bearable.', TRUE, 98, '2024-04-30 09:45:00'),
(13, 5, 12, 4, 'Great but not perfect', 'Excellent noise cancellation and sound quality. Only minor complaints are they don''t fold as compactly as XM4s and the case is larger.', TRUE, 45, '2024-06-15 13:20:00'),
(14, 6, 8, 5, 'AirPods perfection', 'The noise cancellation is impressive for such small earbuds. Spatial audio is amazing for movies, and the fit is secure and comfortable.', TRUE, 76, '2024-04-10 11:00:00'),
(15, 6, 14, 5, 'Best wireless earbuds', 'Sound quality is excellent, noise cancellation works great, and the integration with Apple devices is seamless. Battery life is solid too.', TRUE, 62, '2024-05-18 14:30:00'),
(16, 6, 19, 4, 'Good but expensive', 'They sound great and work well, but at $250 they''re pricey. Lots of good alternatives for less money if you''re not deep in Apple ecosystem.', TRUE, 38, '2024-07-08 10:15:00'),
(17, 7, 5, 5, 'Classic jeans done right', 'Perfect fit, high quality denim, and they age beautifully. These are the jeans by which all others are measured.', TRUE, 28, '2024-05-05 15:45:00'),
(18, 7, 18, 4, 'Good quality but stiff initially', 'Great quality jeans that will last for years. They''re quite stiff when new but break in nicely after a few washes.', TRUE, 15, '2024-06-20 11:30:00'),
(19, 8, 10, 5, 'Iconic and comfortable', 'Air Max 90s are a classic for good reason. Comfortable all day, stylish, and well-made. The cushioning is perfect.', TRUE, 42, '2024-05-12 13:00:00'),
(20, 8, 13, 5, 'Best sneakers ever', 'I''ve bought multiple pairs over the years. They''re comfortable, durable, and never go out of style. Highly recommend.', TRUE, 35, '2024-06-25 16:20:00'),
(21, 9, 3, 4, 'Beautiful dress', 'The floral print is lovely and the fabric quality is good. Fits true to size and perfect for summer events.', TRUE, 12, '2024-06-08 14:15:00'),
(22, 10, 7, 5, 'Perfect running shoes', 'Best running shoes I''ve owned. The Boost cushioning is incredibly comfortable and provides great energy return.', TRUE, 31, '2024-06-30 10:00:00'),
(23, 11, 6, 5, 'Classic aviators', 'You can''t go wrong with Ray-Ban aviators. Quality is excellent, polarized lenses are great, and they look timeless.', TRUE, 48, '2024-05-20 15:30:00'),
(24, 11, 17, 5, 'Worth the investment', 'Had these for 3 years now and they still look new. Build quality is superior to cheaper alternatives.', TRUE, 29, '2024-07-15 11:45:00'),
(25, 12, 11, 4, 'Stylish and functional', 'Beautiful handbag with plenty of space. Leather quality is excellent though the price is a bit high.', TRUE, 19, '2024-06-12 13:30:00'),
(26, 14, 1, 5, 'Best office chair investment', 'After years of back pain, this chair has been life-changing. Expensive but worth every penny for the ergonomics and comfort.', TRUE, 87, '2024-03-30 10:00:00'),
(27, 14, 6, 5, 'Ergonomic excellence', 'I sit for 8+ hours daily and this chair keeps me comfortable. The mesh breathes well and adjustability is perfect.', TRUE, 64, '2024-05-15 14:20:00'),
(28, 16, 3, 5, 'Kitchen workhorse', 'This mixer is incredible. Powerful motor handles any task, multiple attachments make it versatile, and it looks beautiful on the counter.', TRUE, 93, '2024-04-25 11:30:00'),
(29, 16, 20, 5, 'Baking game changer', 'Made bread, pizza dough, cakes, and whipped cream - handles everything effortlessly. Build quality is exceptional.', TRUE, 71, '2024-06-18 15:00:00'),
(30, 17, 2, 5, 'Next-gen gaming amazing', 'The graphics are stunning, load times are nearly instant with the SSD, and the DualSense controller adds immersion. PS5 is worth the wait.', TRUE, 156, '2024-04-05 16:45:00'),
(31, 17, 15, 5, 'Best console ever', 'Game library is growing nicely, performance is incredible, and backwards compatibility with PS4 is seamless. Highly recommend.', TRUE, 112, '2024-06-22 13:15:00'),
(32, 17, 10, 4, 'Great but hard to find', 'Amazing gaming experience when you can actually get one. Stock availability has improved but still challenging.', TRUE, 67, '2024-08-10 10:30:00'),
(33, 18, 8, 5, 'Perfect portable gaming', 'The OLED screen is gorgeous, battery life is good, and the versatility of handheld/docked gaming is unmatched.', TRUE, 84, '2024-05-08 14:00:00'),
(34, 18, 14, 5, 'Best for Nintendo exclusives', 'Pokemon, Zelda, Mario - the exclusive games make this console essential. OLED upgrade is worth it for the better screen.', TRUE, 59, '2024-07-02 11:20:00'),
(35, 20, 1, 5, 'Life-changing book', 'This book genuinely changed how I approach building habits. Practical, science-based, and easy to implement. Highly recommend.', TRUE, 234, '2024-03-15 09:00:00'),
(36, 20, 4, 5, 'Best self-improvement book', 'Clear and actionable advice backed by research. I''ve successfully built several new habits using the techniques in this book.', TRUE, 187, '2024-04-20 10:30:00'),
(37, 20, 7, 5, 'Must-read for everyone', 'Whether you want to build good habits or break bad ones, this book provides a clear framework. One of the best books I''ve read.', TRUE, 156, '2024-05-25 13:45:00'),
(38, 20, 11, 5, 'Practical and effective', 'Not just theory - the book provides specific strategies you can implement immediately. Seeing results after just a few weeks.', TRUE, 143, '2024-06-30 15:15:00'),
(39, 21, 5, 4, 'Great fitness tracker', 'Accurate heart rate monitoring, GPS works well, and battery lasts about a week. Sleep tracking insights are helpful.', TRUE, 42, '2024-06-15 11:00:00'),
(40, 21, 12, 4, 'Good but not perfect', 'Solid fitness tracker with good accuracy. Only wish the screen was slightly larger and battery lasted longer.', TRUE, 28, '2024-07-20 14:30:00'),
(41, 24, 6, 5, 'Best tumbler ever', 'Keeps ice frozen for over 24 hours even in summer heat. Build quality is excellent and worth the premium price.', TRUE, 67, '2024-05-28 10:15:00'),
(42, 24, 13, 5, 'Quality you can trust', 'Yeti products are expensive but they last forever and perform flawlessly. This tumbler goes everywhere with me.', TRUE, 54, '2024-07-05 13:00:00'),
(43, 25, 17, 5, 'Professional photography tool', 'Incredible autofocus system, excellent low-light performance, and the image quality is stunning. Worth upgrading from R6 Mark I.', TRUE, 45, '2024-07-15 16:30:00'),
(44, 27, 2, 4, 'Great TV for the price', 'Picture quality is excellent with QLED technology. Smart features work well though the interface could be more intuitive.', TRUE, 38, '2024-04-18 11:45:00'),
(45, 27, 20, 5, 'Excellent 4K TV', 'Gaming at 120Hz is smooth, HDR looks fantastic, and the size is perfect for our living room. Very happy with this purchase.', TRUE, 52, '2024-06-10 14:20:00'),
(46, 28, 3, 5, 'Cleaning revolution', 'This vacuum is amazing. The laser shows dirt you can''t see, suction is powerful, and battery lasts long enough for whole house.', TRUE, 89, '2024-05-22 10:00:00'),
(47, 28, 11, 5, 'Best vacuum I''ve owned', 'Cordless convenience without sacrificing power. The automatic power adjustment and filtration system are excellent.', TRUE, 67, '2024-07-08 15:45:00'),
(48, 30, 1, 5, 'Kitchen essential', 'Use this almost daily for meal prep. Pressure cooking is fast, yogurt function is great, and it''s easy to clean.', TRUE, 178, '2024-03-10 09:30:00'),
(49, 30, 10, 5, 'Replaces 7 appliances', 'This thing does everything - pressure cook, slow cook, rice, yogurt, sterilize. Saves so much counter space.', TRUE, 145, '2024-05-15 11:15:00'),
(50, 30, 15, 4, 'Very useful but learning curve', 'Once you figure it out it''s fantastic, but the manual could be clearer. Lots of recipes online help.', TRUE, 92, '2024-07-20 13:30:00');

-- =====================================================
-- SECTION 11: AUDIT_LOG (16 records)
-- =====================================================
-- System audit trail for data changes

INSERT INTO audit_log (log_id, table_name, operation, record_id, old_values, new_values, changed_by, changed_at) VALUES
(1, 'products', 'UPDATE', 17, '{"stock_quantity": 70}', '{"stock_quantity": 67}', 'system', '2024-05-18 13:02:00'),
(2, 'customers', 'UPDATE', 1, '{"total_spent": 2698.92, "loyalty_points": 2180}', '{"total_spent": 3129.84, "loyalty_points": 2450}', 'system', '2024-06-05 10:05:00'),
(3, 'products', 'UPDATE', 3, '{"stock_quantity": 125, "total_reviews": 510}', '{"stock_quantity": 120, "total_reviews": 512}', 'system', '2024-06-05 16:30:00'),
(4, 'products', 'INSERT', 25, NULL, '{"product_name": "Canon EOS R6 Mark II Body", "price": 2499.00, "stock_quantity": 25}', 'admin', '2024-03-22 09:45:00'),
(5, 'orders', 'UPDATE', 35, '{"order_status": "Processing"}', '{"order_status": "Shipped"}', 'system', '2024-08-03 14:20:00'),
(6, 'customers', 'UPDATE', 3, '{"loyalty_points": 2890}', '{"loyalty_points": 3100}', 'system', '2024-06-12 10:00:00'),
(7, 'products', 'UPDATE', 20, '{"total_reviews": 5670, "average_rating": 4.8}', '{"total_reviews": 5678, "average_rating": 4.9}', 'system', '2024-07-20 14:00:00'),
(8, 'reviews', 'INSERT', 50, NULL, '{"product_id": 30, "customer_id": 15, "rating": 4, "review_title": "Very useful but learning curve"}', 'customer_15', '2024-07-20 13:30:00'),
(9, 'orders', 'INSERT', 40, NULL, '{"customer_id": 7, "total_amount": 34.14, "order_status": "Processing"}', 'system', '2024-09-25 15:20:00'),
(10, 'products', 'UPDATE', 5, '{"stock_quantity": 165}', '{"stock_quantity": 156}', 'system', '2024-07-22 09:05:00'),
(11, 'customers', 'UPDATE', 11, '{"total_spent": 4445.28, "loyalty_points": 3120}', '{"total_spent": 4876.20, "loyalty_points": 3340}', 'system', '2024-07-22 09:10:00'),
(12, 'shipping_addresses', 'INSERT', 25, NULL, '{"customer_id": 17, "address_type": "Work", "city": "Medford"}', 'customer_17', '2024-02-10 13:00:00'),
(13, 'products', 'UPDATE', 1, '{"total_reviews": 230}', '{"total_reviews": 234}', 'system', '2024-06-10 16:50:00'),
(14, 'cart_items', 'DELETE', 3, '{"customer_id": 8, "product_id": 15, "quantity": 1}', NULL, 'customer_8', '2024-10-07 11:00:00'),
(15, 'categories', 'INSERT', 15, NULL, '{"category_name": "Gaming", "parent_id": 1}', 'admin', '2024-01-15 11:10:00'),
(16, 'customers', 'UPDATE', 16, '{"account_status": "Active"}', '{"account_status": "Suspended"}', 'admin', '2024-09-20 14:00:00');

-- Re-enable RLS on all tables
ALTER TABLE categories ENABLE ROW LEVEL SECURITY;
ALTER TABLE customers ENABLE ROW LEVEL SECURITY;
ALTER TABLE products ENABLE ROW LEVEL SECURITY;
ALTER TABLE product_images ENABLE ROW LEVEL SECURITY;
ALTER TABLE shipping_addresses ENABLE ROW LEVEL SECURITY;
ALTER TABLE cart_items ENABLE ROW LEVEL SECURITY;
ALTER TABLE orders ENABLE ROW LEVEL SECURITY;
ALTER TABLE order_items ENABLE ROW LEVEL SECURITY;
ALTER TABLE payment_transactions ENABLE ROW LEVEL SECURITY;
ALTER TABLE reviews ENABLE ROW LEVEL SECURITY;
ALTER TABLE audit_log ENABLE ROW LEVEL SECURITY;

-- Verification query
SELECT 'categories' AS table_name, COUNT(*) AS record_count FROM categories
UNION ALL SELECT 'customers', COUNT(*) FROM customers
UNION ALL SELECT 'products', COUNT(*) FROM products
UNION ALL SELECT 'product_images', COUNT(*) FROM product_images
UNION ALL SELECT 'shipping_addresses', COUNT(*) FROM shipping_addresses
UNION ALL SELECT 'cart_items', COUNT(*) FROM cart_items
UNION ALL SELECT 'orders', COUNT(*) FROM orders
UNION ALL SELECT 'order_items', COUNT(*) FROM order_items
UNION ALL SELECT 'payment_transactions', COUNT(*) FROM payment_transactions
UNION ALL SELECT 'reviews', COUNT(*) FROM reviews
UNION ALL SELECT 'audit_log', COUNT(*) FROM audit_log;

-- =====================================================
-- END OF INSERT DATA SCRIPT
-- =====================================================
