IF NOT EXISTS (SELECT * FROM SYS.databases WHERE NAME = 'nyfitness')
    CREATE DATABASE nyfitness
    

USE nyfitness
GO



--DROP CONSTRAINTS

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = 'fk_gymclasses_facility_id')
    ALTER TABLE gymclasses DROP CONSTRAINT fk_gymclasses_facility_id


IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = 'fk_gymclassdates_gymclass_id')
    ALTER TABLE gymclassdates DROP CONSTRAINT fk_gymclassdates_gymclass_id

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = 'fk_gymclassdates_facility_id')
    ALTER TABLE gymclassdates DROP CONSTRAINT fk_gymclassdates_facility_id


IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = 'fk_gymmembers_gymmeber_plan_id')
    ALTER TABLE gymmembers DROP CONSTRAINT fk_gymmembers_gymmeber_plan_id

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = 'fk_checkins_facility_id')
    ALTER TABLE checkins DROP CONSTRAINT fk_checkins_facility_id


IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = 'fk_gymclasses_trainer_id')
    ALTER TABLE gymclasses DROP CONSTRAINT fk_gymclasses_trainer_id


IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME = 'fk_checkins_gymmember_id')
    ALTER TABLE checkins DROP CONSTRAINT fk_checkins_gymmember_id



--DROP INDEXES
DROP INDEX IF EXISTS gymclasses.idx_gymclass_id_category
DROP INDEX IF EXISTS gymfacilities.idx_gymfacility_borough

--DROP FUNCTIONS AND TRIGGERS
DROP FUNCTION IF EXISTS AwardLoyaltyPoints
DROP TRIGGER IF EXISTS AwardLoyaltyPointsTrigger
DROP TRIGGER IF EXISTS CheckNewMemberAgeOver18


-- DROP PROCEDURES
DROP PROCEDURE IF EXISTS UpdateGymClassTrainer

--DROP VIEWS
DROP VIEW IF EXISTS FacilityOverview
DROP VIEW IF EXISTS GymClassAttendance

-- DROP TABLES
DROP TABLE IF EXISTS checkins
DROP TABLE IF EXISTS gymtrainers
DROP TABLE IF EXISTS gymplans
DROP TABLE IF EXISTS gymmembers
DROP TABLE IF EXISTS gymclassdates
DROP TABLE IF EXISTS gymclasses
DROP TABLE IF EXISTS gymfacilities



-- Create tables

CREATE TABLE gymclasses (
    gymclass_id INT IDENTITY(1,1) PRIMARY KEY,
    gymclass_category VARCHAR(100) NOT NULL,
    gymclass_name VARCHAR(100) NOT NULl,
    gymclass_trainer_id INT NOT NULL,
    gymclass_facility_id INT NOT NULL,
    gymclass_day_of_week VARCHAR(50) NOT NULl,
    gymclass_start_time TIME NOT NULL,
    gymclass_end_time TIME NOT NULL
);



CREATE TABLE gymclassdates (
    gymclassdates_date_id INT IDENTITY(1,1) PRIMARY KEY,
    gymclassdates_date DATE NOT NULL,
    gymclassdates_gymclass_id INT NOT NULL,
    gymclassdates_num_atendees_on_date INT NOT NULL,
    CONSTRAINT chk_future_date CHECK (gymclassdates_date <= GETDATE())
);




CREATE TABLE gymfacilities (
    gymfacility_id INT IDENTITY(1,1) PRIMARY KEY,
    gymfacility_zipcode VARCHAR(50) NOT NULL,
    gymfacility_borough VARCHAR(50) NOT NULL
);



CREATE TABLE gymmembers (
    gymmember_id INT IDENTITY(1,1) PRIMARY KEY,
    gymmember_firstname VARCHAR(50) NOT NULL,
    gymmember_lastname VARCHAR(50) NOT NULL,
    gymmember_age INT NOT NULL,
    gymmember_gender VARCHAR(50),
    gymmember_email VARCHAR(100) UNIQUE,
    gymmember_plan_id INT NOT NULL,
    gymmember_phonenumber VARCHAR(100) NOT NULL,
    gymmember_zipcode VARCHAR(50) NOT NULL
); 


CREATE TABLE gymplans (
    gymplan_id INT IDENTITY(1,1) PRIMARY KEY,
    gymplan_price MONEY NOT NULL,
    gymplan_type VARCHAR(50) NOT NULL

)


CREATE TABLE gymtrainers (
    gymtrainer_id INT IDENTITY(1,1) PRIMARY KEY,
    gymtrainer_firstname VARCHAR(50) NOT NULL,
    gymtrainer_lastname VARCHAR(50) NOT NULL,
    gymtrainer_email VARCHAR(100) UNIQUE NOT NULL,
    gymtrainer_specialty VARCHAR(100) NOT NULL
)

CREATE TABLE checkins (
    checkin_id INT IDENTITY(1,1) PRIMARY KEY,
    checkin_date DATE NOT NULL,
    checkin_time TIME NOT NULL,
    checkin_gymmember_id INT NOT NULL,
    checkin_facility_id INT NOT NULL,
    CONSTRAINT chk_checkin_date_past CHECK (checkin_date <= GETDATE())
);




-- Insert facilities for the five boroughs of New York
INSERT INTO gymfacilities (gymfacility_zipcode, gymfacility_borough) VALUES ('10453', 'Bronx');
INSERT INTO gymfacilities (gymfacility_zipcode, gymfacility_borough) VALUES ('11201', 'Brooklyn');
INSERT INTO gymfacilities (gymfacility_zipcode, gymfacility_borough) VALUES ('10001', 'Manhattan');
INSERT INTO gymfacilities (gymfacility_zipcode, gymfacility_borough) VALUES ('11368', 'Queens');
INSERT INTO gymfacilities (gymfacility_zipcode, gymfacility_borough) VALUES ('10304', 'Staten Island');


-- Insert entries for gymplans
INSERT INTO gymplans (gymplan_price, gymplan_type)
VALUES (50.00, 'Standard');
INSERT INTO gymplans (gymplan_price, gymplan_type)
VALUES (100.00, 'Premium');


