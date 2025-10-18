-- E-Commerce Platform - Roles and Row-Level Security
-- Created by: Sajid
-- Date: October 9, 2025

-- =====================================
-- DATABASE ROLES CREATION
-- =====================================

-- Create custom roles for the e-commerce platform
CREATE ROLE ecommerce_admin;
CREATE ROLE ecommerce_manager;
CREATE ROLE ecommerce_customer;
CREATE ROLE ecommerce_readonly;

-- =====================================
-- ROLE PERMISSIONS - ADMIN
-- =====================================

-- Admins have full access to everything
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO ecommerce_admin;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO ecommerce_admin;
GRANT ALL PRIVILEGES ON ALL FUNCTIONS IN SCHEMA public TO ecommerce_admin;
ALTER ROLE ecommerce_admin WITH CREATEROLE;

-- =====================================
-- ROLE PERMISSIONS - MANAGER
-- =====================================

-- Managers can manage products, categories, orders, and view customer data
-- Full access to product management
GRANT SELECT, INSERT, UPDATE, DELETE ON products TO ecommerce_manager;
GRANT SELECT, INSERT, UPDATE, DELETE ON categories TO ecommerce_manager;
GRANT SELECT, INSERT, UPDATE, DELETE ON product_images TO ecommerce_manager;

-- Full access to order management
GRANT SELECT, INSERT, UPDATE ON orders TO ecommerce_manager;
GRANT SELECT, INSERT, UPDATE ON order_items TO ecommerce_manager;
GRANT SELECT, UPDATE ON payment_transactions TO ecommerce_manager;

-- Can view and update customer information (but not delete)
GRANT SELECT, UPDATE ON customers TO ecommerce_manager;
GRANT SELECT ON shipping_addresses TO ecommerce_manager;

-- Can view reviews
GRANT SELECT, UPDATE ON reviews TO ecommerce_manager;

-- View audit logs
GRANT SELECT ON audit_log TO ecommerce_manager;

-- View cart items
GRANT SELECT ON cart_items TO ecommerce_manager;

-- Sequence permissions for auto-incrementing IDs
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO ecommerce_manager;

-- Can use all views
GRANT SELECT ON v_product_catalog TO ecommerce_manager;
GRANT SELECT ON v_customer_orders TO ecommerce_manager;
GRANT SELECT ON v_active_carts TO ecommerce_manager;
GRANT SELECT ON v_product_reviews TO ecommerce_manager;
GRANT SELECT ON v_low_stock_alert TO ecommerce_manager;
GRANT SELECT ON v_customer_lifetime_value TO ecommerce_manager;
GRANT SELECT ON v_order_fulfillment TO ecommerce_manager;
GRANT SELECT ON mv_sales_analytics TO ecommerce_manager;
GRANT SELECT ON mv_product_performance TO ecommerce_manager;

-- Function permissions
GRANT EXECUTE ON FUNCTION refresh_materialized_views() TO ecommerce_manager;
GRANT EXECUTE ON FUNCTION calculate_shipping_cost(DECIMAL, VARCHAR) TO ecommerce_manager;
GRANT EXECUTE ON FUNCTION calculate_loyalty_discount(INTEGER, DECIMAL) TO ecommerce_manager;

-- =====================================
-- ROLE PERMISSIONS - CUSTOMER
-- =====================================

-- Customers can view products and manage their own data
-- View products and categories
GRANT SELECT ON products TO ecommerce_customer;
GRANT SELECT ON categories TO ecommerce_customer;
GRANT SELECT ON product_images TO ecommerce_customer;

-- Can view all reviews
GRANT SELECT ON reviews TO ecommerce_customer;

-- Can manage their own reviews (RLS will enforce)
GRANT INSERT, UPDATE, DELETE ON reviews TO ecommerce_customer;

-- View their own customer info (RLS will enforce)
GRANT SELECT, UPDATE ON customers TO ecommerce_customer;

-- Manage their own shipping addresses (RLS will enforce)
GRANT SELECT, INSERT, UPDATE, DELETE ON shipping_addresses TO ecommerce_customer;

-- Manage their own cart (RLS will enforce)
GRANT SELECT, INSERT, UPDATE, DELETE ON cart_items TO ecommerce_customer;

-- View their own orders (RLS will enforce)
GRANT SELECT ON orders TO ecommerce_customer;
GRANT SELECT ON order_items TO ecommerce_customer;
GRANT SELECT ON payment_transactions TO ecommerce_customer;

