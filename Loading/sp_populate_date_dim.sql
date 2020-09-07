
CREATE OR ALTER PROC sp_populate_date_dim @strt DATE, @end DATE
AS BEGIN

DECLARE @st DATE, @nd DATE
SET @st = (SELECT MIN([date]) FROM date_dim)
SET @nd = (SELECT MAX([date]) FROM date_dim)

-- 0
	IF @strt >= @end 
	BEGIN
		PRINT 'ERROR: Start Date > End Date'
	END;

-- start---------start
	IF @strt = @st
		OR @strt = @nd
	BEGIN
		PRINT ' start---------start'
		SET @strt = DATEADD(dd,-1,@st)
	END;

-- end-------------end
	IF @end = @nd
		OR @end = @st
	BEGIN
		PRINT 'end-------------end'
		SET @end = DATEADD(dd,1,@nd)
	END;

-- strt end |----------------|
	IF @strt < @st
			AND  @end < @st
	BEGIN
		PRINT 'strt end |----------------|'
		INSERT INTO date_dim (
			[DATE] 
			,SEASON 
			,MONTHOFYR
			,[YEAR] 
		) (
			SELECT * FROM
			func_populate_date_dim(@strt,DATEADD(dd,-1,@st))
		)
		OPTION (MAXRECURSION 0)
	END;

--   strt |--------end--------|
	IF @strt < @st
			AND  (@end < @nd
				AND @end > @st
				)
	BEGIN
		PRINT 'strt |--------end--------|'
		INSERT INTO date_dim (
			[DATE] 
			,SEASON 
			,MONTHOFYR
			,[YEAR] 
		) (
			SELECT * FROM
			func_populate_date_dim(@strt,DATEADD(dd,-1,@st))
		)
		OPTION (MAXRECURSION 0)
	END;

--     strt |----------------| end
	IF @strt < @st
		AND  @end > @nd
	BEGIN
		PRINT 'strt |----------------| end'
		INSERT INTO date_dim (
			[DATE] 
			,SEASON 
			,MONTHOFYR
			,[YEAR] 
		) (
			SELECT * FROM
			func_populate_date_dim(@strt,DATEADD(dd,-1,@st))
		)
		OPTION (MAXRECURSION 0)
		INSERT INTO date_dim (
			[DATE] 
			,SEASON 
			,MONTHOFYR
			,[YEAR] 
		) (
			SELECT * FROM
			func_populate_date_dim(DATEADD(dd,1,@nd),@end)
		)
		OPTION (MAXRECURSION 0)
	END;

--    |------ start---end---------|
	IF @strt < @nd
		AND @strt > @st
		AND @end > @st
			AND @end < @nd
	BEGIN
		PRINT '|------ start---end---------|'
		PRINT 'ERROR: UNIQUE constraint violated'
	END;
--      |------start----------|  end
	IF (@strt < @nd 
		AND  @strt > @st
		)
		AND @end > @nd 
	BEGIN
		PRINT ' |------start----------|  end'
		SET @strt = @nd 
		INSERT INTO date_dim (
			[DATE] 
			,SEASON 
			,MONTHOFYR
			,[YEAR] 
		) (
			SELECT * FROM
			func_populate_date_dim(DATEADD(dd,1,@nd),@end)
		)
		OPTION (MAXRECURSION 0)
	END;
--  |----------------| start end
	IF @strt > @nd
	BEGIN
		PRINT '|----------------| start end'
		INSERT INTO date_dim (
			[DATE] 
			,SEASON 
			,MONTHOFYR
			,[YEAR] 
		) (
			SELECT * FROM
			func_populate_date_dim(DATEADD(dd,1,@nd),@end)
		)
		OPTION (MAXRECURSION 0)
	END;

END;
GO



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
