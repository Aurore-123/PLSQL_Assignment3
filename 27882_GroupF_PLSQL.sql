SET SERVEROUTPUT ON;

-- ===========================================
-- QUESTION 1 — Variables, %TYPE & DBMS_OUTPUT
-- Student: Isaro Aurore | ID: 27882
-- ===========================================

-- -------------------------------------------
-- Task 1.1 — Variables and BOOLEAN
-- -------------------------------------------
DECLARE
   v_course_name   VARCHAR2(100) := 'Database Management Systems';
   v_credits       NUMBER(1) := 4;
   v_start_date    DATE := DATE '2024-09-01';
   v_heavy_course  BOOLEAN;
BEGIN
   -- Determine if course is heavy
   IF v_credits >= 3 THEN
      v_heavy_course := TRUE;
   ELSE
      v_heavy_course := FALSE;
   END IF;

   -- Print results
   DBMS_OUTPUT.PUT_LINE('Course: ' || v_course_name);
   DBMS_OUTPUT.PUT_LINE('Credits: ' || v_credits);
   DBMS_OUTPUT.PUT_LINE('Semester Start: ' || TO_CHAR(v_start_date, 'DD-MON-YY'));

   IF v_heavy_course THEN
      DBMS_OUTPUT.PUT_LINE('Heavy Course: TRUE');
   ELSE
      DBMS_OUTPUT.PUT_LINE('Heavy Course: FALSE');
   END IF;
END;
/

-- -------------------------------------------
-- Task 1.2 — SELECT INTO with %TYPE
-- -------------------------------------------
DECLARE
   v_course_name   courses.course_name%TYPE;
   v_instructor    courses.instructor%TYPE;
   v_credits       courses.credits%TYPE;
   v_max_students  courses.max_students%TYPE;
BEGIN
   SELECT course_name, instructor, credits, max_students
   INTO v_course_name, v_instructor, v_credits, v_max_students
   FROM courses
   WHERE course_id = 110;

   DBMS_OUTPUT.PUT_LINE('Course: ' || v_course_name);
   DBMS_OUTPUT.PUT_LINE('Instructor: ' || v_instructor);
   DBMS_OUTPUT.PUT_LINE('Credits: ' || v_credits);

   IF v_max_students < 20 THEN
      DBMS_OUTPUT.PUT_LINE('Limited seats available!');
   END IF;
END;
/
-- -------------------------------------------
-- Task 1.3 — %ROWTYPE and Calculations
-- -------------------------------------------
DECLARE
   v_employee      employees%ROWTYPE;
   v_years_worked  NUMBER;
BEGIN
   SELECT *
   INTO v_employee
   FROM employees
   WHERE employee_id = 22;

   v_years_worked := FLOOR(MONTHS_BETWEEN(SYSDATE, v_employee.hire_date) / 12);

   DBMS_OUTPUT.PUT_LINE('Employee: ' || v_employee.first_name || ' ' || v_employee.last_name);
   DBMS_OUTPUT.PUT_LINE('Department: ' || v_employee.department);
   DBMS_OUTPUT.PUT_LINE('Salary: ' || v_employee.salary);
   DBMS_OUTPUT.PUT_LINE('Hire Year: ' || EXTRACT(YEAR FROM v_employee.hire_date));
   DBMS_OUTPUT.PUT_LINE('Years Worked: ' || v_years_worked);

END;
/


-- ===========================================
-- QUESTION 2 — IF / ELSIF / ELSE
-- Student: Isaro Aurore | ID: 27882
-- ===========================================


-- -------------------------------------------
-- Task 2.1 — Employee Commission Checker
-- -------------------------------------------
DECLARE
   v_employee   employees%ROWTYPE;
   v_total_pay  NUMBER;
