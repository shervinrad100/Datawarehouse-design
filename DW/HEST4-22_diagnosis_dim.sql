

ALTER TABLE icd10_codes 
	ALTER COLUMN [description] NVARCHAR(MAX)

SELECT DISTINCT 
	src.DIAG_01
	,ICD10.Description
FROM HES_APC AS src --3929
LEFT JOIN icd10_codes AS ICD10
	ON ICD10.Code = src.DIAG_01
