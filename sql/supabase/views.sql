-- E-Commerce Platform - Views and Materialized Views
-- Created by: Sajid
-- Date: October 9, 2025

-- =====================================
-- REGULAR VIEWS
-- =====================================

-- View 1: Product Catalog - Complete product information with images and ratings
CREATE OR REPLACE VIEW v_product_catalog AS
SELECT 
    p.product_id,
    p.product_name,
    p.sku,
    p.brand,
    c.category_name,
    parent_cat.category_name AS parent_category,
    p.description,
    p.price,
    p.stock_quantity,
    p.is_active,
    p.featured,
    p.average_rating,
    p.total_reviews,
    p.weight_kg,
    p.dimensions,
    (SELECT image_url FROM product_images WHERE product_id = p.product_id AND is_primary = TRUE LIMIT 1) AS primary_image_url,
    (SELECT COUNT(*) FROM product_images WHERE product_id = p.product_id) AS total_images,
    CASE 
        WHEN p.stock_quantity = 0 THEN 'Out of Stock'
        WHEN p.stock_quantity < p.reorder_level THEN 'Low Stock'
        ELSE 'In Stock'
    END AS stock_status,
    p.created_at
FROM products p
JOIN categories c ON p.category_id = c.category_id
LEFT JOIN categories parent_cat ON c.parent_id = parent_cat.category_id
ORDER BY p.product_name;

-- View 2: Customer Orders Summary - Complete order history with customer details
CREATE OR REPLACE VIEW v_customer_orders AS
SELECT 
    o.order_id,
    o.order_date,
    o.order_status,
    cu.customer_id,
    CONCAT(cu.first_name, ' ', cu.last_name) AS customer_name,
    cu.email AS customer_email,
    cu.phone AS customer_phone,
    cu.account_status,
    cu.loyalty_points,
    o.subtotal,
    o.tax_amount,
    o.shipping_cost,
    o.total_amount,
    o.payment_method,
    COUNT(oi.order_item_id) AS item_count,
    SUM(oi.quantity) AS total_quantity,
    STRING_AGG(DISTINCT p.product_name, ', ' ORDER BY p.product_name) AS products,
    CONCAT(sa.street_address, ', ', sa.city, ', ', sa.state, ' ', sa.postal_code) AS shipping_address,
    o.tracking_number,
    o.estimated_delivery,
    o.actual_delivery,
    pt.transaction_status AS payment_status,
    pt.payment_gateway,
    o.created_at
FROM orders o
JOIN customers cu ON o.customer_id = cu.customer_id
LEFT JOIN order_items oi ON o.order_id = oi.order_id
LEFT JOIN products p ON oi.product_id = p.product_id
LEFT JOIN shipping_addresses sa ON o.shipping_address_id = sa.address_id
LEFT JOIN payment_transactions pt ON o.order_id = pt.order_id
GROUP BY 
    o.order_id, o.order_date, o.order_status, cu.customer_id, cu.first_name, cu.last_name,
    cu.email, cu.phone, cu.account_status, cu.loyalty_points, o.subtotal, o.tax_amount,
    o.shipping_cost, o.total_amount, o.payment_method, sa.street_address, sa.city,
    sa.state, sa.postal_code, o.tracking_number, o.estimated_delivery, o.actual_delivery,
    pt.transaction_status, pt.payment_gateway, o.created_at
ORDER BY o.order_date DESC;

-- View 3: Active Shopping Carts - Current cart contents with product details
CREATE OR REPLACE VIEW v_active_carts AS
SELECT 
    ci.cart_item_id,
    cu.customer_id,
    CONCAT(cu.first_name, ' ', cu.last_name) AS customer_name,
    cu.email,
    p.product_id,
    p.product_name,
    p.brand,
    p.price,
    ci.quantity,
    (p.price * ci.quantity) AS line_total,
    p.stock_quantity,
    CASE 
        WHEN p.stock_quantity >= ci.quantity THEN TRUE
        ELSE FALSE
    END AS in_stock,
    ci.added_at,
    ci.updated_at,
    CURRENT_TIMESTAMP - ci.updated_at AS time_in_cart