-- Insert gymmembers
INSERT INTO gymmembers (gymmember_firstname, gymmember_lastname, gymmember_age, gymmember_gender, gymmember_email, gymmember_plan_id, gymmember_phonenumber, gymmember_zipcode)
VALUES
    ('John', 'Doe', 30, 'Male', 'john.doe@example.com', 1, '555-123-4567', '10001'),
    ('Jane', 'Smith', 28, 'Female', 'jane.smith@example.com', 2, '555-234-5678', '11372'),
    ('Michael', 'Johnson', 35, 'Male', 'michael.johnson@example.com', 1, '555-345-6789', '10314'),
    ('Emily', 'Davis', 27, 'Female', 'emily.davis@example.com', 2, '555-456-7890', '11201'),
    ('Alice', 'Johnson', 32, 'Female', 'alice.johnson@example.com', 1, '555-567-8901', '10305'),
    ('David', 'Smith', 29, 'Male', 'david.smith@example.com', 2, '555-678-9012', '11385'),
    ('Sarah', 'Miller', 26, 'Female', 'sarah.miller@example.com', 1, '555-789-0123', '10003'),
    ('Michael', 'Davis', 33, 'Male', 'michael.davis@example.com', 1, '555-890-1234', '11211'),
    ('Emily', 'Wilson', 24, 'Female', 'emily.wilson@example.com', 2, '555-901-2345', '11354'),
    ('Daniel', 'Anderson', 31, 'Male', 'daniel.anderson@example.com', 1, '555-012-3456', '10025'),
    ('Isabella', 'Martin', 29, 'Female', 'isabella.martin@example.com', 2, '555-567-8901', '11368'),
    ('Liam', 'Smith', 40, 'Male', 'liam.smith@example.com', 1, '555-123-4567', '11222'),
    ('Ava', 'Wilson', 45, 'Female', 'ava.wilson@example.com', 2, '555-234-5678', '10013'),
    ('Ethan', 'Davis', 50, 'Male', 'ethan.davis@example.com', 1, '555-345-6789', '11373'),
    ('Olivia', 'Brown', 55, 'Female', 'olivia.brown@example.com', 2, '555-456-7890', '11206'),
    ('Noah', 'Martin', 60, 'Male', 'noah.martin@example.com', 1, '555-567-8901', '10028'),
    ('Sophia', 'Wilson', 65, 'Female', 'sophia.wilson@example.com', 2, '555-678-9012', '11207'),
    ('Mason', 'Hernandez', 70, 'Male', 'mason.hernandez@example.com', 1, '555-789-0123', '10014'),
    ('Ava', 'Robinson', 75, 'Female', 'ava.robinson@example.com', 2, '555-890-1234', '11377'),
    ('Lucas', 'Lee', 80, 'Male', 'lucas.lee@example.com', 1, '555-901-2345', '11221'),
    ('Amelia', 'Walker', 85, 'Female', 'amelia.walker@example.com', 2, '555-012-3456', '10023'),
    ('Henry', 'Smith', 40, 'Male', 'henry.smith@example.com', 1, '555-012-3456', '10023'),
    ('Oliver', 'Lopez', 45, 'Male', 'oliver.lopez@example.com', 2, '555-123-4567', '11237'),
    ('Ella', 'Davis', 50, 'Female', 'ella.davis@example.com', 1, '555-234-5678', '10002'),
    ('Benjamin', 'Hall', 55, 'Male', 'benjamin.hall@example.com', 2, '555-345-6789', '11355'),
    ('Liam', 'Garcia', 60, 'Male', 'liam.garcia@example.com', 1, '555-456-7890', '10303'),
    ('Grace', 'Martin', 65, 'Female', 'grace.martin@example.com', 2, '555-567-8901', '11226'),
    ('William', 'Hernandez', 70, 'Male', 'william.hernandez@example.com', 1, '555-678-9012', '10016'),
    ('Sophia', 'Robinson', 75, 'Female', 'sophia.robinson@example.com', 2, '555-789-0123', '11374'),
    ('Elijah', 'Lee', 80, 'Male', 'elijah.lee@example.com', 1, '555-890-1234', '10009'),
    ('Avery', 'Walker', 85, 'Female', 'avery.walker@example.com', 2, '555-901-2345', '11203'),
    ('Michael', 'Smith', 30, 'Male', 'michael.smith@example.com', 1, '555-012-3456', '10031'),
    ('Emma', 'Lopez', 28, 'Female', 'emma.lopez@example.com', 2, '555-123-4567', '11369'),
    ('Daniel', 'Johnson', 35, 'Male', 'daniel.johnson@example.com', 1, '555-234-5678', '10007'),
    ('Olivia', 'Davis', 27, 'Female', 'olivia.davis@example.com', 2, '555-345-6789', '11222'),
    ('James', 'Hernandez', 32, 'Male', 'james.hernandez@example.com', 1, '555-456-7890', '10012'),
    ('Isabella', 'Martin', 29, 'Female', 'isabella.taylor@example.com', 2, '555-567-8901', '11368');



-- Insert gymtrainers
INSERT INTO gymtrainers (gymtrainer_firstname, gymtrainer_lastname, gymtrainer_email, gymtrainer_specialty)
VALUES
    ('John', 'Smith', 'john.smith@example.com', 'Cardio'), --1
    ('Sarah', 'Johnson', 'sarah.johnson@example.com', 'Cardio'), --2
    ('Michael', 'Davis', 'michael.davis@example.com', 'Cardio'), --3
    ('Emily', 'Wilson', 'emily.wilson@example.com', 'Strength'), --4
    ('David', 'Brown', 'david.brown@example.com', 'Strength'), --5
    ('Jessica', 'Lee', 'jessica.lee@example.com', 'Strength'), --6
    ('Daniel', 'Miller', 'daniel.miller@example.com', 'Yoga'),--7
    ('Olivia', 'Taylor', 'olivia.taylor@example.com', 'Yoga'),--8
    ('Rachel', 'Harris', 'rachel.harris@example.com', 'Yoga'),--9
    ('Matthew', 'Anderson', 'matthew.anderson@example.com', 'Pilates'),--10
    ('Ethan', 'Martinez', 'ethan.martinez@example.com', 'Pilates'),--11
    ('Sophia', 'Hall', 'sophia.hall@example.com', 'Pilates'),--12
    ('William', 'Turner', 'william.turner@example.com', 'Crossfit'),--13
    ('Lily', 'Robinson', 'lily.robinson@example.com', 'Crossfit'),--14
    ('James', 'Brown', 'james.brown@example.com', 'Crossfit'),--15
    ('Jennifer', 'Clark', 'jennifer.clark@example.com', 'Cardio'), --16
    ('Robert', 'Garcia', 'robert.garcia@example.com', 'Cardio'), --17
    ('Catherine', 'Baker', 'catherine.baker@example.com', 'Cardio'), --18
    ('William', 'Gonzalez', 'william.gonzalez@example.com', 'Cardio'), --19
    ('Sophie', 'Moore', 'sophie.moore@example.com', 'Strength'), --20
    ('Andrew', 'White', 'andrew.white@example.com', 'Strength'), --21
    ('Emma', 'Lewis', 'emma.lewis@example.com', 'Strength'), --22
    ('Nicholas', 'Martin', 'nicholas.martin@example.com', 'Strength'), --23
    ('Grace', 'Parker', 'grace.parker@example.com', 'Yoga'), --24
    ('Jacob', 'Clark', 'jacob.clark@example.com', 'Yoga'), --25
    ('Natalie', 'Anderson', 'natalie.anderson@example.com', 'Yoga'), --26
    ('Daniel', 'Hall', 'daniel.hall@example.com', 'Yoga'), --27
    ('Victoria', 'Rodriguez', 'victoria.rodriguez@example.com', 'Pilates'), --28
    ('Christopher', 'Hernandez', 'christopher.hernandez@example.com', 'Pilates'), --29
    ('Ava', 'Young', 'ava.young@example.com', 'Pilates'), --30
    ('Benjamin', 'Scott', 'benjamin.scott@example.com', 'Pilates'), --31
    ('Ella', 'Wright', 'ella.wright@example.com', 'Crossfit'), --32
    ('Alexander', 'King', 'alexander.king@example.com', 'Crossfit'), --33
    ('Chloe', 'Adams', 'chloe.adams@example.com', 'Crossfit'), --34
    ('Samuel', 'Harris', 'samuel.harris@example.com', 'Crossfit'); --35



