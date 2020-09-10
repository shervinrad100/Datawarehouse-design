CREATE Table elective_dim
(
ELECTIVEID INT IDENTITY PRIMARY KEY,
ELECDATE DATE,
ELECDUR INT,
ELECDUR_CALC INT
)

INSERT INTO elective_dim WITH(TABLOCK) (
	ELECDUR
	,ELECDUR_CALC
) (
	SELECT DISTINCT 
		ELECDUR
		,ELECDUR_CALC
	FROM HES_APC
);

--ALTER TABLE HES_APC ADD ELECTIVEID INT

UPDATE src WITH(TABLOCK) SET
	src.ELECTIVEID = dim.ELECTIVEID
FROM HES_APC AS src
JOIN elective_dim AS dim 
	ON src.ELECDUR = dim.ELECDUR
	AND src.ELECDUR_CALC = dim.ELECDUR_CALC