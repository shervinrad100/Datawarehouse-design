INSERT INTO diagnosis_dim WITH(TABLOCK) (
	DIAG_01
) (
	SELECT DISTINCT
		DIAG_01
	FROM HES_APC
);


--ALTER TABLE HES_APC ADD DIAGNOSISID INT

UPDATE src WITH(TABLOCK) SET
	src.DIAGNOSISID = dim.DIAGNOSISID
FROM diagnosis_dim AS dim
JOIN HES_APC AS src
	ON dim.DIAG_01 = src.DIAG_01
