
-- in ssis you need to identify that you dont want to reload old rows
-- create a fail/ignore OR
-- change connection to only import from cdc 
--TRUNCATE TABLE TEST_srcTAB

--SELECT * FROM TEST_srcTAB



-- ENABLING CDC
USE HESTeam4
GO
EXEC sys.sp_cdc_enable_db; --admin priv needed
GO
--Msg 22902, Level 16, State 1, Procedure sys.sp_cdc_enable_db, Line 20 [Batch Start Line 13]
--Caller is not authorized to initiate the requested action. Sysadmin privileges are required.

EXEC sys.sp_cdc_enable_table 
	@source_schema = 'dbo'
	,@source_name = 'TEST_srcTAB'
	,@role_name = NULL
	,@supports_net_changes = 1 ; -- keep track of all individual changes that occur
GO

--PULL DATA OUT OF CDC window
DECLARE @from_date DATETIME, @to_date DATETIME
SELECT @from_date = MAX(LastExtractTime), @to_date = getdate()
FROM stg.ExtractLog 
WHERE SourceName = 'TEST_srcTAB';

DECLARE @from_lsn BINARY(10), @to_lsn BINARY(10) ;
SET @from_lsn = sys.fn_cdc_map_time_to_lsn('smallest greater than', @from_date);
SET @to_lsn = sys.fn_cdc_map_time_to_lsn('largest less than or equal', @to_date);

IF (@from_lsn IS NULL) OR (@to_lsn IS NULL)
	PRINT 'No logs in the time interval'
ELSE
BEGIN
	SELECT
		*
	FROM cdc.fn_cdc_get_net_changes_src_TEST_srcTAB(@from_lsn, @to_lsn, 'all')
END;



-- CHANGE TRACKING instead of CDC
ALTER DATABASE HESTeam4 SET
	Change_Tracking = ON
		(CHANGE_RETENTION = 7 DAYS, AUTO_CLEANUP = ON)
		;
GO

ALTER DATABASE TEST_srcTAB SET 
	ALLOW_SNAPSHOT_ISOLATION ON ;
GO -- need admin priv
-- so that you dont block other users when retriving data

ALTER TABLE TEST_srcTAB 
	ADD IDENTIFIER UNIQUEIDENTIFIER 
		DEFAULT NEWSEQUENTIALID() NOT NULL PRIMARY KEY NONCLUSTERED
	;
GO

ALTER TABLE TEST_srcTAB 
	ENABLE Change_Tracking
		WITH (TRACK_COLUMNS_UPDATED =ON);
GO -- must have a PK so...

-- Extracking using CT
-- you pull anything higher than the last version number
-- type 1/2/3 slowly changing dim

DECLARE @current_version INT
SET @current_version = CHANGE_TRACKING_CURRENT_VERSION() ; 

-- update your log if you have a log table
--UPDATE ExtractLog
--SET LogExtractedVersion = @current_version
--WHERE SourceName = 'TEST_srcTAB' ;
--GO

-- UPDATE/INSERT

-- IF snapshot isolation is enabled
SET TRANSACTION ISOLATION LEVEL SNAPSHOT

DECLARE @previous_version INT
SELECT @previous_version = CHANGE_TRACKING_CURRENT_VERSION() ;

SELECT 
	@previous_version AS 'Previously retrieved Version'
	,@current_version AS 'Current Version'
	,src.*
FROM CHANGETABLE(CHANGES TEST_srcTAB, @previous_version) AS CT
INNER JOIN TEST_srcTAB AS src
	ON src.IDENTIFIER = CT.IDENTIFIER

--UPDATE ExtractLog SET
--	LastExtractedVersion = @current_version
--WHERE SourceName = 'TEST_srcTAB'

SET TRANSACTION ISOLATION LEVEL READ COMMITTED 
GO