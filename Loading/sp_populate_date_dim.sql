
CREATE OR ALTER PROC sp_populate_date_dim @strt DATE, @end DATE
AS BEGIN
-- 1
	IF @strt >= @end 
		OR (@strt > (SELECT MIN([date]) FROM date_dim)
			AND  @end < (SELECT MAX([date]) FROM date_dim)
			)
	BEGIN
		PRINT 'ERROR: Start Date > End Date'
	END;
-- 2
	IF @strt < (SELECT MIN([date]) FROM date_dim)
		AND  @end > (SELECT MAX([date]) FROM date_dim)
	BEGIN
		INSERT INTO date_dim (
			[DATE] 
			,SEASON 
			,MONTHOFYR
			,[YEAR] 
		) (
			SELECT * FROM
			func_populate_date_dim(@strt,(SELECT MIN([date]) FROM date_dim))
		)
		OPTION (MAXRECURSION 0)
		INSERT INTO date_dim (
			[DATE] 
			,SEASON 
			,MONTHOFYR
			,[YEAR] 
		) (
			SELECT * FROM
			func_populate_date_dim((SELECT MAX([date]) FROM date_dim),@end)
		)
		OPTION (MAXRECURSION 0)
	END;
-- 3
	IF (@strt < (SELECT MAX([date]) FROM date_dim) 
		OR  @strt > (SELECT MIN([date]) FROM date_dim)
		)
		AND @end > (SELECT MAX([date]) FROM date_dim) 
	BEGIN
		SET @strt = (SELECT MAX([date]) FROM date_dim) 
		INSERT INTO date_dim (
			[DATE] 
			,SEASON 
			,MONTHOFYR
			,[YEAR] 
		) (
			SELECT * FROM
			func_populate_date_dim(@strt,@end)
		)
		OPTION (MAXRECURSION 0)
	END;
END;
GO


-- episode_dim epiend
DECLARE @s DATE, @e DATE
SET @s = (SELECT MIN(EPIEND) FROM HES_APC)
SET @e = (SELECT MAX(EPIEND) FROM HES_APC)

EXEC sp_populate_date_dim 
	@strt = @s
	,@end = @e
