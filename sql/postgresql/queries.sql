-- E-Commerce Platform - SQL Queries
-- Created by: Sajid
-- Date: October 9, 2025
-- Total Queries: 18 (5 Basic + 13 Advanced)

-- =====================================
-- BASIC QUERIES (5)
-- =====================================

-- 1. SELECT with JOIN - Get all products with their category and brand
SELECT 
    p.product_name,
    p.sku,
    c.category_name,
    p.brand,
    p.price,
    p.stock_quantity,
    p.average_rating,
    p.total_reviews
FROM products p
JOIN categories c ON p.category_id = c.category_id
WHERE p.is_active = TRUE
ORDER BY p.average_rating DESC NULLS LAST, p.total_reviews DESC;

-- 2. GROUP BY - Sales summary by category
SELECT 
    c.category_name,
    COUNT(DISTINCT p.product_id) AS total_products,
    COUNT(oi.order_item_id) AS total_items_sold,
    SUM(oi.quantity) AS units_sold,
    ROUND(SUM(oi.subtotal), 2) AS total_revenue,
    ROUND(AVG(p.price), 2) AS avg_product_price,
    ROUND(AVG(p.average_rating), 2) AS avg_category_rating
FROM categories c
LEFT JOIN products p ON c.category_id = p.category_id
LEFT JOIN order_items oi ON p.product_id = oi.product_id
GROUP BY c.category_id, c.category_name
ORDER BY total_revenue DESC NULLS LAST;

-- 3. WHERE clause - Find high-value orders with details
SELECT 
    o.order_id,
    CONCAT(cu.first_name, ' ', cu.last_name) AS customer_name,
    cu.email,
    o.order_date,
    o.order_status,
    o.subtotal,
    o.tax_amount,
    o.shipping_cost,
    o.total_amount,
    o.payment_method,
    o.tracking_number
FROM orders o
JOIN customers cu ON o.customer_id = cu.customer_id
WHERE o.total_amount > 1000
   AND o.order_status != 'Cancelled'
ORDER BY o.total_amount DESC;

-- 4. ORDER BY - Top-rated products with most reviews
SELECT 
    p.product_name,
    p.brand,
    c.category_name,
    p.price,
    p.average_rating,
    p.total_reviews,
    p.stock_quantity
FROM products p
JOIN categories c ON p.category_id = c.category_id
WHERE p.total_reviews >= 10
   AND p.is_active = TRUE
ORDER BY p.average_rating DESC, p.total_reviews DESC
LIMIT 20;

-- 5. Aggregate functions - Customer statistics and segmentation
SELECT 
    COUNT(*) AS total_customers,
    COUNT(CASE WHEN account_status = 'Active' THEN 1 END) AS active_customers,
    COUNT(CASE WHEN account_status = 'Suspended' THEN 1 END) AS suspended_customers,
    SUM(total_spent) AS total_revenue,
    ROUND(AVG(total_spent), 2) AS avg_customer_value,
    MAX(total_spent) AS highest_spender_value,
    SUM(loyalty_points) AS total_loyalty_points,
    ROUND(AVG(loyalty_points), 2) AS avg_loyalty_points,
    COUNT(CASE WHEN total_spent > 2000 THEN 1 END) AS vip_customers
FROM customers;

-- =====================================
-- ADVANCED QUERIES (13)
-- =====================================

