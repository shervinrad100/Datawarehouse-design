USE HESTeam4
GO

CREATE TABLE admission_dim
(ADMISID int identity primary key
 ,ADMIAGE int
 ,ADMIMETH nvarchar(5)
 ,ADMISORC nvarchar(5)
 ,LOPATID nvarchar(15)
 ,CLASSPAT nvarchar(2)
 ,BEDYEAR int
 ,ADMIDATEID INT
 )


INSERT INTO admission_dim WITH(TABLOCK) (
	ADMIAGE
	,ADMIMETH
	,ADMISORC
	,LOPATID
	,CLASSPAT
	,BEDYEAR
) (
	SELECT DISTINCT 
		ADMIAGE
		,ADMIMETH
		,ADMISORC
		,LOPATID
		,CLASSPAT
		,BEDYEAR
	FROM HES_APC
);


BEGIN TRAN 
UPDATE src WITH(TABLOCK) SET
	 src.ADMISID  = dim.ADMISID
FROM HES_APC AS src
JOIN admission_dim AS dim 
	ON src.ADMIAGE = dim.ADMIAGE
		AND src.ADMIMETH = dim.ADMIMETH
	    AND src.ADMISORC = dim.ADMISORC
	    AND src.LOPATID  = dim.LOPATID
	    AND src.CLASSPAT = dim.CLASSPAT
	    AND src.BEDYEAR  = dim.BEDYEAR
COMMIT TRAN



UPDATE admDIM SET
	ADMIDATEID = dateDIM.DATEID	
FROM admission_dim AS admDIM
JOIN HES_APC AS src 
	ON admDIM.ADMISID = src.ADMISID
JOIN patient_dim AS patDIM
ON src.HESID = patDIM.HESID
	AND src.SEX = patDIM.SEX
	AND src.ETHNOS = patDIM.ETHNOS
	AND src.DOB = patDIM.DOB
	AND src.NEWNHSNO = patDIM.NEWNHSNO
	AND src.NEWNHSNO_CHECK = patDIM.NEWNHSNO_CHECK
	AND src.LEGLCAT = patDIM.LEGLCAT
JOIN date_dim AS dateDIM
	ON src.ADMIDATE = dateDIM.[DATE]


ALTER TABLE admission_dim 
	ADD FOREIGN KEY (ADMIDATEID) REFERENCES date_dim(DATEID)