-- Can place orders (but manager approves)
GRANT INSERT ON orders TO ecommerce_customer;
GRANT INSERT ON order_items TO ecommerce_customer;
GRANT INSERT ON payment_transactions TO ecommerce_customer;

-- Sequence permissions
GRANT USAGE, SELECT ON SEQUENCE customers_customer_id_seq TO ecommerce_customer;
GRANT USAGE, SELECT ON SEQUENCE orders_order_id_seq TO ecommerce_customer;
GRANT USAGE, SELECT ON SEQUENCE order_items_order_item_id_seq TO ecommerce_customer;
GRANT USAGE, SELECT ON SEQUENCE shipping_addresses_address_id_seq TO ecommerce_customer;
GRANT USAGE, SELECT ON SEQUENCE cart_items_cart_item_id_seq TO ecommerce_customer;
GRANT USAGE, SELECT ON SEQUENCE reviews_review_id_seq TO ecommerce_customer;
GRANT USAGE, SELECT ON SEQUENCE payment_transactions_transaction_id_seq TO ecommerce_customer;

-- Can use public views
GRANT SELECT ON v_product_catalog TO ecommerce_customer;
GRANT SELECT ON v_product_reviews TO ecommerce_customer;

-- Function permissions
GRANT EXECUTE ON FUNCTION get_recommended_products(INTEGER, INTEGER) TO ecommerce_customer;
GRANT EXECUTE ON FUNCTION calculate_shipping_cost(DECIMAL, VARCHAR) TO ecommerce_customer;
GRANT EXECUTE ON FUNCTION calculate_loyalty_discount(INTEGER, DECIMAL) TO ecommerce_customer;

-- =====================================
-- ROLE PERMISSIONS - READ ONLY
-- =====================================

-- Read-only access for reports and analytics (no sensitive data)
GRANT SELECT ON products TO ecommerce_readonly;
GRANT SELECT ON categories TO ecommerce_readonly;
GRANT SELECT ON product_images TO ecommerce_readonly;
GRANT SELECT ON reviews TO ecommerce_readonly;
GRANT SELECT ON v_product_catalog TO ecommerce_readonly;
GRANT SELECT ON v_product_reviews TO ecommerce_readonly;
GRANT SELECT ON mv_sales_analytics TO ecommerce_readonly;
GRANT SELECT ON mv_product_performance TO ecommerce_readonly;

-- =====================================
-- ROW LEVEL SECURITY (RLS) POLICIES
-- =====================================

-- Enable RLS on sensitive tables
ALTER TABLE customers ENABLE ROW LEVEL SECURITY;
ALTER TABLE orders ENABLE ROW LEVEL SECURITY;
ALTER TABLE order_items ENABLE ROW LEVEL SECURITY;
ALTER TABLE cart_items ENABLE ROW LEVEL SECURITY;
ALTER TABLE shipping_addresses ENABLE ROW LEVEL SECURITY;
ALTER TABLE reviews ENABLE ROW LEVEL SECURITY;
ALTER TABLE payment_transactions ENABLE ROW LEVEL SECURITY;
ALTER TABLE audit_log ENABLE ROW LEVEL SECURITY;

-- =====================================
-- CUSTOMER RLS POLICIES
-- =====================================

-- Policy 1: Customers can only see their own information
CREATE POLICY customer_view_own_data ON customers
    FOR SELECT
    TO ecommerce_customer
    USING (customer_id = current_setting('app.current_customer_id')::INTEGER);

-- Policy 2: Customers can update their own information
CREATE POLICY customer_update_own_data ON customers
    FOR UPDATE
    TO ecommerce_customer
    USING (customer_id = current_setting('app.current_customer_id')::INTEGER)
    WITH CHECK (customer_id = current_setting('app.current_customer_id')::INTEGER);

-- Policy 3: Managers and admins can see all customers
CREATE POLICY manager_view_all_customers ON customers
    FOR SELECT
    TO ecommerce_manager, ecommerce_admin
    USING (true);

-- Policy 4: Admins can update all customers
CREATE POLICY admin_update_all_customers ON customers
    FOR UPDATE
    TO ecommerce_admin
    USING (true)
    WITH CHECK (true);

-- =====================================
-- ORDER RLS POLICIES
-- =====================================

-- Policy 5: Customers can only see their own orders
CREATE POLICY customer_view_own_orders ON orders
    FOR SELECT
    TO ecommerce_customer
    USING (customer_id = current_setting('app.current_customer_id')::INTEGER);