-- Facility 1 (Bronx) Classes
-- Insert gymclasses grouped by gymclass_category
INSERT INTO gymclasses (gymclass_name, gymclass_category, gymclass_trainer_id, gymclass_facility_id, gymclass_day_of_week, gymclass_start_time, gymclass_end_time)
VALUES
    -- Cardio Classes
    ('Cardio Class Bronx Mon', 'Cardio', 1, 1, 'Monday', '07:00:00', '08:00:00'), --1
    ('Cardio Class Bronx Tue', 'Cardio', 1, 1, 'Tuesday', '18:00:00', '19:00:00'), --2
    ('Cardio Class Bronx Thur', 'Cardio', 1, 1, 'Thursday', '12:00:00', '13:00:00'), --3
    ('Cardio Class Bronx Sat', 'Cardio', 1, 1, 'Saturday', '07:00:00', '08:00:00'), --4

    -- Strength Classes
    ('Strength Class Bronx Mon', 'Strength', 20, 1, 'Monday', '12:00:00', '13:00:00'), --5
    ('Strength Class Bronx Wed', 'Strength', 20, 1, 'Wednesday', '07:00:00', '08:00:00'), --6
    ('Strength Class Bronx Thur', 'Strength', 20, 1, 'Thursday', '18:00:00', '19:00:00'), --7
    ('Strength Class Bronx Sat', 'Strength', 20, 1, 'Saturday', '12:00:00', '13:00:00'), --8

    -- Yoga Classes
    ('Yoga Class Bronx Mon', 'Yoga', 7, 1, 'Monday', '18:00:00', '19:00:00'), --9
    ('Yoga Class Bronx Wed', 'Yoga', 7, 1, 'Wednesday', '12:00:00', '13:00:00'), --10
    ('Yoga Class Bronx Fri', 'Yoga', 7, 1, 'Friday', '07:00:00', '08:00:00'), --11
    ('Yoga Class Bronx Sat', 'Yoga', 7, 1, 'Saturday', '18:00:00', '19:00:00'), --12

    -- Pilates Classes
    ('Pilates Class Bronx Tue', 'Pilates', 10, 1, 'Tuesday', '07:00:00', '08:00:00'), --13
    ('Pilates Class Bronx Wed', 'Pilates', 10, 1, 'Wednesday', '18:00:00', '19:00:00'), --14
    ('Pilates Class Bronx Fri', 'Pilates', 10, 1, 'Friday', '12:00:00', '13:00:00'), --15

    -- Crossfit Classes
    ('Crossfit Class Bronx Tue', 'Crossfit', 13, 1, 'Tuesday', '12:00:00', '13:00:00'), --16
    ('Crossfit Class Bronx Thur', 'Crossfit', 13, 1, 'Thursday', '07:00:00', '08:00:00'), --17
    ('Crossfit Class Bronx Fri', 'Crossfit', 13, 1, 'Friday', '18:00:00', '19:00:00'); --18




-- Facility 2 (Brooklyn) Classes
-- Facility 2 (Brooklyn) Classes
INSERT INTO gymclasses (gymclass_name, gymclass_category, gymclass_trainer_id, gymclass_facility_id, gymclass_day_of_week, gymclass_start_time, gymclass_end_time)
VALUES
    -- Cardio Classes
    ('Cardio Class Bkn Mon', 'Cardio', 2, 2, 'Monday', '07:00:00', '08:00:00'), --19
    ('Cardio Class Bkn Tues', 'Cardio', 2, 2, 'Tuesday', '18:00:00', '19:00:00'), --20
    ('Cardio Class Bkn Thur', 'Cardio', 2, 2, 'Thursday', '12:00:00', '13:00:00'), --21
    ('Cardio Class Bkn Sat', 'Cardio', 2, 2, 'Saturday', '07:00:00', '08:00:00'), --22

    -- Strength Classes
    ('Strength Class Bkn Mon', 'Strength', 21, 2, 'Monday', '12:00:00', '13:00:00'), --23
    ('Strength Class Bkn Wed', 'Strength', 21, 2, 'Wednesday', '07:00:00', '08:00:00'), --24
    ('Strength Class Bkn Thur', 'Strength', 21, 2, 'Thursday', '18:00:00', '19:00:00'), --25
    ('Strength Class Bkn Sat', 'Strength', 21, 2, 'Saturday', '12:00:00', '13:00:00'), --26

    -- Yoga Classes
    ('Yoga Class Bkn Mon', 'Yoga', 8, 2, 'Monday', '18:00:00', '19:00:00'), --27
    ('Yoga Class Bkn Wed', 'Yoga', 8, 2, 'Wednesday', '12:00:00', '13:00:00'), --28
    ('Yoga Class Bkn Fri', 'Yoga', 8, 2, 'Friday', '07:00:00', '08:00:00'), --29
    ('Yoga Class Bkn Sat', 'Yoga', 8, 2, 'Saturday', '18:00:00', '19:00:00'), --30

    -- Pilates Classes
    ('Pilates Class Bkn Tues', 'Pilates', 11, 2, 'Tuesday', '07:00:00', '08:00:00'), --31
    ('Pilates Class Bkn Wed', 'Pilates', 11, 2, 'Wednesday', '18:00:00', '19:00:00'), --32
    ('Pilates Class Bkn Fri', 'Pilates', 11, 2, 'Friday', '12:00:00', '13:00:00'), --33

    -- Crossfit Classes
    ('Crossfit Class Bkn Tues', 'Crossfit', 14, 2, 'Tuesday', '12:00:00', '13:00:00'), --34
    ('Crossfit Class Bkn Thur', 'Crossfit', 14, 2, 'Thursday', '07:00:00', '08:00:00'), --35
    ('Crossfit Class Bkn Fri', 'Crossfit', 14, 2, 'Friday', '18:00:00', '19:00:00'); --36




-- Facility 3 (Manhattan) Classes
-- Facility 3 (Manhattan) Classes
INSERT INTO gymclasses (gymclass_name, gymclass_category, gymclass_trainer_id, gymclass_facility_id, gymclass_day_of_week, gymclass_start_time, gymclass_end_time)
VALUES
    -- Cardio Classes
    ('Cardio Class Manh Mon', 'Cardio', 3, 3, 'Monday', '07:00:00', '08:00:00'), --37
    ('Cardio Class Manh Tues', 'Cardio', 3, 3, 'Tuesday', '18:00:00', '19:00:00'), --38
    ('Cardio Class Manh Thur', 'Cardio', 3, 3, 'Thursday', '12:00:00', '13:00:00'), --39
    ('Cardio Class Manh Sat', 'Cardio', 3, 3, 'Saturday', '07:00:00', '08:00:00'), --40

    -- Strength Classes
    ('Strength Class Manh Mon', 'Strength', 22, 3, 'Monday', '12:00:00', '13:00:00'), --41
    ('Strength Class Manh Wed', 'Strength', 22, 3, 'Wednesday', '07:00:00', '08:00:00'), --42
    ('Strength Class Manh Thur', 'Strength', 22, 3, 'Thursday', '18:00:00', '19:00:00'), --43
    ('Strength Class Manh Sat', 'Strength', 22, 3, 'Saturday', '12:00:00', '13:00:00'), --44

    -- Yoga Classes
    ('Yoga Class Manh Mon', 'Yoga', 9, 3, 'Monday', '18:00:00', '19:00:00'), --45
    ('Yoga Class Manh Wed', 'Yoga', 9, 3, 'Wednesday', '12:00:00', '13:00:00'), --46
    ('Yoga Class Manh Fri', 'Yoga', 9, 3, 'Friday', '07:00:00', '08:00:00'), --47
    ('Yoga Class Manh Sat', 'Yoga', 9, 3, 'Saturday', '18:00:00', '19:00:00'), --48

    -- Pilates Classes
    ('Pilates Class Manh Tues', 'Pilates', 12, 3, 'Tuesday', '07:00:00', '08:00:00'), --49
    ('Pilates Class Manh Wed', 'Pilates', 12, 3, 'Wednesday', '18:00:00', '19:00:00'), --50
    ('Pilates Class Manh Fri', 'Pilates', 12, 3, 'Friday', '12:00:00', '13:00:00'), --51

    -- Crossfit Classes
    ('Crossfit Class Manh Tues', 'Crossfit', 15, 3, 'Tuesday', '12:00:00', '13:00:00'), --52
    ('Crossfit Class Manh Thur', 'Crossfit', 15, 3, 'Thursday', '07:00:00', '08:00:00'), --53
    ('Crossfit Class Manh Fri', 'Crossfit', 15, 3, 'Friday', '18:00:00', '19:00:00'); --54