BEGIN
   -- Fetch employee data
   SELECT *
   INTO v_employee
   FROM employees
   WHERE employee_id = 1;

   -- IF / ELSIF / ELSE logic
   IF v_employee.commission_pct IS NOT NULL 
      AND v_employee.salary > 80000 THEN
      
      DBMS_OUTPUT.PUT_LINE('High-value manager with commission');

   ELSIF v_employee.commission_pct IS NOT NULL 
      AND v_employee.salary <= 80000 THEN
      
      DBMS_OUTPUT.PUT_LINE('Manager with commission — standard tier');

   ELSIF v_employee.commission_pct IS NULL 
      AND v_employee.salary > 90000 THEN
      
      DBMS_OUTPUT.PUT_LINE('Senior employee — consider adding commission incentive');

   ELSE
      DBMS_OUTPUT.PUT_LINE('Standard employee profile');
   END IF;

   -- Calculate total potential earnings
   v_total_pay := v_employee.salary + 
                  (v_employee.salary * NVL(v_employee.commission_pct, 0));

   DBMS_OUTPUT.PUT_LINE('Base Salary: RWF ' || v_employee.salary);
   DBMS_OUTPUT.PUT_LINE('Total Potential Earnings: RWF ' || v_total_pay);

END;
/


-- -------------------------------------------
-- Task 2.2 — Course Availability Check
-- -------------------------------------------
DECLARE
   v_course_name     courses.course_name%TYPE;
   v_max_students    courses.max_students%TYPE;
   v_enrolled_count  NUMBER;
BEGIN
   -- Fetch course details
   SELECT course_name, max_students
   INTO v_course_name, v_max_students
   FROM courses
   WHERE course_id = 103;

   -- Count enrolled students
   SELECT COUNT(*)
   INTO v_enrolled_count
   FROM enrollments
   WHERE course_id = 103;

   -- Print course details
   DBMS_OUTPUT.PUT_LINE('Course: ' || v_course_name);
   DBMS_OUTPUT.PUT_LINE('Max Capacity: ' || v_max_students);
   DBMS_OUTPUT.PUT_LINE('Current Enrollment: ' || v_enrolled_count);

   -- Availability logic
   IF v_enrolled_count < v_max_students * 0.5 THEN
      DBMS_OUTPUT.PUT_LINE('Status: Open — plenty of seats available');

   ELSIF v_enrolled_count BETWEEN v_max_students * 0.5 
                              AND v_max_students * 0.8 THEN
      DBMS_OUTPUT.PUT_LINE('Status: Filling up — limited seats');

   ELSIF v_enrolled_count > v_max_students * 0.8 
         AND v_enrolled_count < v_max_students THEN
      DBMS_OUTPUT.PUT_LINE('Status: Almost full — enroll soon');

   ELSE
      DBMS_OUTPUT.PUT_LINE('Status: FULL — enrollment closed');
   END IF;

END;
/

-- -------------------------------------------
-- Task 2.3 — Student Age Eligibility
-- -------------------------------------------
DECLARE
   v_first_name        students.first_name%TYPE;
   v_last_name         students.last_name%TYPE;
   v_dob               students.date_of_birth%TYPE;
   v_enrollment_date   students.enrollment_date%TYPE;
   v_age               NUMBER;
BEGIN
   -- Fetch student data
   SELECT first_name, last_name, date_of_birth, enrollment_date
   INTO v_first_name, v_last_name, v_dob, v_enrollment_date
   FROM students
   WHERE student_id = 1020;

   -- Calculate age in years
   v_age := FLOOR(MONTHS_BETWEEN(SYSDATE, v_dob) / 12);

   DBMS_OUTPUT.PUT_LINE('Student: ' || v_first_name || ' ' || v_last_name);
   DBMS_OUTPUT.PUT_LINE('Age: ' || v_age);

   -- Age classification
   IF v_age < 18 THEN
      DBMS_OUTPUT.PUT_LINE('Minor student — parental consent required');

   ELSIF v_age BETWEEN 18 AND 25 THEN
      DBMS_OUTPUT.PUT_LINE('Traditional student age');

   ELSE
      DBMS_OUTPUT.PUT_LINE('Mature student — eligible for evening program');
   END IF;

   -- Enrollment year check
   IF EXTRACT(YEAR FROM v_enrollment_date) = 2023 THEN
      DBMS_OUTPUT.PUT_LINE('First-year cohort (2023)');
   END IF;

END;
/

-- ===========================================
-- QUESTION 3 — CASE Statements
-- Student: Isaro Aurore | ID: 27882
-- ===========================================

-- -------------------------------------------
-- Task 3.1 — Score to Grade Conversion
-- -------------------------------------------
DECLARE
   v_score           enrollments.score%TYPE;
   v_stored_grade    enrollments.grade%TYPE;
   v_computed_grade  VARCHAR2(20);
