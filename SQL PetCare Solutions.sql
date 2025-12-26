CREATE DATABASE PetCareSolutions;

-- ---------------------------------------------------------------------

-- Table: owners
-- Stores information about the pet owners
CREATE TABLE owners (
    id INT PRIMARY KEY IDENTITY(1,1),           
    firstName NVARCHAR(50) NOT NULL,            -- NVARCHAR for better Unicode support
    lastName NVARCHAR(50) NOT NULL,
    phoneNumber NVARCHAR(20),
    email NVARCHAR(100) UNIQUE,
    street NVARCHAR(255),
    city NVARCHAR(100)
);
GO

-- Table: users
-- Stores login information and roles for system access control.
CREATE TABLE users (
    id INT PRIMARY KEY IDENTITY(1,1),
    username NVARCHAR(50) NOT NULL UNIQUE,
    passwordHash NVARCHAR(255) NOT NULL,
    role NVARCHAR(50) NOT NULL,
    dateCreated DATETIME DEFAULT GETDATE()      
);
GO

-- Table: veterinarians
-- Stores information about the veterinarians.
CREATE TABLE veterinarians (
    id INT PRIMARY KEY IDENTITY(1,1),
    name NVARCHAR(100) NOT NULL,
    specialty NVARCHAR(100),
    contactInfo NVARCHAR(255),
    userId INT NOT NULL UNIQUE,
    FOREIGN KEY (userId) REFERENCES users(id)
);
GO

-- Table: pets
-- Stores information about each pet.
CREATE TABLE pets (
    id INT PRIMARY KEY IDENTITY(1,1),
    name NVARCHAR(100) NOT NULL,
    species NVARCHAR(50),
    breed NVARCHAR(50),
	Gender NVARCHAR(10),
    dateOfBirth DATE,
    medicalNotes NVARCHAR(MAX),                 
    ownerId INT NOT NULL,
    FOREIGN KEY (ownerId) REFERENCES owners(id)
);
GO


-- Table: appointments
-- Stores information about scheduled appointments.
CREATE TABLE appointments (
    id INT PRIMARY KEY IDENTITY(1,1),
    appointmentDate DATE NOT NULL,
    appointmentTime TIME NOT NULL,
    typeOfService NVARCHAR(100),
    status NVARCHAR(20) DEFAULT 'Scheduled',
    petId INT NOT NULL,
    vetId INT NOT NULL,
    FOREIGN KEY (petId) REFERENCES pets(id),
    FOREIGN KEY (vetId) REFERENCES veterinarians(id)
);
GO

-- Table: medical_records
-- This is a WEAK ENTITY. It stores detailed medical history for each pet visit.
CREATE TABLE medical_records (
    petId INT NOT NULL,
    id INT NOT NULL IDENTITY(1,1),              
    diagnosis NVARCHAR(MAX),
    prescriptions NVARCHAR(MAX),
    vaccinationsGiven NVARCHAR(MAX),
    followupInstructions NVARCHAR(MAX),
    vetId INT NOT NULL,
    PRIMARY KEY (petId, id),                    
    FOREIGN KEY (petId) REFERENCES pets(id),
    FOREIGN KEY (vetId) REFERENCES veterinarians(id)
);

-- This table stores online booking requests made by pet owners.
CREATE TABLE BookingRequests (
    RequestID INT PRIMARY KEY IDENTITY(1,1),     
    OwnerID INT NOT NULL,                         
    PetID INT NOT NULL,                           
    RequestedDate DATE NOT NULL,                  
    RequestedTime TIME NOT NULL,                  
    Status NVARCHAR(20) NOT NULL DEFAULT 'Pending', 
    FOREIGN KEY (OwnerID) REFERENCES owners(id),
    FOREIGN KEY (PetID) REFERENCES pets(id)
);

-- =====================================================================
-- Populate Users Table
-- Description: Inserts user accounts for system access.
-- Roles: 'Veterinarian' for doctors, 'Admin' or 'Receptionist' for staff.
-- Note: Passwords should be properly hashed in a real application.
-- =====================================================================
INSERT INTO users (username, passwordHash, role) VALUES
('ADMIN1', 'hashed_1111_password', 'Administrator'),
('ADMIN', 'hashed_ADMIN_password', 'Administrator'),
('dr.ahmad', 'hashed_password_1', 'Veterinarian'),
('dr.fatima', 'hashed_password_2', 'Veterinarian'),
('sara.reception', 'hashed_password_3', 'Receptionist');

