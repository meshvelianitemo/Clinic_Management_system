USE ClinicApp
GO

CREATE PROCEDURE sp_CreateAppointment
	@DoctorId INT , 
	@PatientId INT,
	@StatusId NVARCHAR(50), 
	@CreatedByUser INT, 
	@AppointmentStart DATETIME ,
	@ReasonForVisit NVARCHAR(300) , 
	@Notes NVARCHAR(200)
AS 
BEGIN
	SET NOCOUNT ON;
	BEGIN TRY
		BEGIN TRAN

			IF NOT EXISTS (
				SELECT 1 FROM Doctors 
				WHERE DoctorId = @DoctorId AND IsActive = 1
			)
			THROW 50010, 'Doctor with this doctorId does not exist, or is not currently active', 1;
		

			IF NOT EXISTS (
				SELECT 1 FROM Patients 
				WHERE PatientId = @PatientId AND IsActive = 1
			)
			THROW 50011, 'Patient with this PatientId does not exist, or is not currently active', 1;

			IF NOT EXISTS (
				SELECT 1 FROM AppointmentStatus 
				WHERE StatusId = @StatusId  
			)
			THROW 50012, 'Invalid StatusId', 1;

			IF NOT EXISTS (
				SELECT 1 FROM Users
				WHERE UserId = @CreatedByUser AND IsActive =1
			)
			THROW 50013, 'User with this UserId does not exist, or is not currently active', 1;
		
			IF EXISTS(
				SELECT 1 FROM Appointments
				WHERE DoctorId = @DoctorId AND AppointmentStart = @AppointmentStart
			)
			THROW 50014, 'This period of time is already booked for another patient', 1;

			DECLARE @AppointmentDuration INT ;

			SELECT @AppointmentDuration = DefaultAppointmentDurationMinutes
			FROM Doctors
			WHERE DoctorId = @DoctorId

			INSERT INTO Appointments(DoctorId, PatientId, StatusId, CreatedByUserId, AppointmentStart, AppointmentEnd, ReasonForVisit, Notes)
			VALUES (@DoctorId, @PatientId, @StatusId, @CreatedByUser, @AppointmentStart, DATEADD(MINUTE, @AppointmentDuration, @AppointmentStart), @ReasonForVisit, @Notes)
		
		COMMIT TRAN
			
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0
        ROLLBACK;
			
			
		THROW;
		
	END CATCH
END
GO


CREATE PROCEDURE sp_ChangeAppointmentStatus
	@AppointmentId INT , 
	@NewStatusId INT, 
	@ChangedByUserId INT
AS 
BEGIN
	SET NOCOUNT ON;	
	BEGIN TRY
		BEGIN TRAN
			
			IF NOT EXISTS(
				SELECT 1 FROM AppointmentStatus
				WHERE StatusId = @NewStatusId
			)
				THROW 50015, 'A status with this StatusId does not exist', 1;
			
			IF NOT EXISTS(
				SELECT 1 FROM Users
				WHERE UserId = @ChangedByUserId AND IsActive =1
			)
				THROW 50016, 'An User with this UserId does not exist, or is not currently active',1;

			UPDATE Appointments 
			SET StatusId = @NewStatusId , CreatedByUserId = @ChangedByUserId
			WHERE AppointmentId = @AppointmentId

		COMMIT TRAN
	END TRY

	BEGIN CATCH
		IF @@TRANCOUNT > 0
        ROLLBACK;
			
			
		THROW;
	END CATCH
END
GO


CREATE PROCEDURE sp_RegisterUser
	@UserName NVARCHAR(100),
	@PasswordHash NVARCHAR(500), 
	@Role NVARCHAR(20)
AS 
BEGIN
	SET NOCOUNT ON;
	BEGIN TRY
		BEGIN TRAN
			
			IF @UserName IS NULL OR LTRIM(RTRIM(@UserName)) = ''
				THROW 50019, 'An UserName cannot be null or empty string', 1;
			
			IF EXISTS (
				SELECT 1 FROM Users
				WHERE UserName = @UserName
			)
			THROW 50017 , 'An user with this UserName already exists',1;
		

			INSERT INTO Users(UserName, PasswordHash, Role, IsActive)
				VALUES (@UserName, @PasswordHash, @Role,1)

		COMMIT TRAN

	END TRY

	BEGIN CATCH
		IF @@TRANCOUNT > 0
			ROLLBACK;
			
			
			THROW;
	END CATCH
END
GO


CREATE PROCEDURE sp_CreatePatient
	@FirstName NVARCHAR(100),
	@LastName NVARCHAR(100), 
	@DateOfBirth DATETIME, 
	@Gender NVARCHAR(50), 
	@Phone NVARCHAR(50), 
	@Email NVARCHAR(100), 
	@PersonalIdNumber NVARCHAR(100), 
	@EmergencyContactName NVARCHAR(50),
	@EmergencyContactNumber NVARCHAR(50),
	@Notes NVARCHAR(200)
AS 
BEGIN
	SET NOCOUNT ON;
	BEGIN TRY
		BEGIN TRAN
			IF EXISTS (
				SELECT 1 FROM Patients
				WHERE PersonalIdNumber = @PersonalIdNumber
			)
			THROW 50018, 'A Patient with this Personal Id number already exists', 1;

			IF @FirstName IS NULL OR LTRIM(RTRIM(@FirstName)) = ''
				THROW 50020, 'A FirstName cannot be null or empty string', 1;

			IF @LastName IS NULL OR LTRIM(RTRIM(@LastName)) = ''
				THROW 50021, 'A LastName cannot be null or empty string', 1;
			
			IF @DateOfBirth > GETDATE()
				THROW 50022, 'A birthDate cannot be in future',1;

			IF @Gender NOT IN ('Male', 'Female', 'Other')
				THROW 50023, 'Invalid gender value', 1;
			
			IF @Email IS NOT NULL AND @Email NOT LIKE '%@%.%'
				THROW 50024, 'Invalid email format', 1;

			IF (@EmergencyContactName IS NULL AND @EmergencyContactNumber IS NOT NULL)
				OR (@EmergencyContactName IS NOT NULL AND @EmergencyContactNumber IS NULL)
				THROW 50025, 'Emergency contact name and number must both be provided', 1;

			INSERT INTO Patients(FirstName, LastName, DateOfBirth, Gender, Phone, Email,PersonalIdNumber, EmergencyContactName, EmergencyContactPhoneNumber, Notes, IsActive)
				VALUES (@FirstName, @LastName, @DateOfBirth, @Gender, @Phone, @Email, @PersonalIdNumber, @EmergencyContactName, @EmergencyContactNumber, @Notes, 1)

		COMMIT TRAN
	END TRY

	BEGIN CATCH
		IF @@TRANCOUNT > 0
			ROLLBACK;
			
			
			THROW;
	END CATCH

END