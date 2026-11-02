-- ============================================================
-- SQL QA VALIDATION REPORT
-- Project: E-commerce Database Testing
-- Database: SQLite
-- ============================================================

-- QA-001: Verify customer without orders (Diana)
-- QA-002: Verify out-of-stock product (Webcam)
-- QA-003: Detect incorrect order totals
-- QA-004: Detect duplicate customer emails
-- QA-005: Detect orders without valid customers
-- QA-006: Detect orders without valid products
-- QA-007: Detect negative prices or stock
-- QA-008: Detect invalid order quantities
-- QA-009: Verify total spending per customer
-- QA-010: Verify order counts per customer

WITH
qa_001 AS (
    SELECT COUNT(*) AS actual
    FROM customers c
    WHERE NOT EXISTS (
        SELECT 1
        FROM orders o
        WHERE o.customer_id = c.id
    )
),
qa_002 AS (
    SELECT COUNT(*) AS actual
    FROM products
    WHERE stock = 0
),
qa_003 AS (
    SELECT COUNT(*) AS issues
    FROM orders o
    JOIN products p ON o.product_id = p.id
    WHERE ABS(o.total - ROUND(o.quantity * p.price, 2)) > 0.001
),
qa_004 AS (
    SELECT COUNT(*) AS issues
    FROM (
        SELECT email
        FROM customers
        GROUP BY email
        HAVING COUNT(*) > 1
    )
),
qa_005 AS (
    SELECT COUNT(*) AS issues
    FROM orders o
    LEFT JOIN customers c ON o.customer_id = c.id
    WHERE c.id IS NULL
),
qa_006 AS (
    SELECT COUNT(*) AS issues
    FROM orders o
    LEFT JOIN products p ON o.product_id = p.id
    WHERE p.id IS NULL
),
qa_007 AS (
    SELECT COUNT(*) AS issues
    FROM products
    WHERE price < 0 OR stock < 0
),
qa_008 AS (
    SELECT COUNT(*) AS issues
    FROM orders
    WHERE quantity <= 0
),
qa_009 AS (
    SELECT COUNT(*) AS issues
    FROM (
        SELECT
            c.id,
            COALESCE(SUM(o.total), 0) AS total_spent
        FROM customers c
        LEFT JOIN orders o ON c.id = o.customer_id
        GROUP BY c.id
    ) actual
    JOIN (
        SELECT 1 AS id, 350 AS expected_total
        UNION ALL SELECT 2, 150
        UNION ALL SELECT 3, 1200
        UNION ALL SELECT 4, 0
    ) expected ON actual.id = expected.id
    WHERE ABS(actual.total_spent - expected.expected_total) > 0.001
),
qa_010 AS (
    SELECT COUNT(*) AS issues
    FROM (
        SELECT
            c.id,
            COUNT(o.id) AS order_count
        FROM customers c
        LEFT JOIN orders o ON c.id = o.customer_id
        GROUP BY c.id
    ) actual
    JOIN (
        SELECT 1 AS id, 2 AS expected_count
        UNION ALL SELECT 2, 2
        UNION ALL SELECT 3, 1
        UNION ALL SELECT 4, 0
    ) expected ON actual.id = expected.id
    WHERE actual.order_count != expected.expected_count
),
results AS (
    SELECT
        'QA-001' AS check_id,
        'Customers without orders' AS description,
        CASE
            WHEN (SELECT actual FROM qa_001) = 1
             AND EXISTS (
                SELECT 1
                FROM customers c
                WHERE c.id = 4
                  AND c.name = 'Diana'
                  AND NOT EXISTS (
                      SELECT 1 FROM orders o
                      WHERE o.customer_id = c.id
                  )
             )
            THEN 'PASS'
            ELSE 'FAIL'
        END AS status,
        ABS((SELECT actual FROM qa_001) - 1) AS issues_found

    UNION ALL

    SELECT
        'QA-002',
        'Out-of-stock products',
        CASE
            WHEN (SELECT actual FROM qa_002) = 1
             AND EXISTS (
                SELECT 1
                FROM products
                WHERE id = 5
                  AND product_name = 'Webcam'
                  AND stock = 0
             )
            THEN 'PASS'
            ELSE 'FAIL'
        END,
        ABS((SELECT actual FROM qa_002) - 1)

    UNION ALL

    SELECT
        'QA-003',
        'Incorrect order totals',
        CASE WHEN issues = 0 THEN 'PASS' ELSE 'FAIL' END,
        issues
    FROM qa_003

    UNION ALL

    SELECT
        'QA-004',
        'Duplicate customer emails',
        CASE WHEN issues = 0 THEN 'PASS' ELSE 'FAIL' END,
        issues
    FROM qa_004

    UNION ALL

    SELECT
        'QA-005',
        'Orders without customers',
        CASE WHEN issues = 0 THEN 'PASS' ELSE 'FAIL' END,
        issues
    FROM qa_005

    UNION ALL

    SELECT
        'QA-006',
        'Orders without products',
        CASE WHEN issues = 0 THEN 'PASS' ELSE 'FAIL' END,
        issues
    FROM qa_006

    UNION ALL

    SELECT
        'QA-007',
        'Negative prices or stock',
        CASE WHEN issues = 0 THEN 'PASS' ELSE 'FAIL' END,
        issues
    FROM qa_007

    UNION ALL

    SELECT
        'QA-008',
        'Invalid order quantities',
        CASE WHEN issues = 0 THEN 'PASS' ELSE 'FAIL' END,
        issues
    FROM qa_008

    UNION ALL

    SELECT
        'QA-009',
        'Customer spending totals',
        CASE WHEN issues = 0 THEN 'PASS' ELSE 'FAIL' END,
        issues
    FROM qa_009

    UNION ALL

    SELECT
        'QA-010',
        'Orders per customer',
        CASE WHEN issues = 0 THEN 'PASS' ELSE 'FAIL' END,
        issues
    FROM qa_010
)

SELECT
    check_id AS "Check ID",
    description AS "Description",
    status AS "Status",
    issues_found AS "Issues Found"
FROM results
ORDER BY check_id;
