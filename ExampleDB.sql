--*************************************************************************--
-- Title: Module08-Milestone02
-- Author: JasonBerney
-- Desc: This file is used to create a database for the Final
-- Change Log: When,Who,What
-- 2017-11-27,JasonBerney,Created File
--**************************************************************************--
-- Step 1: Create the Lab database
Use Master;
go

If Exists(Select Name from SysDatabases Where Name = 'ExampleDB')
 Begin 
  Alter Database [ExampleDB] set Single_user With Rollback Immediate;
  Drop Database ExampleDB;
 End
go

Create Database ExampleDB;
go
Use ExampleDB;
go

-- 1) Create the tables --------------------------------------------------------
CREATE -- DROP
TABLE dbo.Clinics ( 
	ClinicID int IDENTITY (1,1) NOT NULL,
	ClinicName nvarchar (100) NOT NULL,
	ClinicPhoneNumber nvarchar (100) NOT NULL,
	ClinicAddress nvarchar (100) NOT NULL,
	ClinicCity nvarchar (100) NOT NULL,
	ClinicState nvarchar (2) NOT NULL,
	ClinicZipCode nvarchar (10) NOT NULL
);
Go
CREATE -- DROP
TABLE dbo.Patients ( 
	PatientID int IDENTITY (1,1) NOT NULL,
	PatientFirstName nvarchar(100) NOT NULL,
	PatientLastName nvarchar(100) NOT NULL,
	PatientPhoneNumber nvarchar(100) NULL,
	PatientAddress nvarchar(100) NULL,
	PatientCity nvarchar(100) NULL,
	PatientState nvarchar(2) NULL,
	PatientZipCode nvarchar(10) NULL
);
Go
CREATE -- DROP
TABLE dbo.Doctors ( 
	DoctorID int IDENTITY (1,1) NOT NULL,
	DoctorFirstName nvarchar(100) NOT NULL,
	DoctorLastName nvarchar(100) NOT NULL,
	DoctorPhoneNumber nvarchar(100) NULL,
	DoctorAddress nvarchar(100) NULL,
	DoctorCity nvarchar(100) NULL,
	DoctorState nvarchar(2) NULL,
	DoctorZipCode nvarchar(10) NULL
);
Go
CREATE -- DROP
TABLE dbo.Appointments ( 
	AppointmentID int IDENTITY (1,1) NOT NULL,
	AppointmentDateTime datetime NOT NULL,
	AppointmentPatientID int NOT NULL,
	AppointmentDoctorID int NULL,
	AppointmentClinicID int NULL
);
Go
-- 2) Create the constraints ---------------------------------------------------
Alter TABLE dbo.Clinics 
	ADD CONSTRAINT pkClinic 
	PRIMARY KEY (ClinicID);
Go

ALTER TABLE dbo.Clinics
	ADD -- DROP
	CONSTRAINT U_ClinicName UNIQUE (ClinicName);
Go

ALTER TABLE dbo.Clinics
	ADD -- DROP
	CONSTRAINT CK_Clinics_ClinicPhoneNumber CHECK (ClinicPhoneNumber like '[0-9][0-9][0-9]-[0-9][0-9][0-9]-[0-9][0-9][0-9][0-9]');
Go

ALTER TABLE dbo.Clinics
	ADD -- DROP
	CONSTRAINT CK_Clinics_ClinicZipCode CHECK (ClinicZipCode LIKE '[0-9][0-9][0-9][0-9][0-9]' OR ClinicZipCode LIKE '[0-9][0-9][0-9][0-9][0-9]-[0-9][0-9][0-9][0-9]');
Go

Alter TABLE dbo.Patients 
	ADD CONSTRAINT pkPatient 
	PRIMARY KEY (PatientID);
Go

ALTER TABLE dbo.Patients
	ADD -- DROP
	CONSTRAINT CK_Patients_PatientPhoneNumber CHECK (PatientPhoneNumber like '[0-9][0-9][0-9]-[0-9][0-9][0-9]-[0-9][0-9][0-9][0-9]');
Go

