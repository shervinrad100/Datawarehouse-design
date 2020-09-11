
BEGIN TRAN 
CREATE TABLE patient_dim (
	HESID NVARCHAR(15) PRIMARY KEY NOT NULL -- there are nulls in staging & duplicates
	,SEX NVARCHAR(1) NOT NULL
	,ETHNOS NVARCHAR(3) NULL
	,DOB DATE NOT NULL
	,NEWNHSNO NVARCHAR(15) NULL
	,NEWNHSNO_CHECK NVARCHAR(1) NULL
	,LEGLCAT NVARCHAR(2) NULL
	,GEOID INT REFERENCES geography_dim(GEOID)
);
GO

INSERT INTO patient_dim WITH(TABLOCK) ( 
	HESID 
	,SEX 
	,ETHNOS 
	,DOB 
	,NEWNHSNO
	,NEWNHSNO_CHECK
	,LEGLCAT
	,GEOID
) ( 
	SELECT 
		HESID 
		,SEX 
		,ETHNOS 
		,DOB 
		,NEWNHSNO
		,NEWNHSNO_CHECK
		,LEGLCAT
		,GEOID
	FROM (
		SELECT DISTINCT
			HESID 
			,SEX 
			,ETHNOS 
			,DOB 
			,NEWNHSNO
			,NEWNHSNO_CHECK
			,LEGLCAT
			,GEOID
			,COUNT(HESID) OVER (PARTITION BY HESID ORDER BY (SELECT 1)) AS cnt
		FROM HES_APC AS src
		WHERE HESID IS NOT NULL
	) AS SubQ
	WHERE cnt = 1 
);
GO
COMMIT TRAN

--ALTER TABLE patient_dim
--	ADD FOREIGN KEY (GEOID) REFERENCES geography_dim(GEOID)






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

-- duplicated HESIDs -- 6

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

-- Null HESID entries --9
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

--SELECT * FROM patient_dim --65,061 rows
