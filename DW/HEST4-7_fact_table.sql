CREATE TABLE adm_patient_care_fact (
	 IDENTIFIER		UNIQUEIDENTIFIER DEFAULT NEWSEQUENTIALID() 
	,HESID			NVARCHAR(15)	REFERENCES patient_dim(HESID)
	,DIAGNOSISID	INT				REFERENCES diagnosis_dim(DIAGNOSISID)
	,ADMINID		INT				REFERENCES administrative_dim(ADMINID)
	,ELECTIVEID		INT				REFERENCES elective_dim(ELECTIVEID)
	,SPELLID		INT				REFERENCES spell_dim(SPELLID)
	,EPISODEID		INT				REFERENCES episode_dim(EPISODEID)
	,ADMISID		INT				REFERENCES admission_dim(ADMISID)
	,PROVID			INT				REFERENCES provider_dim(PROVID)

	CONSTRAINT pk_adm_patient_care_fact PRIMARY KEY NONCLUSTERED (
		 IDENTIFIER	
		,HESID		
		,DIAGNOSISID
		,ADMINID	
		,ELECTIVEID	
		,SPELLID	
		,EPISODEID	
		,ADMISID	
		,PROVID		
	)
	
);

INSERT INTO adm_patient_care_fact (HESID) (
	SELECT
		HESID 
	FROM patient_dim
);


-- write a proc to update fact table based on new HESIDs



-- write a proc to insert new HESIDs
