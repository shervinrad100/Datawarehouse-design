CREATE TABLE date_dim (
	DATEID		INT IDENTITY PRIMARY KEY NOT NULL
	,[DATE]		DATE UNIQUE
	,SEASON		VARCHAR(5)
	,MONTHOFYR	INT
	,[YEAR]		INT
);

-- initialise table 
INSERT INTO date_dim (
	[DATE]		
	,SEASON		
	,MONTHOFYR	
	,[YEAR]		
) VALUES 
(CAST('2005-04-22' AS DATE),'SPR', 04, 2005),
(CAST('2005-04-23' AS DATE),'SPR', 04, 2005);


SELECT * FROM date_dim

--DROP TABLE date_dim