
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



