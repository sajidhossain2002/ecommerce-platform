# SQL Directory - E-Commerce Platform Database

This directory contains SQL scripts for deploying the e-commerce platform database in two different environments: **Local PostgreSQL** and **Supabase Cloud**.

## 📁 Directory Structure

```
sql/
├── postgresql/           # Local PostgreSQL deployment
│   ├── schema.sql       # Database schema definition
│   ├── load_data.sql    # Sample data insertion (339 records)
│   ├── views.sql        # Business intelligence views
│   ├── triggers.sql     # Automated business logic
│   ├── roles.sql        # User roles and permissions
│   └── queries.sql      # Sample analytical queries
│
└── supabase/            # Supabase cloud deployment
    ├── schema.sql       # Database schema (Supabase-optimized)
    ├── insert_data.sql  # Sample data with RLS compatibility
    ├── views.sql        # Business intelligence views
    ├── triggers.sql     # Automated business logic
    ├── roles_rls.sql    # Row Level Security policies
    └── queries.sql      # Sample analytical queries
```

---

## 🎯 Deployment Options

### Option 1: Local PostgreSQL (Development)

**Best For:**
- Local development and testing
- Learning database concepts
- Offline development
- Full control over database configuration
- No internet dependency

**Requirements:**
- PostgreSQL 13+ installed locally
- pgAdmin 4 (recommended GUI tool)
- 500MB disk space
- Port 5432 available

**Setup Time:** ~15 minutes

**Quick Start:**
```bash
# Create database
psql -U postgres -c "CREATE DATABASE ecommerce_db;"

# Load schema and data
cd sql/postgresql
psql -U postgres -d ecommerce_db -f schema.sql
psql -U postgres -d ecommerce_db -f load_data.sql
psql -U postgres -d ecommerce_db -f views.sql
psql -U postgres -d ecommerce_db -f triggers.sql
psql -U postgres -d ecommerce_db -f roles.sql
```

**📖 Detailed Guide:** [docs/postgresql/setup_guide.md](../docs/postgresql/setup_guide.md)

---

### Option 2: Supabase Cloud (Production)

**Best For:**
- Production deployment
- Cloud-hosted solution
- Auto-scaling and managed backups
- Built-in authentication
- Real-time subscriptions
- Auto-generated REST APIs
- Row Level Security (RLS)

**Requirements:**
- Free Supabase account
- Internet connection
- Modern web browser

**Setup Time:** ~10 minutes

