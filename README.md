# PL/SQL Collections, Records & GOTO Demonstration

**Student Name:** CYIZERE SIBORUREMA Elie  
**Course:** INSY 831 – Database Development with PL/SQL  
**Instructor:** Eric Maniraguha  
**Date:** November 2025  

---

## 🎯 Objective
This project demonstrates how to use **PL/SQL composite data types** — *Collections* and *Records* — along with the **GOTO** statement for control flow.  
It simulates a simple **department payroll and HR data management** example using Oracle PL/SQL.

---

## 📘 Project Overview

The scripts in this repository illustrate the following PL/SQL concepts:

| Concept | Example Used | Description |
|----------|---------------|-------------|
| **Associative Array** | `city_population` | Stores city names and their population values using string keys |
| **VARRAY** | `salary_varray_t` | Holds up to 5 monthly salary values for one employee |
| **Nested Table** | `bonus_nt_t` | A dynamic list of bonuses that can become sparse when elements are deleted |
| **Table-Based Record** | `%ROWTYPE` | Fetches a complete row from the `employees` table |
| **User-Defined Record** | `emp_rec_t` | Custom record type containing a VARRAY of salaries |
| **Cursor-Based Record** | `c_emp` | Iterates through multiple employee rows using a cursor |
| **GOTO Statement** | `error_label` and `finish` | Demonstrates error handling and conditional jump |
| **Collection of Records** | `emps` | Stores multiple employee records in an associative array |

---

## ⚙️ How to Run the Project

### **1️⃣ Enable Output**
In SQL*Plus or SQL Developer:
```sql
SET SERVEROUTPUT ON;