ALTER TABLE dbo.Patients
	ADD -- DROP
	CONSTRAINT CK_Patients_PatientZipCode CHECK (PatientZipCode LIKE '[0-9][0-9][0-9][0-9][0-9]' OR PatientZipCode LIKE '[0-9][0-9][0-9][0-9][0-9]-[0-9][0-9][0-9][0-9]');
Go

Alter TABLE dbo.Doctors 
	ADD CONSTRAINT pkDoctor
	PRIMARY KEY (DoctorID);
Go

ALTER TABLE dbo.Doctors
	ADD -- DROP
	CONSTRAINT CK_Doctors_DoctorPhoneNumber CHECK (DoctorPhoneNumber like '[0-9][0-9][0-9]-[0-9][0-9][0-9]-[0-9][0-9][0-9][0-9]');
Go

ALTER TABLE dbo.Doctors
	ADD -- DROP
	CONSTRAINT CK_Doctors_DoctorZipCode CHECK (DoctorZipCode LIKE '[0-9][0-9][0-9][0-9][0-9]' OR DoctorZipCode LIKE '[0-9][0-9][0-9][0-9][0-9]-[0-9][0-9][0-9][0-9]');
Go

Alter TABLE dbo.Appointments 
	ADD CONSTRAINT pkAppointment
	PRIMARY KEY (AppointmentID);
Go

ALTER TABLE dbo.Appointments
	ADD -- DROP
    CONSTRAINT FK_Appointments_Patients FOREIGN KEY (AppointmentPatientID) REFERENCES Patients (PatientID)
Go

ALTER TABLE dbo.Appointments  
	ADD -- DROP
    CONSTRAINT FK_Appointments_Doctors FOREIGN KEY (AppointmentDoctorID) REFERENCES Doctors (DoctorID)
Go

ALTER TABLE dbo.Appointments  
	ADD -- DROP
    CONSTRAINT FK_Appointments_Clinics FOREIGN KEY (AppointmentClinicID) REFERENCES Clinics (ClinicID)
Go

-- 3) Create the views ---------------------------------------------------------
CREATE VIEW vClinics
AS
SELECT 
	ClinicID,
	ClinicName,
	ClinicPhoneNumber,
	ClinicAddress,
	ClinicCity,
	ClinicState,
	ClinicZipCode
FROM ExampleDB.dbo.Clinics;
GO

CREATE VIEW vPatients
AS
SELECT 
	PatientID,
	PatientFirstName,
	PatientLastName,
	PatientPhoneNumber,
	PatientAddress,
	PatientCity,
	PatientState,
	PatientZipCode
FROM ExampleDB.dbo.Patients;
GO

CREATE VIEW vDoctors
AS
SELECT 
	DoctorID,
	DoctorFirstName,
	DoctorLastName,
	DoctorPhoneNumber,
	DoctorAddress,
	DoctorCity,
	DoctorState,
	DoctorZipCode
FROM ExampleDB.dbo.Doctors;
GO

CREATE VIEW vAppointments
AS
SELECT 
	AppointmentID,
	AppointmentDateTime,
	AppointmentPatientID,
	AppointmentDoctorID,
	AppointmentClinicID
FROM ExampleDB.dbo.Appointments;
GO

CREATE VIEW vClinicsPatientsDoctorsAppointments
 AS
  SELECT 
	C.ClinicID
	,C.ClinicName
	,C.ClinicPhoneNumber
	,C.ClinicAddress
	,C.ClinicCity
	,C.ClinicState
	,C.ClinicZipCode
	,P.PatientID
	,P.PatientFirstName
	,P.PatientLastName
	,P.PatientPhoneNumber
	,P.PatientAddress
	,P.PatientCity
	,P.PatientState
	,P.PatientZipCode
	,D.DoctorID
	,D.DoctorFirstName
	,D.DoctorLastName
	,D.DoctorPhoneNumber
	,D.DoctorAddress
	,D.DoctorCity
	,D.DoctorState
	,D.DoctorZipCode
  	,A.AppointmentID
	,A.AppointmentDateTime
	,A.AppointmentPatientID
	,A.AppointmentDoctorID
	,A.AppointmentClinicID
  FROM dbo.vAppointments AS A
  Join dbo.vClinics AS C
   ON A.AppointmentClinicID = C.ClinicID
  Join dbo.vPatients AS P
   ON A.AppointmentPatientID = P.PatientID
  Join dbo.vDoctors AS D
   ON A.AppointmentDoctorID = D.DoctorID
