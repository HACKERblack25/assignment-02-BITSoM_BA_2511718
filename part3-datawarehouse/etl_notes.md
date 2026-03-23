## ETL Decisions

### Decision 1 — Standardising Inconsistent Date Formats
Problem: The `date` column in `retail_transactions.csv` contained three different formats mixed together: `DD/MM/YYYY` (e.g. `29/08/2023`), `DD-MM-YYYY` (e.g. `20-02-2023`), and ISO format `YYYY-MM-DD` (e.g. `2023-02-05`). SQL databases require a single consistent date format and would reject or misparse mixed inputs — for example, `29/08/2023` would be read as an invalid date or misinterpreted as month 8, day 29 vs day 8, month 29.

Resolution: During the ETL transform step, all date values were parsed using Python's `dateutil.parser.parse()` with `dayfirst=True` to correctly handle DD-first formats. Every date was then converted to the standard ISO format `YYYY-MM-DD` before loading into `dim_date`. This ensures consistent sorting, filtering, and date arithmetic in all analytical queries.

---

### Decision 2 — Fixing Inconsistent Category Casing and Naming
Problem: The `category` column had five distinct values for what should be only three categories: `'electronics'`, `'Electronics'` (same category, different case), `'Grocery'`, `'Groceries'` (same category, two different names), and `'Clothing'`. If loaded as-is, a `GROUP BY category` query would split Electronics into two groups and Grocery into two groups, producing incorrect totals and misleading reports.

Resolution: A standardisation mapping was applied in the transform step before loading into `dim_product`:
- `'electronics'` → `'Electronics'`
- `'Groceries'` → `'Grocery'`
- All other values retained as-is

This ensures every product belongs to exactly one of three clean categories: `Electronics`, `Grocery`, or `Clothing`.

---

### Decision 3 — Filling NULL Values in store_city
Problem: 19 rows (out of 300) had a NULL value in the `store_city` column. Since `dim_store` requires a city to support location-based reporting (e.g. revenue by city), these rows could not be loaded without a city value. Dropping them would mean losing 6% of the data.

Resolution: The city could be reliably derived from the `store_name` column, which had no missing values and had a deterministic one-to-one mapping to cities (e.g. `'Mumbai Central'` always belongs to `'Mumbai'`). A lookup dictionary was built from the known store-to-city mapping and applied to fill all NULL city values before loading. No data rows were dropped.