-- 6. Window Function - Customer purchase ranking and analytics
SELECT 
    customer_id,
    CONCAT(first_name, ' ', last_name) AS customer_name,
    total_spent,
    loyalty_points,
    ROW_NUMBER() OVER (ORDER BY total_spent DESC) AS spending_rank,
    RANK() OVER (ORDER BY total_spent DESC) AS spending_rank_with_ties,
    NTILE(4) OVER (ORDER BY total_spent) AS customer_quartile,
    ROUND(PERCENT_RANK() OVER (ORDER BY total_spent) * 100, 2) AS percentile,
    SUM(total_spent) OVER (ORDER BY total_spent DESC 
                          ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS cumulative_revenue,
    ROUND(AVG(total_spent) OVER (), 2) AS avg_customer_spend
FROM customers
WHERE account_status = 'Active'
ORDER BY total_spent DESC;

-- 7. CTE (Common Table Expression) - Monthly sales trends with growth
WITH monthly_sales AS (
    SELECT 
        TO_CHAR(o.order_date, 'YYYY-MM') AS month,
        COUNT(DISTINCT o.order_id) AS order_count,
        COUNT(DISTINCT o.customer_id) AS unique_customers,
        SUM(o.total_amount) AS monthly_revenue,
        AVG(o.total_amount) AS avg_order_value
    FROM orders o
    WHERE o.order_status NOT IN ('Cancelled', 'Refunded')
    GROUP BY TO_CHAR(o.order_date, 'YYYY-MM')
),
growth_calc AS (
    SELECT 
        month,
        order_count,
        unique_customers,
        ROUND(monthly_revenue, 2) AS monthly_revenue,
        ROUND(avg_order_value, 2) AS avg_order_value,
        LAG(monthly_revenue) OVER (ORDER BY month) AS prev_month_revenue,
        ROUND(monthly_revenue - LAG(monthly_revenue) OVER (ORDER BY month), 2) AS revenue_change
    FROM monthly_sales
)
SELECT 
    month,
    order_count,
    unique_customers,
    monthly_revenue,
    avg_order_value,
    prev_month_revenue,
    revenue_change,
    CASE 
        WHEN prev_month_revenue IS NULL THEN 'N/A'
        ELSE ROUND(((monthly_revenue - prev_month_revenue) / prev_month_revenue) * 100, 2)::TEXT || '%'
    END AS growth_percentage
FROM growth_calc
ORDER BY month;

-- 8. Recursive CTE - Category hierarchy with full path
WITH RECURSIVE category_tree AS (
    -- Base case: top-level categories
    SELECT 
        category_id,
        category_name,
        parent_id,
        category_name AS full_path,
        1 AS level
    FROM categories
    WHERE parent_id IS NULL
    
    UNION ALL
    
    -- Recursive case: subcategories
    SELECT 
        c.category_id,
        c.category_name,
        c.parent_id,
        ct.full_path || ' > ' || c.category_name AS full_path,
        ct.level + 1 AS level
    FROM categories c
    JOIN category_tree ct ON c.parent_id = ct.category_id
)
SELECT 
    category_id,
    category_name,
    full_path,
    level,
    REPEAT('  ', level - 1) || category_name AS indented_name
FROM category_tree
ORDER BY full_path;

-- 9. Subquery - Products performing better than category average
SELECT 
    p.product_name,
    p.brand,
    c.category_name,
    p.price,
    p.average_rating,
    p.total_reviews,
    (SELECT ROUND(AVG(average_rating), 2)
     FROM products
     WHERE category_id = p.category_id
       AND average_rating IS NOT NULL) AS category_avg_rating,
    p.average_rating - (SELECT AVG(average_rating)
                        FROM products
                        WHERE category_id = p.category_id
                          AND average_rating IS NOT NULL) AS rating_difference
FROM products p
JOIN categories c ON p.category_id = c.category_id
WHERE p.average_rating > (
    SELECT AVG(average_rating)
    FROM products
    WHERE category_id = p.category_id
      AND average_rating IS NOT NULL
)
ORDER BY rating_difference DESC;

-- 10. Complex JOIN - Complete order details with all information
SELECT 
    o.order_id,
    o.order_date,
    CONCAT(cu.first_name, ' ', cu.last_name) AS customer_name,
    cu.email AS customer_email,
    cu.loyalty_points,
    STRING_AGG(DISTINCT p.product_name, ', ' ORDER BY p.product_name) AS products_ordered,
    COUNT(DISTINCT oi.product_id) AS unique_products,
    SUM(oi.quantity) AS total_items,
    o.subtotal,
    o.tax_amount,
    o.shipping_cost,
    o.total_amount,
    o.payment_method,
    o.order_status,
    CONCAT(sa.street_address, ', ', sa.city, ', ', sa.state, ' ', sa.postal_code) AS shipping_address,
    o.tracking_number,
    o.estimated_delivery,
    o.actual_delivery
FROM orders o
JOIN customers cu ON o.customer_id = cu.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
LEFT JOIN shipping_addresses sa ON o.shipping_address_id = sa.address_id
GROUP BY 
    o.order_id, o.order_date, cu.first_name, cu.last_name, cu.email, cu.loyalty_points,
    o.subtotal, o.tax_amount, o.shipping_cost, o.total_amount, o.payment_method, 
    o.order_status, sa.street_address, sa.city, sa.state, sa.postal_code,
    o.tracking_number, o.estimated_delivery, o.actual_delivery
ORDER BY o.order_date DESC;

-- 11. Window Function - Product sales performance with running totals
WITH product_sales AS (
    SELECT 
        p.product_id,
        p.product_name,
        p.brand,
        c.category_name,
        COUNT(oi.order_item_id) AS times_sold,
        SUM(oi.quantity) AS units_sold,
        SUM(oi.subtotal) AS total_revenue,
        AVG(p.average_rating) AS avg_rating
    FROM products p
    JOIN categories c ON p.category_id = c.category_id
    LEFT JOIN order_items oi ON p.product_id = oi.product_id
    GROUP BY p.product_id, p.product_name, p.brand, c.category_name
)
SELECT 
    product_name,
    brand,
    category_name,
    times_sold,
    units_sold,
    ROUND(total_revenue, 2) AS total_revenue,
    ROUND(avg_rating, 2) AS avg_rating,
    ROW_NUMBER() OVER (ORDER BY total_revenue DESC NULLS LAST) AS revenue_rank,
    DENSE_RANK() OVER (PARTITION BY category_name ORDER BY total_revenue DESC NULLS LAST) AS category_rank,
    ROUND(SUM(total_revenue) OVER (ORDER BY total_revenue DESC NULLS LAST 
                                   ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW), 2) AS running_revenue,
    ROUND((total_revenue / SUM(total_revenue) OVER () * 100), 2) AS revenue_percentage
FROM product_sales
ORDER BY total_revenue DESC NULLS LAST;

-- 12. CTE with Multiple Levels - Customer lifetime value analysis
WITH customer_orders AS (
    SELECT 
        cu.customer_id,
        CONCAT(cu.first_name, ' ', cu.last_name) AS customer_name,
        cu.registration_date,
        cu.account_status,
        COUNT(o.order_id) AS order_count,
        SUM(o.total_amount) AS lifetime_value,
        AVG(o.total_amount) AS avg_order_value,
        MAX(o.order_date) AS last_order_date,
        MIN(o.order_date) AS first_order_date
    FROM customers cu
    LEFT JOIN orders o ON cu.customer_id = o.customer_id
        AND o.order_status NOT IN ('Cancelled', 'Refunded')
    GROUP BY cu.customer_id, cu.first_name, cu.last_name, cu.registration_date, cu.account_status
),
customer_segments AS (
    SELECT 
        *,
        CURRENT_DATE - last_order_date AS days_since_last_order,
        CASE 
            WHEN order_count = 0 THEN 'Never Purchased'
            WHEN order_count = 1 THEN 'One-Time Buyer'
            WHEN order_count BETWEEN 2 AND 5 THEN 'Regular Customer'
            WHEN order_count > 5 THEN 'VIP Customer'
        END AS customer_segment,
        CASE 
            WHEN last_order_date IS NULL THEN 'Never Ordered'
            WHEN CURRENT_DATE - last_order_date <= 30 THEN 'Active'
            WHEN CURRENT_DATE - last_order_date <= 90 THEN 'At Risk'
            ELSE 'Churned'
        END AS engagement_status
    FROM customer_orders
)
SELECT 
    customer_name,
    account_status,
    customer_segment,
    engagement_status,
    order_count,
    ROUND(lifetime_value, 2) AS lifetime_value,
    ROUND(avg_order_value, 2) AS avg_order_value,
    first_order_date,
    last_order_date,
    days_since_last_order
FROM customer_segments
ORDER BY lifetime_value DESC NULLS LAST;

-- 13. Advanced Aggregation - Product review sentiment analysis
WITH review_stats AS (
    SELECT 
        p.product_id,
        p.product_name,
        p.brand,
        COUNT(r.review_id) AS review_count,
        AVG(r.rating) AS avg_rating,
        COUNT(CASE WHEN r.rating = 5 THEN 1 END) AS five_star_count,
        COUNT(CASE WHEN r.rating = 4 THEN 1 END) AS four_star_count,
        COUNT(CASE WHEN r.rating = 3 THEN 1 END) AS three_star_count,
        COUNT(CASE WHEN r.rating <= 2 THEN 1 END) AS low_rating_count,
        COUNT(CASE WHEN r.is_verified_purchase THEN 1 END) AS verified_reviews,
        SUM(r.helpful_count) AS total_helpful_votes
    FROM products p
    LEFT JOIN reviews r ON p.product_id = r.product_id
    GROUP BY p.product_id, p.product_name, p.brand
    HAVING COUNT(r.review_id) > 0
)
SELECT 
    product_name,
    brand,
    review_count,
    ROUND(avg_rating, 2) AS avg_rating,
    five_star_count,
    four_star_count,
    three_star_count,
    low_rating_count,
    verified_reviews,
    ROUND((verified_reviews::DECIMAL / review_count * 100), 1) AS verified_percentage,
    total_helpful_votes,
    ROUND((five_star_count::DECIMAL / review_count * 100), 1) AS positive_sentiment_pct,
    CASE 
        WHEN (five_star_count + four_star_count)::DECIMAL / review_count >= 0.8 THEN 'Excellent'
        WHEN (five_star_count + four_star_count)::DECIMAL / review_count >= 0.6 THEN 'Good'
        WHEN (five_star_count + four_star_count)::DECIMAL / review_count >= 0.4 THEN 'Mixed'
        ELSE 'Poor'
    END AS sentiment_category
FROM review_stats
ORDER BY avg_rating DESC, review_count DESC;

-- 14. Complex Subquery - Inventory reorder recommendations
SELECT 
    p.product_id,
    p.product_name,
    p.sku,
    c.category_name,
    p.stock_quantity,
    p.reorder_level,
    p.stock_quantity - p.reorder_level AS stock_buffer,
    (SELECT COUNT(*)
     FROM order_items oi
     JOIN orders o ON oi.order_id = o.order_id
     WHERE oi.product_id = p.product_id
       AND o.order_date >= CURRENT_DATE - INTERVAL '30 days'
       AND o.order_status NOT IN ('Cancelled', 'Refunded')) AS orders_last_30_days,
    (SELECT COALESCE(SUM(oi.quantity), 0)
     FROM order_items oi
     JOIN orders o ON oi.order_id = o.order_id
     WHERE oi.product_id = p.product_id
       AND o.order_date >= CURRENT_DATE - INTERVAL '30 days'
       AND o.order_status NOT IN ('Cancelled', 'Refunded')) AS units_sold_last_30_days,
    ROUND((SELECT COALESCE(AVG(oi.quantity), 0)
           FROM order_items oi
           JOIN orders o ON oi.order_id = o.order_id
           WHERE oi.product_id = p.product_id
             AND o.order_status NOT IN ('Cancelled', 'Refunded')), 2) AS avg_order_quantity,
    CASE 
        WHEN p.stock_quantity < p.reorder_level THEN 'URGENT: Reorder Now'
        WHEN p.stock_quantity < p.reorder_level * 1.5 THEN 'WARNING: Low Stock'
        ELSE 'OK'
    END AS stock_status
FROM products p
JOIN categories c ON p.category_id = c.category_id
WHERE p.is_active = TRUE
ORDER BY 
    CASE 
        WHEN p.stock_quantity < p.reorder_level THEN 1
        WHEN p.stock_quantity < p.reorder_level * 1.5 THEN 2
        ELSE 3
    END,
    (p.stock_quantity - p.reorder_level);

-- 15. Window Function - Customer purchase frequency and patterns
WITH customer_purchase_intervals AS (
    SELECT 
        cu.customer_id,
        CONCAT(cu.first_name, ' ', cu.last_name) AS customer_name,
        o.order_id,
        o.order_date,
        o.total_amount,
        ROW_NUMBER() OVER (PARTITION BY cu.customer_id ORDER BY o.order_date) AS purchase_number,
        LAG(o.order_date) OVER (PARTITION BY cu.customer_id ORDER BY o.order_date) AS previous_order_date,
        o.order_date - LAG(o.order_date) OVER (PARTITION BY cu.customer_id ORDER BY o.order_date) AS days_between_orders
    FROM customers cu
    JOIN orders o ON cu.customer_id = o.customer_id
    WHERE o.order_status NOT IN ('Cancelled', 'Refunded')
)
SELECT 
    customer_id,
    customer_name,
    COUNT(*) AS total_orders,
    ROUND(AVG(total_amount), 2) AS avg_order_value,
    MIN(order_date) AS first_purchase,
    MAX(order_date) AS last_purchase,
    ROUND(AVG(days_between_orders), 1) AS avg_days_between_orders,
    MIN(days_between_orders) AS shortest_interval,
    MAX(days_between_orders) AS longest_interval,
    CASE 
        WHEN AVG(days_between_orders) <= 30 THEN 'Very Frequent'
        WHEN AVG(days_between_orders) <= 60 THEN 'Frequent'
        WHEN AVG(days_between_orders) <= 90 THEN 'Occasional'
        ELSE 'Rare'
    END AS purchase_frequency
FROM customer_purchase_intervals
WHERE previous_order_date IS NOT NULL
GROUP BY customer_id, customer_name
HAVING COUNT(*) > 1
ORDER BY avg_days_between_orders;

-- 16. Advanced JOIN - Shopping cart abandonment analysis
SELECT 
    cu.customer_id,
    CONCAT(cu.first_name, ' ', cu.last_name) AS customer_name,
    cu.email,
    COUNT(DISTINCT ci.product_id) AS items_in_cart,
    SUM(ci.quantity) AS total_quantity,
    STRING_AGG(DISTINCT p.product_name, ', ' ORDER BY p.product_name) AS cart_products,
    SUM(p.price * ci.quantity) AS estimated_cart_value,
    MAX(ci.updated_at) AS last_cart_update,
    CURRENT_TIMESTAMP - MAX(ci.updated_at) AS time_since_update,
    (SELECT COUNT(*)
     FROM orders o
     WHERE o.customer_id = cu.customer_id
       AND o.order_date >= MAX(ci.added_at)) AS orders_since_cart_creation,
    CASE 
        WHEN CURRENT_TIMESTAMP - MAX(ci.updated_at) > INTERVAL '7 days' THEN 'Abandoned (7+ days)'
        WHEN CURRENT_TIMESTAMP - MAX(ci.updated_at) > INTERVAL '3 days' THEN 'At Risk (3-7 days)'
        WHEN CURRENT_TIMESTAMP - MAX(ci.updated_at) > INTERVAL '1 day' THEN 'Recent (1-3 days)'
        ELSE 'Active (<1 day)'
    END AS cart_status
FROM customers cu
JOIN cart_items ci ON cu.customer_id = ci.customer_id
JOIN products p ON ci.product_id = p.product_id
GROUP BY cu.customer_id, cu.first_name, cu.last_name, cu.email
ORDER BY estimated_cart_value DESC;

-- 17. CTE - Cross-sell and product affinity analysis
WITH product_pairs AS (
    SELECT 
        oi1.product_id AS product_a,
        oi2.product_id AS product_b,
        COUNT(DISTINCT oi1.order_id) AS times_bought_together
    FROM order_items oi1
    JOIN order_items oi2 ON oi1.order_id = oi2.order_id
        AND oi1.product_id < oi2.product_id
    GROUP BY oi1.product_id, oi2.product_id
    HAVING COUNT(DISTINCT oi1.order_id) >= 2
)
SELECT 
    p1.product_name AS product_a_name,
    p1.brand AS product_a_brand,
    p2.product_name AS product_b_name,
    p2.brand AS product_b_brand,
    pp.times_bought_together,
    ROUND(p1.price + p2.price, 2) AS bundle_price,
    CASE 
        WHEN pp.times_bought_together >= 5 THEN 'Strong Affinity'
        WHEN pp.times_bought_together >= 3 THEN 'Moderate Affinity'
        ELSE 'Weak Affinity'
    END AS affinity_strength
FROM product_pairs pp
JOIN products p1 ON pp.product_a = p1.product_id
JOIN products p2 ON pp.product_b = p2.product_id
ORDER BY pp.times_bought_together DESC, bundle_price DESC;

-- 18. Advanced Window Function - Revenue contribution and Pareto analysis (80/20 rule)
WITH product_revenue AS (
    SELECT 
        p.product_id,
        p.product_name,
        p.brand,
        c.category_name,
        COALESCE(SUM(oi.subtotal), 0) AS total_revenue
    FROM products p
    JOIN categories c ON p.category_id = c.category_id
    LEFT JOIN order_items oi ON p.product_id = oi.product_id
    LEFT JOIN orders o ON oi.order_id = o.order_id
        AND o.order_status NOT IN ('Cancelled', 'Refunded')
    GROUP BY p.product_id, p.product_name, p.brand, c.category_name
),
revenue_analysis AS (
    SELECT 
        product_name,
        brand,
        category_name,
        total_revenue,
        ROW_NUMBER() OVER (ORDER BY total_revenue DESC) AS revenue_rank,
        SUM(total_revenue) OVER () AS overall_revenue,
        SUM(total_revenue) OVER (ORDER BY total_revenue DESC 
                                ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS cumulative_revenue,
        COUNT(*) OVER () AS total_products
    FROM product_revenue
    WHERE total_revenue > 0
)
SELECT 
    revenue_rank,
    product_name,
    brand,
    category_name,
    ROUND(total_revenue, 2) AS total_revenue,
    ROUND((total_revenue / overall_revenue * 100), 2) AS revenue_percentage,
    ROUND((cumulative_revenue / overall_revenue * 100), 2) AS cumulative_percentage,
    ROUND((revenue_rank::DECIMAL / total_products * 100), 2) AS product_percentile,
    CASE 
        WHEN (cumulative_revenue / overall_revenue) <= 0.80 THEN '★ Top 80% Revenue (Vital Few)'
        ELSE 'Bottom 20% Revenue (Trivial Many)'
    END AS pareto_category
FROM revenue_analysis
ORDER BY revenue_rank;
