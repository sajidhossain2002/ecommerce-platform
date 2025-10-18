-- E-Commerce Platform - Triggers
-- Created by: Sajid
-- Date: October 9, 2025

-- =====================================
-- TRIGGER FUNCTIONS
-- =====================================

-- Function 1: Update product stock when order items are created/deleted
CREATE OR REPLACE FUNCTION update_product_stock()
RETURNS TRIGGER AS $$
BEGIN
    -- When a new order item is created (INSERT)
    IF TG_OP = 'INSERT' THEN
        -- Decrease stock quantity
        UPDATE products 
        SET stock_quantity = stock_quantity - NEW.quantity
        WHERE product_id = NEW.product_id;
        
        -- Check if stock is sufficient
        IF (SELECT stock_quantity FROM products WHERE product_id = NEW.product_id) < 0 THEN
            RAISE EXCEPTION 'Insufficient stock for product ID %', NEW.product_id;
        END IF;
        
        RETURN NEW;
    END IF;
    
    -- When an order item is deleted (order cancelled)
    IF TG_OP = 'DELETE' THEN
        -- Restore stock quantity
        UPDATE products 
        SET stock_quantity = stock_quantity + OLD.quantity
        WHERE product_id = OLD.product_id;
        
        RETURN OLD;
    END IF;
    
    -- When quantity is updated
    IF TG_OP = 'UPDATE' THEN
        -- Adjust stock based on quantity change
        UPDATE products 
        SET stock_quantity = stock_quantity + OLD.quantity - NEW.quantity
        WHERE product_id = NEW.product_id;
        
        -- Check if stock is sufficient
        IF (SELECT stock_quantity FROM products WHERE product_id = NEW.product_id) < 0 THEN
            RAISE EXCEPTION 'Insufficient stock for product ID %', NEW.product_id;
        END IF;
        
        RETURN NEW;
    END IF;
    
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

-- Function 2: Update customer total spent and loyalty points
CREATE OR REPLACE FUNCTION update_customer_metrics()
RETURNS TRIGGER AS $$
DECLARE
    order_total DECIMAL(12,2);
    points_to_add INTEGER;
BEGIN
    -- When order status changes to 'Delivered'
    IF TG_OP = 'UPDATE' AND OLD.order_status != 'Delivered' AND NEW.order_status = 'Delivered' THEN
        order_total := NEW.total_amount;
        
        -- Calculate loyalty points (1 point per $1 spent)
        points_to_add := FLOOR(order_total);
        
        -- Update customer metrics
        UPDATE customers 
        SET total_spent = total_spent + order_total,
            loyalty_points = loyalty_points + points_to_add
        WHERE customer_id = NEW.customer_id;
        
        RETURN NEW;
    END IF;
    
    -- When order is refunded
    IF TG_OP = 'UPDATE' AND OLD.order_status != 'Refunded' AND NEW.order_status = 'Refunded' THEN
        order_total := NEW.total_amount;
        points_to_add := FLOOR(order_total);
        
        -- Deduct from customer metrics
        UPDATE customers 
        SET total_spent = GREATEST(total_spent - order_total, 0),
            loyalty_points = GREATEST(loyalty_points - points_to_add, 0)
        WHERE customer_id = NEW.customer_id;
        
        RETURN NEW;
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Function 3: Update product rating and review count
CREATE OR REPLACE FUNCTION update_product_rating()
RETURNS TRIGGER AS $$
DECLARE
    new_avg_rating DECIMAL(3,2);
    review_count INTEGER;
BEGIN
    -- When a review is inserted or updated
    IF TG_OP IN ('INSERT', 'UPDATE') THEN
        -- Calculate new average rating and count
        SELECT 
            ROUND(AVG(rating)::NUMERIC, 2),
            COUNT(*)
        INTO new_avg_rating, review_count
        FROM reviews
        WHERE product_id = NEW.product_id;
        
        -- Update product
        UPDATE products
        SET average_rating = new_avg_rating,
            total_reviews = review_count
        WHERE product_id = NEW.product_id;
        
        RETURN NEW;
    END IF;
    
    -- When a review is deleted
    IF TG_OP = 'DELETE' THEN
        -- Recalculate average rating
        SELECT 
            ROUND(AVG(rating)::NUMERIC, 2),
            COUNT(*)
        INTO new_avg_rating, review_count
        FROM reviews
        WHERE product_id = OLD.product_id;
        
        -- Update product (handle case where no reviews remain)
        UPDATE products
        SET average_rating = new_avg_rating,
            total_reviews = review_count
        WHERE product_id = OLD.product_id;
        
        RETURN OLD;
    END IF;
    
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

