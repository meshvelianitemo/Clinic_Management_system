CREATE DATABASE ClinicApp;
GO

CREATE TABLE Users
(
	UserId INT IDENTITY(1000,1), --PRIMARY KEY
	UserName NVARCHAR(100) NOT NULL, -- UNIQUE
	PasswordHash NVARCHAR(300) NOT NULL, 
	Role NVARCHAR(100) NOT NULL, 
	IsActive BIT NOT NULL DEFAULT 1, 
	LastLoginAt DATETIME,
	CreatedAt DATETIME DEFAULT(GETDATE()), 
	CONSTRAINT PK_Users_UserId PRIMARY KEY (UserId), 
	CONSTRAINT UQ_Users_UserName UNIQUE (UserName)
);
GO

CREATE TABLE AppointmentStatus
(
	StatusId INT IDENTITY(1000,1), 
	StatusName NVARCHAR(50) NOT NULL, --UNIQUE AND CHECK
	IsFinal BIT NOT NULL DEFAULT 0, 
	IsActive BIT NOT NULL , 
	CONSTRAINT PK_AppointmentStatus_StatusId PRIMARY KEY (StatusId), 
	CONSTRAINT CH_AppointmentStatus_StatusName CHECK(StatusName IN ('Scheduled','Completed','Cancelled', 'NoShow', 'Rescheduled')),
	CONSTRAINT UQ_AppointmentStatus_StatusName UNIQUE(StatusName)
)
GO

CREATE TABLE Doctors
(
	DoctorId INT IDENTITY(1000,1),  --PRIMARY KEY
	UserId INT NULL, --UNIQUE
	FirstName NVARCHAR(100) NOT NULL, 
	LastName NVARCHAR(150) NOT NULL , 
	Specialization NVARCHAR(150) NOT NULL ,
	LicenseNumber NVARCHAR(100) NOT NULL , --UNIQUE CONSTRAINT 
	Phone VARCHAR(40) NOT NULL , 
	Email NVARCHAR(200) NOT NULL, --UNIQUE
	Bio NVARCHAR(500) , 
	DefaultAppointmentDurationMinutes INT DEFAULT(20), 
	CreatedAt DATETIME DEFAULT(GETDATE()), 
	IsActive BIT NOT NULL , 
	UpdatedAt DATETIME, 
	CONSTRAINT PK_Doctors_DoctorId PRIMARY KEY(DoctorId), 
	CONSTRAINT UQ_Doctors_UserId UNIQUE (UserId), 
	CONSTRAINT UQ_Doctors_LicenseNumber UNIQUE (LicenseNumber), 
	CONSTRAINT UQ_Doctors_Email UNIQUE(Email),
	CONSTRAINT FK_Doctors_UserId FOREIGN KEY (UserId) REFERENCES Users(UserId)
)
GO

CREATE TABLE Patients
(
	PatientId INT IDENTITY(1000,1), --PRIMARY KEY
	FirstName NVARCHAR(100) NOT NULL, 
	LastName NVARCHAR(150) NOT NULL ,
	DateOfBirth DATETIME NOT NULL , 
	Gender NVARCHAR(50) NOT NULL , --CHECK
	Phone NVARCHAR(30) NOT NULL ,
	Email NVARCHAR(200) , 
	PersonalIdNumber NVARCHAR(30) NOT NULL , --UNIQUE
	EmergencyContactName NVARCHAR(150) , 
	EmergencyContactPhoneNumber NVARCHAR(30), 
	Notes NVARCHAR (300), 
	IsActive BIT NOT NULL , 
	UpdatedAt DATETIME, 
	CreatedAt DATETIME DEFAULT(GETDATE()),
	CONSTRAINT PK_Patients_PatientId PRIMARY KEY (PatientId), 
	CONSTRAINT UQ_Patients_PersonalIdNumber UNIQUE (PersonalIdNumber),
	CONSTRAINT CH_Patients_Gender CHECK (Gender IN ('Male', 'Female', 'Other'))
)
GO

