-- demo_collections_records_goto.sql
-- Run with SERVEROUTPUT ON

SET SERVEROUTPUT ON SIZE 1000000;

-- 1) Associative Array (index-by table) example: city populations
DECLARE
  TYPE population_t IS TABLE OF NUMBER INDEX BY VARCHAR2(64);
  city_population population_t;
  v_city VARCHAR2(64);
BEGIN
  city_population('Kigali') := 1500000;
  city_population('Musanze') := 450000;
  city_population('Butare') := 96000;

  DBMS_OUTPUT.PUT_LINE('--- Associative Array: City populations ---');

  v_city := 'Kigali';
  IF city_population.EXISTS(v_city) THEN
    DBMS_OUTPUT.PUT_LINE(v_city || ': ' || city_population(v_city));
  END IF;

  -- iterate all known keys by using a simple workaround: loop through a known key list
  FOR k IN (SELECT 'Kigali' AS k FROM DUAL UNION ALL SELECT 'Musanze' FROM DUAL UNION ALL SELECT 'Butare' FROM DUAL) LOOP
    IF city_population.EXISTS(k.k) THEN
      DBMS_OUTPUT.PUT_LINE('City: ' || k.k || ' => ' || city_population(k.k));
    END IF;
  END LOOP;
END;
/

-- 2) VARRAY example: store up to 5 salaries for an employee
DECLARE
  TYPE salary_varray_t IS VARRAY(5) OF NUMBER;
  v_salaries salary_varray_t;
  i PLS_INTEGER;
BEGIN
  DBMS_OUTPUT.PUT_LINE('--- VARRAY: Employee monthly salaries (max 5) ---');
  v_salaries := salary_varray_t(5000, 6000, 7000, 8000, 9000);

  FOR i IN 1 .. v_salaries.COUNT LOOP
    DBMS_OUTPUT.PUT_LINE('Salary ' || i || ': ' || v_salaries(i));
  END LOOP;

  -- Reverse order example
  DBMS_OUTPUT.PUT_LINE('Reversed order:');
  FOR i IN REVERSE 1 .. v_salaries.COUNT LOOP
    DBMS_OUTPUT.PUT_LINE('Salary ' || i || ': ' || v_salaries(i));
  END LOOP;
END;
/

-- 3) Nested table example: dynamic list of bonuses, sparse after DELETE
DECLARE
  TYPE bonus_nt_t IS TABLE OF NUMBER;
  bonuses bonus_nt_t := bonus_nt_t(500, 1000, 1500);
  total_bonus NUMBER := 0;
  i PLS_INTEGER;
BEGIN
  DBMS_OUTPUT.PUT_LINE('--- Nested Table: Bonuses ---');
  -- delete the middle bonus to create a gap
  bonuses.DELETE(2);

  FOR i IN 1 .. NVL(bonuses.LAST, 0) LOOP
    IF bonuses.EXISTS(i) THEN
      DBMS_OUTPUT.PUT_LINE('Bonus at ' || i || ': ' || bonuses(i));
      total_bonus := total_bonus + bonuses(i);
    ELSE
      DBMS_OUTPUT.PUT_LINE('Bonus at ' || i || ': <deleted>');
    END IF;
  END LOOP;

  DBMS_OUTPUT.PUT_LINE('Total of existing bonuses: ' || total_bonus);
END;
/

-- 4) Records: table-based (%ROWTYPE), user-defined, cursor-based
DECLARE
  -- table-based record
  emp_row employees%ROWTYPE;

  -- user-defined record containing a VARRAY (to show nested composition)
  TYPE salary_varray_t IS VARRAY(3) OF NUMBER;
  TYPE emp_rec_t IS RECORD (
    emp_id NUMBER,
    name VARCHAR2(100),
    salaries salary_varray_t
  );
  emp_rec emp_rec_t;

  -- cursor-based record
  CURSOR c_emp IS SELECT employee_id, first_name FROM employees;
  cur_rec c_emp%ROWTYPE;
