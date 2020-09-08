use HESTeam4

select diagnosis_dim.DIAGNOSISID,diagnosis_dim.DIAG_01,ICD10Codes.Description
from diagnosis_dim
inner join
ICD10Codes
on diagnosis_dim.DIAG_01=ICD10Codes.Code
order by DIAGNOSISID