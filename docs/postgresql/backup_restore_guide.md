# Backup and Restore Guide

Project: E-Commerce Platform Database (PostgreSQL)  
Student: Sajid  
Track: Option 3 - Coding-Heavy DBA / DevOps Project

This guide documents the backup, restore, and verification strategy for the e-commerce database in both self-hosted PostgreSQL and Supabase (hosted Postgres) environments. Follow these steps before enabling Row-Level Security in production.

---

## 1. Prerequisites
- PostgreSQL 13+ with `pg_dump`, `pg_restore`, and `psql` on your PATH.
- Access to the target database instance (local, staging, production) and valid credentials.
- Optional: Supabase CLI (`npm install -g supabase`) for hosted backups.
- Sufficient disk space for full dumps (estimate 25 MB per environment with current sample data).

---

## 2. Local Backup Strategy

### 2.1 Logical Backups (`pg_dump`)
Create daily schema + data dumps and keep the last 7 copies.

```bash
# Set context
export DB_NAME=ecommerce_platform
export BACKUP_DIR=~/backups/ecommerce
mkdir -p "$BACKUP_DIR"

# Full logical backup
pg_dump \
  --dbname="$DB_NAME" \
  --format=custom \
  --file="$BACKUP_DIR/${DB_NAME}_$(date +%Y%m%d_%H%M).dump" \
  --no-owner --no-privileges
```

Key flags:
- `--format=custom` enables parallel restores and selective object recovery.
- `--no-owner` / `--no-privileges` avoid role conflicts between environments.

### 2.2 Physical Backups (`pg_basebackup`)
Run weekly to capture WAL and large object state.

```bash
pg_basebackup \
  --pgdata=$BACKUP_DIR/base_$(date +%Y%m%d) \
  --format=tar \
  --wal-method=stream \
  --checkpoint=fast
```

Store physical backups off-site or in S3-compatible storage for disaster recovery.

---

## 3. Local Restore Procedure

### 3.1 Prepare Target Instance
```bash
createdb ecommerce_restore
```

### 3.2 Restore From Logical Dump
```bash
pg_restore \
  --dbname=ecommerce_restore \
  --jobs=4 \
  --role=postgres \
  --clean \
  ~/backups/ecommerce/ecommerce_platform_YYYYMMDD_HHMM.dump
```

### 3.3 Post-Restore Validation
```sql
\c ecommerce_restore
SELECT COUNT(*) FROM products;
SELECT COUNT(*) FROM orders WHERE order_status = 'Delivered';
SELECT * FROM mv_sales_analytics LIMIT 5;
SELECT * FROM audit_log ORDER BY changed_at DESC LIMIT 5;
```

Re-run `sql/roles.sql` if restoring into a clean cluster without the custom roles.

---

## 4. Supabase Backup Workflow

### 4.1 Export Using Supabase CLI
```bash
supabase db dump --db-url "postgres://USER:PASSWORD@HOST:PORT/postgres" --file ecommerce_supabase.dump
```

### 4.2 Import Into Local Dev For Verification
```bash
createdb ecommerce_supabase_restore
pg_restore --dbname=ecommerce_supabase_restore --clean ecommerce_supabase.dump
```

### 4.3 Verify Critical Tables
```sql
SELECT COUNT(*) FROM customers;
SELECT order_status, COUNT(*) FROM orders GROUP BY order_status ORDER BY 1;
SELECT * FROM v_customer_orders WHERE customer_id = 3;
```

---

## 5. Automation Checklist
- [ ] Schedule `pg_dump` daily via cron or Windows Task Scheduler.
- [ ] Schedule `pg_basebackup` weekly with retention policies.
- [ ] Send backup success/failure notifications to the team channel.
- [ ] Perform quarterly restore drills on staging.
- [ ] Document any schema migrations and tag backups prior to deployment.

---

## 6. Troubleshooting Tips
- If `pg_restore` fails on RLS policies, rerun `sql/roles.sql` after the restore.
- For Supabase, ensure replication slots are healthy; `supabase status` will flag lagging WAL.
- Large restores benefit from `SET maintenance_work_mem = '512MB';` prior to running `pg_restore`.
- After a restore, refresh materialized views:

```sql
REFRESH MATERIALIZED VIEW CONCURRENTLY mv_sales_analytics;
REFRESH MATERIALIZED VIEW CONCURRENTLY mv_product_performance;
```

---

Maintain this guide alongside operational runbooks so new DBAs can execute backups and restores without guesswork.