-- Facility 4 (Queens) Classes
INSERT INTO gymclasses (gymclass_name, gymclass_category, gymclass_trainer_id, gymclass_facility_id, gymclass_day_of_week, gymclass_start_time, gymclass_end_time)
VALUES
    -- Cardio Classes
    ('Cardio Class Qns Mon', 'Cardio', 16, 4, 'Monday', '07:00:00', '08:00:00'), --55
    ('Cardio Class Qns Tues', 'Cardio', 16, 4, 'Tuesday', '18:00:00', '19:00:00'), --56
    ('Cardio Class Qns Thur', 'Cardio', 16, 4, 'Thursday', '12:00:00', '13:00:00'), --57
    ('Cardio Class Qns Sat', 'Cardio', 16, 4, 'Saturday', '07:00:00', '08:00:00'), --58

    -- Strength Classes
    ('Strength Class Qns Mon', 'Strength', 23, 4, 'Monday', '12:00:00', '13:00:00'), --59
    ('Strength Class Qns Wed', 'Strength', 23, 4, 'Wednesday', '07:00:00', '08:00:00'), --60
    ('Strength Class Qns Thur', 'Strength', 23, 4, 'Thursday', '18:00:00', '19:00:00'), --61
    ('Strength Class Qns Sat', 'Strength', 23, 4, 'Saturday', '12:00:00', '13:00:00'), --62

    -- Yoga Classes
    ('Yoga Class Qns Mon', 'Yoga', 24, 4, 'Monday', '18:00:00', '19:00:00'), --63
    ('Yoga Class Qns Wed', 'Yoga', 24, 4, 'Wednesday', '12:00:00', '13:00:00'), --64
    ('Yoga Class Qns Fri', 'Yoga', 24, 4, 'Friday', '07:00:00', '08:00:00'), --65
    ('Yoga Class Qns Sat', 'Yoga', 24, 4, 'Saturday', '18:00:00', '19:00:00'), --66

    -- Pilates Classes
    ('Pilates Class Qns Tues', 'Pilates', 28, 4, 'Tuesday', '07:00:00', '08:00:00'), --67
    ('Pilates Class Qns Wed', 'Pilates', 28, 4, 'Wednesday', '18:00:00', '19:00:00'), --68
    ('Pilates Class Qns Fri', 'Pilates', 28, 4, 'Friday', '12:00:00', '13:00:00'), --69

    -- Crossfit Classes
    ('Crossfit Class Qns Tues', 'Crossfit', 32, 4, 'Tuesday', '12:00:00', '13:00:00'), --70
    ('Crossfit Class Qns Thur', 'Crossfit', 32, 4, 'Thursday', '07:00:00', '08:00:00'), --71
    ('Crossfit Class Qns Fri', 'Crossfit', 32, 4, 'Friday', '18:00:00', '19:00:00'); --72




-- Facility 5 (Staten Island) Classes
INSERT INTO gymclasses (gymclass_name, gymclass_category, gymclass_trainer_id, gymclass_facility_id, gymclass_day_of_week, gymclass_start_time, gymclass_end_time)
VALUES
    -- Cardio Classes
    ('Cardio Class SI Mon', 'Cardio', 17, 5, 'Monday', '07:00:00', '08:00:00'), --73
    ('Cardio Class SI Tues', 'Cardio', 17, 5, 'Tuesday', '18:00:00', '19:00:00'), --74
    ('Cardio Class SI Thurs', 'Cardio', 17, 5, 'Thursday', '12:00:00', '13:00:00'), --75
    ('Cardio Class SI Sat', 'Cardio', 17, 5, 'Saturday', '07:00:00', '08:00:00'), --76

    -- Strength Classes
    ('Strength Class SI Mon', 'Strength', 4, 5, 'Monday', '12:00:00', '13:00:00'), --77
    ('Strength Class SI Wed', 'Strength', 4, 5, 'Wednesday', '07:00:00', '08:00:00'), --78
    ('Strength Class SI Thurs', 'Strength', 4, 5, 'Thursday', '18:00:00', '19:00:00'), --79
    ('Strength Class SI Sat', 'Strength', 4, 5, 'Saturday', '12:00:00', '13:00:00'), --80

    -- Yoga Classes
    ('Yoga Class SI Mon', 'Yoga', 25, 5, 'Monday', '18:00:00', '19:00:00'), --81
    ('Yoga Class SI Wed', 'Yoga', 25, 5, 'Wednesday', '12:00:00', '13:00:00'), --82
    ('Yoga Class SI Fri', 'Yoga', 25, 5, 'Friday', '07:00:00', '08:00:00'), --83
    ('Yoga Class SI Sat', 'Yoga', 25, 5, 'Saturday', '18:00:00', '19:00:00'), --84

    -- Pilates Classes
    ('Pilates Class SI Tues', 'Pilates', 29, 5, 'Tuesday', '07:00:00', '08:00:00'), --85
    ('Pilates Class SI Wed', 'Pilates', 29, 5, 'Wednesday', '18:00:00', '19:00:00'), --86
    ('Pilates Class SI Fri', 'Pilates', 29, 5, 'Friday', '12:00:00', '13:00:00'), --87

    -- Crossfit Classes
    ('Crossfit Class SI Tues', 'Crossfit', 33, 5, 'Tuesday', '12:00:00', '13:00:00'), --88
    ('Crossfit Class SI Thurs', 'Crossfit', 33, 5, 'Thursday', '07:00:00', '08:00:00'), --89
    ('Crossfit Class SI Fri', 'Crossfit', 33, 5, 'Friday', '18:00:00', '19:00:00'); --90


 