BEGIN
   -- Fetch enrollment record
   SELECT score, grade
   INTO v_score, v_stored_grade
   FROM enrollments
   WHERE enrollment_id = 5;

   -- Compute grade using searched CASE
   CASE
      WHEN v_score IS NULL THEN
         v_computed_grade := 'Not yet graded';
      WHEN v_score >= 90 THEN
         v_computed_grade := 'A';
      WHEN v_score >= 80 THEN
         v_computed_grade := 'B';
      WHEN v_score >= 70 THEN
         v_computed_grade := 'C';
      WHEN v_score >= 60 THEN
         v_computed_grade := 'D';
      ELSE
         v_computed_grade := 'F';
   END CASE;

   DBMS_OUTPUT.PUT_LINE('Score: ' || NVL(TO_CHAR(v_score), 'NULL'));
   DBMS_OUTPUT.PUT_LINE('Stored Grade: ' || NVL(v_stored_grade, 'NULL'));
   DBMS_OUTPUT.PUT_LINE('Computed Grade: ' || v_computed_grade);

   -- Compare grades
   IF v_stored_grade = v_computed_grade THEN
      DBMS_OUTPUT.PUT_LINE('Grade match: YES');
   ELSE
      DBMS_OUTPUT.PUT_LINE('Grade match: NO — stored ' 
                           || NVL(v_stored_grade, 'NULL') 
                           || ', computed ' 
                           || v_computed_grade);
   END IF;

END;
/

-- -------------------------------------------
-- Task 3.2 — Department Location Codes
-- -------------------------------------------
DECLARE
   v_dept_name     departments.department_name%TYPE;
   v_budget        departments.budget%TYPE;
   v_building_code VARCHAR2(50);
BEGIN
   -- Fetch Computer Science department
   SELECT department_name, budget
   INTO v_dept_name, v_budget
   FROM departments
   WHERE department_name = 'Computer Science';

   -- Simple CASE for building code
   CASE v_dept_name
      WHEN 'Computer Science' THEN
         v_building_code := 'BLD-CS | ICT Wing';
      WHEN 'Mathematics' THEN
         v_building_code := 'BLD-MT | Science Wing';
      WHEN 'Business' THEN
         v_building_code := 'BLD-BS | Commerce Wing';
      WHEN 'Engineering' THEN
         v_building_code := 'BLD-EN | Technical Wing';
      WHEN 'Psychology' THEN
         v_building_code := 'BLD-PS | Humanities Wing';
      ELSE
         v_building_code := 'BLD-GN | General Wing';
   END CASE;

   DBMS_OUTPUT.PUT_LINE('Department: ' || v_dept_name);
   DBMS_OUTPUT.PUT_LINE('Building Code: ' || v_building_code);
   DBMS_OUTPUT.PUT_LINE('Budget: RWF ' || v_budget);

   -- Inline CASE expression for budget status
   DBMS_OUTPUT.PUT_LINE(
      'Budget Status: ' ||
      CASE
         WHEN v_budget > 600000 THEN 'Well Funded'
         WHEN v_budget BETWEEN 400000 AND 600000 THEN 'Adequately Funded'
         ELSE 'Underfunded'
      END
   );

END;
/

-- -------------------------------------------
-- Task 3.3 — Job Title Rank
-- -------------------------------------------
DECLARE
   v_employee     employees%ROWTYPE;
   v_rank_number  NUMBER;
   v_rank_title   VARCHAR2(50);
BEGIN
   -- Fetch employee
   SELECT *
   INTO v_employee
   FROM employees
   WHERE employee_id = 14;

   -- CASE for rank assignment
   CASE
      WHEN v_employee.job_title = 'Full Professor' THEN
         v_rank_number := 1;
         v_rank_title  := 'Senior Academic';

      WHEN v_employee.job_title = 'Associate Professor' THEN
         v_rank_number := 2;
         v_rank_title  := 'Mid Academic';

      WHEN v_employee.job_title = 'Assistant Professor' THEN
         v_rank_number := 3;
         v_rank_title  := 'Junior Academic';

      WHEN v_employee.job_title LIKE '%Developer%'
        OR v_employee.job_title LIKE '%Engineer%' THEN
         v_rank_number := 4;
         v_rank_title  := 'Technical Staff';

      WHEN v_employee.job_title LIKE '%Admin%'
        OR v_employee.job_title LIKE '%Coordinator%' THEN
         v_rank_number := 5;
         v_rank_title  := 'Administrative Staff';

      ELSE
         v_rank_number := 6;
         v_rank_title  := 'General Staff';
   END CASE;

   -- Print details
   DBMS_OUTPUT.PUT_LINE('Employee: ' || v_employee.first_name || ' ' || v_employee.last_name);
   DBMS_OUTPUT.PUT_LINE('Job Title: ' || v_employee.job_title);
   DBMS_OUTPUT.PUT_LINE('Salary: RWF ' || v_employee.salary);
   DBMS_OUTPUT.PUT_LINE('Rank Number: ' || v_rank_number);
   DBMS_OUTPUT.PUT_LINE('Rank Title: ' || v_rank_title);

   -- Promotion check
   IF v_rank_number <= 2 AND v_employee.salary < 100000 THEN
      DBMS_OUTPUT.PUT_LINE('Promotion eligible');
   END IF;

