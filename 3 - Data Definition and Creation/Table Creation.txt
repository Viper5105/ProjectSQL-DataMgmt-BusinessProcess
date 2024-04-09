SET FOREIGN_KEY_CHECKS = 0;
DROP TABLE  IF EXISTS      A_Department            	 ;
DROP TABLE  IF EXISTS      A_Employee          		 ;
DROP TABLE  IF EXISTS      A_Paycheck          		 ;
DROP TABLE  IF EXISTS      A_Job_Title               ;
DROP TABLE  IF EXISTS      A_New_Hire_Posting		 ;
DROP TABLE  IF EXISTS      A_Withdrawl_Paperwork	 ;
DROP TABLE  IF EXISTS      A_Company_Asset_Ownership ;
DROP TABLE  IF EXISTS      A_Company_Asset        	 ;
DROP TABLE  IF EXISTS      A_Physical_Company_Asset  ;
DROP TABLE  IF EXISTS      A_Clearance_Company_Asset ;
DROP TABLE  IF EXISTS      A_IT_Access_Company_Asset ;

-- ===========================================================================
-- Create employee table.
-- ===========================================================================

CREATE TABLE A_Employee
    ( Employee_ID   INT(8) PRIMARY KEY 
    , Department_ID	INT(4) NOT NULL
    , Job_ID		INT(4) NOT NULL
    , Supervisor_ID	INT(8) NOT NULL
    , First_Name    VARCHAR(32) NOT NULL     
    , Last_Name     VARCHAR(32) NOT NULL     
    , Email    		VARCHAR(32)     
    , Phone_Number  VARCHAR(10)     
    , Hire_Date   	DATE NOT NULL     
    , Salary    	INT(8) NOT NULL    
    ) ;

-- ===========================================================================
-- Create paycheck table.
-- ===========================================================================

CREATE TABLE A_Paycheck
    ( Paycheck_ID  			INT(16) PRIMARY KEY 
    , Paid_to_Employee_ID	INT(8) NOT NULL
    , Paycheck_Date    		DATE NOT NULL    
    , Amount   				REAL(6,2) NOT NULL    
    , Memo    				VARCHAR(20) NOT NULL
    , CONSTRAINT Memo_pickval
       CHECK (Memo in ('salary','severance','final paycheck','benefit'))
    ) ;

-- ===========================================================================
-- Create department table.
-- ===========================================================================

CREATE TABLE A_Department
    ( Department_ID     			INT(4) PRIMARY KEY
    , HR_Manager_Employee_ID		INT(8) NOT NULL
    , Name    	  					VARCHAR(32) NOT NULL
    ) ;

-- ===========================================================================
-- Create job title table.
-- ===========================================================================

CREATE TABLE A_Job_Title
    ( Job_ID        	INT(4) PRIMARY KEY    
    , Title    			VARCHAR(32) NOT NULL   
    , Job_Description	VARCHAR(255) NOT NULL
    , MinSalary    		INT(8) NOT NULL   
    , MaxSalary    		INT(8) NOT NULL
    ) ;

-- ===========================================================================
-- Create new hire posting table.
-- ===========================================================================

CREATE TABLE A_New_Hire_Posting
    ( Posting_ID        	INT(8) PRIMARY KEY 
    , Job_Title_ID			INT(4) NOT NULL
    , Department_ID			INT(4) NOT NULL
    , Department_Endorsed   BOOL    
    , Posting_Date 			DATE    
    , Posting_Description   VARCHAR(255) NOT NULL
    ) ;

-- ===========================================================================
-- Create withdrawl paperwork table.
-- ===========================================================================

CREATE TABLE A_Withdrawl_Paperwork
    ( Resignation_ID        		INT(12) PRIMARY KEY 
    , Employee_ID					INT(8) NOT NULL
    , Department_ID					INT(4) NOT NULL
    , Department_Endorsed   		BOOL
    , Department_Endorsement_Date	DATE
    , Notice_Date					DATE NOT NULL
    , Last_Working_Day				DATE NOT NULL
    , Reason						VARCHAR(255) NOT NULL
    ) ;

-- ===========================================================================
-- Create company asset ownership table.
-- ===========================================================================

CREATE TABLE A_Company_Asset_Ownership
    ( Asset_ID        			INT(12) NOT NULL  
    , Employee_ID				INT(8) NOT NULL
    , Ownership_Start_Date    	DATE NOT NULL
    , Ownership_End_Date		DATE
    ) ;

-- ===========================================================================
-- Create company asset table.
-- ===========================================================================

