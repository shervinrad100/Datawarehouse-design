# HES

## What was done
1. data was loaded into a staging table
2. dimensions were created and data picked from the staging table
  - dates were separated into date dim. 
3. data was found online to enrich the dims. They were loaded as staging tables
  - must start with the dims furthest out
4. data was picked from the enrichment staging tables and updated the dims
5. fact table was created and populated 
  - first input into the fact table was the patient dim
6. foreign key relationships were put in place
7. SSIS package created 
  - import new rows straight from the source instead of importing as staging table
 
__Do check the database diagram on SSMS (it looks really pretty)__



## in progress
7. triggers to be placed to insert and delete on cascade
8. change table or CDC to be activated and linked to SSIS 



## Things we learned and would do differently next time:

1. look at data and see what you have
	- choose your dims
	- choose your facts
2. Create DB diagram and ERD and create a data dictionary
	allows you to easily refer back to them when things change or you need to create 
	relationships in SQL
3. load data into staging tbl without changing data types because they could be truncated
4. address null values
	- change them to recognisable values of target destination type eg:
		varchar --> 'NULL'
		date    --> '1800-01-01' **
		int     --> recognisably invalid int
	this helps you avoid incorrect joins 
5. create dim tables without loading data into it 
6. once all tables are made, change the scripts to include the FK relationships
7. load data into dim tables from OUTSIDE TO INSIDE
	- after each dim insert, alter src table, add dimID col, update src.dimID
8. create and insert rows into fact tab 



GENERAL:
commit only to your branch

organise scripts based on project stage because you need to go back and change things if relationships change

date_dim: when inserting dates, the invalid 1800 date causes the entry to start from that date
