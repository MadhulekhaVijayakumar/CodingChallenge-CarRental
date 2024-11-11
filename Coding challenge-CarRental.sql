--creating Database
create database CarRental

--creating table Vehicle
create table Vehicle(
vehicleID int primary key,
make varchar(50),
model varchar(30),
[year] int,
dailyRate decimal(10,2),
[status] varchar(20),
passengerCapacity int,
engineCapacity int)

--creating table Customer
create table Customer(
customerID int identity primary key,
firstName varchar(50),
lastName varchar(50),
email varchar(50),
phoneNumber varchar(15))

--create table Lease
create table Lease(
leaseID int identity primary key,
vehicleID int foreign key references Vehicle(vehicleID),
customerID int foreign key references Customer(customerID),
startDate date,
endDate date,
[type] varchar(20))

--create table payment
create table Payment(
paymentID int identity primary key,
leaseID int foreign key references Lease(leaseID),
paymentDate date,
amount decimal(10,2))

--changing datatype
alter table Vehicle
alter column [status] bit

--insert values into Vehicle table
insert into Vehicle (vehicleID,make, model, year, dailyRate, status, passengerCapacity, engineCapacity)
values 
(1,'Toyota', 'Camry', 2022, 50.00,1 , 4, 1450),
(2,'Honda', 'Civic', 2023, 45.00, 1, 7, 1500),
(3,'Ford', 'Focus', 2022, 48.00, 0, 4, 1400),
(4,'Nissan', 'Altima', 2023, 52.00, 1, 7, 1200),
(5,'Chevrolet', 'Malibu', 2022, 47.00,1, 4, 1800),
(6,'Hyundai', 'Sonata', 2023, 49.00, 0, 7, 1400),
(7,'BMW', '3 Series', 2023, 60.00, 1, 7, 2499),
(8,'Mercedes', 'C-Class', 2022 ,58.00, 1, 8, 2599),
(9,'Audi', 'A4', 2022, 55.00, 0, 4, 2500),
(10,'Lexus' ,'ES', 2023, 54.00,1,4,2500)

-- Insert values into customer table
insert into Customer (firstName, lastName, email, phoneNumber)
values
('John', 'Doe', 'johndoe@example.com', '555-555-5555'),
('Jane', 'Smith', 'janesmith@example.com', '555-123-4567'),
('Robert', 'Johnson', 'robert@example.com', '555-789-1234'),
('Sarah', 'Brown', 'sarah@example.com', '555-456-7890'),
('David', 'Lee', 'david@example.com', '555-987-6543'),
('Laura', 'Hall', 'laura@example.com', '555-234-5678'),
('Michael', 'Davis', 'michael@example.com', '555-876-5432'),
('Emma', 'Wilson', 'emma@example.com', '555-432-1098'),
('William', 'Taylor', 'william@example.com', '555-321-6547'),
('Olivia', 'Adams', 'olivia@example.com', '555-765-4321')

--insert values into lease table
INSERT INTO Lease (vehicleID, customerID, startDate, endDate, [type])
VALUES
(1, 1, '2023-01-01', '2023-01-05', 'Daily'),
(2, 2, '2023-02-15', '2023-02-28', 'Monthly'),
(3, 3, '2023-03-10', '2023-03-15', 'Daily'),
(4, 4, '2023-04-20', '2023-04-30', 'Monthly'),
(5, 5, '2023-05-05', '2023-05-10', 'Daily'),
(4, 3, '2023-06-15', '2023-06-30', 'Monthly'),
(7, 7, '2023-07-01', '2023-07-10', 'Daily'),
(8, 8, '2023-08-12', '2023-08-15', 'Monthly'),
(3, 3, '2023-09-07', '2023-09-10', 'Daily'),
(10, 10, '2023-10-10', '2023-10-31', 'Monthly')

--Insert values into payment table
insert into Payment (leaseID, paymentDate, amount)
values
(1, '2023-01-03', 200.00),
(2, '2023-02-20', 1000.00),
(3, '2023-03-12', 75.00),
(4, '2023-04-25', 900.00),
(5, '2023-05-07', 60.00),
(6, '2023-06-18', 1200.00),
(7, '2023-07-03', 40.00),
(8, '2023-08-14', 1100.00),
(9, '2023-09-09', 80.00),
(10, '2023-10-25', 1500.00)

