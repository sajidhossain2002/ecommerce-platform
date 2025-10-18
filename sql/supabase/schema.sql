-- E-Commerce Platform Database Schema
-- Created by: Sajid
-- Date: October 9, 2025

-- Drop tables if they exist (for clean recreation)
DROP TABLE IF EXISTS audit_log CASCADE;
DROP TABLE IF EXISTS payment_transactions CASCADE;
DROP TABLE IF EXISTS cart_items CASCADE;
DROP TABLE IF EXISTS order_items CASCADE;
DROP TABLE IF EXISTS orders CASCADE;
DROP TABLE IF EXISTS shipping_addresses CASCADE;
DROP TABLE IF EXISTS reviews CASCADE;
DROP TABLE IF EXISTS product_images CASCADE;
DROP TABLE IF EXISTS products CASCADE;
DROP TABLE IF EXISTS categories CASCADE;
DROP TABLE IF EXISTS customers CASCADE;

-- =====================================
-- TABLE CREATION
-- =====================================

-- Create Customers Table
CREATE TABLE customers (
    customer_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    phone VARCHAR(20),
    password_hash VARCHAR(255) NOT NULL,
    date_of_birth DATE,
    account_status VARCHAR(20) DEFAULT 'Active',
    loyalty_points INTEGER DEFAULT 0,
    total_spent DECIMAL(12,2) DEFAULT 0.00,
    registration_date DATE DEFAULT CURRENT_DATE,
    last_login TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    -- Constraints
    CONSTRAINT chk_customer_email CHECK (email LIKE '%@%.%'),
    CONSTRAINT chk_customer_phone CHECK (phone ~ '^[0-9+\-\s()]+$'),
    CONSTRAINT chk_account_status CHECK (account_status IN ('Active', 'Inactive', 'Suspended')),
    CONSTRAINT chk_loyalty_points CHECK (loyalty_points >= 0),
    CONSTRAINT chk_total_spent CHECK (total_spent >= 0),
    CONSTRAINT chk_dob CHECK (date_of_birth <= CURRENT_DATE)
);

-- Create Categories Table (Hierarchical)
CREATE TABLE categories (
    category_id SERIAL PRIMARY KEY,
    category_name VARCHAR(100) NOT NULL UNIQUE,
    description TEXT,
    parent_id INTEGER REFERENCES categories(category_id),
    image_url VARCHAR(255),
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    -- Constraints
    CONSTRAINT chk_category_name CHECK (LENGTH(category_name) >= 2)
);

-- Create Products Table
CREATE TABLE products (
    product_id SERIAL PRIMARY KEY,
    product_name VARCHAR(200) NOT NULL,
    sku VARCHAR(50) UNIQUE NOT NULL,
    category_id INTEGER REFERENCES categories(category_id),
    description TEXT,
    price DECIMAL(10,2) NOT NULL,
    cost_price DECIMAL(10,2),
    stock_quantity INTEGER DEFAULT 0,
    reorder_level INTEGER DEFAULT 10,
    brand VARCHAR(100),
    weight_kg DECIMAL(8,3),
    dimensions VARCHAR(100),
    is_active BOOLEAN DEFAULT TRUE,
    featured BOOLEAN DEFAULT FALSE,
    average_rating DECIMAL(3,2),
    total_reviews INTEGER DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    -- Constraints
    CONSTRAINT chk_product_price CHECK (price > 0),
    CONSTRAINT chk_cost_price CHECK (cost_price IS NULL OR cost_price >= 0),
    CONSTRAINT chk_stock_quantity CHECK (stock_quantity >= 0),
    CONSTRAINT chk_reorder_level CHECK (reorder_level >= 0),
    CONSTRAINT chk_weight CHECK (weight_kg IS NULL OR weight_kg > 0),
    CONSTRAINT chk_average_rating CHECK (average_rating IS NULL OR (average_rating >= 0 AND average_rating <= 5)),
    CONSTRAINT chk_total_reviews CHECK (total_reviews >= 0)
);

-- Create Product Images Table
CREATE TABLE product_images (
    image_id SERIAL PRIMARY KEY,
    product_id INTEGER NOT NULL REFERENCES products(product_id) ON DELETE CASCADE,
    image_url VARCHAR(255) NOT NULL,
    alt_text VARCHAR(200),
    is_primary BOOLEAN DEFAULT FALSE,
    display_order INTEGER DEFAULT 1,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    -- Constraints
    CONSTRAINT chk_display_order CHECK (display_order > 0)
);