-- Policy 6: Customers can create their own orders
CREATE POLICY customer_create_own_orders ON orders
    FOR INSERT
    TO ecommerce_customer
    WITH CHECK (customer_id = current_setting('app.current_customer_id')::INTEGER);

-- Policy 7: Managers and admins can see all orders
CREATE POLICY manager_view_all_orders ON orders
    FOR SELECT
    TO ecommerce_manager, ecommerce_admin
    USING (true);

-- Policy 8: Managers and admins can update all orders
CREATE POLICY manager_update_all_orders ON orders
    FOR UPDATE
    TO ecommerce_manager, ecommerce_admin
    USING (true)
    WITH CHECK (true);

-- =====================================
-- ORDER ITEMS RLS POLICIES
-- =====================================

-- Policy 9: Customers can view order items for their orders
CREATE POLICY customer_view_own_order_items ON order_items
    FOR SELECT
    TO ecommerce_customer
    USING (order_id IN (
        SELECT order_id FROM orders 
        WHERE customer_id = current_setting('app.current_customer_id')::INTEGER
    ));

-- Policy 10: Customers can insert order items for their orders
CREATE POLICY customer_create_own_order_items ON order_items
    FOR INSERT
    TO ecommerce_customer
    WITH CHECK (order_id IN (
        SELECT order_id FROM orders 
        WHERE customer_id = current_setting('app.current_customer_id')::INTEGER
    ));

-- Policy 11: Managers can view and modify all order items
CREATE POLICY manager_manage_order_items ON order_items
    FOR ALL
    TO ecommerce_manager, ecommerce_admin
    USING (true)
    WITH CHECK (true);

-- =====================================
-- CART RLS POLICIES
-- =====================================

-- Policy 12: Customers can only manage their own cart
CREATE POLICY customer_manage_own_cart ON cart_items
    FOR ALL
    TO ecommerce_customer
    USING (customer_id = current_setting('app.current_customer_id')::INTEGER)
    WITH CHECK (customer_id = current_setting('app.current_customer_id')::INTEGER);

-- Policy 13: Managers can view all carts
CREATE POLICY manager_view_all_carts ON cart_items
    FOR SELECT
    TO ecommerce_manager, ecommerce_admin
    USING (true);

-- =====================================
-- SHIPPING ADDRESS RLS POLICIES
-- =====================================

-- Policy 14: Customers can only manage their own addresses
CREATE POLICY customer_manage_own_addresses ON shipping_addresses
    FOR ALL
    TO ecommerce_customer
    USING (customer_id = current_setting('app.current_customer_id')::INTEGER)
    WITH CHECK (customer_id = current_setting('app.current_customer_id')::INTEGER);

-- Policy 15: Managers can view all addresses
CREATE POLICY manager_view_all_addresses ON shipping_addresses
    FOR SELECT
    TO ecommerce_manager, ecommerce_admin
    USING (true);

-- =====================================
-- REVIEW RLS POLICIES
-- =====================================

-- Policy 16: Everyone can view all reviews
CREATE POLICY public_view_reviews ON reviews
    FOR SELECT
    TO ecommerce_customer, ecommerce_manager, ecommerce_admin, ecommerce_readonly
    USING (true);

-- Policy 17: Customers can create reviews (verified purchase check in trigger)
CREATE POLICY customer_create_reviews ON reviews
    FOR INSERT
    TO ecommerce_customer
    WITH CHECK (customer_id = current_setting('app.current_customer_id')::INTEGER);

-- Policy 18: Customers can update/delete their own reviews
CREATE POLICY customer_manage_own_reviews ON reviews
    FOR ALL
    TO ecommerce_customer
    USING (customer_id = current_setting('app.current_customer_id')::INTEGER)
    WITH CHECK (customer_id = current_setting('app.current_customer_id')::INTEGER);

-- Policy 19: Managers can moderate all reviews
CREATE POLICY manager_manage_reviews ON reviews
    FOR UPDATE
    TO ecommerce_manager, ecommerce_admin
    USING (true)
    WITH CHECK (true);

-- =====================================
-- PAYMENT TRANSACTION RLS POLICIES
-- =====================================

-- Policy 20: Customers can view their own payment transactions
CREATE POLICY customer_view_own_payments ON payment_transactions
    FOR SELECT
    TO ecommerce_customer
    USING (order_id IN (
        SELECT order_id FROM orders 
        WHERE customer_id = current_setting('app.current_customer_id')::INTEGER
    ));