GO

-- 4) Create the stored procedures ---------------------------------------------
Create Procedure pInsClinics
(	
	@ClinicName nvarchar(100),
	@ClinicPhoneNumber nvarchar(100),
	@ClinicAddress nvarchar (100),
	@ClinicCity nvarchar (100),
	@ClinicState nvarchar (2),
	@ClinicZipCode nvarchar (10)
)
/* Author: <JasonBerney>
** Desc: Inserts records into Clinics table
** Change Log: When,Who,What
** <2017-11-06>,<Jason Berney>,Created Sproc.
*/
AS
 Begin
  Declare @RC int = 0;
  Begin Try
   Begin Transaction 
    Insert Into dbo.Clinics
		(ClinicName, ClinicPhoneNumber, ClinicAddress, ClinicCity, ClinicState, ClinicZipCode)
	Values 
		(@ClinicName, @ClinicPhoneNumber, @ClinicAddress, @ClinicCity, @ClinicState, @ClinicZipCode)
   Commit Transaction
   Set @RC = +1
  End Try
  Begin Catch
   Rollback Transaction
   Print Error_Message()
   Set @RC = -1
  End Catch
  Return @RC;
 End
go

 Create Procedure pUpdClinics
(	
	@ClinicID int,
	@ClinicName nvarchar(100),
	@ClinicPhoneNumber nvarchar(100),
	@ClinicAddress nvarchar (100),
	@ClinicCity nvarchar (100),
	@ClinicState nvarchar (2),
	@ClinicZipCode nvarchar (10)
)
/* Author: <JasonBerney>
** Desc: Updates records into Clinics table
** Change Log: When,Who,What
** <2017-11-06>,<Jason Berney>,Created Sproc.
*/
AS
 Begin
  Declare @RC int = 0;
  Begin Try
   Begin Transaction 
    Update dbo.Clinics
		set	ClinicName = @ClinicName,
			ClinicPhoneNumber = @ClinicPhoneNumber,
			ClinicAddress = @ClinicAddress,
			ClinicCity = @ClinicCity,
			ClinicState = @ClinicState,
			ClinicZipCode = @ClinicZipCode
	Where 
			ClinicID = @ClinicID
   Commit Transaction
   Set @RC = +1
  End Try
  Begin Catch
   Rollback Transaction
   Print Error_Message()
   Set @RC = -1
  End Catch
  Return @RC;
 End
go

Create Procedure pDelClinics
(
	@ClinicID int
)
/* Author: <JasonBerney>
** Desc: Deletes records into Clinic table
** Change Log: When,Who,What
** <2017-11-06>,<Jason Berney>,Created Sproc.
*/
AS
 Begin
  Declare @RC int = 0;
  Begin Try
   Begin Transaction 
    Delete from Clinics
	Where ClinicID = @ClinicID
   Commit Transaction
   Set @RC = +1
  End Try
  Begin Catch
   Rollback Transaction
   Print Error_Message()
   Set @RC = -1
  End Catch
  Return @RC;
 End
go

Create Procedure pInsPatients
(	
	@PatientFirstName nvarchar(100),
	@PatientLastName nvarchar(100),
	@PatientPhoneNumber nvarchar(100),
	@PatientAddress nvarchar (100),
	@PatientCity nvarchar (100),
	@PatientState nvarchar (2),
	@PatientZipCode nvarchar (10)
)
/* Author: <JasonBerney>
** Desc: Inserts records into Patients table
** Change Log: When,Who,What
** <2017-11-06>,<Jason Berney>,Created Sproc.
*/
AS
 Begin
  Declare @RC int = 0;
  Begin Try
   Begin Transaction 
    Insert Into dbo.Patients
		(PatientFirstName, PatientLastName, PatientPhoneNumber, PatientAddress, PatientCity, PatientState, PatientZipCode)
	Values 
		(@PatientFirstName, @PatientLastName, @PatientPhoneNumber, @PatientAddress, @PatientCity, @PatientState, @PatientZipCode)
   Commit Transaction
   Set @RC = +1
  End Try
  Begin Catch
   Rollback Transaction
   Print Error_Message()
   Set @RC = -1
  End Catch
  Return @RC;
 End
