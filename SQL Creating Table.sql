-- ##Create Address Type Table

create table Address_Type (
    AddressTypeCode CHAR(1) PRIMARY KEY CHECK (AddressTypeCode IN ('B', 'H', 'O')),
    AddressTypeDescription VARCHAR(50) NOT NULL
);

-- ##Insert Values into Address_Type Table

insert into Address_Type (AddressTypeCode, AddressTypeDescription) VALUES
('B', 'Business'),
('H', 'Home'),
('O', 'Office');

--# Create State Info Table
 create table State_Info (
    State_ID INT PRIMARY KEY,
    State_Name VARCHAR(50) NOT NULL,
    Country_Code CHAR(2) -- Will be changed to VARCHAR(3) later
);

-- ##Insert Values into State_Info Table
insert into State_Info (State_ID, State_Name, Country_Code) VALUES
(1, 'Maharashtra', 'IN'),
(2, 'Karnataka', 'IN');

--### Create Customer Table--

create table Customer (
    Cust_ID int identity(1,1) primary key, -- Auto Incrementing Primary Key
    C_Name varchar(100) NOT NULL check (C_Name NOT LIKE '%[^A-Za-z ]%'), -- Only Characters
    Aadhar_Card char(12) unique NOT NULL, -- Unique Aadhar
    Mobile_Number char(10) unique NOT NULL check (Mobile_Number LIKE '[0-9]%'), -- Only Numbers
    Date_of_Birth date check (DATEDIFF(YEAR, Date_of_Birth, GETDATE()) > 15), -- Age > 15
    Address VARCHAR(255),
    AddressTypeCode char(1) NOT NULL check (AddressTypeCode IN ('B', 'H', 'O')),
    State_ID INT NOT NULL,
    foreign key (AddressTypeCode) REFERENCES Address_Type(AddressTypeCode),
    FOREIGN KEY (State_ID) REFERENCES State_Info(State_ID)
);

--## Modify Customer Table Column Name
EXEC sp_rename 'Customer.CustomerName', 'C_Name', 'COLUMN';

--## Insert Data into Customer Table
insert into Customer (C_Name, Aadhar_Card, Mobile_Number, Date_of_Birth, Address, AddressTypeCode, State_ID) VALUES
('Janvi Bhavsar', '123456789012', '9876543210', '2001-05-15', 'Dharangaon, Maharashtra', 'H', 1),
('Priya Bhavsar', '123456789013', '9876543211', '1995-08-20', 'Mumbai, Maharashtra', 'O', 2);

--##  Alter Column Type for Country_Code
ALTER TABLE State_Info ALTER COLUMN Country_Code VARCHAR(3);