--1. Update the daily rate for a Mercedes car to 68.
update Vehicle
set dailyRate = 68
where make = 'Mercedes'

--2. Delete a specific customer and all associated leases and payments.
delete from Payment
where leaseID in (select leaseID from Lease where customerID =1)
delete from Lease
where customerID =1 
delete from Customer
where customerID = 1

--3. Rename the "paymentDate" column in the Payment table to "transactionDate".
EXEC sp_rename 'Payment.paymentDate', 'transactionDate', 'COLUMN'

--4. Find a specific customer by email.
select * from Customer
where email = 'emma@example.com';

--5. Get active leases for a specific customer.
select top 1 * from Lease
where customerID = 3
order by endDate desc

--6. Find all payments made by a customer with a specific phone number.
select * from Payment P
JOIN Lease L on P.leaseID = L.leaseID
JOIN Customer C on L.customerID = C.customerID
where C.phoneNumber = '555-432-1098'

--7. Calculate the average daily rate of all available cars.
select AVG(dailyRate) as AverageDailyRate
from Vehicle
where status = 1

--8. Find the car with the highest daily rate.
select top 1 * from Vehicle
order by dailyRate DESC

--9. Retrieve all cars leased by a specific customer.
select * from Vehicle V
JOIN 
Lease L ON V.vehicleID = L.vehicleID
JOIN 
Customer C ON L.customerID = C.customerID
WHERE C.firstName = 'Emma'

--10. Find the details of the most recent lease.
select top 1 * from Lease
order by endDate DESc
--11. List all payments made in the year 2023.
select * from Payment
where YEAR(transactionDate) = 2023

--12. Retrieve customers who have not made any payments.
select C. * FROM Customer C
LEFT JOIN 
Lease L on C.customerID = L.customerID
LEFT JOIN 
Payment P on L.leaseID = P.leaseID
where P.paymentID IS NULL

--13. Retrieve Car Details and Their Total Payments.
select V.*, SUM(P.amount) as TotalPayments
from Vehicle V
JOIN 
Lease L on V.vehicleID = L.vehicleID
JOIN 
Payment P on L.leaseID = P.leaseID
Group By V.vehicleID, V.make, V.model, V.year, V.dailyRate, V.status, V.passengerCapacity, V.engineCapacity

--14. Calculate Total Payments for Each Customer.
select C.customerID, C.firstName, C.lastName, SUM(P.amount) as TotalPayments
from Customer C
JOIN 
Lease L on C.customerID = L.customerID
JOIN 
Payment P on L.leaseID = P.leaseID
group By C.customerID, C.firstName, C.lastName

--15. List Car Details for Each Lease.
select * from Lease L
JOIN 
Vehicle V on L.vehicleID = V.vehicleID

--16. Retrieve Details of Active Leases with Customer and Car Information.
select L.leaseID, L.startDate, L.endDate, L.type,
       C.firstName, C.lastName, C.email,
       V.make, V.model, V.year
from Lease L
JOIN 
Customer C ON L.customerID = C.customerID
JOIN 
Vehicle V ON L.vehicleID = V.vehicleID
where year(L.endDate)=2023 

--17. Find the Customer Who Has Spent the Most on Leases.
select top 1 C.customerID, C.firstName, C.lastName, SUM(P.amount) as TotalSpent
from Customer C
JOIN 
Lease L on C.customerID = L.customerID
JOIN 
Payment P on L.leaseID = P.leaseID
group by C.customerID, C.firstName, C.lastName
order by TotalSpent DESC

--18. List All Cars with Their Current Lease Information.
select V.year,V.make,V.model, L.leaseID, L.startDate, L.endDate, C.firstName, C.lastName
FROM Vehicle V
left JOIN 
Lease L ON V.vehicleID = L.vehicleID AND year(L.endDate)=2023
left JOIN 
Customer C ON L.customerID = C.customerID

select * from Customer;
select * from Vehicle;