go

 Create Procedure pUpdPatients
(	
	@PatientID int,
	@PatientFirstName nvarchar(100),
	@PatientLastName nvarchar(100),
	@PatientPhoneNumber nvarchar(100),
	@PatientAddress nvarchar (100),
	@PatientCity nvarchar (100),
	@PatientState nvarchar (2),
	@PatientZipCode nvarchar (10)
)
/* Author: <JasonBerney>
** Desc: Updates records into Patients table
** Change Log: When,Who,What
** <2017-11-06>,<Jason Berney>,Created Sproc.
*/
AS
 Begin
  Declare @RC int = 0;
  Begin Try
   Begin Transaction 
    Update dbo.Patients
		set	PatientFirstName = @PatientFirstName,
			PatientLastName = @PatientLastName,
			PatientPhoneNumber = @PatientPhoneNumber,
			PatientAddress = @PatientAddress,
			PatientCity = @PatientCity,
			PatientState = @PatientState,
			PatientZipCode = @PatientZipCode
	Where 
			PatientID = @PatientID
   Commit Transaction
   Set @RC = +1
  End Try
  Begin Catch
   Rollback Transaction
   Print Error_Message()
   Set @RC = -1
  End Catch
  Return @RC;
 End
go

Create Procedure pDelPatients
(
	@PatientID int
)
/* Author: <JasonBerney>
** Desc: Deletes records into Patients table
** Change Log: When,Who,What
** <2017-11-06>,<Jason Berney>,Created Sproc.
*/
AS
 Begin
  Declare @RC int = 0;
  Begin Try
   Begin Transaction 
    Delete from Patients
	Where PatientID = @PatientID
   Commit Transaction
   Set @RC = +1
  End Try
  Begin Catch
   Rollback Transaction
   Print Error_Message()
   Set @RC = -1
  End Catch
  Return @RC;
 End
go

Create Procedure pInsDoctors
(	
	@DoctorFirstName nvarchar(100),
	@DoctorLastName nvarchar(100),
	@DoctorPhoneNumber nvarchar(100),
	@DoctorAddress nvarchar (100),
	@DoctorCity nvarchar (100),
	@DoctorState nvarchar (2),
	@DoctorZipCode nvarchar (10)
)
/* Author: <JasonBerney>
** Desc: Inserts records into Patients table
** Change Log: When,Who,What
** <2017-11-06>,<Jason Berney>,Created Sproc.
*/
AS
 Begin
  Declare @RC int = 0;
  Begin Try
   Begin Transaction 
    Insert Into dbo.Doctors
		(DoctorFirstName, DoctorLastName, DoctorPhoneNumber, DoctorAddress, DoctorCity, DoctorState, DoctorZipCode)
	Values 
		(@DoctorFirstName, @DoctorLastName, @DoctorPhoneNumber, @DoctorAddress, @DoctorCity, @DoctorState, @DoctorZipCode)
   Commit Transaction
   Set @RC = +1
  End Try
  Begin Catch
   Rollback Transaction
   Print Error_Message()
   Set @RC = -1
  End Catch
  Return @RC;
 End
go

 Create Procedure pUpdDoctors
