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
 ,ADMIDATE date)