FROM cart_items ci
JOIN customers cu ON ci.customer_id = cu.customer_id
JOIN products p ON ci.product_id = p.product_id
WHERE p.is_active = TRUE
ORDER BY ci.updated_at DESC;

-- View 4: Product Reviews with Customer Info
CREATE OR REPLACE VIEW v_product_reviews AS
SELECT 
    r.review_id,
    p.product_id,
    p.product_name,
    p.brand,
    c.category_name,
    r.customer_id,
    CONCAT(cu.first_name, ' ', LEFT(cu.last_name, 1), '.') AS reviewer_name,
    r.rating,
    r.review_title,
    r.review_text,
    r.is_verified_purchase,
    r.helpful_count,
    r.created_at AS review_date,
    (SELECT COUNT(*) FROM orders o
     JOIN order_items oi ON o.order_id = oi.order_id
     WHERE o.customer_id = r.customer_id 
       AND oi.product_id = r.product_id
       AND o.order_status = 'Delivered') AS times_purchased
FROM reviews r
JOIN products p ON r.product_id = p.product_id
JOIN categories c ON p.category_id = c.category_id
JOIN customers cu ON r.customer_id = cu.customer_id
ORDER BY r.created_at DESC;

-- View 5: Low Stock Alert - Products that need reordering
CREATE OR REPLACE VIEW v_low_stock_alert AS
SELECT 
    p.product_id,
    p.product_name,
    p.sku,
    p.brand,
    c.category_name,
    p.stock_quantity,
    p.reorder_level,
    p.stock_quantity - p.reorder_level AS stock_deficit,
    p.price,
    p.cost_price,
    (SELECT COUNT(*) FROM order_items oi 
     JOIN orders o ON oi.order_id = o.order_id
     WHERE oi.product_id = p.product_id 
       AND o.order_date >= CURRENT_DATE - INTERVAL '30 days'
       AND o.order_status NOT IN ('Cancelled', 'Refunded')) AS orders_last_30_days,
    (SELECT COALESCE(SUM(oi.quantity), 0) FROM order_items oi 
     JOIN orders o ON oi.order_id = o.order_id
     WHERE oi.product_id = p.product_id 
       AND o.order_date >= CURRENT_DATE - INTERVAL '30 days'
       AND o.order_status NOT IN ('Cancelled', 'Refunded')) AS units_sold_last_30_days,
    CASE 
        WHEN p.stock_quantity = 0 THEN 'CRITICAL: Out of Stock'
        WHEN p.stock_quantity < p.reorder_level * 0.5 THEN 'URGENT: Reorder Immediately'
        WHEN p.stock_quantity < p.reorder_level THEN 'WARNING: Below Reorder Level'
        ELSE 'OK'
    END AS priority_level
FROM products p
JOIN categories c ON p.category_id = c.category_id
WHERE p.is_active = TRUE
  AND p.stock_quantity <= p.reorder_level
ORDER BY 
    CASE 
        WHEN p.stock_quantity = 0 THEN 1
        WHEN p.stock_quantity < p.reorder_level * 0.5 THEN 2
        WHEN p.stock_quantity < p.reorder_level THEN 3
        ELSE 4
    END,
    p.stock_quantity;