(	
	@DoctorID int,
	@DoctorFirstName nvarchar(100),
	@DoctorLastName nvarchar(100),
	@DoctorPhoneNumber nvarchar(100),
	@DoctorAddress nvarchar (100),
	@DoctorCity nvarchar (100),
	@DoctorState nvarchar (2),
	@DoctorZipCode nvarchar (10)
)
/* Author: <JasonBerney>
** Desc: Updates records into Doctors table
** Change Log: When,Who,What
** <2017-11-06>,<Jason Berney>,Created Sproc.
*/
AS
 Begin
  Declare @RC int = 0;
  Begin Try
   Begin Transaction 
    Update dbo.Doctors
		set	DoctorFirstName = @DoctorFirstName,
			DoctorLastName = @DoctorLastName,
			DoctorPhoneNumber = @DoctorPhoneNumber,
			DoctorAddress = @DoctorAddress,
			DoctorCity = @DoctorCity,
			DoctorState = @DoctorState,
			DoctorZipCode = @DoctorZipCode
	Where 
			DoctorID = @DoctorID
   Commit Transaction
   Set @RC = +1
  End Try
  Begin Catch
   Rollback Transaction
   Print Error_Message()
   Set @RC = -1
  End Catch
  Return @RC;
 End
go

Create Procedure pDelDoctors
(
	@DoctorID int
)
/* Author: <JasonBerney>
** Desc: Deletes records into Doctors table
** Change Log: When,Who,What
** <2017-11-06>,<Jason Berney>,Created Sproc.
*/
AS
 Begin
  Declare @RC int = 0;
  Begin Try
   Begin Transaction 
    Delete from Doctors
	Where DoctorID = @DoctorID
   Commit Transaction
   Set @RC = +1
  End Try
  Begin Catch
   Rollback Transaction
   Print Error_Message()
   Set @RC = -1
  End Catch
  Return @RC;
 End
go

Create Procedure pInsAppointments
(	
	@AppointmentDateTime datetime,
	@AppointmentPatientID int,
	@AppointmentDoctorID int,
	@AppointmentClinicID int
)
/* Author: <JasonBerney>
** Desc: Inserts records into Appointments table
** Change Log: When,Who,What
** <2017-11-06>,<Jason Berney>,Created Sproc.
*/
AS
 Begin
  Declare @RC int = 0;
  Begin Try
   Begin Transaction 
    Insert Into dbo.Appointments
		(AppointmentDateTime, AppointmentPatientID, AppointmentDoctorID, AppointmentClinicID)
	Values 
		(@AppointmentDateTime, @AppointmentPatientID, @AppointmentDoctorID, @AppointmentClinicID)
   Commit Transaction
   Set @RC = +1
  End Try
  Begin Catch
   Rollback Transaction
   Print Error_Message()
   Set @RC = -1
  End Catch
  Return @RC;
 End
go

 Create Procedure pUpdAppointments
(	
	@AppointmentID int,
	@AppointmentDateTime datetime,
	@AppointmentPatientID int,
	@AppointmentDoctorID int,
	@AppointmentClinicID int
)
/* Author: <JasonBerney>
** Desc: Updates records into Appointments table
** Change Log: When,Who,What
** <2017-11-06>,<Jason Berney>,Created Sproc.
*/
AS
 Begin
  Declare @RC int = 0;
  Begin Try
   Begin Transaction 
    Update dbo.Appointments
		set	AppointmentDateTime = @AppointmentDateTime,
			AppointmentPatientID = @AppointmentPatientID,
			AppointmentDoctorID = @AppointmentDoctorID,
			AppointmentClinicID = @AppointmentClinicID
	Where 
			AppointmentID = @AppointmentID
   Commit Transaction
   Set @RC = +1
  End Try
  Begin Catch
   Rollback Transaction
   Print Error_Message()
   Set @RC = -1
  End Catch
  Return @RC;
 End
go

Create Procedure pDelAppointments
(
	@AppointmentID int
)
/* Author: <JasonBerney>
** Desc: Deletes records into Appointments table
** Change Log: When,Who,What
** <2017-11-06>,<Jason Berney>,Created Sproc.
*/
AS
 Begin
  Declare @RC int = 0;
  Begin Try
   Begin Transaction 
    Delete from Appointments
	Where AppointmentID = @AppointmentID
   Commit Transaction
   Set @RC = +1
  End Try
  Begin Catch
   Rollback Transaction
   Print Error_Message()
   Set @RC = -1
  End Catch
  Return @RC;
 End