**Quick Start:**
1. Create project at [supabase.com](https://supabase.com)
2. Open SQL Editor
3. Run scripts in order:
   - `schema.sql`
   - `insert_data.sql`
   - `views.sql`
   - `triggers.sql`
   - `roles_rls.sql`

**📖 Detailed Guide:** [docs/supabase/supabase_setup_guide.md](../docs/supabase/supabase_setup_guide.md)

---

## 📊 Database Statistics

### Tables: 11

| Table | Records | Description |
|-------|---------|-------------|
| categories | 15 | Product categorization hierarchy |
| customers | 20 | Registered user accounts |
| products | 30 | Product catalog |
| product_images | 44 | Product photography |
| shipping_addresses | 25 | Customer delivery locations |
| cart_items | 11 | Active shopping carts |
| orders | 40 | Purchase orders |
| order_items | 48 | Order line items |
| payment_transactions | 40 | Payment processing records |
| reviews | 50 | Customer product reviews |
| audit_log | 16 | System change tracking |
| **TOTAL** | **339** | **Complete e-commerce dataset** |

### Views: 5
- `vw_product_catalog` - Public product catalog with images
- `vw_customer_orders` - Customer order history
- `vw_sales_summary` - Revenue analytics
- `vw_inventory_status` - Stock level monitoring
- `vw_top_products` - Best-selling products

### Triggers: 8
- Order total calculation
- Inventory management
- Loyalty points tracking
- Review rating aggregation
- Audit logging
- Stock alerts
- Customer spending updates
- Cart expiration

### Roles: 3 (PostgreSQL) / RLS Policies: 25+ (Supabase)
- Admin: Full system access
- App: Application-level access
- ReadOnly: Analytics and reporting
- Customer RLS: Data privacy policies

---

## 🔄 Migration Between Environments

### From Local PostgreSQL → Supabase

```bash
# Export data from local PostgreSQL
pg_dump -U postgres -d ecommerce_db --data-only --inserts > export.sql

# Upload to Supabase via SQL Editor
# Note: Adjust for RLS policies if needed
```

### From Supabase → Local PostgreSQL

```bash
# Download project backup from Supabase Dashboard
# Restore to local PostgreSQL
psql -U postgres -d ecommerce_db < supabase_backup.sql
```

---

## 🔑 Key Differences

| Feature | PostgreSQL | Supabase |
|---------|-----------|----------|
| **Security Model** | Traditional roles | Row Level Security (RLS) |
| **Authentication** | Manual setup | Built-in Auth |
| **APIs** | Manual creation | Auto-generated REST/GraphQL |
| **Hosting** | Self-hosted | Fully managed cloud |
| **Scaling** | Manual | Auto-scaling |
| **Backups** | Manual | Automated daily |
| **Cost** | Hardware/server costs | Free tier available |
| **Data Privacy** | Role-based | Policy-based (RLS) |
| **Real-time** | Manual with triggers | Built-in real-time |

---

## 📝 File Descriptions

### Common Files (Both Environments)

#### schema.sql
Defines the database structure:
- 11 tables with proper relationships
- Primary keys and foreign keys
- Check constraints for data validation
- Indexes for query optimization
- Column data types and defaults

#### views.sql
Business intelligence views:
- Product catalog aggregation
- Customer order history
- Sales analytics
- Inventory monitoring
- Top products by revenue and reviews

#### triggers.sql
Automated business logic:
- Calculate order totals on insert/update
- Update product stock after orders
- Maintain customer loyalty points
- Aggregate product ratings from reviews
- Log all data changes to audit_log
- Send low stock alerts

#### queries.sql
Sample analytical queries:
- Revenue analysis by month/category
- Customer lifetime value (CLV)
- Product performance metrics
- Inventory turnover rates
- Review sentiment analysis
- Cart abandonment tracking

### PostgreSQL-Specific Files

#### load_data.sql
Traditional INSERT statements:
- 339 records across 11 tables
- Realistic e-commerce sample data
- Referential integrity maintained
- Sequential execution safe

#### roles.sql
PostgreSQL role-based security:
- `ecommerce_admin`: Full database access
- `ecommerce_app`: CRUD operations only
- `ecommerce_readonly`: SELECT permissions only

### Supabase-Specific Files

#### insert_data.sql
RLS-compatible data insertion:
- Same 339 records as PostgreSQL version
- Temporarily disables RLS during bulk insert
- Re-enables RLS after data load
- Includes verification queries

#### roles_rls.sql
Row Level Security policies:
- Customer data privacy (own data only)
- Public product catalog (all users)
- Shopping cart isolation (owner only)
- Order privacy (customer + admin)
- Payment security (PCI considerations)
- Review moderation (public read, owner write)
- Admin oversight (full access)
- 25+ granular security policies

---

## 🚀 Getting Started

### For Local Development (Recommended for beginners)

1. **Install PostgreSQL**: Download from [postgresql.org](https://www.postgresql.org/download/)
2. **Follow Setup Guide**: [docs/postgresql/setup_guide.md](../docs/postgresql/setup_guide.md)
3. **Load Files in Order**:
   - schema.sql → load_data.sql → views.sql → triggers.sql → roles.sql
4. **Verify**: Run queries from `queries.sql`

### For Cloud Deployment (Recommended for production)

1. **Create Supabase Account**: Visit [supabase.com](https://supabase.com)
2. **Follow Setup Guide**: [docs/supabase/supabase_setup_guide.md](../docs/supabase/supabase_setup_guide.md)
3. **Load Files in Order**:
   - schema.sql → insert_data.sql → views.sql → triggers.sql → roles_rls.sql
4. **Test RLS**: Use Supabase Auth UI

---

## 📚 Documentation

- **PostgreSQL Setup**: [docs/postgresql/setup_guide.md](../docs/postgresql/setup_guide.md)
- **PostgreSQL Backup**: [docs/postgresql/backup_restore_guide.md](../docs/postgresql/backup_restore_guide.md)
- **Supabase Setup**: [docs/supabase/supabase_setup_guide.md](../docs/supabase/supabase_setup_guide.md)
- **Main README**: [../README.md](../README.md)

---

## 🔧 Customization

### Adding Your Own Data

1. **Clear Sample Data**:
   ```sql
   TRUNCATE TABLE audit_log, reviews, payment_transactions, 
                  order_items, orders, cart_items, 
                  shipping_addresses, product_images, 
                  products, customers, categories CASCADE;
   ```

2. **Import Your Data**: Use `COPY` or `\copy` commands

3. **Verify Constraints**: Ensure foreign keys are satisfied

### Modifying Schema

1. **Update schema.sql** with your changes
2. **Regenerate database**:
   ```sql
   DROP DATABASE ecommerce_db;
   CREATE DATABASE ecommerce_db;
   \c ecommerce_db
   \i schema.sql
   ```
3. **Update views/triggers** if schema changes affect them

---

## 🐛 Troubleshooting

### Common Issues

**"Foreign key violation"**
- Load data files in the correct order (see file descriptions above)
- Parent records must exist before children

**"Permission denied"**
- Check role permissions (PostgreSQL)
- Verify RLS policies (Supabase)
- Ensure proper authentication

**"Duplicate key value"**
- Clear existing data before re-importing
- Check for conflicting INSERT statements

---

## 📞 Support

- Review setup guides in `docs/` directory
- Check file comments for detailed explanations
- PostgreSQL docs: [postgresql.org/docs](https://www.postgresql.org/docs/)
- Supabase docs: [supabase.com/docs](https://supabase.com/docs)

---

**Ready to deploy?** Choose your environment above and follow the setup guide! 🚀