-- Create Reviews Table
CREATE TABLE reviews (
    review_id SERIAL PRIMARY KEY,
    product_id INTEGER NOT NULL REFERENCES products(product_id) ON DELETE CASCADE,
    customer_id INTEGER NOT NULL REFERENCES customers(customer_id) ON DELETE CASCADE,
    rating INTEGER NOT NULL,
    review_title VARCHAR(200),
    review_text TEXT,
    is_verified_purchase BOOLEAN DEFAULT FALSE,
    helpful_count INTEGER DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    -- Constraints
    CONSTRAINT chk_rating CHECK (rating >= 1 AND rating <= 5),
    CONSTRAINT chk_helpful_count CHECK (helpful_count >= 0),
    CONSTRAINT unique_customer_product_review UNIQUE (product_id, customer_id)
);

-- Create Shipping Addresses Table
CREATE TABLE shipping_addresses (
    address_id SERIAL PRIMARY KEY,
    customer_id INTEGER NOT NULL REFERENCES customers(customer_id) ON DELETE CASCADE,
    address_type VARCHAR(20) DEFAULT 'Home',
    recipient_name VARCHAR(100) NOT NULL,
    street_address VARCHAR(200) NOT NULL,
    city VARCHAR(100) NOT NULL,
    state VARCHAR(50) NOT NULL,
    postal_code VARCHAR(20) NOT NULL,
    country VARCHAR(50) DEFAULT 'USA',
    phone VARCHAR(20),
    is_default BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    -- Constraints
    CONSTRAINT chk_address_type CHECK (address_type IN ('Home', 'Work', 'Other')),
    CONSTRAINT chk_postal_code CHECK (postal_code ~ '^[0-9]{5}(-[0-9]{4})?$')
);

-- Create Orders Table
CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    customer_id INTEGER NOT NULL REFERENCES customers(customer_id),
    order_date DATE DEFAULT CURRENT_DATE,
    order_status VARCHAR(20) DEFAULT 'Processing',
    subtotal DECIMAL(12,2) NOT NULL,
    tax_amount DECIMAL(10,2) DEFAULT 0.00,
    shipping_cost DECIMAL(10,2) DEFAULT 0.00,
    total_amount DECIMAL(12,2) NOT NULL,
    payment_method VARCHAR(30),
    shipping_address_id INTEGER REFERENCES shipping_addresses(address_id),
    tracking_number VARCHAR(50),
    estimated_delivery DATE,
    actual_delivery DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    -- Constraints
    CONSTRAINT chk_order_status CHECK (order_status IN ('Processing', 'Confirmed', 'Shipped', 'Delivered', 'Cancelled', 'Refunded')),
    CONSTRAINT chk_subtotal CHECK (subtotal >= 0),
    CONSTRAINT chk_tax_amount CHECK (tax_amount >= 0),
    CONSTRAINT chk_shipping_cost CHECK (shipping_cost >= 0),
    CONSTRAINT chk_total_amount CHECK (total_amount >= 0),
    CONSTRAINT chk_payment_method CHECK (payment_method IN ('Credit Card', 'Debit Card', 'PayPal', 'Apple Pay', 'Google Pay')),
    CONSTRAINT chk_delivery_dates CHECK (actual_delivery IS NULL OR actual_delivery >= order_date)
);

-- Create Order Items Table
CREATE TABLE order_items (
    order_item_id SERIAL PRIMARY KEY,
    order_id INTEGER NOT NULL REFERENCES orders(order_id) ON DELETE CASCADE,
    product_id INTEGER NOT NULL REFERENCES products(product_id),
    quantity INTEGER NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    discount_amount DECIMAL(10,2) DEFAULT 0.00,
    subtotal DECIMAL(10,2) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    -- Constraints
    CONSTRAINT chk_quantity CHECK (quantity > 0),
    CONSTRAINT chk_unit_price CHECK (unit_price >= 0),
    CONSTRAINT chk_discount_amount CHECK (discount_amount >= 0),
    CONSTRAINT chk_item_subtotal CHECK (subtotal >= 0)
);

-- Create Shopping Cart Table
CREATE TABLE cart_items (
    cart_item_id SERIAL PRIMARY KEY,
    customer_id INTEGER NOT NULL REFERENCES customers(customer_id) ON DELETE CASCADE,
    product_id INTEGER NOT NULL REFERENCES products(product_id) ON DELETE CASCADE,
    quantity INTEGER NOT NULL,
    added_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    -- Constraints
    CONSTRAINT chk_cart_quantity CHECK (quantity > 0),
    CONSTRAINT unique_customer_product_cart UNIQUE (customer_id, product_id)
);