END;
/

-- ===========================================
-- QUESTION 4 — Loops
-- Student: Isaro Aurore | ID: 27882
-- ===========================================

-- -------------------------------------------
-- Task 4.1 — Basic LOOP: Tuition Fee Calculator
-- -------------------------------------------

DECLARE
   v_total_credits   NUMBER := 0;
   v_total_tuition   NUMBER := 0;
   v_course_id       NUMBER := 101;
   v_course_name     courses.course_name%TYPE;
   v_credits         courses.credits%TYPE;
   v_cost_per_credit CONSTANT NUMBER := 150000;
BEGIN
   LOOP
      -- Fetch course
      SELECT course_name, credits
      INTO v_course_name, v_credits
      FROM courses
      WHERE course_id = v_course_id;

      -- Accumulate totals
      v_total_credits := v_total_credits + v_credits;
      v_total_tuition := v_total_tuition + 
                         (v_credits * v_cost_per_credit);

      -- Print iteration
      DBMS_OUTPUT.PUT_LINE(
         'Added: ' || v_course_name ||
         ' (' || v_credits || ' credits)' ||
         ' | Running Total: ' || v_total_credits ||
         ' credits | Tuition So Far: RWF ' || v_total_tuition
      );

      -- Exit condition
      EXIT WHEN v_total_credits >= 15;

      -- Move to next course
      v_course_id := v_course_id + 1;
   END LOOP;

   -- Final output
   DBMS_OUTPUT.PUT_LINE('--------------------------------');
   DBMS_OUTPUT.PUT_LINE('Final Total Credits: ' || v_total_credits);
   DBMS_OUTPUT.PUT_LINE('Final Tuition: RWF ' || v_total_tuition);
   DBMS_OUTPUT.PUT_LINE('Average Cost per Credit: RWF ' ||
      (v_total_tuition / v_total_credits));

END;
/

-- -------------------------------------------
-- Task 4.2 — WHILE Loop: Department Salary Budget
-- -------------------------------------------
DECLARE
   CURSOR cs_employees IS
      SELECT first_name, last_name, salary
      FROM employees
      WHERE department = 'Computer Science';

   v_first_name     employees.first_name%TYPE;
   v_last_name      employees.last_name%TYPE;
   v_salary         employees.salary%TYPE;

   v_total_salary   NUMBER := 0;
   v_employee_count NUMBER := 0;
   v_high_earners   NUMBER := 0;
   v_low_earners    NUMBER := 0;

   v_max_salary     NUMBER := 0;
   v_max_name       VARCHAR2(100);
BEGIN
   OPEN cs_employees;
   FETCH cs_employees INTO v_first_name, v_last_name, v_salary;

   WHILE cs_employees%FOUND LOOP

      v_employee_count := v_employee_count + 1;
      v_total_salary   := v_total_salary + v_salary;

      -- High earners
      IF v_salary > 75000 THEN
         v_high_earners := v_high_earners + 1;
      END IF;

      -- Low earners
      IF v_salary < 65000 THEN
         v_low_earners := v_low_earners + 1;
      END IF;

      -- Track highest salary
      IF v_salary > v_max_salary THEN
         v_max_salary := v_salary;
         v_max_name   := v_first_name || ' ' || v_last_name;
      END IF;

      FETCH cs_employees INTO v_first_name, v_last_name, v_salary;
   END LOOP;

   CLOSE cs_employees;

   -- Print Report
   DBMS_OUTPUT.PUT_LINE('===== Computer Science Salary Report =====');
   DBMS_OUTPUT.PUT_LINE('Total Employees: ' || v_employee_count);
   DBMS_OUTPUT.PUT_LINE('Total Salary Bill: RWF ' || v_total_salary);

   IF v_employee_count > 0 THEN
      DBMS_OUTPUT.PUT_LINE('Average Salary: RWF ' ||
         (v_total_salary / v_employee_count));
   END IF;

   DBMS_OUTPUT.PUT_LINE('High Earners (>75k): ' || v_high_earners);
   DBMS_OUTPUT.PUT_LINE('Low Earners (<65k): ' || v_low_earners);
   DBMS_OUTPUT.PUT_LINE('Highest Paid: ' || v_max_name ||
                        ' — RWF ' || v_max_salary);
   DBMS_OUTPUT.PUT_LINE('==========================================');

