
INSERT INTO admission_dim(
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
UPDATE src SET
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