go
-- 5) Set the permissions ------------------------------------------------------
Grant Select, Insert, Update, Delete On Clinics To Public
--Revoke Select On Clinics To Public
--Deny Select On Clinics To Public

Grant Exec On pInsClinics To Public
Grant Exec On pUpdClinics To Public
Grant Exec On pDelClinics To Public

Grant Select, Insert, Update, Delete On Patients To Public
--Revoke Select On Patients To Public
--Deny Select On Patients To Public

Grant Exec On pInsPatients To Public
Grant Exec On pUpdPatients To Public
Grant Exec On pDelPatients To Public

Grant Select, Insert, Update, Delete On Doctors To Public
--Revoke Select On Doctors To Public
--Deny Select On Doctors To Public

Grant Exec On pInsDoctors To Public
Grant Exec On pUpdDoctors To Public
Grant Exec On pDelDoctors To Public

Grant Select, Insert, Update, Delete On Appointments To Public
--Revoke Select On Appointments To Public
--Deny Select On Appointments To Public

Grant Exec On pInsAppointments To Public
Grant Exec On pUpdAppointments To Public
Grant Exec On pDelAppointments To Public

-- 6) Test the views and stored procedures -------------------------------------
Set NoCount On;
Declare @Status int
       ,@NewClinicID int
       ,@NewPatientID int
       ,@NewDoctorID int
	   ,@NewAppointmentID int;

Begin	
	-- For [dbo].[Clinics]
	Exec @Status = pInsClinics
			 @ClinicName ='Springview'
			,@ClinicPhoneNumber ='205-498-4498'
			,@ClinicAddress ='23 Anniversary Place'
			,@ClinicCity ='Seattle'
			,@ClinicState ='WA'
			,@ClinicZipCode ='98101'
	Select Case @Status
	  When +1 Then 'Insert to Courses was successful!'
	  When -1 Then 'Insert to Courses failed! Common Issues: Duplicate Data'
	  End as [Status];
	Set @NewClinicID = @@IDENTITY;
	--Select * From vClinics Where ClinicID = @NewCourseID;

-- For [dbo].[Patients]
	Exec @Status = pInsPatients
			 @PatientFirstName ='Tori'
			,@PatientLastName ='Legrand'
			,@PatientPhoneNumber ='202-333-4678'
			,@PatientAddress ='565 Memorial Court'
			,@PatientCity ='Seattle'
			,@PatientState ='WA'
			,@PatientZipCode ='98102'
	Select Case @Status
	  When +1 Then 'Insert to Students was successful!'
	  When -1 Then 'Insert failed! Common Issues: Duplicate Data'
	  End as [Status];
	Set @NewPatientID = @@IDENTITY;
	--Select * From vPatients Where PatientID = @NewPatientID;

	-- For [dbo].[Doctors]
 	Exec @Status = pInsDoctors
			 @DoctorFirstName ='Vivyanne'
			,@DoctorLastName ='Hambridge'
			,@DoctorPhoneNumber ='786-613-8288'
			,@DoctorAddress ='5 Rusk Plaza'
			,@DoctorCity ='Seattle'
			,@DoctorState ='WA'
			,@DoctorZipCode ='98103'
	Select Case @Status
	  When +1 Then 'Insert to Enrollments was successful!'
	  When -1 Then 'Insert to Enrollments failed! Common Issues: Duplicate Data'
	  End as [Status];
	Set @NewDoctorID = @@IDENTITY;
	--Select * From vDoctors Where DoctorID = @NewDoctorID;

	-- For [dbo].[Appointments]
 	Exec @Status = pInsAppointments
			 @AppointmentDateTime = '20170110'
			,@AppointmentPatientID = @NewPatientID
			,@AppointmentDoctorID = @NewDoctorID
			,@AppointmentClinicID = @NewClinicID
	Select Case @Status
	  When +1 Then 'Insert to Enrollments was successful!'
	  When -1 Then 'Insert to Enrollments failed! Common Issues: Duplicate Data'
	  End as [Status];
	Set @NewAppointmentID = @@IDENTITY;
	--Select * From vDoctors Where DoctorID = @NewDoctorID;
