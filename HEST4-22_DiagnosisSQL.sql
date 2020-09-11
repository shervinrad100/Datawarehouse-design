use HESTeam4

CREATE TABLE diagnosis_dim
(
DIAGNOSISID INT IDENTITY PRIMARY KEY,
DIAG_01 NVARCHAR(10),
Description TEXT
);
GO

insert into diagnosis_dim (
  DIAG_01
  ,Description
) (
select distinct
diagnosis_dim.DIAG_01
,ICD10Codes.Description
from diagnosis_dim
inner join ICD10Codes
on diagnosis_dim.DIAG_01=ICD10Codes.Code

--update diagnosis_dim
--set diagnosis_dim.Description=ICD10Codes.Description
--from ICD10Codes,diagnosis_dim
--where ICD10Codes.Code=diagnosis_dim.DIAG_01

select * from diagnosis_dim
