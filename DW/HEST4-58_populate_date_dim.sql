
-- episode_dim_epiend
BEGIN TRAN episode_dim_epiend
DECLARE @s DATE, @e DATE
SET @s = (SELECT MIN(EPIEND) FROM HES_APC)
SET @e = (SELECT MAX(EPIEND) FROM HES_APC)

EXEC sp_populate_date_dim 
	@strt = @s
	,@end = @e ;
GO
COMMIT TRAN episode_dim_epiend

-- episode_dim_epistart
BEGIN TRAN episode_dim_epistart

DECLARE @s DATE, @e DATE
SET @s = (SELECT MIN(EPISTART) FROM HES_APC)
SET @e = (SELECT MAX(EPISTART) FROM HES_APC)

EXEC sp_populate_date_dim 
	@strt = @s
	,@end = @e ;
GO

COMMIT TRAN episode_dim_epistart

-- addmission_dim_ADMIDATE
BEGIN TRAN addmission_dim_ADMIDATE

DECLARE @s DATE, @e DATE
SET @s = (SELECT MIN(ADMIDATE) FROM HES_APC)
SET @e = (SELECT MAX(ADMIDATE) FROM HES_APC)

EXEC sp_populate_date_dim 
	@strt = @s
	,@end = @e ;
GO
COMMIT TRAN addmission_dim_ADMIDATE




-- elective_dim_ELECDATE do not include 1800-01-01. Sensible start at 2004-12-24
BEGIN TRAN elective_dim_ELECDATE
DECLARE @s DATE, @e DATE
SET @s = '2004-12-24'
SET @e = (SELECT MAX(ELECDATE) FROM HES_APC)

EXEC sp_populate_date_dim 
	@strt = @s
	,@end = @e ;
GO
COMMIT TRAN elective_dim_ELECDATE


SELECT * FROM date_dim