SELECT *FROM users

-- =====================================================================
-- Populate Owners Table
-- Description: Inserts records for pet owners.
-- =====================================================================
INSERT INTO owners (firstName, lastName, phoneNumber, email, street, city) VALUES
('Samli', 'Khalejd', '07912345687', 'salmi.k@example.com', '123 Al-Rainbow St', 'Amman');
('Sami', 'Khaled', '0791234567', 'sami.k@example.com', '123 Al-Rainbow St', 'Amman'),
('Nadia', 'Saleh', '0788765432', 'nadia.s@example.com', '45 Queen Rania St', 'Irbid'),
('Omar', 'Zaid', '0777112233', 'omar.z@example.com', '78 Gardens St', 'Amman');

SELECT *FROM owners

-- =====================================================================
-- Populate Veterinarians Table
-- Description: Inserts records for veterinarians, linking them to their user accounts.
-- Note: The 'userId' must correspond to an existing ID in the 'users' table.
-- =====================================================================
INSERT INTO veterinarians (name, specialty, contactInfo, userId) VALUES
('Dr. Ahmad Yaseen', 'General Practice & Surgery', 'ayaseen@petcare.com', 1),
('Dr. Fatima Ali', 'Dermatology', 'fali@petcare.com', 2),
-- Assuming the third user is not a vet, we only add two vets.
-- You can add a third vet if you create a corresponding user for them.
('Dr. Yazan', 'Dentistry', 'yazan@petcare.com', 3);

SELECT *FROM veterinarians

-- =====================================================================
-- Populate Pets Table
-- Description: Inserts records for pets, linking them to their owners.
-- Note: The 'ownerId' must correspond to an existing ID in the 'owners' table.
-- =====================================================================
INSERT INTO pets (name, species, breed, Gender, dateOfBirth, medicalNotes, ownerId) VALUES
('Mishmish', 'Cat', 'Shirazi', 'Male', '2022-04-10', 'Allergic to dust.', 1),
('Leo', 'Dog', 'German Shepherd', 'Male', '2021-08-20', 'Slightly sensitive stomach.', 2),
('Kiwi', 'Bird', 'Cockatiel', 'Female', '2023-01-15', 'Very active and healthy.', 3);

SELECT *FROM pets

-- =====================================================================
-- Populate Appointments Table
-- Description: Schedules appointments, linking pets to veterinarians.
-- Note: 'petId' and 'vetId' must correspond to existing IDs.
-- =====================================================================
INSERT INTO appointments (appointmentDate, appointmentTime, typeOfService, status, petId, vetId) VALUES
('2024-05-20', '10:00:00', 'Annual Checkup', 'Completed', 1, 1),
('2024-05-22', '11:30:00', 'Vaccination', 'Completed', 2, 2),
('2024-06-15', '09:00:00', 'Dental Cleaning', 'Scheduled', 3, 1);

SELECT *FROM appointments

-- =====================================================================
-- Populate Medical Records Table
-- Description: Creates medical records for pet visits. This is a weak entity dependent on a pet.
-- Note: 'petId' and 'vetId' must correspond to existing IDs.
-- =====================================================================
INSERT INTO medical_records (petId, diagnosis, prescriptions, vaccinationsGiven, followupInstructions, vetId) VALUES
(1, 'Minor ear infection', 'Otic-Plus ear drops, 5 drops twice daily for 7 days.', 'None', 'Re-check in one week if symptoms persist.', 1),
(2, 'Routine vaccination update', 'None', 'Rabies (1-year), DAPPv (Booster)', 'Monitor for any lethargy or swelling at the injection site.', 2),
(1, 'Post-checkup observation', 'Flea and tick prevention (Bravecto)', 'None', 'Apply monthly.', 1);

SELECT *FROM medical_records