-- Function 4: Audit log for all table changes
CREATE OR REPLACE FUNCTION log_table_changes()
RETURNS TRIGGER AS $$
DECLARE
    table_name_var VARCHAR(50);
    operation_var VARCHAR(10);
    record_id_var INTEGER;
    old_values_var JSONB;
    new_values_var JSONB;
BEGIN
    table_name_var := TG_TABLE_NAME;
    operation_var := TG_OP;
    
    -- Handle INSERT
    IF TG_OP = 'INSERT' THEN
        CASE table_name_var
            WHEN 'customers' THEN 
                record_id_var := NEW.customer_id;
                new_values_var := to_jsonb(NEW);
            WHEN 'products' THEN 
                record_id_var := NEW.product_id;
                new_values_var := to_jsonb(NEW);
            WHEN 'orders' THEN 
                record_id_var := NEW.order_id;
                new_values_var := to_jsonb(NEW);
            WHEN 'reviews' THEN 
                record_id_var := NEW.review_id;
                new_values_var := to_jsonb(NEW);
            WHEN 'categories' THEN 
                record_id_var := NEW.category_id;
                new_values_var := to_jsonb(NEW);
        END CASE;
        
        INSERT INTO audit_log (table_name, operation, record_id, old_values, new_values, changed_by)
        VALUES (table_name_var, operation_var, record_id_var, NULL, new_values_var, current_user);
        
        RETURN NEW;
    END IF;
    
    -- Handle UPDATE
    IF TG_OP = 'UPDATE' THEN
        CASE table_name_var
            WHEN 'customers' THEN 
                record_id_var := NEW.customer_id;
                old_values_var := to_jsonb(OLD);
                new_values_var := to_jsonb(NEW);
            WHEN 'products' THEN 
                record_id_var := NEW.product_id;
                old_values_var := to_jsonb(OLD);
                new_values_var := to_jsonb(NEW);
            WHEN 'orders' THEN 
                record_id_var := NEW.order_id;
                old_values_var := to_jsonb(OLD);
                new_values_var := to_jsonb(NEW);
            WHEN 'reviews' THEN 
                record_id_var := NEW.review_id;
                old_values_var := to_jsonb(OLD);
                new_values_var := to_jsonb(NEW);
            WHEN 'categories' THEN 
                record_id_var := NEW.category_id;
                old_values_var := to_jsonb(OLD);
                new_values_var := to_jsonb(NEW);
        END CASE;
        
        INSERT INTO audit_log (table_name, operation, record_id, old_values, new_values, changed_by)
        VALUES (table_name_var, operation_var, record_id_var, old_values_var, new_values_var, current_user);
        
        RETURN NEW;
    END IF;
    
    -- Handle DELETE
    IF TG_OP = 'DELETE' THEN
        CASE table_name_var
            WHEN 'customers' THEN 
                record_id_var := OLD.customer_id;
                old_values_var := to_jsonb(OLD);
            WHEN 'products' THEN 
                record_id_var := OLD.product_id;
                old_values_var := to_jsonb(OLD);
            WHEN 'orders' THEN 
                record_id_var := OLD.order_id;
                old_values_var := to_jsonb(OLD);
            WHEN 'reviews' THEN 
                record_id_var := OLD.review_id;
                old_values_var := to_jsonb(OLD);
            WHEN 'categories' THEN 
                record_id_var := OLD.category_id;
                old_values_var := to_jsonb(OLD);
        END CASE;
        
        INSERT INTO audit_log (table_name, operation, record_id, old_values, new_values, changed_by)
        VALUES (table_name_var, operation_var, record_id_var, old_values_var, NULL, current_user);
        
        RETURN OLD;
    END IF;
    
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

-- Function 5: Update cart item timestamp
CREATE OR REPLACE FUNCTION update_cart_timestamp()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Function 6: Validate order total calculation
CREATE OR REPLACE FUNCTION validate_order_total()
RETURNS TRIGGER AS $$
DECLARE
    calculated_total DECIMAL(12,2);
