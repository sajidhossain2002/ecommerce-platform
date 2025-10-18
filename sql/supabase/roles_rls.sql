-- =====================================================
-- E-Commerce Platform - Row Level Security (RLS) Configuration
-- =====================================================
-- Purpose: Implement customer privacy and data access controls
-- Security Model: Customer data ownership, public catalog, admin oversight
-- Deployment: Supabase PostgreSQL with RLS
-- Author: SAJID
-- Date: October 2025
-- =====================================================

-- =====================================================
-- ROLE DEFINITIONS
-- =====================================================
-- Define user roles for the e-commerce platform

-- Authenticated customer role (logged-in shoppers)
-- Note: In Supabase, use auth.uid() to get current user's ID

-- =====================================================
-- DROP EXISTING POLICIES (if re-running script)
-- =====================================================

-- Categories policies
DROP POLICY IF EXISTS "public_can_view_categories" ON categories;
DROP POLICY IF EXISTS "admin_can_manage_categories" ON categories;

-- Products policies
DROP POLICY IF EXISTS "public_can_view_active_products" ON products;
DROP POLICY IF EXISTS "admin_can_manage_products" ON products;

-- Product Images policies
DROP POLICY IF EXISTS "public_can_view_product_images" ON product_images;
DROP POLICY IF EXISTS "admin_can_manage_product_images" ON product_images;

-- Customers policies
DROP POLICY IF EXISTS "customers_can_view_own_data" ON customers;
DROP POLICY IF EXISTS "customers_can_update_own_profile" ON customers;
DROP POLICY IF EXISTS "admin_can_view_all_customers" ON customers;
DROP POLICY IF EXISTS "admin_can_manage_customers" ON customers;

-- Shipping Addresses policies
DROP POLICY IF EXISTS "customers_can_view_own_addresses" ON shipping_addresses;
DROP POLICY IF EXISTS "customers_can_manage_own_addresses" ON shipping_addresses;
DROP POLICY IF EXISTS "admin_can_view_all_addresses" ON shipping_addresses;

-- Cart Items policies
DROP POLICY IF EXISTS "customers_can_view_own_cart" ON cart_items;
DROP POLICY IF EXISTS "customers_can_manage_own_cart" ON cart_items;

-- Orders policies
DROP POLICY IF EXISTS "customers_can_view_own_orders" ON orders;
DROP POLICY IF EXISTS "admin_can_view_all_orders" ON orders;
DROP POLICY IF EXISTS "admin_can_update_orders" ON orders;

-- Order Items policies
DROP POLICY IF EXISTS "customers_can_view_own_order_items" ON order_items;
DROP POLICY IF EXISTS "admin_can_view_all_order_items" ON order_items;

-- Payment Transactions policies
DROP POLICY IF EXISTS "customers_can_view_own_transactions" ON payment_transactions;
DROP POLICY IF EXISTS "admin_can_view_all_transactions" ON payment_transactions;

-- Reviews policies
DROP POLICY IF EXISTS "public_can_view_reviews" ON reviews;
DROP POLICY IF EXISTS "customers_can_create_reviews" ON reviews;
DROP POLICY IF EXISTS "customers_can_edit_own_reviews" ON reviews;
DROP POLICY IF EXISTS "customers_can_delete_own_reviews" ON reviews;
DROP POLICY IF EXISTS "admin_can_manage_reviews" ON reviews;

-- Audit Log policies
DROP POLICY IF EXISTS "admin_can_view_audit_log" ON audit_log;

-- =====================================================
-- ENABLE ROW LEVEL SECURITY ON ALL TABLES
-- =====================================================

ALTER TABLE categories ENABLE ROW LEVEL SECURITY;
ALTER TABLE products ENABLE ROW LEVEL SECURITY;
ALTER TABLE product_images ENABLE ROW LEVEL SECURITY;
ALTER TABLE customers ENABLE ROW LEVEL SECURITY;
ALTER TABLE shipping_addresses ENABLE ROW LEVEL SECURITY;
ALTER TABLE cart_items ENABLE ROW LEVEL SECURITY;
ALTER TABLE orders ENABLE ROW LEVEL SECURITY;
ALTER TABLE order_items ENABLE ROW LEVEL SECURITY;
ALTER TABLE payment_transactions ENABLE ROW LEVEL SECURITY;
ALTER TABLE reviews ENABLE ROW LEVEL SECURITY;
ALTER TABLE audit_log ENABLE ROW LEVEL SECURITY;

-- =====================================================
-- CATEGORIES TABLE POLICIES
-- =====================================================
-- Public product catalog browsing

-- Anyone can view active categories (including anonymous visitors)
CREATE POLICY "public_can_view_categories"
ON categories
FOR SELECT
USING (is_active = TRUE);

