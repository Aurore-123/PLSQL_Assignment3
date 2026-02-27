# PL/SQL Assignment 3  
## DB development with pl/sql  

**Student Name:** Isaro Aurore 
**Student ID:** 27882
 

---

##  Assignment Overview

This assignment demonstrates the use of PL/SQL anonymous blocks in Oracle SQL Developer.  
The tasks cover variables, conditional statements, CASE expressions, loops, cursors, and a comprehensive final report block.

---

##  Approach Used

The assignment was completed using structured PL/SQL anonymous blocks.

Key concepts implemented:

- Variable declarations using standard data types
- Use of %TYPE and %ROWTYPE for safer datatype referencing
- SELECT INTO statements to retrieve data from tables
- IF / ELSIF / ELSE conditional logic
- Simple CASE and searched CASE statements
- LOOP, WHILE LOOP, and FOR LOOP constructs
- Cursor-based iteration for processing multiple records
- Calculations using built-in functions such as MONTHS_BETWEEN
- Formatted output using DBMS_OUTPUT.PUT_LINE

Each question was implemented as a separate executable block, with Question 5 combining multiple concepts into one comprehensive solution.

---

##  Lessons Learned

Through this assignment, I learned:

- The importance of matching exact column names in database queries
- How %TYPE and %ROWTYPE help prevent datatype mismatch errors
- The difference between simple CASE and searched CASE statements
- Proper loop control using EXIT conditions
- The importance of ending PL/SQL blocks with END; and /
- How to format output clearly for readability

---

##  Challenges Faced

Some challenges encountered during the assignment:

- Debugging column mismatches (e.g., department vs department_id)
- Handling NULL values correctly
- Ensuring each block compiled without syntax errors
- Managing multiple tasks within one structured file
- Properly formatting output for clear reporting

All issues were resolved through testing and debugging in SQL Developer.

---

##  Final Notes

All PL/SQL blocks were tested successfully using F5 execution in Oracle SQL Developer with SERVEROUTPUT enabled.

The solution file and output screenshots are included in this submission branch.
