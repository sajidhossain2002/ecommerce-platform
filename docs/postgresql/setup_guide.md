# PostgreSQL Local Setup Guide

Complete guide to setting up the E-Commerce Platform database on your local PostgreSQL instance.

## Table of Contents

1. [Prerequisites](#prerequisites)
2. [Installation](#installation)
3. [Database Creation](#database-creation)
4. [Schema Setup](#schema-setup)
5. [Data Loading](#data-loading)
6. [Role Configuration](#role-configuration)
7. [Verification](#verification)
8. [Troubleshooting](#troubleshooting)

---

## Prerequisites

### Required Software

- **PostgreSQL 13 or higher**: Download from [postgresql.org](https://www.postgresql.org/download/)
- **pgAdmin 4**: Included with PostgreSQL installer or download separately
- **Text Editor**: VS Code, Sublime Text, or any SQL-compatible editor

### System Requirements

- **OS**: Windows 10/11, macOS 10.15+, or Linux
- **RAM**: Minimum 4GB (8GB recommended for better performance)
- **Disk Space**: At least 500MB free space
- **Ports**: Port 5432 available (default PostgreSQL port)

---

## Installation

### Windows Installation

1. **Download PostgreSQL Installer**:
   - Visit [postgresql.org/download/windows](https://www.postgresql.org/download/windows/)
   - Download the latest PostgreSQL 15.x installer for Windows

2. **Run the Installer**:
   - Execute the downloaded `.exe` file
   - Follow the installation wizard
   - **Important**: Remember the superuser (postgres) password you set

3. **Select Components**:
   - ✅ PostgreSQL Server
   - ✅ pgAdmin 4
   - ✅ Command Line Tools
   - ✅ Stack Builder (optional)

4. **Set Installation Directory**:
   - Default: `C:\Program Files\PostgreSQL\15`
   - Or choose custom location

5. **Set Data Directory**:
   - Default: `C:\Program Files\PostgreSQL\15\data`

6. **Set Password**:
   - Create a strong password for the `postgres` superuser
   - **SAVE THIS PASSWORD** - you'll need it frequently

7. **Set Port**:
   - Default: `5432`
   - Change only if port 5432 is already in use

8. **Select Locale**:
   - Default locale (usually English, United States)

9. **Complete Installation**:
   - Click "Next" through remaining screens
   - Wait for installation to complete
   - Uncheck Stack Builder unless you need additional tools

### macOS Installation

```bash
# Using Homebrew
brew install postgresql@15

# Start PostgreSQL service
brew services start postgresql@15

# Install pgAdmin separately
brew install --cask pgadmin4
```

### Linux (Ubuntu/Debian) Installation

```bash
# Add PostgreSQL repository
sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -

# Update and install
sudo apt-get update
sudo apt-get install postgresql-15 postgresql-contrib-15

# Install pgAdmin
sudo apt-get install pgadmin4
```

---

## Database Creation

### Using pgAdmin 4

1. **Launch pgAdmin 4**:
   - Windows: Start Menu → PostgreSQL 15 → pgAdmin 4
   - macOS/Linux: Applications → pgAdmin 4

2. **Connect to PostgreSQL Server**:
   - Expand "Servers" in the left sidebar
   - Click on "PostgreSQL 15"
   - Enter your postgres password when prompted

3. **Create New Database**:
   - Right-click on "Databases"
   - Select "Create" → "Database..."
   - **Database name**: `ecommerce_db`
   - **Owner**: `postgres`
   - **Encoding**: `UTF8`
   - **Template**: `template0`
   - **Collation**: `Default`
   - **Character type**: `Default`
   - Click "Save"

### Using Command Line (Alternative)

```bash
# Connect to PostgreSQL
psql -U postgres

# Create database
CREATE DATABASE ecommerce_db
    WITH
    OWNER = postgres
    ENCODING = 'UTF8'
    LC_COLLATE = 'en_US.UTF-8'
    LC_CTYPE = 'en_US.UTF-8'
    TABLESPACE = pg_default
    CONNECTION LIMIT = -1
    TEMPLATE template0;

# Verify creation
\l ecommerce_db

# Connect to the database
\c ecommerce_db

# Exit
\q
```

---

## Schema Setup

### Load Database Schema

1. **Open Query Tool in pgAdmin**:
   - Expand "Databases" → "ecommerce_db"
   - Right-click on "ecommerce_db"
   - Select "Query Tool"

2. **Load Schema File**:
   - Click "Open File" button (folder icon)
   - Navigate to: `sql/postgresql/schema.sql`
   - Click "Open"

3. **Execute Schema Script**:
   - Click "Execute/Refresh" button (▶ play icon) or press `F5`
   - Wait for execution to complete
   - Check "Messages" tab for success confirmation

4. **Verify Tables Created**:
   - Expand "ecommerce_db" → "Schemas" → "public" → "Tables"
   - You should see 11 tables:
     - categories
     - customers
     - products
     - product_images
     - shipping_addresses
     - cart_items
     - orders
     - order_items
     - payment_transactions
     - reviews
     - audit_log

### Using Command Line (Alternative)

```bash
# Navigate to project directory
cd /path/to/ecommerce-platform

# Execute schema file
psql -U postgres -d ecommerce_db -f sql/postgresql/schema.sql

# Verify tables
psql -U postgres -d ecommerce_db -c "\dt"
```

---

## Data Loading

### Load Sample Data

1. **Open Query Tool** (if not already open):
   - Right-click on "ecommerce_db"
   - Select "Query Tool"

2. **Load Data File**:
   - Click "Open File" button
   - Navigate to: `sql/postgresql/load_data.sql`
   - Click "Open"

3. **Execute Data Script**:
   - Click "Execute/Refresh" button (▶) or press `F5`
   - **Note**: This may take 30-60 seconds (339 records across 11 tables)
   - Wait for completion message

4. **Verify Data Loaded**:
   - Run verification query:
   ```sql
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
   UNION ALL SELECT 'audit_log', COUNT(*) FROM audit_log
   ORDER BY table_name;
   ```
   - Expected output: 339 total records

### Expected Record Counts

| Table                  | Records |
|------------------------|---------|
| categories             | 15      |
| customers              | 20      |
| products               | 30      |
| product_images         | 44      |
| shipping_addresses     | 25      |
| cart_items             | 11      |
| orders                 | 40      |
| order_items            | 48      |
| payment_transactions   | 40      |
| reviews                | 50      |
| audit_log              | 16      |
| **TOTAL**              | **339** |

---

## Role Configuration

### Create Application Roles

1. **Open Query Tool**:
   - Right-click on "ecommerce_db"
   - Select "Query Tool"

2. **Load Roles File**:
   - Click "Open File"
   - Navigate to: `sql/postgresql/roles.sql`
   - Click "Open"

3. **Execute Roles Script**:
   - Click "Execute/Refresh" (▶)
   - Wait for completion

4. **Verify Roles Created**:
   - Expand "ecommerce_db" → "Login/Group Roles"
   - You should see:
     - `ecommerce_admin` (full access)
     - `ecommerce_app` (application read/write)
     - `ecommerce_readonly` (read-only queries)

### Role Descriptions

- **ecommerce_admin**: Full administrative access (CRUD + schema changes)
- **ecommerce_app**: Application-level access (CRUD operations only)
- **ecommerce_readonly**: Read-only access for reporting and analytics

---

## Verification

### Test Database Functionality

Run these queries to verify everything is working:

```sql
-- 1. Test product catalog query
SELECT 
    p.product_name,
    p.price,
    c.category_name,
    p.stock_quantity,
    p.average_rating
FROM products p
JOIN categories c ON p.category_id = c.category_id
WHERE p.is_active = TRUE
ORDER BY p.average_rating DESC
LIMIT 10;

-- 2. Test customer orders query
SELECT 
    o.order_id,
    c.first_name || ' ' || c.last_name AS customer_name,
    o.order_date,
    o.total_amount,
    o.order_status
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
ORDER BY o.order_date DESC
LIMIT 10;

-- 3. Test review statistics
SELECT 
    p.product_name,
    COUNT(r.review_id) AS total_reviews,
    AVG(r.rating) AS avg_rating,
    SUM(r.helpful_count) AS total_helpful
FROM products p
LEFT JOIN reviews r ON p.product_id = r.product_id
GROUP BY p.product_id, p.product_name
HAVING COUNT(r.review_id) > 0
ORDER BY avg_rating DESC, total_reviews DESC;

-- 4. Test revenue analysis
SELECT 
    DATE_TRUNC('month', order_date) AS month,
    COUNT(*) AS total_orders,
    SUM(total_amount) AS monthly_revenue,
    AVG(total_amount) AS avg_order_value
FROM orders
WHERE order_status = 'Delivered'
GROUP BY DATE_TRUNC('month', order_date)
ORDER BY month DESC;
```

### Load Views and Triggers (Optional but Recommended)

1. **Load Views**:
   ```bash
   psql -U postgres -d ecommerce_db -f sql/postgresql/views.sql
   ```

2. **Load Triggers**:
   ```bash
   psql -U postgres -d ecommerce_db -f sql/postgresql/triggers.sql
   ```

3. **Test Views**:
   ```sql
   SELECT * FROM vw_product_catalog LIMIT 10;
   SELECT * FROM vw_customer_orders LIMIT 10;
   SELECT * FROM vw_sales_summary;
   ```

---

## Troubleshooting

### Common Issues and Solutions

#### Issue 1: "Connection refused" or "Could not connect to server"

**Solutions**:
```bash
# Check if PostgreSQL is running (Windows)
# Services → PostgreSQL → Status should be "Running"

# Start PostgreSQL service (Windows)
net start postgresql-x64-15

# macOS
brew services start postgresql@15

# Linux
sudo systemctl start postgresql
```

#### Issue 2: "Password authentication failed for user postgres"

**Solutions**:
- Reset password using pgAdmin or command line
- Check `pg_hba.conf` file for authentication settings
- Ensure you're using the correct password

#### Issue 3: "Database already exists"

**Solutions**:
```sql
-- Drop and recreate database
DROP DATABASE IF EXISTS ecommerce_db;
CREATE DATABASE ecommerce_db;
```

#### Issue 4: "Permission denied" errors

**Solutions**:
```sql
-- Grant necessary permissions
GRANT ALL PRIVILEGES ON DATABASE ecommerce_db TO postgres;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO postgres;
```

#### Issue 5: Foreign key constraint violations during data load

**Solutions**:
- Ensure you loaded `schema.sql` before `load_data.sql`
- Data must be loaded in this exact order (dependencies):
  1. categories
  2. customers
  3. products
  4. product_images, shipping_addresses
  5. cart_items, orders
  6. order_items, payment_transactions
  7. reviews
  8. audit_log

#### Issue 6: Slow query performance

**Solutions**:
```sql
-- Analyze tables for query optimization
ANALYZE categories;
ANALYZE customers;
ANALYZE products;
ANALYZE orders;
ANALYZE order_items;

-- Rebuild indexes
REINDEX DATABASE ecommerce_db;
```

### Get PostgreSQL Connection Info

```sql
-- Check current database
SELECT current_database();

-- Check server version
SELECT version();

-- Check active connections
SELECT * FROM pg_stat_activity WHERE datname = 'ecommerce_db';

-- Check database size
SELECT pg_size_pretty(pg_database_size('ecommerce_db'));
```

---

## Next Steps

After successful setup:

1. **Explore Sample Queries**: Review `sql/postgresql/queries.sql` for analytics examples
2. **Test Application**: Use connection string: `postgresql://postgres:password@localhost:5432/ecommerce_db`
3. **Backup Database**: See [Backup & Restore Guide](backup_restore_guide.md)
4. **Deploy to Production**: Consider cloud PostgreSQL services (AWS RDS, Google Cloud SQL, Azure Database)

---

## Resources

- [PostgreSQL Official Documentation](https://www.postgresql.org/docs/)
- [pgAdmin 4 Documentation](https://www.pgadmin.org/docs/)
- [PostgreSQL Tutorial](https://www.postgresqltutorial.com/)
- [SQL Performance Tuning](https://use-the-index-luke.com/)

---

**Setup Complete!** 🎉

Your local e-commerce database is now ready for development and testing.

For cloud deployment with Supabase, see [Supabase Setup Guide](../supabase/supabase_setup_guide.md).