-- Only admins can modify categories
CREATE POLICY "admin_can_manage_categories"
ON categories
FOR ALL
USING (auth.jwt() ->> 'role' = 'admin')
WITH CHECK (auth.jwt() ->> 'role' = 'admin');

-- =====================================================
-- PRODUCTS TABLE POLICIES
-- =====================================================
-- Public product catalog with admin management

-- Anyone can view active products (product catalog is public)
CREATE POLICY "public_can_view_active_products"
ON products
FOR SELECT
USING (is_active = TRUE);

-- Only admins can manage product inventory
CREATE POLICY "admin_can_manage_products"
ON products
FOR ALL
USING (auth.jwt() ->> 'role' = 'admin')
WITH CHECK (auth.jwt() ->> 'role' = 'admin');

-- =====================================================
-- PRODUCT_IMAGES TABLE POLICIES
-- =====================================================
-- Public product photography

-- Anyone can view product images
CREATE POLICY "public_can_view_product_images"
ON product_images
FOR SELECT
USING (TRUE);

-- Only admins can manage product images
CREATE POLICY "admin_can_manage_product_images"
ON product_images
FOR ALL
USING (auth.jwt() ->> 'role' = 'admin')
WITH CHECK (auth.jwt() ->> 'role' = 'admin');

-- =====================================================
-- CUSTOMERS TABLE POLICIES
-- =====================================================
-- Customer privacy protection

-- Customers can only view their own data
CREATE POLICY "customers_can_view_own_data"
ON customers
FOR SELECT
USING (customer_id::text = auth.uid());

-- Customers can update their own profile (except sensitive fields)
CREATE POLICY "customers_can_update_own_profile"
ON customers
FOR UPDATE
USING (customer_id::text = auth.uid())
WITH CHECK (
    customer_id::text = auth.uid() AND
    -- Prevent customers from changing account status or total_spent
    account_status = (SELECT account_status FROM customers WHERE customer_id::text = auth.uid()) AND
    total_spent = (SELECT total_spent FROM customers WHERE customer_id::text = auth.uid())
);

-- Admins can view all customers
CREATE POLICY "admin_can_view_all_customers"
ON customers
FOR SELECT
USING (auth.jwt() ->> 'role' = 'admin');

-- Admins can manage all customers
CREATE POLICY "admin_can_manage_customers"
ON customers
FOR ALL
USING (auth.jwt() ->> 'role' = 'admin')
WITH CHECK (auth.jwt() ->> 'role' = 'admin');

-- =====================================================
-- SHIPPING_ADDRESSES TABLE POLICIES
-- =====================================================
-- Address privacy and ownership

-- Customers can view only their own addresses
CREATE POLICY "customers_can_view_own_addresses"
ON shipping_addresses
FOR SELECT
USING (customer_id::text = auth.uid());

-- Customers can manage their own addresses (insert, update, delete)
CREATE POLICY "customers_can_manage_own_addresses"
ON shipping_addresses
FOR ALL
USING (customer_id::text = auth.uid())
WITH CHECK (customer_id::text = auth.uid());

-- Admins can view all addresses (for order fulfillment)
CREATE POLICY "admin_can_view_all_addresses"
ON shipping_addresses
FOR SELECT
USING (auth.jwt() ->> 'role' = 'admin');

-- =====================================================
-- CART_ITEMS TABLE POLICIES
-- =====================================================
-- Shopping cart privacy

-- Customers can view only their own cart
CREATE POLICY "customers_can_view_own_cart"
ON cart_items
FOR SELECT
USING (customer_id::text = auth.uid());

-- Customers can manage their own cart items
CREATE POLICY "customers_can_manage_own_cart"
ON cart_items
FOR ALL
USING (customer_id::text = auth.uid())
WITH CHECK (customer_id::text = auth.uid());

-- =====================================================
-- ORDERS TABLE POLICIES
-- =====================================================
-- Order privacy and fulfillment access

-- Customers can view only their own orders
CREATE POLICY "customers_can_view_own_orders"
ON orders
FOR SELECT
USING (customer_id::text = auth.uid());

-- Admins can view all orders (for fulfillment)
CREATE POLICY "admin_can_view_all_orders"
ON orders
FOR SELECT
USING (auth.jwt() ->> 'role' = 'admin');

-- Admins can update order status
CREATE POLICY "admin_can_update_orders"
ON orders
FOR UPDATE
USING (auth.jwt() ->> 'role' = 'admin')
WITH CHECK (auth.jwt() ->> 'role' = 'admin');

-- =====================================================
-- ORDER_ITEMS TABLE POLICIES
-- =====================================================
-- Order line item privacy

-- Customers can view items from their own orders
CREATE POLICY "customers_can_view_own_order_items"
ON order_items
FOR SELECT
USING (
    EXISTS (
        SELECT 1 FROM orders
        WHERE orders.order_id = order_items.order_id
        AND orders.customer_id::text = auth.uid()
    )
);