-- View 6: Customer Lifetime Value Analysis
CREATE OR REPLACE VIEW v_customer_lifetime_value AS
SELECT 
    cu.customer_id,
    CONCAT(cu.first_name, ' ', cu.last_name) AS customer_name,
    cu.email,
    cu.phone,
    cu.account_status,
    cu.registration_date,
    cu.last_login,
    cu.loyalty_points,
    cu.total_spent,
    COUNT(DISTINCT o.order_id) AS total_orders,
    COALESCE(ROUND(AVG(o.total_amount), 2), 0) AS avg_order_value,
    MAX(o.order_date) AS last_order_date,
    MIN(o.order_date) AS first_order_date,
    CURRENT_DATE - MAX(o.order_date) AS days_since_last_order,
    CASE 
        WHEN COUNT(o.order_id) = 0 THEN 'Never Purchased'
        WHEN COUNT(o.order_id) = 1 THEN 'One-Time Buyer'
        WHEN COUNT(o.order_id) BETWEEN 2 AND 5 THEN 'Regular Customer'
        WHEN COUNT(o.order_id) > 5 THEN 'VIP Customer'
    END AS customer_segment,
    CASE 
        WHEN MAX(o.order_date) IS NULL THEN 'Never Ordered'
        WHEN CURRENT_DATE - MAX(o.order_date) <= 30 THEN 'Active'
        WHEN CURRENT_DATE - MAX(o.order_date) <= 90 THEN 'At Risk'
        ELSE 'Churned'
    END AS engagement_status
FROM customers cu
LEFT JOIN orders o ON cu.customer_id = o.customer_id
    AND o.order_status NOT IN ('Cancelled', 'Refunded')
GROUP BY 
    cu.customer_id, cu.first_name, cu.last_name, cu.email, cu.phone,
    cu.account_status, cu.registration_date, cu.last_login, cu.loyalty_points, cu.total_spent
ORDER BY cu.total_spent DESC;

-- View 7: Order Fulfillment Status - Track order processing
CREATE OR REPLACE VIEW v_order_fulfillment AS
SELECT 
    o.order_id,
    o.order_date,
    CONCAT(cu.first_name, ' ', cu.last_name) AS customer_name,
    o.order_status,
    o.total_amount,
    o.payment_method,
    pt.transaction_status AS payment_status,
    o.tracking_number,
    o.estimated_delivery,
    o.actual_delivery,
    CASE 
        WHEN o.order_status = 'Processing' THEN 1
        WHEN o.order_status = 'Confirmed' THEN 2
        WHEN o.order_status = 'Shipped' THEN 3
        WHEN o.order_status = 'Delivered' THEN 4
        ELSE 0
    END AS fulfillment_stage,
    CASE 
        WHEN o.actual_delivery IS NOT NULL THEN 
            o.actual_delivery - o.order_date
        WHEN o.order_status = 'Shipped' THEN 
            CURRENT_DATE - o.order_date
        ELSE NULL
    END AS days_to_fulfill,
    CASE 
        WHEN o.actual_delivery IS NOT NULL AND o.actual_delivery > o.estimated_delivery THEN 'Late'
        WHEN o.actual_delivery IS NOT NULL AND o.actual_delivery <= o.estimated_delivery THEN 'On Time'
        WHEN o.order_status = 'Shipped' AND CURRENT_DATE > o.estimated_delivery THEN 'Expected Late'
        WHEN o.order_status IN ('Processing', 'Confirmed') AND CURRENT_DATE > o.estimated_delivery - 2 THEN 'At Risk'
        ELSE 'On Track'
    END AS delivery_status
FROM orders o
JOIN customers cu ON o.customer_id = cu.customer_id
LEFT JOIN payment_transactions pt ON o.order_id = pt.order_id
WHERE o.order_status NOT IN ('Cancelled', 'Refunded')
ORDER BY o.order_date DESC;

-- =====================================
-- MATERIALIZED VIEWS (For Performance)
-- =====================================

