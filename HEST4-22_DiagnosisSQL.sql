use HESTeam4

select diagnosis_dim.DIAGNOSISID,diagnosis_dim.DIAG_01,ICD10Codes.Description
from diagnosis_dim
inner join
ICD10Codes
on diagnosis_dim.DIAG_01=ICD10Codes.Code
order by DIAGNOSISID

--update diagnosis_dim
--set diagnosis_dim.Description=ICD10Codes.Description
--from ICD10Codes,diagnosis_dim
--where ICD10Codes.Code=diagnosis_dim.DIAG_01

select * from diagnosis_dim