BEGIN
  DBMS_OUTPUT.PUT_LINE('--- Records examples ---');

  -- table-based: attempt to fetch employee 100
  BEGIN
    SELECT * INTO emp_row FROM employees WHERE employee_id = 100;
    DBMS_OUTPUT.PUT_LINE('Table-based record: ' || emp_row.employee_id || ' => ' || emp_row.first_name || ' ' || emp_row.last_name);
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      DBMS_OUTPUT.PUT_LINE('No employee with ID=100 found for table-based record demo.');
  END;

  -- user-defined record with VARRAY
  emp_rec.emp_id := 200;
  emp_rec.name := 'Demo Employee';
  emp_rec.salaries := salary_varray_t(4100, 4200, 4300);
  DBMS_OUTPUT.PUT_LINE('User-defined record: ' || emp_rec.emp_id || ', ' || emp_rec.name || ', salaries: ' || emp_rec.salaries(1) || ', ' || emp_rec.salaries(2) || ', ' || emp_rec.salaries(3));

  -- cursor-based record iteration
  OPEN c_emp;
  LOOP
    FETCH c_emp INTO cur_rec;
    EXIT WHEN c_emp%NOTFOUND;
    DBMS_OUTPUT.PUT_LINE('Cursor row => ID:' || cur_rec.employee_id || ', Name:' || cur_rec.first_name);
  END LOOP;
  CLOSE c_emp;
END;
/

-- 5) GOTO example: validate salary list and jump to error_label when invalid
DECLARE
  TYPE salary_varray_t IS VARRAY(5) OF NUMBER;
  salaries salary_varray_t := salary_varray_t(5000, 0, 7000); -- notice a zero salary to trigger validation
  i PLS_INTEGER;
  sum_sal NUMBER := 0;
BEGIN
  DBMS_OUTPUT.PUT_LINE('--- GOTO example: salary validation ---');

  FOR i IN 1..salaries.COUNT LOOP
    IF salaries(i) IS NULL OR salaries(i) <= 0 THEN
      DBMS_OUTPUT.PUT_LINE('Invalid salary at position ' || i || ': ' || NVL(TO_CHAR(salaries(i)), 'NULL'));
      GOTO error_label;
    END IF;
    sum_sal := sum_sal + salaries(i);
  END LOOP;

  DBMS_OUTPUT.PUT_LINE('Sum of salaries: ' || sum_sal);
  GOTO finish;

<<error_label>>
  DBMS_OUTPUT.PUT_LINE('Error label reached: one or more salaries invalid. Aborting sum.');

<<finish>>
  NULL; -- end
END;
/

-- 6) Combining collections and records: collection of user-defined records
DECLARE
  TYPE emp_rec_t IS RECORD (
    emp_id NUMBER,
    emp_name VARCHAR2(80),
    monthly_salaries VARCHAR2(4000) -- simple textual representation for demo
  );

  TYPE emp_table_t IS TABLE OF emp_rec_t INDEX BY PLS_INTEGER;
  emps emp_table_t;
  i PLS_INTEGER := 0;
BEGIN
  DBMS_OUTPUT.PUT_LINE('--- Collection of Records (Associative by integer) ---');

  i := i + 1;
  emps(i).emp_id := 100;
  emps(i).emp_name := 'Alice Smith';
  emps(i).monthly_salaries := '5000,6000,7000';

  i := i + 1;
  emps(i).emp_id := 101;
  emps(i).emp_name := 'Bob Jones';
  emps(i).monthly_salaries := '6000,6500,7000';

  FOR j IN 1..emps.LAST LOOP
    IF emps.EXISTS(j) THEN
      DBMS_OUTPUT.PUT_LINE('Emp[' || j || '] ID=' || emps(j).emp_id || ', Name=' || emps(j).emp_name || ', Salaries=' || emps(j).monthly_salaries);
    END IF;
  END LOOP;
END;
/