-- Policy 21: Customers can create payment transactions for their orders
CREATE POLICY customer_create_own_payments ON payment_transactions
    FOR INSERT
    TO ecommerce_customer
    WITH CHECK (order_id IN (
        SELECT order_id FROM orders 
        WHERE customer_id = current_setting('app.current_customer_id')::INTEGER
    ));

-- Policy 22: Managers can view and update all payment transactions
CREATE POLICY manager_manage_payments ON payment_transactions
    FOR ALL
    TO ecommerce_manager, ecommerce_admin
    USING (true)
    WITH CHECK (true);

-- =====================================
-- AUDIT LOG RLS POLICIES
-- =====================================

-- Policy 23: Only admins can view audit logs
CREATE POLICY admin_view_audit_log ON audit_log
    FOR SELECT
    TO ecommerce_admin
    USING (true);

-- Policy 24: Managers can view audit logs (read-only)
CREATE POLICY manager_view_audit_log ON audit_log
    FOR SELECT
    TO ecommerce_manager
    USING (true);

-- =====================================
-- HELPER FUNCTIONS FOR RLS
-- =====================================

-- Function to set current customer session variable
CREATE OR REPLACE FUNCTION set_current_customer(p_customer_id INTEGER)
RETURNS VOID AS $$
BEGIN
    PERFORM set_config('app.current_customer_id', p_customer_id::TEXT, false);
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Function to get current customer from session
CREATE OR REPLACE FUNCTION get_current_customer()
RETURNS INTEGER AS $$
BEGIN
    RETURN current_setting('app.current_customer_id', true)::INTEGER;
EXCEPTION
    WHEN OTHERS THEN
        RETURN NULL;
END;
$$ LANGUAGE plpgsql;

-- Function to check if customer can review product (must have purchased)
CREATE OR REPLACE FUNCTION can_review_product(p_customer_id INTEGER, p_product_id INTEGER)
RETURNS BOOLEAN AS $$
BEGIN
    RETURN EXISTS (
        SELECT 1
        FROM orders o
        JOIN order_items oi ON o.order_id = oi.order_id
        WHERE o.customer_id = p_customer_id
          AND oi.product_id = p_product_id
          AND o.order_status = 'Delivered'
    );
END;
$$ LANGUAGE plpgsql;

-- =====================================
-- GRANT PERMISSIONS ON HELPER FUNCTIONS
-- =====================================

GRANT EXECUTE ON FUNCTION set_current_customer(INTEGER) TO ecommerce_customer;
GRANT EXECUTE ON FUNCTION get_current_customer() TO ecommerce_customer;
GRANT EXECUTE ON FUNCTION can_review_product(INTEGER, INTEGER) TO ecommerce_customer;

-- =====================================
-- USAGE EXAMPLES
-- =====================================

/*
-- Example 1: Set current customer session (app login)
SELECT set_current_customer(1); -- Customer ID 1 logs in

-- Example 2: Customer views their own data
SELECT * FROM customers; -- Will only see their own record

-- Example 3: Customer views their orders
SELECT * FROM orders; -- Will only see their own orders

-- Example 4: Customer adds item to cart
INSERT INTO cart_items (customer_id, product_id, quantity)
VALUES (1, 5, 2); -- Will succeed if current_customer_id = 1

-- Example 5: Check if customer can review a product
SELECT can_review_product(1, 3); -- Returns true if customer 1 purchased product 3

-- Example 6: Manager views all customers (no RLS restrictions)
SET ROLE ecommerce_manager;
SELECT * FROM customers; -- Sees all customers

-- Example 7: Refresh materialized views (manager)
SELECT refresh_materialized_views();
*/

-- =====================================
-- COMMENTS
-- =====================================

COMMENT ON ROLE ecommerce_admin IS 'Full administrative access to all e-commerce platform functions';
COMMENT ON ROLE ecommerce_manager IS 'Store manager with access to products, orders, and customer management';
COMMENT ON ROLE ecommerce_customer IS 'Customer role with restricted access to own data only';
COMMENT ON ROLE ecommerce_readonly IS 'Read-only access for reporting and analytics (non-sensitive data)';

COMMENT ON FUNCTION set_current_customer(INTEGER) IS 'Sets the current customer ID in session for RLS enforcement';
COMMENT ON FUNCTION get_current_customer() IS 'Gets the current customer ID from session';
COMMENT ON FUNCTION can_review_product(INTEGER, INTEGER) IS 'Checks if a customer has purchased and can review a product';