-- Materialized View 1: Sales Analytics Dashboard
CREATE MATERIALIZED VIEW mv_sales_analytics AS
WITH daily_stats AS (
    SELECT 
        o.order_date,
        COUNT(DISTINCT o.order_id) AS orders_count,
        COUNT(DISTINCT o.customer_id) AS unique_customers,
        SUM(o.total_amount) AS revenue,
        AVG(o.total_amount) AS avg_order_value,
        SUM(oi.quantity) AS units_sold
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    WHERE o.order_status NOT IN ('Cancelled', 'Refunded')
    GROUP BY o.order_date
),
category_stats AS (
    SELECT 
        c.category_id,
        c.category_name,
        COUNT(DISTINCT oi.order_id) AS orders_count,
        SUM(oi.quantity) AS units_sold,
        SUM(oi.subtotal) AS revenue,
        COUNT(DISTINCT p.product_id) AS active_products
    FROM categories c
    JOIN products p ON c.category_id = p.category_id
    LEFT JOIN order_items oi ON p.product_id = oi.product_id
    LEFT JOIN orders o ON oi.order_id = o.order_id
        AND o.order_status NOT IN ('Cancelled', 'Refunded')
    GROUP BY c.category_id, c.category_name
)
SELECT 
    'Total Sales' AS metric_category,
    'All Time' AS time_period,
    (SELECT COALESCE(SUM(revenue), 0) FROM daily_stats) AS total_revenue,
    (SELECT COALESCE(SUM(orders_count), 0) FROM daily_stats) AS total_orders,
    (SELECT COALESCE(SUM(units_sold), 0) FROM daily_stats) AS total_units,
    (SELECT COALESCE(ROUND(AVG(avg_order_value), 2), 0) FROM daily_stats) AS avg_order_value,
    (SELECT COUNT(DISTINCT customer_id) FROM customers WHERE account_status = 'Active') AS active_customers,
    CURRENT_TIMESTAMP AS last_refreshed
UNION ALL
SELECT 
    'Last 30 Days' AS metric_category,
    'Monthly' AS time_period,
    (SELECT COALESCE(SUM(revenue), 0) FROM daily_stats WHERE order_date >= CURRENT_DATE - INTERVAL '30 days') AS total_revenue,
    (SELECT COALESCE(SUM(orders_count), 0) FROM daily_stats WHERE order_date >= CURRENT_DATE - INTERVAL '30 days') AS total_orders,
    (SELECT COALESCE(SUM(units_sold), 0) FROM daily_stats WHERE order_date >= CURRENT_DATE - INTERVAL '30 days') AS total_units,
    (SELECT COALESCE(ROUND(AVG(avg_order_value), 2), 0) FROM daily_stats WHERE order_date >= CURRENT_DATE - INTERVAL '30 days') AS avg_order_value,
    (SELECT COUNT(DISTINCT customer_id) FROM orders WHERE order_date >= CURRENT_DATE - INTERVAL '30 days') AS active_customers,
    CURRENT_TIMESTAMP AS last_refreshed
UNION ALL
SELECT 
    'Category: ' || category_name AS metric_category,
    'All Time' AS time_period,
    COALESCE(revenue, 0) AS total_revenue,
    COALESCE(orders_count, 0) AS total_orders,
    COALESCE(units_sold, 0) AS total_units,
    CASE WHEN orders_count > 0 THEN ROUND(revenue / orders_count, 2) ELSE 0 END AS avg_order_value,
    active_products AS active_customers,
    CURRENT_TIMESTAMP AS last_refreshed
FROM category_stats;

-- Create index on materialized view
CREATE INDEX idx_mv_sales_category ON mv_sales_analytics(metric_category);

-- Materialized View 2: Product Performance Metrics
CREATE MATERIALIZED VIEW mv_product_performance AS
SELECT 
    p.product_id,
    p.product_name,
    p.sku,
    p.brand,
    c.category_name,
    p.price,
    p.cost_price,
    p.price - COALESCE(p.cost_price, 0) AS profit_margin,
    CASE 
        WHEN p.cost_price IS NOT NULL AND p.cost_price > 0 
        THEN ROUND(((p.price - p.cost_price) / p.price * 100), 2)
        ELSE NULL
    END AS profit_margin_percent,
    p.stock_quantity,
    p.average_rating,
    p.total_reviews,
    COALESCE(sales.total_orders, 0) AS total_orders,
    COALESCE(sales.total_quantity_sold, 0) AS total_quantity_sold,
    COALESCE(sales.total_revenue, 0) AS total_revenue,
    COALESCE(sales.total_profit, 0) AS total_profit,
    COALESCE(sales.last_30_days_orders, 0) AS orders_last_30_days,
    COALESCE(sales.last_30_days_quantity, 0) AS units_sold_last_30_days,
    COALESCE(sales.last_30_days_revenue, 0) AS revenue_last_30_days,
    CASE 
        WHEN sales.last_order_date IS NOT NULL 
        THEN CURRENT_DATE - sales.last_order_date
        ELSE NULL
    END AS days_since_last_sale,
    p.featured,
    p.is_active,
    CURRENT_TIMESTAMP AS last_refreshed
