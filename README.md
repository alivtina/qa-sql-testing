# SQL Testing Portfolio

A practical SQL testing project demonstrating database validation skills for Junior QA.

## Project Overview

This project uses SQLite to simulate an e-commerce database and perform SQL-based QA checks.

The database contains customers, products, and orders.

The goal is to validate data integrity, identify potential data issues, and verify business-related calculations using SQL.

## Tools

- SQLite
- SQL
- Git
- GitHub

## Database Structure

The project contains three tables:

| Table | Description |
|---|---|
| `customers` | Customer information |
| `products` | Product prices and stock quantities |
| `orders` | Customer orders and purchase totals |

The schema includes primary keys, foreign keys, unique constraints, and validation checks.

## QA Test Coverage

| Check ID | Description | Expected Result |
|---|---|---|
| QA-001 | Find customers without orders | Diana |
| QA-002 | Find out-of-stock products | Webcam |
| QA-003 | Find incorrect order totals | No rows |
| QA-004 | Detect duplicate customer emails | No rows |
| QA-005 | Find orders without valid customers | No rows |
| QA-006 | Find orders without valid products | No rows |
| QA-007 | Detect negative prices or stock | No rows |
| QA-008 | Detect invalid order quantities | No rows |
| QA-009 | Calculate total spending per customer | Expected totals |
| QA-010 | Count orders per customer | Expected counts |

## Project Structure

```text
qa-sql-testing/
├── README.md
├── .gitignore
├── database/
│   ├── schema.sql
│   └── sample-data.sql
└── queries/
    └── qa-checks.sql
```

## How to Run

### 1. Create the database

```bash
sqlite3 database/shop.db < database/schema.sql
```

### 2. Insert sample data

```bash
sqlite3 database/shop.db < database/sample-data.sql
```

### 3. Run QA checks

```bash
sqlite3 -header -column database/shop.db < queries/qa-checks.sql
```

The sample data should be inserted into a newly created database to avoid duplicate primary key errors.

## SQL Skills Demonstrated

- SELECT and WHERE
- JOIN and LEFT JOIN
- GROUP BY and HAVING
- COUNT and SUM
- COALESCE
- NOT EXISTS
- Data integrity validation
- Duplicate detection
- Business rule verification

## Notes

This is a portfolio project using simulated e-commerce data.

All SQL checks are designed for a local SQLite test database. No production data is used.
