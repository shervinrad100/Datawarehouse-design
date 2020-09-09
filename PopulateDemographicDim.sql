
Insert into demographic_dim (REGION, GHDI, UNEMPLOYMENTRATE, CRIMEOFFENSES)
Select Distinct
d.[Region name], 
d.[2018], 
u.[Yearly average], 
c.[Total]
From disposable_income_per_head as d
join unemployment as u
on d.[Region name]=u.Region
join crime_offence_ as c
on u.Region = c.[area name]

