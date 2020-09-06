
BEGIN TRAN 
CREATE TABLE patient_dim (
	HESID NVARCHAR(15) PRIMARY KEY NOT NULL -- there are nulls in staging & duplicates
	,SEX CHAR(1) NOT NULL
	,ETHNOS NVARCHAR(3) NULL
	,DOB DATE NOT NULL
	,NEWNHSNO NVARCHAR(15) NULL
	,NEWNHSNO_CHECK CHAR(1) NULL
	--,HOMEADD NVARCHAR(8) NULL
	,LEGLCAT NVARCHAR(2) NULL
);
GO

INSERT INTO patient_dim ( 
	HESID 
	,SEX 
	,ETHNOS 
	,DOB 
	,NEWNHSNO
	,NEWNHSNO_CHECK
	--,HOMEADD 
	,LEGLCAT
) ( 
	SELECT 
		HESID 
		,SEX 
		,ETHNOS 
		,DOB 
		,NEWNHSNO
		,NEWNHSNO_CHECK
		--,HOMEADD 
		,LEGLCAT
	FROM (
		SELECT DISTINCT
			HESID 
			,SEX 
			,ETHNOS 
			,DOB 
			,NEWNHSNO
			,NEWNHSNO_CHECK
			--,HOMEADD 
			,LEGLCAT
			,COUNT(HESID) OVER (PARTITION BY HESID ORDER BY (SELECT 1)) AS cnt
		FROM HES_APC
		WHERE HESID IS NOT NULL
	) AS SubQ
	WHERE cnt <= 1 
);
GO
COMMIT TRAN
/* METHOD 2
SELECT 
	HESID 
	,SEX 
	,ETHNOS 
	,DOB 
	,NEWNHSNO
	,NEWNHSNO_CHECK
	--,HOMEADD 
	,LEGLCAT
INTO patient_dim
FROM (
	SELECT DISTINCT
		HESID 
		,SEX 
		,ETHNOS 
		,DOB 
		,NEWNHSNO
		,NEWNHSNO_CHECK
		--,HOMEADD 
		,LEGLCAT
		,COUNT(HESID) OVER (PARTITION BY HESID ORDER BY (SELECT 1)) AS cnt
	FROM HES_APC
	WHERE HESID IS NOT NULL
) AS SubQ
WHERE cnt <= 1 ;

-- HESID COL AS PK AND NO NULL
ALTER TABLE patient_dim
	ALTER COLUMN HESID NVARCHAR(15) NOT NULL
GO 
ALTER TABLE patient_dim
	ADD CONSTRAINT pk_patient_dim PRIMARY KEY (HESID)
GO
--ROLLBACK TRAN
COMMIT TRAN
GO
*/

-- duplicated HESIDs
SELECT * FROM ( 
	SELECT DISTINCT
		CAST(HESID AS float) AS HESID
		,SEX 
		,ETHNOS 
		,DOB 
		,NEWNHSNO
		,NEWNHSNO_CHECK
		--,HOMEADD 
		,LEGLCAT
		,COUNT(HESID) OVER (PARTITION BY HESID ORDER BY (SELECT 1)) AS cnt 
	FROM HES_APC
	WHERE HESID IS NOT NULL
) AS subQ
WHERE  cnt > 1

-- Null HESID entries 
SELECT  
	HESID
	,SEX 
	,ETHNOS 
	,DOB 
	,NEWNHSNO
	,NEWNHSNO_CHECK
	--,HOMEADD 
	,LEGLCAT
FROM HES_APC WHERE HESID IS NULL

-- Number of ignored entries 
SELECT 
	9 AS Nulls
	,6 AS Dupes
	,COUNT(*) AS tot_ppl 
FROM HES_APC
