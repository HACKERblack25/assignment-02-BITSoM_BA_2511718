-- ============================================================
-- Part 3.1 — Star Schema Design
-- Source: retail_transactions.csv
-- ============================================================

-- ============================================================
-- STEP 1: DROP tables if re-running (order matters — fact first)
-- ============================================================
DROP TABLE IF EXISTS fact_sales;
DROP TABLE IF EXISTS dim_date;
DROP TABLE IF EXISTS dim_store;
DROP TABLE IF EXISTS dim_product;


-- ============================================================
-- STEP 2: CREATE DIMENSION TABLES
-- ============================================================

-- dim_date: one row per unique calendar date
CREATE TABLE dim_date (
    date_key    SERIAL PRIMARY KEY,   -- surrogate key
    full_date   DATE        NOT NULL, -- e.g. 2023-08-29
    day         INT         NOT NULL, -- 1-31
    month       INT         NOT NULL, -- 1-12
    month_name  VARCHAR(15) NOT NULL, -- 'August'
    quarter     INT         NOT NULL, -- 1-4
    year        INT         NOT NULL  -- 2023
);

-- dim_store: one row per physical store
CREATE TABLE dim_store (
    store_key   SERIAL PRIMARY KEY,
    store_id    VARCHAR(10)  NOT NULL, -- e.g. STR001
    store_name  VARCHAR(100) NOT NULL, -- e.g. 'Chennai Anna'
    city        VARCHAR(50)  NOT NULL  -- e.g. 'Chennai'
);

-- dim_product: one row per product
CREATE TABLE dim_product (
    product_key  SERIAL PRIMARY KEY,
    product_id   VARCHAR(10)  NOT NULL, -- e.g. PRD001
    product_name VARCHAR(100) NOT NULL, -- e.g. 'Speaker'
    category     VARCHAR(50)  NOT NULL  -- standardised: Electronics / Grocery / Clothing
);

-- fact_sales: one row per transaction (the central fact table)
CREATE TABLE fact_sales (
    sales_key      SERIAL PRIMARY KEY,
    transaction_id VARCHAR(20) NOT NULL,
    date_key       INT NOT NULL REFERENCES dim_date(date_key),
    store_key      INT NOT NULL REFERENCES dim_store(store_key),
    product_key    INT NOT NULL REFERENCES dim_product(product_key),
    units_sold     INT            NOT NULL,
    unit_price     NUMERIC(12,2)  NOT NULL,
    revenue        NUMERIC(14,2)  NOT NULL  -- units_sold * unit_price (computed during ETL)
);


-- ============================================================
-- STEP 3: INSERT DIMENSION DATA
-- ============================================================

-- dim_date (one row per unique date used in the 10 fact rows below)
INSERT INTO dim_date (full_date, day, month, month_name, quarter, year) VALUES
('2023-08-29', 29,  8, 'August',    3, 2023),
('2023-12-12', 12, 12, 'December',  4, 2023),
('2023-02-05',  5,  2, 'February',  1, 2023),
('2023-02-20', 20,  2, 'February',  1, 2023),
('2023-01-15', 15,  1, 'January',   1, 2023),
('2023-09-08',  8,  9, 'September', 3, 2023),
('2023-03-31', 31,  3, 'March',     1, 2023),
('2023-10-26', 26, 10, 'October',   4, 2023),
('2023-08-12', 12,  8, 'August',    3, 2023),
('2023-04-06',  6,  4, 'April',     2, 2023);

-- dim_store (5 stores from the data)
INSERT INTO dim_store (store_id, store_name, city) VALUES
('STR001', 'Chennai Anna',   'Chennai'),
('STR002', 'Delhi South',    'Delhi'),
('STR003', 'Bangalore MG',   'Bangalore'),
('STR004', 'Pune FC Road',   'Pune'),
('STR005', 'Mumbai Central', 'Mumbai');

-- dim_product (products used in the 10 fact rows)
INSERT INTO dim_product (product_id, product_name, category) VALUES
('PRD001', 'Speaker',    'Electronics'),
('PRD002', 'Tablet',     'Electronics'),
('PRD003', 'Phone',      'Electronics'),
('PRD004', 'Smartwatch', 'Electronics'),
('PRD005', 'Atta 10kg',  'Grocery'),
('PRD006', 'Jeans',      'Clothing'),
('PRD007', 'Biscuits',   'Grocery'),
('PRD008', 'Jacket',     'Clothing'),
('PRD009', 'Laptop',     'Electronics'),
('PRD010', 'Milk 1L',    'Grocery');


-- ============================================================
-- STEP 4: INSERT FACT DATA (10 cleaned rows)
-- Cleaning applied:
--   - Dates standardised to YYYY-MM-DD (was: DD/MM/YYYY, DD-MM-YYYY)
--   - category 'electronics' -> 'Electronics', 'Groceries' -> 'Grocery'
--   - NULL store_city filled from store_name lookup
--   - revenue = units_sold * unit_price (computed column)
-- ============================================================
INSERT INTO fact_sales (transaction_id, date_key, store_key, product_key, units_sold, unit_price, revenue) VALUES
-- TXN5000: Speaker, Chennai Anna, 29 Aug 2023
('TXN5000', 1, 1, 1,   3,  49262.78,  147788.34),
-- TXN5001: Tablet, Chennai Anna, 12 Dec 2023
('TXN5001', 2, 1, 2,  11,  23226.12,  255487.32),
-- TXN5002: Phone, Chennai Anna, 05 Feb 2023  [date was 2023-02-05 — already ISO]
('TXN5002', 3, 1, 3,  20,  48703.39,  974067.80),
-- TXN5003: Tablet, Delhi South, 20 Feb 2023  [date was 20-02-2023]
('TXN5003', 4, 2, 2,  14,  23226.12,  325165.68),
-- TXN5004: Smartwatch, Chennai Anna, 15 Jan 2023  [category was 'electronics' -> 'Electronics']
('TXN5004', 5, 1, 4,  10,  58851.01,  588510.10),
-- TXN5005: Atta 10kg, Bangalore MG, 08 Sep 2023  [date was 2023-08-09, parsed dayfirst -> Sep 8]
('TXN5005', 6, 3, 5,  12,  52464.00,  629568.00),
-- TXN5006: Smartwatch, Pune FC Road, 31 Mar 2023  [category was 'electronics' -> 'Electronics']
('TXN5006', 7, 4, 4,   6,  58851.01,  353106.06),
-- TXN5007: Jeans, Pune FC Road, 26 Oct 2023
('TXN5007', 8, 4, 6,  16,   2317.47,   37079.52),
-- TXN5008: Biscuits, Bangalore MG, 12 Aug 2023  [category was 'Groceries' -> 'Grocery']
('TXN5008', 9, 3, 7,   9,  27469.99,  247229.91),
-- TXN5010: Jacket, Chennai Anna, 06 Apr 2023
('TXN5010', 10, 1, 8,  15,  30187.24,  452808.60);