-- Insert mock check-ins for gym members
INSERT INTO checkins (checkin_date, checkin_time, checkin_gymmember_id, checkin_facility_id)
VALUES
    ('2023-08-01', '08:30:00', 1, 1),
    ('2023-08-01', '12:15:00', 2, 2),
    ('2023-08-01', '18:30:00', 3, 3),
    ('2023-08-01', '07:45:00', 4, 4),
    ('2023-08-01', '13:10:00', 5, 5),
    ('2023-08-01', '19:15:00', 6, 1),
    ('2023-08-01', '08:00:00', 7, 2),
    ('2023-08-01', '12:30:00', 8, 3),
    ('2023-08-01', '18:45:00', 9, 4),
    ('2023-08-01', '07:30:00', 10, 5),
    ('2023-08-01', '12:45:00', 11, 1),
    ('2023-08-01', '18:00:00', 12, 2),
    ('2023-08-01', '07:55:00', 13, 3),
    ('2023-08-01', '13:20:00', 14, 4),
    ('2023-08-01', '18:30:00', 15, 5),
    ('2023-08-01', '08:15:00', 16, 1),
    ('2023-08-01', '12:40:00', 17, 1),
    ('2023-08-01', '19:00:00', 18, 5),
    ('2023-08-01', '07:50:00', 19, 3),
    ('2023-08-01', '12:55:00', 20, 4),
    ('2023-08-02', '08:30:00', 1, 3),
    ('2023-08-02', '12:15:00', 2, 2),
    ('2023-08-02', '18:30:00', 3, 1),
    ('2023-08-02', '07:45:00', 4, 2),
    ('2023-08-02', '13:10:00', 5, 4),
    ('2023-08-02', '19:15:00', 6, 3),
    ('2023-08-02', '08:00:00', 7, 5),
    ('2023-08-02', '12:30:00', 8, 2),
    ('2023-08-02', '18:45:00', 9, 5),
    ('2023-08-02', '07:30:00', 10, 3),
    ('2023-08-02', '12:45:00', 11, 1),
    ('2023-08-02', '18:00:00', 12, 3),
    ('2023-08-02', '07:55:00', 13, 5),
    ('2023-08-02', '13:20:00', 14, 1),
    ('2023-08-02', '18:30:00', 15, 3),
    ('2023-08-02', '08:15:00', 16, 5),
    ('2023-08-02', '12:40:00', 17, 5),
    ('2023-08-02', '19:00:00', 18, 3),
    ('2023-08-02', '07:50:00', 19, 2),
    ('2023-08-02', '12:55:00', 20, 1),
    ('2023-08-03', '08:30:00', 1, 2),
    ('2023-08-03', '12:15:00', 2, 4),
    ('2023-08-03', '18:30:00', 3, 1),
    ('2023-08-03', '07:45:00', 4, 2),
    ('2023-08-03', '13:10:00', 5, 3),
    ('2023-08-03', '19:15:00', 6, 1),
    ('2023-08-03', '08:00:00', 7, 3),
    ('2023-08-03', '12:30:00', 8, 2),
    ('2023-08-03', '18:45:00', 9, 5),
    ('2023-08-03', '07:30:00', 10, 2),
    ('2023-08-03', '12:45:00', 11, 4),
    ('2023-08-03', '18:00:00', 12, 2),
    ('2023-08-03', '07:55:00', 13, 1),
    ('2023-08-03', '13:20:00', 14, 3),
    ('2023-08-03', '18:30:00', 15, 3),
    ('2023-08-03', '08:15:00', 16, 2),
    ('2023-08-03', '12:40:00', 17, 1),
    ('2023-08-03', '19:00:00', 18, 3),
    ('2023-08-03', '07:50:00', 19, 2),
    ('2023-08-03', '12:55:00', 20, 1),
    ('2023-08-04', '08:30:00', 1, 3),
    ('2023-08-04', '12:15:00', 2, 2),
    ('2023-08-04', '18:30:00', 3, 1),
    ('2023-08-04', '07:45:00', 4, 1),
    ('2023-08-04', '13:10:00', 5, 2),
    ('2023-08-04', '19:15:00', 6, 3),
    ('2023-08-04', '08:00:00', 7, 4),
    ('2023-08-04', '12:30:00', 8, 5),
    ('2023-08-04', '18:45:00', 9, 2),
    ('2023-08-04', '07:30:00', 10, 3),
    ('2023-08-04', '12:45:00', 11, 5),
    ('2023-08-04', '18:00:00', 12, 2),
    ('2023-08-04', '07:55:00', 13, 4),
    ('2023-08-04', '13:20:00', 14, 4),
    ('2023-08-04', '18:30:00', 15, 2),
    ('2023-08-04', '08:15:00', 16, 1),
    ('2023-08-04', '12:40:00', 17, 3),
    ('2023-08-04', '19:00:00', 18, 2),
    ('2023-08-04', '07:50:00', 19, 1),
    ('2023-08-04', '12:55:00', 20, 3),
    ('2023-08-05', '08:30:00', 1, 2),
    ('2023-08-05', '12:15:00', 2, 5),
    ('2023-08-05', '18:30:00', 3, 2),
    ('2023-08-05', '07:45:00', 4, 4),
    ('2023-08-05', '13:10:00', 5, 2),
    ('2023-08-05', '19:15:00', 6, 1),
    ('2023-08-05', '08:00:00', 7, 4),
    ('2023-08-05', '12:30:00', 8, 5),
    ('2023-08-05', '18:45:00', 9, 1),
    ('2023-08-05', '07:30:00', 10, 2),
    ('2023-08-05', '12:45:00', 11, 5),
    ('2023-08-05', '18:00:00', 12, 4),
    ('2023-08-05', '07:55:00', 13, 3),
    ('2023-08-05', '13:20:00', 14, 2),
    ('2023-08-05', '18:30:00', 15, 5),
    ('2023-08-05', '08:15:00', 16, 2),
    ('2023-08-05', '12:40:00', 17, 4),
    ('2023-08-05', '19:00:00', 18, 1),
    ('2023-08-05', '07:50:00', 19, 3),
    ('2023-08-05', '12:55:00', 20, 2),
    ('2023-08-06', '08:30:00', 1, 1),
    ('2023-08-06', '12:15:00', 2, 3),
    ('2023-08-06', '18:30:00', 3, 4),
    ('2023-08-06', '07:45:00', 4, 1),
    ('2023-08-06', '13:10:00', 5, 5),
    ('2023-08-06', '19:15:00', 6, 5),
    ('2023-08-06', '08:00:00', 7, 1),
    ('2023-08-06', '12:30:00', 8, 2),
    ('2023-08-06', '18:45:00', 9, 3),
    ('2023-08-06', '07:30:00', 10, 3),
    ('2023-08-06', '12:45:00', 11, 5),
    ('2023-08-06', '18:00:00', 12, 2),
    ('2023-08-06', '07:55:00', 13, 2),
    ('2023-08-06', '13:20:00', 14, 4),
    ('2023-08-06', '18:30:00', 15, 5),
    ('2023-08-06', '08:15:00', 16, 1),
    ('2023-08-06', '12:40:00', 17, 3),
    ('2023-08-06', '19:00:00', 18, 2),
    ('2023-08-06', '07:50:00', 19, 1),
    ('2023-08-06', '12:55:00', 20, 4),
    ('2023-08-07', '08:30:00', 1, 2),
    ('2023-08-07', '12:15:00', 2, 5),
    ('2023-08-07', '18:30:00', 3, 1),
    ('2023-08-07', '07:45:00', 4, 4),
    ('2023-08-07', '13:10:00', 5, 2),
    ('2023-08-07', '19:15:00', 6, 5),
    ('2023-08-07', '08:00:00', 7, 2),
    ('2023-08-07', '12:30:00', 8, 1),
    ('2023-08-07', '18:45:00', 9, 4),
    ('2023-08-07', '07:30:00', 10, 4),
    ('2023-08-07', '12:45:00', 11, 3),
    ('2023-08-07', '18:00:00', 12, 3),
    ('2023-08-07', '07:55:00', 13, 2),
    ('2023-08-07', '13:20:00', 14, 1),
    ('2023-08-07', '18:30:00', 15, 5),
    ('2023-08-07', '08:15:00', 16, 5),
    ('2023-08-07', '12:40:00', 17, 1),
    ('2023-08-07', '19:00:00', 18, 3),
    ('2023-08-07', '07:50:00', 19, 4),
    ('2023-08-07', '12:55:00', 20, 5),

    ('2023-08-08', '08:30:00', 1, 4),
    ('2023-08-08', '12:15:00', 2, 2),
    ('2023-08-08', '18:30:00', 3, 3),
    ('2023-08-08', '07:45:00', 4, 2),
    ('2023-08-08', '13:10:00', 5, 5),
    ('2023-08-08', '19:15:00', 6, 3),
    ('2023-08-08', '08:00:00', 7, 2),
    ('2023-08-08', '12:30:00', 8, 4),
    ('2023-08-08', '18:45:00', 9, 5),
    ('2023-08-08', '07:30:00', 10, 2),
    ('2023-08-08', '12:45:00', 11, 3),
    ('2023-08-08', '18:00:00', 12, 2),
    ('2023-08-08', '07:55:00', 13, 1),
    ('2023-08-08', '13:20:00', 14, 3),
    ('2023-08-08', '18:30:00', 15, 5),
    ('2023-08-08', '08:15:00', 16, 4),
    ('2023-08-08', '12:40:00', 17, 1),
    ('2023-08-08', '19:00:00', 18, 4),
    ('2023-08-08', '07:50:00', 19, 3),
    ('2023-08-08', '12:55:00', 20, 2)