-- =====================================================================
-- Populate Booking Requests Table
-- Description: Simulates online booking requests made by owners for their pets.
-- Note: 'OwnerID' and 'PetID' must correspond to existing IDs.
-- =====================================================================
INSERT INTO BookingRequests (OwnerID, PetID, RequestedDate, RequestedTime, Status) VALUES
(3, 3, '2024-07-08', '14:00:00', 'Pending');
(3, 3, '2024-07-01', '14:00:00', 'Pending'),
(1, 1, '2024-06-25', '10:00:00', 'Confirmed'),
(2, 2, '2024-08-10', '16:00:00', 'Pending');

SELECT *FROM BookingRequests



-- =====================================================================
-- Update Users Table
-- Description: Modifies existing user account details.
-- =====================================================================

-- Scenario 1: A user (sara.reception) has been promoted to an 'Admin' role.
UPDATE users
SET role = 'Admin'
WHERE username = 'sara.reception';

-- Scenario 2: A user resets their password. We update the hash for Dr. Ahmad.
UPDATE users
SET passwordHash = 'new_hashed_password_for_ahmad'
WHERE id = 1;

-- Scenario 3: A user changes their username for standardization.
UPDATE users
SET username = 'dr.fatima.ali'
WHERE username = 'dr.fatima';

SELECT *FROM users


-- =====================================================================
-- Update Owners Table
-- Description: Modifies owner information.
-- =====================================================================

-- Scenario 1: Owner Sami Khaled has moved to a new address.
UPDATE owners
SET street = '250 Abdoun St', city = 'ZQARA'
WHERE id = 5;

-- Scenario 2: Owner Nadia Saleh has a new phone number.
UPDATE owners
SET phoneNumber = '0789998877'
WHERE email = 'nadia.s@example.com';

-- Scenario 3: Correcting a typo in an owner's last name.
UPDATE owners
SET lastName = 'Zayed'
WHERE id = 3;

SELECT *FROM owners


-- =====================================================================
-- Update Veterinarians Table
-- Description: Modifies veterinarian details like specialty or contact info.
-- =====================================================================

-- Scenario 1: Dr. Fatima Ali has completed a new certification in animal nutrition.
UPDATE veterinarians
SET specialty = 'Dermatology & Nutrition'
WHERE id = 2;

-- Scenario 2: Updating the main contact email for the clinic's lead vet.
UPDATE veterinarians
SET contactInfo = 'ahmad.yaseen.vet@petcare.com'
WHERE name = 'Dr. Ahmad Yaseen';

-- Scenario 3: Updating Dr. Yazan's name after an official registration.
UPDATE veterinarians
SET name = 'Dr. Yazan Al-Majali'
WHERE id = 3;

SELECT *FROM veterinarians


-- =====================================================================
-- Update Pets Table
-- Description: Modifies pet information, such as medical notes or ownership.
-- =====================================================================

-- Scenario 1: The owner reports that 'Mishmish' is now on a special diet.
UPDATE pets
SET medicalNotes = 'Allergic to dust. Now on a grain-free diet.'
WHERE name = 'Mishmish';

-- Scenario 2: The pet 'Leo' has been re-homed to another existing owner (Sami Khaled).
UPDATE pets
SET ownerId = 1
WHERE id = 2;

-- Scenario 3: Correcting the date of birth for 'Kiwi' the bird.
UPDATE pets
SET dateOfBirth = '2023-02-01'
WHERE id = 3;

SELECT *FROM pets


-- =====================================================================
-- Update Appointments Table
-- Description: Modifies appointment details, such as status or time.
-- =====================================================================

-- Scenario 1: An appointment that was scheduled has been cancelled by the owner.
UPDATE appointments
SET status = 'Cancelled'
WHERE id = 3; -- This was the scheduled dental cleaning for Kiwi.

-- Scenario 2: Rescheduling a completed appointment for a follow-up check. Let's reuse appointment ID 1.
UPDATE appointments
SET appointmentDate = '2024-05-27', status = 'Scheduled', typeOfService = 'Follow-up Check'
WHERE id = 1;

-- Scenario 3: The time for a confirmed booking request (ID 2) needs to be slightly adjusted.
UPDATE appointments
SET appointmentTime = '12:00:00'
WHERE id = 2;

SELECT *FROM appointments


