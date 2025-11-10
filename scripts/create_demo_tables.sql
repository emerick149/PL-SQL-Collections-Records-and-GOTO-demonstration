-- create_demo_tables.sql
-- Creates a minimal employees table used by examples
BEGIN
  EXECUTE IMMEDIATE 'CREATE TABLE employees (
    employee_id NUMBER PRIMARY KEY,
    first_name VARCHAR2(50),
    last_name VARCHAR2(50),
    department_id NUMBER,
    salary NUMBER
  )';
EXCEPTION
  WHEN OTHERS THEN
    IF SQLCODE = -955 THEN
      -- Table already exists: ignore
      NULL;
    ELSE
      RAISE;
    END IF;
END;
/

-- Insert sample rows (use MERGE to avoid duplicate inserts)
MERGE INTO employees e
USING (
  SELECT 100 AS employee_id, 'Alice' AS first_name, 'Smith' AS last_name, 10 AS department_id, 5000 AS salary FROM DUAL UNION ALL
  SELECT 101, 'Bob', 'Jones', 20, 6000 FROM DUAL UNION ALL
  SELECT 102, 'Carol', 'White', 10, 7000 FROM DUAL
) src
ON (e.employee_id = src.employee_id)
WHEN NOT MATCHED THEN
  INSERT (employee_id, first_name, last_name, department_id, salary)
  VALUES (src.employee_id, src.first_name, src.last_name, src.department_id, src.salary);
/