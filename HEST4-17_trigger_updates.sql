
CREATE OR ALTER PROC sp_ @name NVARCHAR(10) AS
BEGIN
	
END;
GO




SELECT 
	[name]
FROM sys.tables
WHERE [object_id] = object_id('patient_dim')

CREATE OR ALTER TRIGGER trg_new_rows ON TEST_srcTAB AFTER INSERT, UPDATE AS
BEGIN
	PRINT ' ' 
END; 