end
---- Show the Current data in the Clinics, Patients, Appointments, and Doctors Tables before you delete the data!
Select * From vClinicsPatientsDoctorsAppointments;

--< Test Update Sprocs >-- 
Begin
-- For [dbo].[Clinics]
  Exec @Status = pUpdClinics
     @ClinicID = @NewClinicID
	,@ClinicName ='Springview'
	,@ClinicPhoneNumber ='205-498-4498'
	,@ClinicAddress ='23 Anniversary Place'
	,@ClinicCity ='Seattle'
	,@ClinicState ='WA'
	,@ClinicZipCode ='98101'
  Select Case @Status
  	When +1 Then 'Update was successful!'
  	When -1 Then 'Update failed! Common Issues: Duplicate Data or Foriegn Key Violation'
  End as [Status];

-- For [dbo].[Students]
  Exec @Status = pUpdPatients
     @PatientID = @NewPatientID
	,@PatientFirstName ='Tori'
	,@PatientLastName ='Legrand'
	,@PatientPhoneNumber ='202-333-4678'
	,@PatientAddress ='565 Memorial Court'
	,@PatientCity ='Seattle'
	,@PatientState ='WA'
	,@PatientZipCode ='98102'
  Select Case @Status
  	When +1 Then 'Update was successful!'
  	When -1 Then 'Update failed! Common Issues: Duplicate Data or Foriegn Key Violation'
  End as [Status];
  --Select * From vStudents Where StudentID = @NewStudentID;

-- For [dbo].[Enrollments]
 	Exec @Status = pUpdDoctors
         @DoctorID = @NewDoctorID
		,@DoctorFirstName ='Vivyanne'
		,@DoctorLastName ='Hambridge'
		,@DoctorPhoneNumber ='786-613-8288'
		,@DoctorAddress ='5 Rusk Plaza'
		,@DoctorCity ='Seattle'
		,@DoctorState ='WA'
		,@DoctorZipCode ='98103'
	Select Case @Status
	  When +1 Then 'Update to Doctors was successful!'
	  When -1 Then 'Update to Doctors failed! Common Issues: Duplicate Data'
	  End as [Status];

 	Exec @Status = pUpdAppointments
		 @AppointmentID = @NewAppointmentID
		,@AppointmentDateTime = '20170110'
		,@AppointmentPatientID = @NewPatientID
		,@AppointmentDoctorID = @NewDoctorID
		,@AppointmentClinicID = @NewClinicID
	Select Case @Status
	  When +1 Then 'Insert to Appointments was successful!'
	  When -1 Then 'Insert to Appointments failed! Common Issues: Duplicate Data'
	  End as [Status];
	Set @NewAppointmentID = @@IDENTITY;
End

----< Test Delete Sprocs >-- 
Begin
	Exec @Status = pDelAppointments
			 @AppointmentID = @NewAppointmentID
	Select Case @Status
	  When +1 Then 'Delete was successful!'
	  When -1 Then 'Delete failed! Common Issues: Foriegn Key Violation'
	End as [Status];

	Exec @Status = pDelClinics
			 @ClinicID = @NewClinicID
	Select Case @Status
	  When +1 Then 'Delete was successful!'
	  When -1 Then 'Delete failed! Common Issues: Foriegn Key Violation'
	  End as [Status];

	Exec @Status = pDelPatients
			 @PatientID = @NewPatientID
	Select Case @Status
	  When +1 Then 'Delete was successful!'
	  When -1 Then 'Delete failed! Common Issues: Foriegn Key Violation'
	  End as [Status];

	Exec @Status = pDelDoctors
			 @DoctorID = @NewDoctorID
	Select Case @Status
	  When +1 Then 'Delete was successful!'
	  When -1 Then 'Delete failed! Common Issues: Foriegn Key Violation'
	  End as [Status];
End

Select * From vClinicsPatientsDoctorsAppointments;