CREATE TABLE A_Company_Asset
    ( Asset_ID        INT(12) PRIMARY KEY
    , Department_ID	  INT(4) NOT NULL
    , Asset_Type      VARCHAR(20) NOT NULL
    , CONSTRAINT Asset_Type_pickval
       CHECK (Asset_Type in ('Physical Asset','Clearance','IT Access'))
    ) ;

-- ===========================================================================
-- Create physical asset subtype table.
-- ===========================================================================

CREATE TABLE A_Physical_Company_Asset
    ( P_Asset_ID        	INT(12) NOT NULL     
    , Purchase_Date     	DATE NOT NULL
    , Asset_Condition		VARCHAR(32) NOT NULL
    , Condition_Check_Date	DATE	NOT NULL
    , Ownership_Status		VARCHAR(32) NOT NULL
    , CONSTRAINT Condition_pickval
       CHECK (Asset_Condition in ('unit pristine/new','standard wear/tear','degraded','broken'))
    , CONSTRAINT Ownership_pickval
       CHECK (Ownership_Status in ('owned','rented','in stock'))
    ) ;

-- ===========================================================================
-- Create clearance subtype table.
-- ===========================================================================

CREATE TABLE A_Clearance_Company_Asset
    ( C_Asset_ID        INT(12) NOT NULL   
    , Clearance_Type    VARCHAR(64) NOT NULL
    , CONSTRAINT Clearance_pickval
       CHECK (Clearance_Type in ('Manager Notice', 'Digital Lock Combination','Group Area Password', 'Inspection Stamp', 'CUI Database'))
    ) ;

-- ===========================================================================
-- Create IT access subtype table.
-- ===========================================================================

CREATE TABLE A_IT_Access_Company_Asset
    ( IT_Asset_ID      INT(12) NOT NULL     
    , Access_Type    	VARCHAR(32) NOT NULL
    , Location 			VARCHAR(255) NOT NULL
    ) ;

-- ===========================================================================
-- Create foreign keys.
-- ===========================================================================

ALTER TABLE A_Department 
ADD CONSTRAINT FOREIGN KEY (HR_Manager_Employee_ID) 
      REFERENCES A_Employee(Employee_ID);
ALTER TABLE A_Employee 
ADD CONSTRAINT FOREIGN KEY (Department_ID) 
      REFERENCES A_Department(Department_ID);
ALTER TABLE A_Employee 
ADD CONSTRAINT FOREIGN KEY (Job_ID) 
      REFERENCES A_Job_Title(Job_ID);
ALTER TABLE A_Employee 
ADD CONSTRAINT FOREIGN KEY (Supervisor_ID) 
      REFERENCES A_Employee(Employee_ID);
ALTER TABLE A_New_Hire_Posting 
ADD CONSTRAINT FOREIGN KEY (Job_Title_ID) 
      REFERENCES A_Job_Title(Job_ID);
ALTER TABLE A_New_Hire_Posting
ADD CONSTRAINT FOREIGN KEY (Department_ID) 
      REFERENCES A_Department(Department_ID);
ALTER TABLE A_Paycheck 
ADD CONSTRAINT FOREIGN KEY (Paid_to_Employee_ID) 
      REFERENCES A_Employee(Employee_ID);
ALTER TABLE A_Withdrawl_Paperwork
ADD CONSTRAINT FOREIGN KEY (Employee_ID) 
      REFERENCES A_Employee(Employee_ID);
ALTER TABLE A_Withdrawl_Paperwork 
ADD CONSTRAINT FOREIGN KEY (Department_ID) 
      REFERENCES A_Department(Department_ID);
ALTER TABLE A_Company_Asset_Ownership 
ADD CONSTRAINT FOREIGN KEY (Asset_ID) 
      REFERENCES A_Company_Asset(Asset_ID);
ALTER TABLE A_Company_Asset_Ownership 
ADD CONSTRAINT FOREIGN KEY (Employee_ID) 
      REFERENCES A_Employee(Employee_ID);
ALTER TABLE A_Company_Asset
ADD CONSTRAINT FOREIGN KEY (Department_ID) 
      REFERENCES A_Department(Department_ID);
ALTER TABLE A_Physical_Company_Asset 
ADD CONSTRAINT FOREIGN KEY (P_Asset_ID) 
      REFERENCES A_Company_Asset(Asset_ID);
ALTER TABLE A_Clearance_Company_Asset 
ADD CONSTRAINT FOREIGN KEY (C_Asset_ID) 
      REFERENCES A_Company_Asset(Asset_ID);
ALTER TABLE A_IT_Access_Company_Asset 
ADD CONSTRAINT FOREIGN KEY (IT_Asset_ID) 
      REFERENCES A_Company_Asset(Asset_ID);