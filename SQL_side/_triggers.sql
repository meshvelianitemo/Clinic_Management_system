USE ClinicApp;
Go
 

CREATE TRIGGER trg_StatusHistoryLog
ON [dbo].[Appointments]
AFTER UPDATE 
AS 
BEGIN
	SET NOCOUNT ON;

	INSERT INTO AppointmentStatusHistory(AppointmentId,ChangedByUserId, OldStatusId, NewStatusId)
		SELECT 
				d.AppointmentId, 
				i.CreatedByUserId,
				d.StatusId,
				i.StatusId
			FROM deleted d
				JOIN
			inserted i
				ON d.AppointmentId = i.AppointmentId
			WHERE d.StatusId <> i.StatusId;
END
GO

CREATE TRIGGER trg_PreventAppointmentDelete
ON [dbo].[Appointments]
INSTEAD OF DELETE
AS 
BEGIN
	SET NOCOUNT ON;
	
	UPDATE [dbo].[Appointments] 
		SET StatusId = (SELECT StatusId FROM AppointmentStatus WHERE StatusName = 'Cancelled'), UpdatedAt = GETDATE()
		WHERE AppointmentId IN (SELECT AppointmentId FROM DELETED)
		 	
END
GO

CREATE TRIGGER trg_SoftDeleteUser
ON [dbo].[Users]
INSTEAD OF DELETE
AS 
BEGIN
	SET NOCOUNT ON;

	UPDATE [dbo].[Users]
		SET IsActive = 0
			WHERE UserId IN (SELECT UserId FROM DELETED)
		
END 
GO

CREATE TRIGGER trg_appointments_syncUpdateDate
ON [dbo].[Appointments]
AFTER UPDATE
AS 
BEGIN
	SET NOCOUNT ON;
	UPDATE Appointments 
	SET UpdatedAt = GETDATE()
	WHERE AppointmentId IN (SELECT AppointmentId FROM INSERTED); 
	
END
GO

CREATE TRIGGER trg_doctors_syncUpdateDate
ON [dbo].[Doctors]
AFTER UPDATE
AS 
BEGIN
	SET NOCOUNT ON;
	UPDATE Doctors 
	SET UpdatedAt = GETDATE()
	WHERE DoctorId IN (SELECT DoctorId FROM INSERTED); 
	
END
GO

CREATE TRIGGER trg_patients_syncUpdateDate
ON [dbo].[Patients]
AFTER UPDATE
AS 
BEGIN
	SET NOCOUNT ON;
	UPDATE Patients 
	SET UpdatedAt = GETDATE()
	WHERE PatientId IN (SELECT PatientId FROM INSERTED); 
	
END
GO