BEGIN
    calculated_total := NEW.subtotal + NEW.tax_amount + NEW.shipping_cost;
    
    -- Check if total matches (allow for small rounding differences)
    IF ABS(NEW.total_amount - calculated_total) > 0.01 THEN
        RAISE EXCEPTION 'Order total (%) does not match calculated total (%). Subtotal: %, Tax: %, Shipping: %',
            NEW.total_amount, calculated_total, NEW.subtotal, NEW.tax_amount, NEW.shipping_cost;
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- =====================================
-- TRIGGER CREATION
-- =====================================

-- Trigger 1: Manage product stock on order item changes
DROP TRIGGER IF EXISTS trg_update_product_stock ON order_items;
CREATE TRIGGER trg_update_product_stock
    AFTER INSERT OR UPDATE OR DELETE ON order_items
    FOR EACH ROW
    EXECUTE FUNCTION update_product_stock();

-- Trigger 2: Update customer metrics when order is delivered/refunded
DROP TRIGGER IF EXISTS trg_update_customer_metrics ON orders;
CREATE TRIGGER trg_update_customer_metrics
    AFTER UPDATE ON orders
    FOR EACH ROW
    EXECUTE FUNCTION update_customer_metrics();

-- Trigger 3: Update product rating when reviews change
DROP TRIGGER IF EXISTS trg_update_product_rating ON reviews;
CREATE TRIGGER trg_update_product_rating
    AFTER INSERT OR UPDATE OR DELETE ON reviews
    FOR EACH ROW
    EXECUTE FUNCTION update_product_rating();

-- Trigger 4: Update cart timestamp on modification
DROP TRIGGER IF EXISTS trg_update_cart_timestamp ON cart_items;
CREATE TRIGGER trg_update_cart_timestamp
    BEFORE UPDATE ON cart_items
    FOR EACH ROW
    EXECUTE FUNCTION update_cart_timestamp();

-- Trigger 5: Validate order totals before insert/update
DROP TRIGGER IF EXISTS trg_validate_order_total ON orders;
CREATE TRIGGER trg_validate_order_total
    BEFORE INSERT OR UPDATE ON orders
    FOR EACH ROW
    EXECUTE FUNCTION validate_order_total();

-- Trigger 6-10: Audit logging for critical tables
DROP TRIGGER IF EXISTS trg_audit_customers ON customers;
CREATE TRIGGER trg_audit_customers
    AFTER INSERT OR UPDATE OR DELETE ON customers
    FOR EACH ROW
    EXECUTE FUNCTION log_table_changes();

DROP TRIGGER IF EXISTS trg_audit_products ON products;
CREATE TRIGGER trg_audit_products
    AFTER INSERT OR UPDATE OR DELETE ON products
    FOR EACH ROW
    EXECUTE FUNCTION log_table_changes();

DROP TRIGGER IF EXISTS trg_audit_orders ON orders;
CREATE TRIGGER trg_audit_orders
    AFTER INSERT OR UPDATE OR DELETE ON orders
    FOR EACH ROW
    EXECUTE FUNCTION log_table_changes();

DROP TRIGGER IF EXISTS trg_audit_reviews ON reviews;
CREATE TRIGGER trg_audit_reviews
    AFTER INSERT OR UPDATE OR DELETE ON reviews
    FOR EACH ROW
    EXECUTE FUNCTION log_table_changes();

DROP TRIGGER IF EXISTS trg_audit_categories ON categories;
CREATE TRIGGER trg_audit_categories
    AFTER INSERT OR UPDATE OR DELETE ON categories
    FOR EACH ROW
    EXECUTE FUNCTION log_table_changes();

-- =====================================
-- UTILITY FUNCTIONS
-- =====================================