-- Admins can view all order items
CREATE POLICY "admin_can_view_all_order_items"
ON order_items
FOR SELECT
USING (auth.jwt() ->> 'role' = 'admin');

-- =====================================================
-- PAYMENT_TRANSACTIONS TABLE POLICIES
-- =====================================================
-- Payment information privacy (PCI compliance consideration)

-- Customers can view their own payment transactions
CREATE POLICY "customers_can_view_own_transactions"
ON payment_transactions
FOR SELECT
USING (
    EXISTS (
        SELECT 1 FROM orders
        WHERE orders.order_id = payment_transactions.order_id
        AND orders.customer_id::text = auth.uid()
    )
);

-- Admins can view all transactions (for accounting)
CREATE POLICY "admin_can_view_all_transactions"
ON payment_transactions
FOR SELECT
USING (auth.jwt() ->> 'role' = 'admin');

-- =====================================================
-- REVIEWS TABLE POLICIES
-- =====================================================
-- Product review moderation

-- Anyone can read reviews (public product feedback)
CREATE POLICY "public_can_view_reviews"
ON reviews
FOR SELECT
USING (TRUE);

-- Authenticated customers can create reviews
CREATE POLICY "customers_can_create_reviews"
ON reviews
FOR INSERT
WITH CHECK (customer_id::text = auth.uid());

-- Customers can edit their own reviews (within reasonable timeframe)
CREATE POLICY "customers_can_edit_own_reviews"
ON reviews
FOR UPDATE
USING (customer_id::text = auth.uid())
WITH CHECK (customer_id::text = auth.uid());

-- Customers can delete their own reviews
CREATE POLICY "customers_can_delete_own_reviews"
ON reviews
FOR DELETE
USING (customer_id::text = auth.uid());

-- Admins can manage all reviews (content moderation)
CREATE POLICY "admin_can_manage_reviews"
ON reviews
FOR ALL
USING (auth.jwt() ->> 'role' = 'admin')
WITH CHECK (auth.jwt() ->> 'role' = 'admin');

-- =====================================================
-- AUDIT_LOG TABLE POLICIES
-- =====================================================
-- System audit trail (admin-only access)

-- Only admins can view audit logs
CREATE POLICY "admin_can_view_audit_log"
ON audit_log
FOR SELECT
USING (auth.jwt() ->> 'role' = 'admin');

-- =====================================================
-- HELPER FUNCTIONS (Optional)
-- =====================================================
-- Custom functions to enhance security checks

-- Function to check if user is admin
CREATE OR REPLACE FUNCTION is_admin()
RETURNS BOOLEAN AS $$
BEGIN
    RETURN auth.jwt() ->> 'role' = 'admin';
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Function to check if user owns a customer record
CREATE OR REPLACE FUNCTION owns_customer_record(check_customer_id INTEGER)
RETURNS BOOLEAN AS $$
BEGIN
    RETURN check_customer_id::text = auth.uid();
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Function to check if user has placed an order
CREATE OR REPLACE FUNCTION owns_order(check_order_id INTEGER)
RETURNS BOOLEAN AS $$
BEGIN
    RETURN EXISTS (
        SELECT 1 FROM orders
        WHERE order_id = check_order_id
        AND customer_id::text = auth.uid()
    );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- =====================================================
-- VERIFICATION QUERIES
-- =====================================================
-- Test RLS policies are active

-- Check which tables have RLS enabled
SELECT schemaname, tablename, rowsecurity
FROM pg_tables
WHERE schemaname = 'public'
AND tablename IN (
    'categories', 'products', 'product_images', 'customers',
    'shipping_addresses', 'cart_items', 'orders', 'order_items',
    'payment_transactions', 'reviews', 'audit_log'
)
ORDER BY tablename;

-- Count active policies per table
SELECT schemaname, tablename, COUNT(*) as policy_count
FROM pg_policies
WHERE schemaname = 'public'
GROUP BY schemaname, tablename
ORDER BY tablename;

-- =====================================================
-- SECURITY NOTES
-- =====================================================
-- 1. Customer Privacy: Customers can only access their own data
-- 2. Public Catalog: Products, categories, and reviews are publicly viewable
-- 3. Cart Isolation: Shopping carts are private to each customer
-- 4. Order Security: Orders and payment info are private
-- 5. Admin Oversight: Admins have full access for business operations
-- 6. Review Moderation: Admins can moderate inappropriate reviews
-- 7. Audit Trail: System changes are logged and admin-accessible
--
-- Different from FAIAN (Medical):
-- - Focus on shopping privacy vs. HIPAA compliance
-- - Public product catalog vs. private medical records
-- - Customer ownership vs. patient consent
--
-- Different from RAKIB (Library):
-- - Payment security vs. library circulation
-- - Product reviews vs. book ratings
-- - Shopping cart vs. borrowing queue
--
-- =====================================================
-- END OF RLS CONFIGURATION
-- =====================================================