FROM products p
JOIN categories c ON p.category_id = c.category_id
LEFT JOIN (
    SELECT 
        oi.product_id,
        COUNT(DISTINCT o.order_id) AS total_orders,
        SUM(oi.quantity) AS total_quantity_sold,
        SUM(oi.subtotal) AS total_revenue,
        SUM(oi.subtotal - (oi.quantity * p2.cost_price)) AS total_profit,
        COUNT(DISTINCT CASE 
            WHEN o.order_date >= CURRENT_DATE - INTERVAL '30 days' 
            THEN o.order_id 
        END) AS last_30_days_orders,
        SUM(CASE 
            WHEN o.order_date >= CURRENT_DATE - INTERVAL '30 days' 
            THEN oi.quantity 
            ELSE 0 
        END) AS last_30_days_quantity,
        SUM(CASE 
            WHEN o.order_date >= CURRENT_DATE - INTERVAL '30 days' 
            THEN oi.subtotal 
            ELSE 0 
        END) AS last_30_days_revenue,
        MAX(o.order_date) AS last_order_date
    FROM order_items oi
    JOIN orders o ON oi.order_id = o.order_id
    JOIN products p2 ON oi.product_id = p2.product_id
    WHERE o.order_status NOT IN ('Cancelled', 'Refunded')
    GROUP BY oi.product_id
) sales ON p.product_id = sales.product_id
ORDER BY sales.total_revenue DESC NULLS LAST;

-- Create indexes on materialized view
CREATE INDEX idx_mv_product_perf_category ON mv_product_performance(category_name);
CREATE INDEX idx_mv_product_perf_revenue ON mv_product_performance(total_revenue DESC NULLS LAST);
CREATE INDEX idx_mv_product_perf_rating ON mv_product_performance(average_rating DESC NULLS LAST);

-- =====================================
-- REFRESH FUNCTIONS
-- =====================================

-- Function to refresh all materialized views
CREATE OR REPLACE FUNCTION refresh_materialized_views()
RETURNS VOID AS $$
BEGIN
    REFRESH MATERIALIZED VIEW mv_sales_analytics;
    REFRESH MATERIALIZED VIEW mv_product_performance;
    
    RAISE NOTICE 'All materialized views refreshed successfully at %', CURRENT_TIMESTAMP;
END;
$$ LANGUAGE plpgsql;

-- =====================================
-- COMMENTS
-- =====================================

COMMENT ON VIEW v_product_catalog IS 'Complete product catalog with category hierarchy and images';
COMMENT ON VIEW v_customer_orders IS 'Detailed order history with customer and product information';
COMMENT ON VIEW v_active_carts IS 'Current shopping cart contents for all customers';
COMMENT ON VIEW v_product_reviews IS 'Product reviews with customer information (anonymized)';
COMMENT ON VIEW v_low_stock_alert IS 'Products that need reordering with priority levels';
COMMENT ON VIEW v_customer_lifetime_value IS 'Customer segmentation and lifetime value analysis';
COMMENT ON VIEW v_order_fulfillment IS 'Order processing and delivery tracking status';
COMMENT ON MATERIALIZED VIEW mv_sales_analytics IS 'Pre-calculated sales metrics for dashboard performance';
COMMENT ON MATERIALIZED VIEW mv_product_performance IS 'Product performance metrics with profit calculations';
COMMENT ON FUNCTION refresh_materialized_views() IS 'Refreshes all materialized views to update cached data';