-- Facility 1 (Bronx) - Class Dates
INSERT INTO gymclassdates (gymclassdates_date, gymclassdates_gymclass_id, gymclassdates_num_atendees_on_date)
VALUES
    -- August 1
    ('2023-08-01', 4, 11),
    ('2023-08-01', 5, 25),
    ('2023-08-01', 6, 14),
    
    -- August 2
    ('2023-08-02', 7, 20),
    ('2023-08-02', 8, 21),
    ('2023-08-02', 9, 28),

    -- August 3
    ('2023-08-03', 10, 20),
    ('2023-08-03', 11, 15),
    ('2023-08-03', 12, 9),

    -- August 4
    ('2023-08-04', 13, 22),
    ('2023-08-04', 14, 18),
    ('2023-08-04', 15, 19),

    -- August 5
    ('2023-08-05', 16, 16),
    ('2023-08-05', 17, 13),
    ('2023-08-05', 18, 22),

    -- August 7
    ('2023-08-07', 1, 21),
    ('2023-08-07', 2, 19),
    ('2023-08-07', 3, 30),


    -- August 8
    ('2023-08-08', 4, 35),
    ('2023-08-08', 5, 14),
    ('2023-08-08', 6, 21),

    -- August 9
    ('2023-08-09', 7, 23),
    ('2023-08-09', 8, 27),
    ('2023-08-09', 9, 32),
    
    -- August 10
    ('2023-08-10', 10, 8),
    ('2023-08-10', 11, 16),
    ('2023-08-10', 12, 14),

    -- August 11
    ('2023-08-11', 13, 17),
    ('2023-08-11', 14, 25),
    ('2023-08-11', 15, 26),
    
    -- August 12
    ('2023-08-12', 16, 13),
    ('2023-08-12', 17, 19),
    ('2023-08-12', 18, 14),

    -- August 14
    ('2023-08-14', 1, 20),
    ('2023-08-14', 2, 25),
    ('2023-08-14', 3, 30)






-- Facility 2 (Brooklyn) - Class Dates
INSERT INTO gymclassdates (gymclassdates_date, gymclassdates_gymclass_id, gymclassdates_num_atendees_on_date)
VALUES
    -- August 1
    ('2023-08-01', 22, 10),
    ('2023-08-01', 23, 25),
    ('2023-08-01', 24, 16),
    
    -- August 2
    ('2023-08-02', 25, 18),
    ('2023-08-02', 26, 33),
    ('2023-08-02', 27, 21),

    -- August 3
    ('2023-08-03', 28, 28),
    ('2023-08-03', 29, 15),
    ('2023-08-03', 30, 19),

    -- August 4
    ('2023-08-04', 31, 21),
    ('2023-08-04', 32, 18),
    ('2023-08-04', 33, 16),

    -- August 5
    ('2023-08-05', 34, 22),
    ('2023-08-05', 35, 12),
    ('2023-08-05', 36, 26),

    -- August 7
    ('2023-08-07', 19, 14),
    ('2023-08-07', 20, 30),
    ('2023-08-07', 21, 33),


    -- August 8
    ('2023-08-08', 22, 25),
    ('2023-08-08', 23, 5),
    ('2023-08-08', 24, 8),

    -- August 9
    ('2023-08-09', 25, 23),
    ('2023-08-09', 26, 26),
    ('2023-08-09', 27, 25),
    
    -- August 10
    ('2023-08-10', 28, 30),
    ('2023-08-10', 29, 25),
    ('2023-08-10', 30, 24),

    -- August 11
    ('2023-08-11', 31, 25),
    ('2023-08-11', 32, 26),
    ('2023-08-11', 33, 14),
    
    -- August 12
    ('2023-08-12', 34, 28),
    ('2023-08-12', 35, 31),
    ('2023-08-12', 36, 22),

    -- August 14
    ('2023-08-14', 19, 21),
    ('2023-08-14', 20, 26),
    ('2023-08-14', 21, 31)




-- Facility 3 (Manhattan) - Class Dates
INSERT INTO gymclassdates (gymclassdates_date, gymclassdates_gymclass_id, gymclassdates_num_atendees_on_date)
VALUES
    -- August 1
    ('2023-08-01', 40, 13),
    ('2023-08-01', 41, 24),
    ('2023-08-01', 42, 16),
    
    -- August 2
    ('2023-08-02', 43, 30),
    ('2023-08-02', 44, 31),
    ('2023-08-02', 45, 25),

    -- August 3
    ('2023-08-03', 46, 29),
    ('2023-08-03', 47, 31),
    ('2023-08-03', 48, 22),

    -- August 4
    ('2023-08-04', 49, 13),
    ('2023-08-04', 50, 18),
    ('2023-08-04', 51, 25),

    -- August 5
    ('2023-08-05', 52, 20),
    ('2023-08-05', 53, 16),
    ('2023-08-05', 54, 19),

    -- August 7
    ('2023-08-07', 37, 28),
    ('2023-08-07', 38, 14),
    ('2023-08-07', 39, 21),


    -- August 8
    ('2023-08-08', 40, 16),
    ('2023-08-08', 41, 20),
    ('2023-08-08', 42, 30),

    -- August 9
    ('2023-08-09', 43, 20),
    ('2023-08-09', 44, 18),
    ('2023-08-09', 45, 19),
    
    -- August 10
    ('2023-08-10', 46, 25),
    ('2023-08-10', 47, 25),
    ('2023-08-10', 48, 30),

    -- August 11
    ('2023-08-11', 49, 26),
    ('2023-08-11', 50, 27),
    ('2023-08-11', 51, 30),
    
    -- August 12
    ('2023-08-12', 52, 25),
    ('2023-08-12', 53, 24),
    ('2023-08-12', 54, 11),

    -- August 14
    ('2023-08-14', 37, 10),
    ('2023-08-14', 38, 15),
    ('2023-08-14', 39, 18)





-- Facility 4 (Queens) - Class Dates
INSERT INTO gymclassdates (gymclassdates_date, gymclassdates_gymclass_id, gymclassdates_num_atendees_on_date)
VALUES
    -- August 1
    ('2023-08-01', 58, 22),
    ('2023-08-01', 59, 26),
    ('2023-08-01', 60, 28),
    
    -- August 2
    ('2023-08-02', 61, 21),
    ('2023-08-02', 62, 28),
    ('2023-08-02', 63, 30),

    -- August 3
    ('2023-08-03', 64, 25),
    ('2023-08-03', 65, 15),
    ('2023-08-03', 66, 14),

    -- August 4
    ('2023-08-04', 67, 16),
    ('2023-08-04', 68, 18),
    ('2023-08-04', 69, 19),

    -- August 5
    ('2023-08-05', 70, 25),
    ('2023-08-05', 71, 24),
    ('2023-08-05', 72, 22),

    -- August 7
    ('2023-08-07', 55, 27),
    ('2023-08-07', 56, 14),
    ('2023-08-07', 57, 6),


    -- August 8
    ('2023-08-08', 58, 22),
    ('2023-08-08', 59, 25),
    ('2023-08-08', 60, 24),

    -- August 9
    ('2023-08-09', 61, 20),
    ('2023-08-09', 62, 15),
    ('2023-08-09', 63, 18),
    
    -- August 10
    ('2023-08-10', 64, 13),
    ('2023-08-10', 65, 14),
    ('2023-08-10', 66, 20),

    -- August 11
    ('2023-08-11', 67, 25),
    ('2023-08-11', 68, 30),
    ('2023-08-11', 69, 21),
    
    -- August 12
    ('2023-08-12', 70, 15),
    ('2023-08-12', 71, 18),
    ('2023-08-12', 72, 19),

    -- August 14
    ('2023-08-14', 55, 21),
    ('2023-08-14', 56, 25),
    ('2023-08-14', 57, 22)




