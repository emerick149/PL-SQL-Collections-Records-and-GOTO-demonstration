# Run Instructions

Use Oracle SQL*Plus, SQLcl, or SQL Developer. Ensure `SERVEROUTPUT` is enabled:

In SQL*Plus / SQLcl:
```
SET SERVEROUTPUT ON SIZE 1000000
@create_demo_tables.sql
@demo_collections_records_goto.sql
```

In SQL Developer, open each .sql and press the "Run Script" (F5) button; ensure DBMS output panel is enabled.

Notes:
- The scripts are *anonymous blocks* and do not require creating packages.
- `create_demo_tables.sql` will create an `employees` table in your current schema. Remove or edit if such a table exists already.