CREATE TABLE DoctorSchedules
(
	ScheduleId INT IDENTITY(1000,1) , --PRIMARY KEY, 
	DoctorId INT NOT NULL, --FOREIGN KEY 
	DayOfWeek INT NOT NULL , --CHECK
	StartTime TIME(0) NOT NULL, 
	EndTime TIME(0) NOT NULL , 
	BreakStartTime TIME(0), --CHECK
	BreakEndTime TIME(0), --CHECK
	IsActive BIT NOT NULL ,
	EffectiveFrom DATETIME , 
	EffectiveTo DATETIME, 
	CONSTRAINT PK_DoctorSchedules_ScheduleId PRIMARY KEY(ScheduleId) , 
	CONSTRAINT Fk_DoctorSchedules_DoctorId FOREIGN KEY(DoctorId) REFERENCES Doctors(DoctorId), 
	CONSTRAINT CH_DoctorSchedules_DayOfWeek CHECK (DayOfWeek BETWEEN 1 AND 7),
	CONSTRAINT CH_DoctorSchedules_TimeRange CHECK (StartTime < EndTime)
)
GO

CREATE TABLE Appointments
(
	AppointmentId INT IDENTITY(1000,1), --PRIMARY KEY
	DoctorId INT NOT NULL, --FOREIGN KEY
	PatientId INT NOT NULL, --FOREIGN KEY
	StatusId INT NOT NULL, --FOREIGN KEY
	CreatedByUserId INT NOT NULL, --FOREIGN KEY
	AppointmentStart DATETIME NOT NULL, --CHECK
	AppointmentEnd DATETIME NOT NULL , --CHECK
	ReasonForVisit NVARCHAR(200) NOT NULL, 
	Notes NVARCHAR(200), 
	CreatedAt DATETIME DEFAULT(GETDATE()),
	UpdatedAt DATETIME, 
	CONSTRAINT PK_Appointments_AppointmentId PRIMARY KEY(AppointmentId), 
	CONSTRAINT FK_Appointments_DoctorId FOREIGN KEY (DoctorId) REFERENCES Doctors(DoctorId), 
	CONSTRAINT FK_Appointments_PatientId FOREIGN KEY (PatientId) REFERENCES Patients(PatientId), 
	CONSTRAINT FK_Appointments_StatusId FOREIGN KEY (StatusId) REFERENCES AppointmentStatus(StatusId), 
	CONSTRAINT FK_Appointments_CreatedByUserId FOREIGN KEY(CreatedByUserId) REFERENCES Users(UserId),
	CONSTRAINT CH_Appointments_TimeRange CHECK (AppointmentStart < AppointmentEnd)
);
GO

CREATE TABLE AppointmentStatusHistory
(
	HistoryId INT IDENTITY(1000,1),  --PRIMARY KEY
	AppointmentId INT NOT NULL, --FOREIGN KEY
	ChangedByUserId INT NOT NULL, --FOREIGN KEY
	OldStatusId INT NOT NULL , 
	NewStatusId INT NOT NULL ,
	ChangedAt DATETIME DEFAULT(GETDATE()), 
	CONSTRAINT PK_AppointmentStatusHistory_HistoryId PRIMARY KEY(HistoryId), 
	CONSTRAINT FK_AppointmentStatusHistory_AppointmentId FOREIGN KEY (AppointmentId) REFERENCES Appointments(AppointmentId), 
	CONSTRAINT FK_AppointmentStatusHistory_ChangedByUserId FOREIGN KEY (ChangedByUserId) REFERENCES Users(UserId), 
	CONSTRAINT FK_AppointmentStatusHistory_OldStatusId FOREIGN KEY (OldStatusId) REFERENCES AppointmentStatus(StatusId),
	CONSTRAINT FK_AppointmentStatusHistory_NewStatusId FOREIGN KEY (NewStatusId) REFERENCES AppointmentStatus(StatusId)
);
GO