END;
/

-- -------------------------------------------
-- Task 4.3 — FOR Loop: Academic Performance Table
-- -------------------------------------------
DECLARE
   v_first_name     students.first_name%TYPE;
   v_last_name      students.last_name%TYPE;
   v_gpa            students.gpa%TYPE;
   v_enroll_count   NUMBER;

   v_performance    VARCHAR2(30);
   v_load_status    VARCHAR2(30);

   v_total_students NUMBER := 0;

   v_summa_count    NUMBER := 0;
   v_magna_count    NUMBER := 0;
   v_cum_count      NUMBER := 0;
   v_sat_count      NUMBER := 0;
   v_prob_count     NUMBER := 0;

BEGIN
   FOR v_id IN 1001..1010 LOOP

      -- Fetch student
      SELECT first_name, last_name, gpa
      INTO v_first_name, v_last_name, v_gpa
      FROM students
      WHERE student_id = v_id;

      -- Count enrollments
      SELECT COUNT(*)
      INTO v_enroll_count
      FROM enrollments
      WHERE student_id = v_id;

      -- Performance classification
      CASE
         WHEN v_gpa >= 3.8 THEN
            v_performance := 'Summa Cum Laude';
            v_summa_count := v_summa_count + 1;

         WHEN v_gpa >= 3.5 THEN
            v_performance := 'Magna Cum Laude';
            v_magna_count := v_magna_count + 1;

         WHEN v_gpa >= 3.2 THEN
            v_performance := 'Cum Laude';
            v_cum_count := v_cum_count + 1;

         WHEN v_gpa >= 2.5 THEN
            v_performance := 'Satisfactory';
            v_sat_count := v_sat_count + 1;

         ELSE
            v_performance := 'Probation';
            v_prob_count := v_prob_count + 1;
      END CASE;

      -- Enrollment load classification
      CASE
         WHEN v_enroll_count <= 1 THEN
            v_load_status := 'Under-enrolled';
         WHEN v_enroll_count BETWEEN 2 AND 3 THEN
            v_load_status := 'Normal Load';
         ELSE
            v_load_status := 'Full Load';
      END CASE;

      -- Print row
      DBMS_OUTPUT.PUT_LINE(
         'ID:' || v_id ||
         ' | ' || RPAD(v_first_name || ' ' || v_last_name, 20) ||
         ' | GPA:' || v_gpa ||
         ' | ' || RPAD(v_performance, 20) ||
         ' | ' || v_load_status
      );

      v_total_students := v_total_students + 1;

   END LOOP;

   -- Final summary
   DBMS_OUTPUT.PUT_LINE('---------------------------------------------');
   DBMS_OUTPUT.PUT_LINE('Total Students Printed: ' || v_total_students);
   DBMS_OUTPUT.PUT_LINE('Summa Cum Laude: ' || v_summa_count);
   DBMS_OUTPUT.PUT_LINE('Magna Cum Laude: ' || v_magna_count);
   DBMS_OUTPUT.PUT_LINE('Cum Laude: ' || v_cum_count);
   DBMS_OUTPUT.PUT_LINE('Satisfactory: ' || v_sat_count);
   DBMS_OUTPUT.PUT_LINE('Probation: ' || v_prob_count);

END;
/

-- ===========================================
-- QUESTION 5 — Combined Challenge
-- Student: Isaro Aurore | ID: 27882
-- ===========================================

