
CREATE TABLE geography_dim (
	GEOID INT IDENTITY PRIMARY KEY
	, Region NVARCHAR(50)
	,Postcode NVARCHAR(5)
)

-- INSERT INTO geography_dim (Postcode) 
--(SELECT DISTINCT HOMEADD FROM HES_APC) 
-- UPDATE geography_dim SET region = geoSRC.Region
-- FROM geoSRC RIGHT JOIN HES_APC 
-- ON geoSRC.Postcode = HES_APC.HOMEADD


BEGIN TRAN
UPDATE patient_dim SET 
	GEOID = geoDIM.GEOID
FROM patient_dim AS patDIM
JOIN HES_APC AS src
	ON src.HESID = patDIM.HESID
	AND src.SEX = patDIM.SEX
	AND src.ETHNOS = patDIM.ETHNOS
	AND src.DOB = patDIM.DOB
	AND src.NEWNHSNO = patDIM.NEWNHSNO
	AND src.NEWNHSNO_CHECK = patDIM.NEWNHSNO_CHECK
	AND src.LEGLCAT = patDIM.LEGLCAT
JOIN geography_dim AS geoDIM
	ON geoDIM.Postcode = src.HOMEADD
; 
COMMIT TRAN

ALTER TABLE geography_dim
	ADD FOREIGN KEY (Region) REFERENCES demographic_dim(REGION)