USE HESTeam4
CREATE TABLE episode_dim
(EPISODEID int identity primary key
 ,EPISODE int
 ,EPIDUR int
 ,EPIEND date
 ,EPISTART date
 ,EPISTAT char(1)
 ,EPITYPE char(1)
 ,STARTAGE int
 ,ENDAGE int
 ,ACTIVAGE NVARCHAR(3)
 ,EPIORDER INT)