-- Facility 5 (Staten Island) - Class Dates
INSERT INTO gymclassdates (gymclassdates_date, gymclassdates_gymclass_id, gymclassdates_num_atendees_on_date)
VALUES
    -- August 1
    ('2023-08-01', 76, 16),
    ('2023-08-01', 77, 28),
    ('2023-08-01', 78, 31),
    
    -- August 2
    ('2023-08-02', 79, 24),
    ('2023-08-02', 80, 11),
    ('2023-08-02', 81, 13),

    -- August 3
    ('2023-08-03', 82, 16),
    ('2023-08-03', 83, 18),
    ('2023-08-03', 84, 27),

    -- August 4
    ('2023-08-04', 85, 25),
    ('2023-08-04', 86, 22),
    ('2023-08-04', 87, 26),

    -- August 5
    ('2023-08-05', 88, 21),
    ('2023-08-05', 89, 14),
    ('2023-08-05', 90, 19),

    -- August 7
    ('2023-08-07', 73, 21),
    ('2023-08-07', 74, 11),
    ('2023-08-07', 75, 7),


    -- August 8
    ('2023-08-08', 76, 20),
    ('2023-08-08', 77, 20),
    ('2023-08-08', 78, 31),

    -- August 9
    ('2023-08-09', 79, 24),
    ('2023-08-09', 80, 11),
    ('2023-08-09', 81, 18),
    
    -- August 10
    ('2023-08-10', 82, 20),
    ('2023-08-10', 83, 25),
    ('2023-08-10', 84, 27),

    -- August 11
    ('2023-08-11', 85, 26),
    ('2023-08-11', 86, 17),
    ('2023-08-11', 87, 22),
    
    -- August 12
    ('2023-08-12', 88, 15),
    ('2023-08-12', 89, 18),
    ('2023-08-12', 90, 27),

    -- August 14
    ('2023-08-14', 73, 25),
    ('2023-08-14', 74, 30),
    ('2023-08-14', 75, 31)


ALTER TABLE gymmembers
ADD CONSTRAINT fk_gymmembers_gymmeber_plan_id FOREIGN KEY (gymmember_plan_id) REFERENCES gymplans(gymplan_id); 


ALTER TABLE checkins
ADD CONSTRAINT fk_checkins_gymmember_id FOREIGN KEY (checkin_gymmember_id) REFERENCES gymmembers(gymmember_id); 

ALTER TABLE checkins
ADD CONSTRAINT fk_checkins_facility_id FOREIGN KEY (checkin_facility_id) REFERENCES gymfacilities(gymfacility_id);


ALTER TABLE gymclassdates
ADD CONSTRAINT fk_gymclassdates_gymclass_id FOREIGN KEY (gymclassdates_gymclass_id) REFERENCES gymclasses(gymclass_id); 
    

ALTER TABLE gymclasses
ADD CONSTRAINT fk_gymclasses_facility_id FOREIGN KEY (gymclass_facility_id) REFERENCES gymfacilities(gymfacility_id);

ALTER TABLE gymclasses
ADD CONSTRAINT fk_gymclasses_trainer_id FOREIGN KEY (gymclass_trainer_id) REFERENCES gymtrainers(gymtrainer_id);



-- First let's look at the tables
SELECT * FROM gymfacilities
SELECT * FROM gymclassdates
SELECT * FROM gymmembers
SELECT * FROM gymplans
SELECT * FROM gymclasses
SELECT * FROM gymtrainers
SELECT * FROM checkins




-- Let's see which facility has the most check ins

SELECT
    gf.gymfacility_borough AS Facility_Borough,
    COUNT(ci.checkin_id) AS Number_of_Checkins
FROM
    gymfacilities gf
LEFT JOIN
    checkins ci ON gf.gymfacility_id = ci.checkin_facility_id
GROUP BY
    gf.gymfacility_borough
ORDER BY
    Number_of_Checkins DESC;


-- It appears Brooklyn has been the most popular facility, while Queens has had the lowest number of check ins.





-- Let's take a look at the classes and the trainers for the classes. We will order the query by the trainer name so that we can see all of the classes for each trainer.
SELECT
    gymclasses.gymclass_id AS Class_ID,
    gymclasses.gymclass_category AS Class_Category,
    gymclasses.gymclass_name AS Class_Name,
    gymclasses.gymclass_trainer_id AS Trainer_ID,
    CONCAT(gymtrainers.gymtrainer_firstname, ' ', gymtrainers.gymtrainer_lastname) AS Trainer_Name,
    gymfacilities.gymfacility_borough AS Facility_Borough,
    gymclasses.gymclass_day_of_week AS Day,
    gymclasses.gymclass_start_time AS Start_Time,
    gymclasses.gymclass_end_time AS End_Time
FROM
    gymclasses
JOIN
    gymtrainers ON gymclasses.gymclass_trainer_id = gymtrainers.gymtrainer_id
JOIN
    gymfacilities ON gymclasses.gymclass_facility_id = gymfacilities.gymfacility_id
ORDER BY
    Trainer_Name;






--Let's see which class category is most popular amongst all facilities.
SELECT
    gymclasses.gymclass_category AS Class_Category,
    SUM(gymclassdates.gymclassdates_num_atendees_on_date) AS Total_Attendees
FROM
    gymclasses
JOIN
    gymclassdates ON gymclasses.gymclass_id = gymclassdates.gymclassdates_gymclass_id
GROUP BY
    gymclasses.gymclass_category
ORDER BY
    Total_Attendees DESC;  

--We see that strength, yoga and cardio are the most popular classes with fairly similar number of attendees.



-- Let's see if we can find the most popular class categories for each individual facility.
WITH AttendeeCounts AS (
    SELECT
        gymfacilities.gymfacility_borough AS Borough,
        gymclasses.gymclass_category AS Class_Category,
        SUM(gymclassdates.gymclassdates_num_atendees_on_date) AS Total_Attendees
    FROM
        gymclasses
    JOIN
        gymclassdates ON gymclasses.gymclass_id = gymclassdates.gymclassdates_gymclass_id
    JOIN
        gymfacilities ON gymclasses.gymclass_facility_id = gymfacilities.gymfacility_id
    GROUP BY
        gymfacilities.gymfacility_borough,
        gymclasses.gymclass_category
)
SELECT
    Borough,
    Class_Category,
    Total_Attendees,
    RANK() OVER (PARTITION BY Borough ORDER BY Total_Attendees DESC) AS Category_Rank
FROM
    AttendeeCounts
ORDER BY
    Borough,
    Total_Attendees DESC;

-- It appears that there are differences in the popularity of classes at some facilities. In the Bronx and Brooklyn, cardio are most popular. Yoga and strength are more popular in Manhattan and Staten Island.




--Let's see if the time a class starts may factor into a classes popularity. Let's see the total number of attendees grouped by the start of a class time.
SELECT
    gymclasses.gymclass_start_time AS Class_Start_Time,
    SUM(gymclassdates.gymclassdates_num_atendees_on_date) AS Total_Attendees
FROM
    gymclasses
JOIN
    gymclassdates ON gymclasses.gymclass_id = gymclassdates.gymclassdates_gymclass_id
