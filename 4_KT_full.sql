DELIMITER //

DROP PROCEDURE IF EXISTS Structure_create;
CREATE PROCEDURE Structure_create()
BEGIN

CREATE TABLE IF NOT EXISTS Work_Group (
    Brigade_ID INT AUTO_INCREMENT PRIMARY KEY,
    Work_Period VARCHAR(50)
);

CREATE TABLE IF NOT EXISTS Addition (
    ID_Addition INT AUTO_INCREMENT PRIMARY KEY,
    Time_Adjustment DECIMAL(5,2),
    Cost_Adjustment DECIMAL(10,2)
);

CREATE TABLE IF NOT EXISTS Management (
    Management_ID INT AUTO_INCREMENT PRIMARY KEY,
    Customer_Full_Name VARCHAR(150),
    Customer_Short_Name VARCHAR(50),
    OKPO VARCHAR(10)
);

CREATE TABLE IF NOT EXISTS Employee (
    ID_Employee INT AUTO_INCREMENT PRIMARY KEY,
    Login_Employee VARCHAR(36),
    Password_Employee VARCHAR(255),
    Passport_Series VARCHAR(10),
    Passport_Number VARCHAR(10),
    Last_Name VARCHAR(50),
    First_Name VARCHAR(50),
    Middle_Name VARCHAR(50),
    Brigade_ID INT,
    FOREIGN KEY (Brigade_ID) REFERENCES Work_Group(Brigade_ID)
        ON DELETE SET NULL ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS Work_Schedule (
    ID_Schedule INT AUTO_INCREMENT PRIMARY KEY,
    Day_Week VARCHAR(11),
    Time_Start TIME,
    Time_End TIME,
    ID_Employee INT,
    FOREIGN KEY (ID_Employee) REFERENCES Employee(ID_Employee)
        ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS Work (
    ID_Work INT AUTO_INCREMENT PRIMARY KEY,
    Work_Name VARCHAR(100),
    Work_Cost DECIMAL(10,2),
    Work_Status VARCHAR(30),
    ID_Schedule INT,
    ID_Addition INT,
    FOREIGN KEY (ID_Schedule) REFERENCES Work_Schedule(ID_Schedule)
        ON DELETE SET NULL ON UPDATE CASCADE,
    FOREIGN KEY (ID_Addition) REFERENCES Addition(ID_Addition)
        ON DELETE SET NULL ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS Documents (
    Contract_ID INT AUTO_INCREMENT PRIMARY KEY,
    Contract_Date DATE,
    Legal_Address VARCHAR(150),
    ID_Work INT,
    Management_ID INT,
    FOREIGN KEY (ID_Work) REFERENCES Work(ID_Work)
        ON DELETE SET NULL ON UPDATE CASCADE,
    FOREIGN KEY (Management_ID) REFERENCES Management(Management_ID)
        ON DELETE SET NULL ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS Objects (
    Object_ID INT AUTO_INCREMENT PRIMARY KEY,
    Object_Address VARCHAR(150),
    Object_Description VARCHAR(255),
    Object_Plan VARCHAR(255),
    Start_Construction_Date DATE,
    End_Construction_Date DATE,
    Contract_ID INT,
    FOREIGN KEY (Contract_ID) REFERENCES Documents(Contract_ID)
        ON DELETE SET NULL ON UPDATE CASCADE
);

ALTER TABLE Documents
ADD COLUMN IF NOT EXISTS Object_ID INT,
ADD CONSTRAINT fk_documents_object
FOREIGN KEY (Object_ID) REFERENCES Objects(Object_ID)
    ON DELETE SET NULL ON UPDATE CASCADE;

END //

DELIMITER ;

CALL Structure_create();
DROP PROCEDURE Structure_create;

DELIMITER //

DROP PROCEDURE IF EXISTS DropTables;
CREATE PROCEDURE DropTables()
BEGIN
    SET FOREIGN_KEY_CHECKS = 0;

    DROP TABLE IF EXISTS Objects;
    DROP TABLE IF EXISTS Documents;
    DROP TABLE IF EXISTS Work;
    DROP TABLE IF EXISTS Work_Schedule;
    DROP TABLE IF EXISTS Employee;
    DROP TABLE IF EXISTS Management;
    DROP TABLE IF EXISTS Addition;
    DROP TABLE IF EXISTS Work_Group;

    SET FOREIGN_KEY_CHECKS = 1;
END //

DELIMITER ;

CREATE INDEX idx_employee_brigade ON Employee(Brigade_ID);
CREATE INDEX idx_schedule_employee ON Work_Schedule(ID_Employee);
CREATE INDEX idx_work_schedule ON Work(ID_Schedule);
CREATE INDEX idx_work_addition ON Work(ID_Addition);


REVOKE ALL PRIVILEGES, GRANT OPTION FROM 'administrator'@'localhost';
REVOKE ALL PRIVILEGES, GRANT OPTION FROM 'scheduler'@'localhost';
REVOKE ALL PRIVILEGES, GRANT OPTION FROM 'accountant'@'localhost';
REVOKE ALL PRIVILEGES, GRANT OPTION FROM 'employee_groupe'@'localhost';
REVOKE ALL PRIVILEGES, GRANT OPTION FROM 'leader_group'@'localhost';
REVOKE ALL PRIVILEGES, GRANT OPTION FROM 'customer'@'localhost';

GRANT ALL PRIVILEGES ON *.* TO 'administrator'@'localhost';

GRANT SELECT ON Work_Group TO 'scheduler'@'localhost';
GRANT SELECT, INSERT, UPDATE, DELETE ON Work_Schedule TO 'scheduler'@'localhost';
GRANT SELECT, INSERT, UPDATE ON Work TO 'scheduler'@'localhost';
GRANT SELECT, INSERT, UPDATE ON Objects TO 'scheduler'@'localhost';

GRANT SELECT ON Employee TO 'accountant'@'localhost';
GRANT SELECT, INSERT, UPDATE ON Addition TO 'accountant'@'localhost';
GRANT SELECT, INSERT, UPDATE ON Work TO 'accountant'@'localhost';
GRANT SELECT ON Documents TO 'accountant'@'localhost';
GRANT SELECT ON Objects TO 'accountant'@'localhost';

GRANT SELECT ON Work_Group TO 'employee_groupe'@'localhost';
GRANT SELECT ON Employee TO 'employee_groupe'@'localhost';
GRANT SELECT, INSERT ON Work_Schedule TO 'employee_groupe'@'localhost';
GRANT SELECT ON Work TO 'employee_groupe'@'localhost';
GRANT SELECT ON Objects TO 'employee_groupe'@'localhost';

GRANT SELECT, UPDATE ON Work_Group TO 'leader_group'@'localhost';
GRANT SELECT, UPDATE ON Employee TO 'leader_group'@'localhost';
GRANT SELECT, UPDATE ON Work_Schedule TO 'leader_group'@'localhost';
GRANT SELECT, UPDATE ON Work TO 'leader_group'@'localhost';
GRANT SELECT ON Documents TO 'leader_group'@'localhost';
GRANT SELECT, UPDATE ON Objects TO 'leader_group'@'localhost';
GRANT SELECT ON Management TO 'leader_group'@'localhost';

GRANT SELECT ON Work TO 'customer'@'localhost';
GRANT SELECT ON Documents TO 'customer'@'localhost';
GRANT SELECT ON Objects TO 'customer'@'localhost';
GRANT SELECT ON Management TO 'customer'@'localhost';

SELECT VERSION();