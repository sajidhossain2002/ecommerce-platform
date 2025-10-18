# Supabase Setup Guide - E-Commerce Platform

**Student:** Sajid  
**Project:** E-Commerce Platform Database  
**Database:** Supabase (PostgreSQL)  
**Last Updated:** October 2025

---

## What is Supabase and Why Use It?

Supabase is basically "PostgreSQL in the cloud" - it's a hosted database service that you access through your web browser. Think of it like Google Drive for databases instead of installing Microsoft Office.

**Why it's perfect for this e-commerce project:**
- ✨ **No installation** - works on any computer with internet
- 🚀 **Always online** - your database doesn't shut down when you close your laptop
- 💾 **Automatic backups** - never lose your product catalog or orders
- 🔐 **Built-in security** - Row Level Security works perfectly
- 📊 **Visual tools** - see your products and orders in a spreadsheet-like view
- 🆓 **Free tier** - costs nothing, perfect for student projects
- 🌐 **API included** - if you want to build a real e-commerce website later

---

## Step 1: Create Your Supabase Account

Let's get started!

1. Go to **[https://supabase.com](https://supabase.com)** in your browser
2. Click **"Start your project"** or **"Sign Up"**
3. Choose how to sign up:
   - **GitHub** (recommended - one click, no password needed)
   - **Email** (you'll need to verify)
4. If you used email, check your inbox and click the confirmation link

**First time tip:** Bookmark the Supabase dashboard - you'll be visiting it a lot!

---

## Step 2: Create Your E-Commerce Database Project

Once logged in, let's create the database:

1. Click the big green **"New Project"** button
2. First-time users need to create an **Organization:**
   - Organization name: `Your Name - Projects`
   - Click **"Create organization"**
3. Now fill in your project details:

   **Project Name:** `ecommerce-platform`  
   _(You can name it anything - this is just a label)_

   **Database Password:** Create a STRONG password  
   - Example: `EcommerceDB_2025!Secure#`
   - **IMPORTANT:** Save this password somewhere safe!
   - You'll need it to connect later
   - Don't use obvious passwords like "password" or "123456"

   **Region:** Choose the closest location:
   - 🇺🇸 `US East (Virginia)` - USA East Coast
   - 🇺🇸 `US West (Oregon)` - USA West Coast  
   - 🇪🇺 `Europe (Frankfurt)` - Europe
   - 🇸🇬 `Asia (Singapore)` - Asia/Australia

   **Pricing Plan:** `Free` (includes everything we need!)

4. Click **"Create new project"**

Now wait 2-3 minutes while Supabase provisions your PostgreSQL database. You'll see a progress animation. Perfect time to grab a snack! 🍕

---

## Step 3: Get to Know the Dashboard

Once your project is ready, you'll see the main dashboard with these sections:

- **🏠 Home** - Overview and statistics
- **📊 Table Editor** - Browse your data visually (great for seeing products/orders)
- **💻 SQL Editor** - Where we'll run our SQL scripts ← **This is key!**
- **🗄️ Database** - Connection details and backups
- **🔐 Authentication** - User login system (not needed for this project)
- **📁 Storage** - File uploads (could use for product images, but not required)
- **⚡ Edge Functions** - Serverless functions (not needed)

---

## Step 4: Save Your Connection Details

Before we build anything, let's save the database connection info:

1. Click **"Database"** in the left sidebar (cylinder icon)
2. Scroll down to **"Connection info"** or **"Connection string"**
3. You'll see details like:

```
Host: db.xyzabcdefghijk.supabase.co
Database name: postgres
Port: 5432
User: postgres
Password: [your password from Step 2]
```

**Save these in a text file!** You might need them to:
- Connect using tools like pgAdmin or DBeaver
- Build a web/mobile app later
- Share with your professor for grading

---

## Step 5: Create All Database Tables

Time to build our e-commerce database with 11 tables!

1. Click **"SQL Editor"** in the left sidebar (looks like `</>`)
2. Click **"New query"** button (top right)
3. Open the file `sql/schema.sql` from this project folder
4. Copy EVERYTHING from that file (Ctrl+A, Ctrl+C)
5. Paste it into the Supabase SQL Editor (Ctrl+V)
6. Click **"Run"** (or press Ctrl+Enter)

You should see: **"Success. No rows returned"**

This creates all 11 tables:
- ✅ **categories** (product categories with hierarchy)
- ✅ **customers** (customer accounts)
- ✅ **products** (product catalog)
- ✅ **product_images** (product photos)
- ✅ **shipping_addresses** (customer addresses)
- ✅ **cart_items** (shopping carts)
- ✅ **orders** (order headers)
- ✅ **order_items** (products in each order)
- ✅ **payment_transactions** (payment records)
- ✅ **reviews** (product reviews)
- ✅ **audit_log** (tracks all changes)

**Troubleshooting:**
- **"relation already exists"** = Table already created (you can ignore this)
- **Syntax error** = Make sure you copied the entire file
- **Permission error** = Run `GRANT ALL ON SCHEMA public TO postgres;` first
- **Need to start fresh?** = Database → Settings → Reset Database (⚠️ deletes everything!)

---

## Step 6: Load Sample E-Commerce Data

Let's populate our store with products, customers, and orders!

1. Stay in **SQL Editor**
2. Click **"New query"** to get a fresh editor
3. Open `sql/load_data.sql` from the project
4. Copy all the content
5. Paste it into the SQL Editor
6. Click **"Run"**

You'll see output like:
```
INSERT 0 18  (18 product categories)
INSERT 0 20  (20 customers)
INSERT 0 30  (30 products)
INSERT 0 44  (44 product images)
INSERT 0 25  (25 shipping addresses)
INSERT 0 11  (11 active shopping carts)
INSERT 0 40  (40 orders)
INSERT 0 48  (48 order line items)
INSERT 0 40  (40 payment transactions)
INSERT 0 50  (50 product reviews)
INSERT 0 16  (16 audit log entries)
```

**Total: 342 rows of realistic e-commerce data!**

**Verify everything loaded:**
```sql
SELECT 'categories' AS table_name, COUNT(*) AS rows FROM categories
UNION ALL SELECT 'customers', COUNT(*) FROM customers
UNION ALL SELECT 'products', COUNT(*) FROM products
UNION ALL SELECT 'product_images', COUNT(*) FROM product_images
UNION ALL SELECT 'shipping_addresses', COUNT(*) FROM shipping_addresses
UNION ALL SELECT 'cart_items', COUNT(*) FROM cart_items
UNION ALL SELECT 'orders', COUNT(*) FROM orders
UNION ALL SELECT 'order_items', COUNT(*) FROM order_items
UNION ALL SELECT 'payment_transactions', COUNT(*) FROM payment_transactions
UNION ALL SELECT 'reviews', COUNT(*) FROM reviews
UNION ALL SELECT 'audit_log', COUNT(*) FROM audit_log
ORDER BY table_name;
```

You should see 342 total rows! 🎉

---

## Step 7: Explore Your Products Visually

Let's see what we loaded:

1. Click **"Table Editor"** in the sidebar
2. Select **"products"** from the dropdown
3. You'll see a spreadsheet view of all products!

Try these:
- Sort by **price** (click the column header)
- Filter to see only **Electronics**
- Click any row to see full details
- Look at the **stock_quantity** to see inventory levels

Switch to other tables:
- **customers** - see all registered shoppers
- **orders** - view order history
- **reviews** - read product reviews
- **cart_items** - see what's in people's shopping carts

Pretty cool, right? This is your live e-commerce database! 🛒

---

## Step 8: Create Triggers for Business Logic

Triggers automatically handle things like:
- Reducing stock when someone places an order
- Updating product ratings when someone leaves a review
- Tracking changes in the audit log
- Calculating customer loyalty points

Let's set them up:

1. Back to **SQL Editor**
2. Click **"New query"**
3. Open `sql/triggers.sql`
4. Copy everything
5. Paste and **Run**

You'll see messages like:
```
CREATE FUNCTION
CREATE TRIGGER
CREATE TRIGGER
...
```

**Test the inventory trigger:**
```sql
-- Check product stock
SELECT product_name, stock_quantity FROM products WHERE product_id = 1;

-- Place an order (this should reduce stock)
INSERT INTO orders (customer_id, order_date, order_status, subtotal, tax_amount, shipping_cost, total_amount)
VALUES (1, CURRENT_DATE, 'Processing', 599.99, 59.99, 9.99, 669.97);

-- Get the order_id that was just created
SELECT MAX(order_id) FROM orders;

-- Add an item to the order (use the order_id from above)
INSERT INTO order_items (order_id, product_id, quantity, unit_price, subtotal)
VALUES ((SELECT MAX(order_id) FROM orders), 1, 1, 599.99, 599.99);

-- Check stock again - should be 1 less!
SELECT product_name, stock_quantity FROM products WHERE product_id = 1;
```

If the stock went down, your trigger is working! 🎯

---

## Step 9: Create Views for Analytics

Views make it easy to analyze sales, customers, and products:

1. **New query** in SQL Editor
2. Open `sql/views.sql`
3. Copy and paste all of it
4. **Run**

You'll see:
```
CREATE VIEW
CREATE VIEW
CREATE MATERIALIZED VIEW
...
```

**Test some views:**

```sql
-- See order summary
SELECT * FROM v_order_summary ORDER BY order_date DESC LIMIT 10;

-- Customer lifetime value
SELECT * FROM v_customer_summary ORDER BY total_spent DESC LIMIT 10;

-- Product performance
SELECT * FROM mv_product_performance ORDER BY total_revenue DESC LIMIT 10;

-- Sales analytics
SELECT * FROM mv_sales_analytics;
```

These views give you instant insights into your e-commerce business!

---

## Step 10: Set Up Row Level Security

Row Level Security (RLS) ensures customers only see their own data:

Since Supabase works differently than local PostgreSQL, here's a simplified setup:

```sql
-- Enable RLS on customer-facing tables
ALTER TABLE customers ENABLE ROW LEVEL SECURITY;
ALTER TABLE orders ENABLE ROW LEVEL SECURITY;
ALTER TABLE cart_items ENABLE ROW LEVEL SECURITY;
ALTER TABLE shipping_addresses ENABLE ROW LEVEL SECURITY;
ALTER TABLE reviews ENABLE ROW LEVEL SECURITY;

-- Allow authenticated users full access (for this academic project)
-- In production, you'd restrict based on customer_id = auth.uid()

CREATE POLICY "Allow authenticated access" ON customers
    FOR ALL TO authenticated
    USING (true) WITH CHECK (true);

CREATE POLICY "Allow authenticated access" ON orders
    FOR ALL TO authenticated
    USING (true) WITH CHECK (true);

CREATE POLICY "Allow authenticated access" ON cart_items
    FOR ALL TO authenticated
    USING (true) WITH CHECK (true);

CREATE POLICY "Allow authenticated access" ON shipping_addresses
    FOR ALL TO authenticated
    USING (true) WITH CHECK (true);

CREATE POLICY "Allow authenticated access" ON reviews
    FOR ALL TO authenticated
    USING (true) WITH CHECK (true);

-- Products and categories are public (anyone can view)
CREATE POLICY "Public read access" ON products
    FOR SELECT TO anon, authenticated
    USING (is_active = true);

CREATE POLICY "Public read access" ON categories
    FOR SELECT TO anon, authenticated
    USING (true);
```

---

## Step 11: Run Analytics Queries

Let's explore the business with some SQL magic!

**Query 1: Top Selling Products**
```sql
SELECT 
    p.product_name,
    p.brand,
    COUNT(DISTINCT oi.order_id) AS orders_count,
    SUM(oi.quantity) AS units_sold,
    SUM(oi.subtotal) AS total_revenue,
    p.average_rating,
    p.total_reviews
FROM products p
JOIN order_items oi ON p.product_id = oi.product_id
GROUP BY p.product_id, p.product_name, p.brand, p.average_rating, p.total_reviews
ORDER BY total_revenue DESC
LIMIT 10;
```

**Query 2: Customer Segmentation (Window Functions!)**
```sql
SELECT 
    customer_id,
    first_name || ' ' || last_name AS customer_name,
    total_spent,
    loyalty_points,
    NTILE(4) OVER (ORDER BY total_spent DESC) AS spending_quartile,
    CASE 
        WHEN NTILE(4) OVER (ORDER BY total_spent DESC) = 1 THEN 'VIP'
        WHEN NTILE(4) OVER (ORDER BY total_spent DESC) = 2 THEN 'Gold'
        WHEN NTILE(4) OVER (ORDER BY total_spent DESC) = 3 THEN 'Silver'
        ELSE 'Bronze'
    END AS customer_tier
FROM customers
WHERE account_status = 'Active'
ORDER BY total_spent DESC;
```

**Query 3: Revenue by Category**
```sql
SELECT 
    c.category_name,
    COUNT(DISTINCT p.product_id) AS products,
    COUNT(DISTINCT oi.order_id) AS orders,
    SUM(oi.quantity) AS units_sold,
    ROUND(SUM(oi.subtotal), 2) AS total_revenue,
    ROUND(AVG(p.average_rating), 2) AS avg_rating
FROM categories c
LEFT JOIN products p ON c.category_id = p.category_id
LEFT JOIN order_items oi ON p.product_id = oi.product_id
GROUP BY c.category_id, c.category_name
ORDER BY total_revenue DESC NULLS LAST;
```

**Query 4: Monthly Sales Trend**
```sql
SELECT 
    TO_CHAR(order_date, 'YYYY-MM') AS month,
    COUNT(*) AS total_orders,
    SUM(total_amount) AS revenue,
    AVG(total_amount) AS avg_order_value,
    COUNT(DISTINCT customer_id) AS unique_customers
FROM orders
WHERE order_status NOT IN ('Cancelled', 'Refunded')
GROUP BY TO_CHAR(order_date, 'YYYY-MM')
ORDER BY month DESC;
```

---

## Step 12: Test Product Reviews & Ratings

Let's see how the review system works:

```sql
-- Add a new review
INSERT INTO reviews (product_id, customer_id, rating, review_text, review_date)
VALUES (1, 5, 5, 'Absolutely love this product! Best purchase ever!', CURRENT_DATE);

-- The trigger should automatically update the product's average rating!
SELECT product_name, average_rating, total_reviews 
FROM products 
WHERE product_id = 1;

-- See all reviews for a product
SELECT 
    c.first_name || ' ' || c.last_name AS customer_name,
    r.rating,
    r.review_text,
    r.review_date,
    r.verified_purchase
FROM reviews r
JOIN customers c ON r.customer_id = c.customer_id
WHERE r.product_id = 1
ORDER BY r.review_date DESC;
```

---

## Step 13: Explore the Shopping Cart

See what customers have in their carts:

```sql
SELECT 
    c.first_name || ' ' || c.last_name AS customer,
    p.product_name,
    ci.quantity,
    p.price,
    ci.quantity * p.price AS subtotal,
    ci.added_at
FROM cart_items ci
JOIN customers c ON ci.customer_id = c.customer_id
JOIN products p ON ci.product_id = p.product_id
ORDER BY ci.added_at DESC;
```

---

## Step 14: Analyze Category Hierarchy

E-commerce sites have nested categories (Electronics > Laptops > Gaming Laptops). Let's see ours:

```sql
-- Recursive query to show full category tree
WITH RECURSIVE category_tree AS (
    -- Start with top-level categories (no parent)
    SELECT 
        category_id,
        category_name,
        parent_id,
        0 AS level,
        category_name AS path
    FROM categories
    WHERE parent_id IS NULL
    
    UNION ALL
    
    -- Add child categories
    SELECT 
        c.category_id,
        c.category_name,
        c.parent_id,
        ct.level + 1,
        ct.path || ' > ' || c.category_name
    FROM categories c
    JOIN category_tree ct ON c.parent_id = ct.category_id
)
SELECT 
    REPEAT('  ', level) || category_name AS category_structure,
    level,
    path
FROM category_tree
ORDER BY path;
```

This shows you the full category tree structure! 🌳

---

## Step 15: Backups (Automatic!)

Great news - Supabase backs up your database automatically:

**Free tier includes:**
- ✅ Daily automated backups
- ✅ 7-day retention
- ✅ Download anytime as SQL file

**To download a backup:**
1. Click **"Database"** → **"Backups"**
2. You'll see your automatic backups listed
3. Click **"Download"** to get a `.sql` file

**To restore:**
1. Create a new Supabase project
2. Run the SQL file in the SQL Editor

**Manual export:**
You can also export specific tables anytime:
```sql
-- Just copy the results and save as CSV
SELECT * FROM products;
SELECT * FROM orders;
```

---

## Step 16: Connect from External Tools (Optional)

Want to use pgAdmin, DBeaver, or other database tools?

1. Click the **"Connect"** button at the top of your Supabase dashboard (near your project name)
2. A popup will show your connection details - use these settings:

```
Connection Type: PostgreSQL
Host: [your-host].supabase.co
Port: 5432
Database: postgres
Username: postgres
Password: [your database password]
SSL Mode: Require (important!)
```

3. Test connection and save!

Now you can use your favorite database tools alongside Supabase.

---

## Troubleshooting

### "Permission denied for table"
```sql
-- Run this:
GRANT ALL ON ALL TABLES IN SCHEMA public TO postgres;
GRANT ALL ON ALL SEQUENCES IN SCHEMA public TO postgres;
```

### "Function does not exist"
- Make sure you ran `triggers.sql` completely
- Check for typos in function names
- Try running triggers.sql again

### "Cannot insert duplicate key"
- You're trying to insert a record with an ID that already exists
- Let PostgreSQL auto-generate IDs (don't specify the ID column)
- Or use a different unique value

### Query is slow
- Add `LIMIT 100` to limit results
- Refresh materialized views: `REFRESH MATERIALIZED VIEW mv_product_performance;`
- Check if indexes exist: `SELECT * FROM pg_indexes WHERE tablename = 'products';`

### Can't see data in Table Editor
- Check RLS policies (they might be blocking access)
- Try querying in SQL Editor instead
- Make sure data actually loaded (run COUNT queries)

---

## Cool Things to Try

**1. Add yourself as a customer:**
```sql
INSERT INTO customers (first_name, last_name, email, phone, password_hash, date_of_birth, account_status)
VALUES ('Your', 'Name', 'you@email.com', '555-0123', 'hashed_password_here', '2000-01-01', 'Active');
```

**2. Create an order for yourself:**
```sql
-- Place an order
INSERT INTO orders (customer_id, order_date, order_status, subtotal, tax_amount, shipping_cost, total_amount)
VALUES (
    (SELECT customer_id FROM customers WHERE email = 'you@email.com'),
    CURRENT_DATE,
    'Processing',
    99.99,
    9.99,
    5.99,
    115.97
);

-- Add items to your order
INSERT INTO order_items (order_id, product_id, quantity, unit_price, subtotal)
VALUES (
    (SELECT MAX(order_id) FROM orders),
    (SELECT product_id FROM products ORDER BY RANDOM() LIMIT 1),
    1,
    99.99,
    99.99
);
```

**3. Write a product review:**
```sql
INSERT INTO reviews (product_id, customer_id, rating, review_text, review_date, verified_purchase)
VALUES (
    1,
    (SELECT customer_id FROM customers WHERE email = 'you@email.com'),
    5,
    'This is an amazing product! Highly recommend!',
    CURRENT_DATE,
    true
);
```

**4. Check the audit log:**
```sql
SELECT 
    table_name,
    operation,
    changed_by,
    changed_at,
    new_data
FROM audit_log
ORDER BY changed_at DESC
LIMIT 20;
```

---

## Next Steps

You're all set up! Here's what to explore:

- ✅ Run all 18 queries from `queries.sql`
- ✅ Test triggers by placing orders and leaving reviews
- ✅ Explore materialized views for performance comparisons
- ✅ Analyze customer behavior and product performance
- ✅ Try building a simple storefront using Supabase JavaScript client
- ✅ Experiment with Row Level Security for different user types

---

## Building a Real E-Commerce Site (Future Idea)

Since you have Supabase, you could actually build a real website:

1. **Frontend:** Use React, Next.js, or vanilla JavaScript
2. **Connect:** Use Supabase JavaScript library
3. **Features you could add:**
   - Product browsing and search
   - Shopping cart
   - Customer login
   - Order history
   - Admin dashboard
   - Real-time inventory updates

Supabase gives you everything you need - database, authentication, and APIs!

---

## Resources

- **Supabase Docs:** https://supabase.com/docs
- **PostgreSQL Tutorial:** https://www.postgresqltutorial.com/
- **Supabase JavaScript Client:** https://supabase.com/docs/reference/javascript
- **E-Commerce SQL Patterns:** https://mode.com/sql-tutorial/
- **This Project Repository:** (add your GitHub link)

---

## Why This Setup Is Awesome

Using Supabase gives you:
- 🎯 Real production-grade database (PostgreSQL)
- ☁️ Cloud-hosted (access from anywhere)
- 🔒 Enterprise-level security (RLS policies)
- 📊 Visual data exploration (Table Editor)
- 💰 $0 cost (free tier is generous)
- 🚀 API auto-generated (REST & GraphQL)
- ⚡ Real-time subscriptions (live updates)
- 📈 Performance monitoring
- 🔄 Automatic backups

It's the perfect platform for learning database design AND for building real applications!

---

**Questions? Issues?**

If something doesn't work:
1. Check the error message carefully
2. Look at the Supabase logs (Database → Logs)
3. Search Supabase documentation
4. Ask in the Supabase Discord community

Good luck with your e-commerce database project! 🛍️✨