-- -------------------------------------------
-- QUESTION 5 — Employee Profile Report
-- -------------------------------------------
DECLARE
   v_employee           employees%ROWTYPE;
   v_years_service      NUMBER;
   v_service_status     VARCHAR2(30);

   v_pay_grade          NUMBER;
   v_raise_status       VARCHAR2(30);
   v_proposed_salary    NUMBER;

   v_colleagues         NUMBER := 0;
   v_highest_salary     NUMBER := 0;
   v_more_than_tom      NUMBER := 0;

BEGIN
   -- ===============================
   -- Step 1 — Employee Profile
   -- ===============================
   SELECT *
   INTO v_employee
   FROM employees
   WHERE employee_id = 5;

   v_years_service := ROUND(MONTHS_BETWEEN(SYSDATE, v_employee.hire_date) / 12, 1);

   IF v_years_service < 2 THEN
      v_service_status := 'Probationary';
   ELSIF v_years_service BETWEEN 2 AND 5 THEN
      v_service_status := 'Confirmed';
   ELSE
      v_service_status := 'Senior Staff';
   END IF;

   -- ===============================
   -- Step 2 — Salary Analysis
   -- ===============================
   CASE
      WHEN v_employee.salary >= 100000 THEN v_pay_grade := 1;
      WHEN v_employee.salary >= 90000 THEN v_pay_grade := 2;
      WHEN v_employee.salary >= 80000 THEN v_pay_grade := 3;
      WHEN v_employee.salary >= 70000 THEN v_pay_grade := 4;
      ELSE v_pay_grade := 5;
   END CASE;

   IF v_years_service > 3 AND v_employee.salary < 85000 THEN
      v_raise_status := 'Raise recommended';
      v_proposed_salary := v_employee.salary * 1.10;
   ELSE
      v_raise_status := 'No raise required';
      v_proposed_salary := v_employee.salary;
   END IF;

   -- ===============================
   -- Step 3 — Department Summary
   -- ===============================
   FOR rec IN (
      SELECT salary
      FROM employees
      WHERE department = v_employee.department
        AND employee_id != v_employee.employee_id
   ) LOOP

      v_colleagues := v_colleagues + 1;

      IF rec.salary > v_highest_salary THEN
         v_highest_salary := rec.salary;
      END IF;

      IF rec.salary > v_employee.salary THEN
         v_more_than_tom := v_more_than_tom + 1;
      END IF;

   END LOOP;

   -- ===============================
   -- Step 4 — Final Report Output
   -- ===============================

   DBMS_OUTPUT.PUT_LINE('========================================');
   DBMS_OUTPUT.PUT_LINE('   EMPLOYEE PROFILE REPORT');
   DBMS_OUTPUT.PUT_LINE('   AUCA — HR Department System');
   DBMS_OUTPUT.PUT_LINE('========================================');

   DBMS_OUTPUT.PUT_LINE('Employee: ' || v_employee.first_name || 
                        ' ' || v_employee.last_name ||
                        ' (ID: ' || v_employee.employee_id || ')');

   DBMS_OUTPUT.PUT_LINE('Department: ' || v_employee.department);
   DBMS_OUTPUT.PUT_LINE('Job Title: ' || v_employee.job_title);
   DBMS_OUTPUT.PUT_LINE('Hire Date: ' || 
                        TO_CHAR(v_employee.hire_date, 'DD-MON-YY') ||
                        ' | Years of Service: ' || v_years_service);

   DBMS_OUTPUT.PUT_LINE('Service Status: ' || v_service_status);

   DBMS_OUTPUT.PUT_LINE('----------------------------------------');

   DBMS_OUTPUT.PUT_LINE('Salary: RWF ' || v_employee.salary ||
                        ' | Pay Grade: ' || v_pay_grade);

   DBMS_OUTPUT.PUT_LINE('Raise Status: ' || v_raise_status);
   DBMS_OUTPUT.PUT_LINE('Proposed Salary: RWF ' || v_proposed_salary);

   DBMS_OUTPUT.PUT_LINE('----------------------------------------');

   DBMS_OUTPUT.PUT_LINE('Dept. Colleagues: ' || v_colleagues);
   DBMS_OUTPUT.PUT_LINE('Dept. Highest Salary: RWF ' || v_highest_salary);
   DBMS_OUTPUT.PUT_LINE('Colleagues Earning More: ' || v_more_than_tom);

   DBMS_OUTPUT.PUT_LINE('========================================');

END;
/