-- Function to calculate recommended products based on purchase history
CREATE OR REPLACE FUNCTION get_recommended_products(p_customer_id INTEGER, p_limit INTEGER DEFAULT 5)
RETURNS TABLE (
    product_id INTEGER,
    product_name VARCHAR(200),
    brand VARCHAR(100),
    price DECIMAL(10,2),
    average_rating DECIMAL(3,2),
    recommendation_score INTEGER
) AS $$
BEGIN
    RETURN QUERY
    WITH customer_categories AS (
        -- Get categories the customer has purchased from
        SELECT DISTINCT p.category_id
        FROM orders o
        JOIN order_items oi ON o.order_id = oi.order_id
        JOIN products p ON oi.product_id = p.product_id
        WHERE o.customer_id = p_customer_id
    ),
    customer_products AS (
        -- Get products the customer has already purchased
        SELECT DISTINCT oi.product_id
        FROM orders o
        JOIN order_items oi ON o.order_id = oi.order_id
        WHERE o.customer_id = p_customer_id
    )
    SELECT 
        p.product_id,
        p.product_name,
        p.brand,
        p.price,
        p.average_rating,
        (CASE WHEN p.category_id IN (SELECT category_id FROM customer_categories) THEN 2 ELSE 0 END +
         CASE WHEN p.featured = TRUE THEN 1 ELSE 0 END +
         CASE WHEN p.average_rating >= 4.5 THEN 2 WHEN p.average_rating >= 4.0 THEN 1 ELSE 0 END) AS recommendation_score
    FROM products p
    WHERE p.is_active = TRUE
      AND p.stock_quantity > 0
      AND p.product_id NOT IN (SELECT product_id FROM customer_products)
    ORDER BY recommendation_score DESC, p.average_rating DESC NULLS LAST, p.total_reviews DESC
    LIMIT p_limit;
END;
$$ LANGUAGE plpgsql;

-- Function to calculate shipping cost based on order value and location
CREATE OR REPLACE FUNCTION calculate_shipping_cost(
    p_subtotal DECIMAL(12,2),
    p_state VARCHAR(50)
) RETURNS DECIMAL(10,2) AS $$
DECLARE
    shipping_cost DECIMAL(10,2);
BEGIN
    -- Free shipping for orders over $500
    IF p_subtotal >= 500 THEN
        RETURN 0.00;
    END IF;
    
    -- Standard shipping rates
    IF p_state = 'MA' THEN
        shipping_cost := 5.99;
    ELSIF p_state IN ('NY', 'CT', 'RI', 'NH', 'VT', 'ME') THEN
        shipping_cost := 8.99;
    ELSE
        shipping_cost := 12.99;
    END IF;
    
    -- Additional charge for small orders
    IF p_subtotal < 50 THEN
        shipping_cost := shipping_cost + 3.00;
    END IF;
    
    RETURN shipping_cost;
END;
$$ LANGUAGE plpgsql;

-- Function to apply loyalty discounts
CREATE OR REPLACE FUNCTION calculate_loyalty_discount(
    p_customer_id INTEGER,
    p_subtotal DECIMAL(12,2)
) RETURNS DECIMAL(10,2) AS $$
DECLARE
    loyalty_points INTEGER;
    discount DECIMAL(10,2);
BEGIN
    -- Get customer loyalty points
    SELECT loyalty_points INTO loyalty_points
    FROM customers
    WHERE customer_id = p_customer_id;
    
    -- Calculate discount (100 points = $10 discount, max 20% of order)
    discount := LEAST(
        (loyalty_points / 100) * 10,
        p_subtotal * 0.20
    );
    
    RETURN ROUND(discount, 2);
END;
$$ LANGUAGE plpgsql;

-- =====================================
-- COMMENTS
-- =====================================

COMMENT ON FUNCTION update_product_stock() IS 'Automatically updates product stock when order items are created, updated, or deleted';
COMMENT ON FUNCTION update_customer_metrics() IS 'Updates customer total_spent and loyalty_points when orders are delivered or refunded';
COMMENT ON FUNCTION update_product_rating() IS 'Recalculates product average rating and review count when reviews change';
COMMENT ON FUNCTION log_table_changes() IS 'Logs all INSERT, UPDATE, DELETE operations to audit_log table';
COMMENT ON FUNCTION update_cart_timestamp() IS 'Updates the updated_at timestamp when cart items are modified';
COMMENT ON FUNCTION validate_order_total() IS 'Validates that order total matches subtotal + tax + shipping';
COMMENT ON FUNCTION get_recommended_products(INTEGER, INTEGER) IS 'Returns recommended products for a customer based on purchase history';
COMMENT ON FUNCTION calculate_shipping_cost(DECIMAL, VARCHAR) IS 'Calculates shipping cost based on order value and destination state';
COMMENT ON FUNCTION calculate_loyalty_discount(INTEGER, DECIMAL) IS 'Calculates loyalty point discount for a customer';
