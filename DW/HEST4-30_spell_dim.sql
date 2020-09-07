
ALTER TABLE spell_dim
	ALTER COLUMN SPELLDUR INT
GO


INSERT INTO spell_dim (
	SPELL
	,SPELLBGIN
	,SPELLEND
	,SPELLDUR
) (
	SELECT DISTINCT 
		SPELL
		,SPELBGIN
		,SPELEND
		,SPELDUR
	FROM HES_APC
);
GO