-- Create Payment Transactions Table
CREATE TABLE payment_transactions (
    transaction_id SERIAL PRIMARY KEY,
    order_id INTEGER NOT NULL REFERENCES orders(order_id),
    payment_method VARCHAR(30) NOT NULL,
    transaction_amount DECIMAL(12,2) NOT NULL,
    transaction_status VARCHAR(20) DEFAULT 'Pending',
    payment_gateway VARCHAR(50),
    gateway_transaction_id VARCHAR(100),
    card_last_four VARCHAR(4),
    transaction_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    -- Constraints
    CONSTRAINT chk_transaction_amount CHECK (transaction_amount > 0),
    CONSTRAINT chk_transaction_status CHECK (transaction_status IN ('Pending', 'Completed', 'Failed', 'Refunded'))
);

-- Create Audit Log Table
CREATE TABLE audit_log (
    log_id SERIAL PRIMARY KEY,
    table_name VARCHAR(50) NOT NULL,
    operation VARCHAR(10) NOT NULL,
    record_id INTEGER,
    old_values JSONB,
    new_values JSONB,
    changed_by VARCHAR(100),
    changed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    -- Constraints
    CONSTRAINT chk_audit_operation CHECK (operation IN ('INSERT', 'UPDATE', 'DELETE'))
);

-- =====================================
-- INDEXES FOR PERFORMANCE
-- =====================================

-- Customer indexes
CREATE INDEX idx_customers_email ON customers(email);
CREATE INDEX idx_customers_status ON customers(account_status);
CREATE INDEX idx_customers_last_login ON customers(last_login);

-- Category indexes
CREATE INDEX idx_categories_parent ON categories(parent_id);
CREATE INDEX idx_categories_active ON categories(is_active);

-- Product indexes
CREATE INDEX idx_products_category ON products(category_id);
CREATE INDEX idx_products_sku ON products(sku);
CREATE INDEX idx_products_name ON products(product_name);
CREATE INDEX idx_products_brand ON products(brand);
CREATE INDEX idx_products_active ON products(is_active);
CREATE INDEX idx_products_featured ON products(featured);
CREATE INDEX idx_products_rating ON products(average_rating);

-- Review indexes
CREATE INDEX idx_reviews_product ON reviews(product_id);
CREATE INDEX idx_reviews_customer ON reviews(customer_id);
CREATE INDEX idx_reviews_rating ON reviews(rating);
CREATE INDEX idx_reviews_verified ON reviews(is_verified_purchase);

-- Order indexes
CREATE INDEX idx_orders_customer ON orders(customer_id);
CREATE INDEX idx_orders_status ON orders(order_status);
CREATE INDEX idx_orders_date ON orders(order_date);
CREATE INDEX idx_orders_tracking ON orders(tracking_number);

-- Order items indexes
CREATE INDEX idx_order_items_order ON order_items(order_id);
CREATE INDEX idx_order_items_product ON order_items(product_id);

-- Cart indexes
CREATE INDEX idx_cart_customer ON cart_items(customer_id);
CREATE INDEX idx_cart_product ON cart_items(product_id);

-- Payment indexes
CREATE INDEX idx_payments_order ON payment_transactions(order_id);
CREATE INDEX idx_payments_status ON payment_transactions(transaction_status);
CREATE INDEX idx_payments_gateway ON payment_transactions(payment_gateway);

-- =====================================
-- TABLE COMMENTS
-- =====================================

COMMENT ON TABLE customers IS 'Customer accounts with loyalty and purchase history';
COMMENT ON TABLE categories IS 'Hierarchical product categories';
COMMENT ON TABLE products IS 'Product catalog with inventory management';
COMMENT ON TABLE product_images IS 'Product image gallery';
COMMENT ON TABLE reviews IS 'Customer product reviews and ratings';
COMMENT ON TABLE shipping_addresses IS 'Customer shipping addresses';
COMMENT ON TABLE orders IS 'Order transactions';
COMMENT ON TABLE order_items IS 'Individual items within orders';
COMMENT ON TABLE cart_items IS 'Shopping cart for active customers';
COMMENT ON TABLE payment_transactions IS 'Payment processing records';
COMMENT ON TABLE audit_log IS 'Complete audit trail for all changes';