GROUP BY
    gymclasses.gymclass_start_time
ORDER BY
    gymclasses.gymclass_start_time;


-- It appears that there are nearly an equal amount of attendees for each start time.




--Let's take a look at the members. We like to know the demographics of the members across all of our facilities, as well as each individual facility. 
-- Let's first find out the average age and the male to female ratio across all facilities.

SELECT
    SUM(CASE WHEN gymmember_gender = 'Male' THEN 1 ELSE 0 END) AS number_of_males,
    SUM(CASE WHEN gymmember_gender = 'Female' THEN 1 ELSE 0 END) AS number_of_females,
    AVG(gymmember_age) AS average_age
FROM gymmembers;


-- We see that the number of males to females are about even, and the average age accross all gyms is 47.





-- Let's see the average age based on the check-in's for each facility.

SELECT
    f.gymfacility_borough,
    c.checkin_facility_id,
    AVG(m.gymmember_age) AS average_age
FROM checkins c
JOIN gymmembers m ON c.checkin_gymmember_id = m.gymmember_id
JOIN gymfacilities f ON c.checkin_facility_id = f.gymfacility_id
GROUP BY f.gymfacility_borough, c.checkin_facility_id;


-- We see that the age range are fairly similar at each gym.




--The manager would like to send an email to all premium members from the Queens facility regarding an upcoming perks for premium members exclusive at the Queens facility.
SELECT DISTINCT
    m.gymmember_firstname,
    m.gymmember_lastname,
    m.gymmember_email,
    m.gymmember_plan_id
FROM checkins c
JOIN gymmembers m ON c.checkin_gymmember_id = m.gymmember_id
JOIN gymfacilities f ON c.checkin_facility_id = f.gymfacility_id
WHERE f.gymfacility_borough = 'Queens' AND m.gymmember_plan_id = 2;


-- This returns a table with all of the members who have checked into the Queens facility.



--The gym has hired a database administrator, who would like to improve the company's queries for more efficiency etc. 
--Let's try some of the same queries using some of the concepts learned in a later chapters for efficiency etc..


--First, let's create a view function which shows a table of classes and the number of attendees of each class by date.

GO

CREATE VIEW GymClassAttendance AS
SELECT
    gc.gymclass_id,
    gc.gymclass_name,
    gc.gymclass_category,
    gc.gymclass_trainer_id,
    gt.gymtrainer_firstname AS trainer_firstname,
    gt.gymtrainer_lastname AS trainer_lastname,
    gc.gymclass_day_of_week,
    gc.gymclass_start_time,
    gc.gymclass_end_time,
    gca.gymclassdates_date,
    gca.gymclassdates_num_atendees_on_date
FROM
    gymclasses gc
INNER JOIN
    gymclassdates gca ON gc.gymclass_id = gca.gymclassdates_gymclass_id
LEFT JOIN
    gymtrainers gt ON gc.gymclass_trainer_id = gt.gymtrainer_id;

GO

SELECT
    gymclass_name,
    gymclassdates_date,
    gymclassdates_num_atendees_on_date
FROM
    GymClassAttendance
ORDER BY gymclassdates_date




GO

--The database administrator would also like to create a transaction safe procedure which ensures that a class is updated correctly if the trainer changes.

--Lets look at the trainer for gymclass_id 88 before making the change. 
SELECT * FROM gymclasses WHERE gymclass_id = 88

GO

CREATE PROCEDURE UpdateGymClassTrainer
    @class_id INT,
    @new_trainer_id INT
AS
BEGIN
    BEGIN TRY
        -- Start a transaction
        BEGIN TRANSACTION;

        -- Check if the gym class exists
        IF NOT EXISTS (SELECT 1 FROM gymclasses WHERE gymclass_id = @class_id)
        BEGIN
            THROW 50001, 'Gym class does not exist.', 1;
        END;

        -- Check if the new trainer exists
        IF NOT EXISTS (SELECT 1 FROM gymtrainers WHERE gymtrainer_id = @new_trainer_id)
        BEGIN
            THROW 50002, 'New trainer does not exist.', 1;
        END;

        -- Update the gym class with the new trainer
        UPDATE gymclasses
        SET gymclass_trainer_id = @new_trainer_id
        WHERE gymclass_id = @class_id;

        -- Commit the transaction
        COMMIT;
        
        PRINT 'Gym class trainer updated successfully.';
    END TRY
    BEGIN CATCH
        -- Rollback the transaction if an error occurs
        ROLLBACK;

        DECLARE @ErrorMessage NVARCHAR(4000);
        DECLARE @ErrorSeverity INT;
        DECLARE @ErrorState INT;

        SELECT
            @ErrorMessage = ERROR_MESSAGE(),
            @ErrorSeverity = ERROR_SEVERITY(),
            @ErrorState = ERROR_STATE();

        THROW @ErrorSeverity, @ErrorMessage, @ErrorState;
    END CATCH;
END;









--We can see that the gymtrainer_id is now 35 for this class.



GO

--The database administrator would like to use indexing to improve the database performance. Recall the query from earlier where we found the class category popularity by facility. Let's try to improve with indexing.

-- Create an index on gymclass_id and gymclass_category columns in the gymclasses table
CREATE INDEX idx_gymclass_id_category ON gymclasses (gymclass_id, gymclass_category);

-- Create an index on the gymfacility_borough column in the gymfacilities table
CREATE INDEX idx_gymfacility_borough ON gymfacilities (gymfacility_borough);


-- Again, let's see which class category is most popular amongst all facilities.
SELECT
    gymclasses.gymclass_category AS Class_Category,
    SUM(gymclassdates.gymclassdates_num_atendees_on_date) AS Total_Attendees
FROM
    gymclasses
JOIN
    gymclassdates ON gymclasses.gymclass_id = gymclassdates.gymclassdates_gymclass_id
GROUP BY
    gymclasses.gymclass_category
ORDER BY
    Total_Attendees DESC;



GO

--Lastly, the database administrator would like to create a trigger function to ensure that members are over the age of 18 if they are added to the gymmembers table.

-- Create the trigger function

CREATE TRIGGER CheckNewMemberAgeOver18
ON gymmembers
AFTER INSERT
AS
BEGIN
    DECLARE @member_id INT, @member_age INT;

    -- Get the member ID and age of the inserted member
    SELECT @member_id = i.gymmember_id,
           @member_age = i.gymmember_age
    FROM inserted i;

    -- Check if the member's age is less than or equal to 18
    IF @member_age <= 18
    BEGIN
        -- Member is under 18; roll back the transaction
        ROLLBACK TRANSACTION;
    END;
END;



-- Enable the trigger
ENABLE TRIGGER CheckNewMemberAgeOver18 ON gymmembers;


--Now let's see if the trigger works. First we insert a member over the age of 18.
INSERT INTO gymmembers (gymmember_firstname, gymmember_lastname, gymmember_age, gymmember_gender, gymmember_email, gymmember_plan_id, gymmember_phonenumber, gymmember_zipcode)
VALUES ('Randy', 'Watson', 25, 'Male', 'mrrandywatson@soulglo.com', 1, '123-456-7890', '12345');

--We can see that this member was inserted successfully.


-- Insert a new member under the age of 18
INSERT INTO gymmembers (gymmember_firstname, gymmember_lastname, gymmember_age, gymmember_gender, gymmember_email, gymmember_plan_id, gymmember_phonenumber, gymmember_zipcode)
VALUES ('Billy', 'Jean', 10, 'Female', 'billy.jean@examle.com', 1, '987-654-3210', '54321');

--As we expected, this insert statement was not allowed because the member is under the age of 18.














