-- =====================================================================
-- Update Medical Records Table
-- Description: Amends existing medical records with new information.
-- =====================================================================

-- Scenario 1: Adding more detailed follow-up instructions to a medical record.
UPDATE medical_records
SET followupInstructions = 'Re-check in one week. Administer ear drops carefully and monitor for redness.'
WHERE petId = 1 AND id = 1; -- Note the composite key in WHERE clause.

-- Scenario 2: Updating a diagnosis after lab results came in for pet 'Leo'.
UPDATE medical_records
SET diagnosis = 'Routine vaccination update. Lab work shows mild iron deficiency.'
WHERE petId = 2;

-- Scenario 3: Updating prescriptions for Mishmish's record.
UPDATE medical_records
SET prescriptions = 'Flea and tick prevention (Bravecto). Add iron supplement to food.'
WHERE petId = 1 AND id = 3;

SELECT *FROM medical_records


-- =====================================================================
-- Update Booking Requests Table
-- Description: Modifies the status of booking requests.
-- =====================================================================

-- Scenario 1: A pending booking request has been confirmed by the clinic staff.
UPDATE BookingRequests
SET Status = 'Confirmed'
WHERE RequestID = 1; -- This was the pending request for Kiwi.

-- Scenario 2: A different pending request is rejected due to no availability.
UPDATE BookingRequests
SET Status = 'Rejected'
WHERE RequestID = 3; -- This was the other pending request.

-- Scenario 3: The owner who had a confirmed request (ID 2) calls to cancel it.
UPDATE BookingRequests
SET Status = 'Cancelled by Owner'
WHERE RequestID = 2;

SELECT *FROM BookingRequests





-- =====================================================================
-- Delete from BookingRequests Table
-- Description: Deletes a specific booking request.
-- =====================================================================

-- Scenario: A booking request that was previously rejected is now being purged from the system to keep the list clean.
DELETE FROM BookingRequests
WHERE Status = 'Rejected';

SELECT *FROM BookingRequests

-- =====================================================================
-- Delete from Appointments Table
-- Description: Deletes a specific appointment.
-- =====================================================================

-- Scenario: An appointment that was cancelled some time ago is being removed from the schedule records.
DELETE FROM appointments
WHERE id = 3 AND status = 'Cancelled';

SELECT *FROM appointments

-- =====================================================================
-- Delete from Medical Records Table
-- Description: Deletes a specific medical record.
-- =====================================================================

-- Scenario: A veterinarian decides a minor, supplementary record is redundant and removes it.
-- We must specify the composite key (petId, id) for accuracy.
DELETE FROM medical_records
WHERE petId = 1 AND id = 3;

SELECT *FROM medical_records

-- =====================================================================
-- Delete from Pets Table
-- Description: Deletes a pet's record.
-- NOTE: This can only be done AFTER all its appointments, medical records, and booking requests have been removed.
-- =====================================================================

-- Scenario: The pet 'Kiwi' (ID 3) has been re-homed, and the owner requested the removal of its data.
-- We have already deleted its associated appointment and it has no medical records in our script.
DELETE FROM pets
WHERE id = 1;

SELECT *FROM pets

-- =====================================================================
-- Delete from Owners Table
-- Description: Deletes an owner's record.
-- NOTE: This can only be done AFTER all their pets have been removed.
-- =====================================================================

-- Scenario: The owner of the pet we just deleted ('Omar Zayed', ID 3) is also leaving the clinic.
DELETE FROM owners
WHERE id =12;

SELECT *FROM owners

-- =====================================================================
-- Delete from Veterinarians Table
-- Description: Deletes a vet's record.
-- NOTE: This can only be done AFTER all their appointments and medical records are reassigned or removed.
-- =====================================================================

-- Scenario: Dr. Yazan (ID 3) has left the clinic. His record is being removed.
-- He has no existing appointments or medical records linked to him in our data.
DELETE FROM veterinarians
WHERE id = 3;

SELECT *FROM veterinarians

-- =====================================================================
-- Delete from Users Table
-- Description: Deletes a user's login account.
-- NOTE: This can only be done AFTER the corresponding veterinarian/staff record is removed.
-- =====================================================================

