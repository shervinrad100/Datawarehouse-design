
-- GP DIM
INSERT INTO gp_dim (
	GPPRAC
	,PROVID
) (
	SELECT DISTINCT
		src.GPPRAC
		,src.PROVID
	FROM HES_APC AS src
);

ALTER TABLE HES_APC ADD GPID INT

UPDATE src SET
	src.GPID = dim.GPID
FROM HES_APC AS src
JOIN gp_dim AS dim
	ON src.GPPRAC = dim.GPPRAC
	AND src.PROVID = dim.PROVID
