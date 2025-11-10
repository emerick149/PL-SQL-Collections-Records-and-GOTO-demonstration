# Design Document — PL/SQL Collections, Records & GOTO Problem

## Problem Definition (student task)
Build a small PL/SQL module to manage a department payroll & personnel demo that exercises:
- **Collections**
  - Use an **Associative Array** to store city populations (string index).
  - Use a **VARRAY** to store up to 5 monthly salaries for a single employee.
  - Use a **Nested Table** to store a variable list of bonus amounts for a department.
- **Records**
  - Demonstrate a table-based record (`%ROWTYPE`) by selecting from `employees`.
  - Demonstrate a user-defined record containing various types and a VARRAY inside it.
  - Demonstrate cursor-based record iteration.
- **GOTO**
  - Use `GOTO` labels to control flow for early exit or to re-check data validation in one small example. (Explicit use requested by instructor.)

## Learning Objectives
- Correct declaration and initialization of collections and records.
- Proper iteration and existence checks (`EXISTS`, `COUNT`, `LAST`).
- Combining records and collections.
- Understand the (limited) use of `GOTO` in PL/SQL and disciplined labeling.

## Assessment Checklist
- Code runs without compile errors.
- DBMS_OUTPUT is clear and annotated.
- Examples include comments explaining each step.
- Edge cases handled (e.g., sparse nested table entries).
- Documentation explains how to run and expected output.