-- Scenario: The system access account for the veterinarian who just left ('Dr. Yazan') is now being deleted.
DELETE FROM users
WHERE id = 12;

SELECT *FROM users


-- =====================================================================
-- Query 1: Retrieve all veterinarian names
-- Description: A simple and direct query to get a list of the full names of all veterinarians
-- working at the clinic. Useful for receptionists or for populating a dropdown menu.
SELECT name
FROM veterinarians;


-- Query 2: List each pet and its owner's name (JOIN on two tables)
-- Description: This query joins the 'pets' and 'owners' tables to create a clear list
-- showing which owner each pet belongs to. It uses aliases (p, o) for readability.
SELECT
    p.name AS PetName,
    p.species,
    o.firstName AS OwnerFirstName,
    o.lastName AS OwnerLastName
FROM
    pets AS p
JOIN
    owners AS o ON p.ownerId = o.id;


-- Query 3: Find all appointments for a specific pet
-- Description: This query retrieves the complete appointment history for a single pet
-- (in this case, the pet with ID = 1), which is essential for tracking a pet's visits.
SELECT
    appointmentDate,
    appointmentTime,
    typeOfService,
    status
FROM
    appointments
WHERE
    petId = 1
ORDER BY
    appointmentDate DESC;


-- Query 4: Display a specific veterinarian's schedule for a given day (JOIN on three tables)
-- Description: A more complex query that joins three tables (appointments, pets, veterinarians)
-- to show a specific vet's schedule for a particular day, ordered by time. This is a core operational query.
SELECT
    a.appointmentTime,
    p.name AS PetName,
    o.firstName AS OwnerName,
    a.typeOfService
FROM
    appointments AS a
JOIN
    pets AS p ON a.petId = p.id
JOIN
    owners AS o ON p.ownerId = o.id
WHERE
    a.vetId = 1 AND a.appointmentDate = '2024-05-27' -- We updated this appointment in a previous step
ORDER BY
    a.appointmentTime;


-- Query 5: Count the number of pets each owner has
-- Description: This query uses an aggregate function (COUNT) and GROUP BY to get a summary report
-- showing how many pets are registered to each owner. It's useful for client management and insights.
SELECT
    o.firstName,
    o.lastName,
    o.email,
    COUNT(p.id) AS NumberOfPets
FROM
    owners AS o
LEFT JOIN -- Using LEFT JOIN to include owners who might have 0 pets
    pets AS p ON o.id = p.ownerId
GROUP BY
    o.id, o.firstName, o.lastName, o.email
ORDER BY
    NumberOfPets DESC;


-- =====================================================================
-- Query 1: General Clinic Activity Summary
-- Description: This query provides a high-level overview of all appointments in the system.
-- It counts the total number of appointments, finds the date of the very first appointment
-- on record (MIN), and the date of the most recent or furthest future appointment (MAX).
SELECT
    COUNT(id) AS TotalAppointments,
    MIN(appointmentDate) AS FirstAppointmentDate,
    MAX(appointmentDate) AS LastAppointmentDate
FROM
    appointments;

-- Query 2: Performance Summary for Each Veterinarian
-- Description: A more advanced query that groups the appointments by each veterinarian
-- to provide individual performance metrics. It shows the total number of appointments
-- each vet has handled, along with their first and last appointment dates on record.
SELECT
    v.name AS VeterinarianName,
    COUNT(a.id) AS NumberOfAppointments,
    MIN(a.appointmentDate) AS FirstAppointment,
    MAX(a.appointmentDate) AS LastAppointment
FROM
    veterinarians AS v
JOIN
    appointments AS a ON v.id = a.vetId
GROUP BY
    v.name
ORDER BY
    NumberOfAppointments DESC

-- Query 3 (Enhanced): Appointment Status Dashboard with Date Range
-- Description: This enhanced query provides a summary by status, and now includes
-- the earliest (MIN) and latest (MAX) appointment dates for each status category,
-- showing the time range for each group.
SELECT
    status,
    COUNT(id) AS NumberOfAppointments,
    MIN(appointmentDate) AS EarliestDate,
    MAX(appointmentDate) AS LatestDate
FROM
    appointments
GROUP BY
    status;
