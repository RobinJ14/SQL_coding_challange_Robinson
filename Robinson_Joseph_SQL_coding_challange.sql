create database crime_management
use crime_management;

-- Create tables
CREATE TABLE Crime (
 CrimeID INT PRIMARY KEY,
 IncidentType VARCHAR(255),
 IncidentDate DATE,
 Location VARCHAR(255),
 Description TEXT,
 Status VARCHAR(20)
);

CREATE TABLE Victim (
 VictimID INT PRIMARY KEY,
 CrimeID INT,
 Name VARCHAR(255),
 ContactInfo VARCHAR(255),
 Injuries VARCHAR(255),
 FOREIGN KEY (CrimeID) REFERENCES Crime(CrimeID)
);

CREATE TABLE Suspect (
 SuspectID INT PRIMARY KEY,
 CrimeID INT,
 Name VARCHAR(255),
 Description TEXT,
 CriminalHistory TEXT,
 FOREIGN KEY (CrimeID) REFERENCES Crime(CrimeID)
);

-- Insert sample data
INSERT INTO Crime (CrimeID, IncidentType, IncidentDate, Location, Description, Status)
VALUES
 (1, 'Robbery', '2023-09-15', '123 Main St, Cityville', 'Armed robbery at a convenience store', 'Open'),
 (2, 'Homicide', '2023-09-20', '456 Elm St, Townsville', 'Investigation into a murder case', 'Under Investigation'),
 (3, 'Theft', '2023-09-10', '789 Oak St, Villagetown', 'Shoplifting incident at a mall', 'Closed')

 --new records
insert into crime values(4, 'Theft', '2023-08-10', '789 Oak St, Villagetown', 'aaaaaaaa', 'open');
insert into crime values (5, 'Theft', '2023-05-10', '789 Oak St, Villagetown', 'bbbbbbb', 'open');
insert into crime values (6, 'Theft', '2023-05-10', '789 Oak St, Villagetown', 'bbbbbbb', 'open');


INSERT INTO Victim (VictimID, CrimeID, Name, ContactInfo, Injuries)
VALUES
 (1, 1, 'John Doe', 'johndoe@example.com', 'Minor injuries'),
 (2, 2, 'Jane Smith', 'janesmith@example.com', 'Deceased'),
 (3, 3, 'Alice Johnson', 'alicejohnson@example.com', 'None');

 --new records
INSERT INTO Victim (VictimID, CrimeID, Name, ContactInfo, Injuries,age)
VALUES(4, 4, 'john doe', 'aaaaa@example.com', 'Minor injuries',20)
INSERT INTO Victim (VictimID, CrimeID, Name, ContactInfo, Injuries,age)
VALUES(5, 3, 'john doe', 'aaaaa@example.com', 'Minor injuries',20)

INSERT INTO Suspect (SuspectID, CrimeID, Name, Description, CriminalHistory)
VALUES
 (1, 1, 'Robber 1', 'Armed and masked robber', 'Previous robbery convictions'),
 (2, 2, 'Unknown', 'Investigation ongoing', NULL),
 (3, 3, 'Suspect 1', 'Shoplifting suspect', 'Prior shoplifting arrests');

 --new records
INSERT INTO Suspect (SuspectID, CrimeID, Name, Description, CriminalHistory,age)
VALUES(4, 4, 'alice johnson', 'Armed and masked robber', 'Previous robbery convictions',18);
INSERT INTO Suspect (SuspectID, CrimeID, Name, Description, CriminalHistory,age)
VALUES (5, 5, 'alice johnson', 'Armed and masked robber', 'Previous robbery convictions',18);

select * from Crime
select * from Victim
select * from Suspect

-- 1. Select all open incidents.
select * from crime where Status='open'

-- 2. Find the total number of incidents.
select count(*) as  Total_NO_OF_Incidents from Crime

-- 3. List all unique incident types.
select distinct(incidenttype) from Crime

-- 4. Retrieve incidents that occurred between '2023-09-01' and '2023-09-10'.
select * from Crime where IncidentDate between '2023-09-01' and '2023-09-10'

-- 5. List persons involved in incidents in descending order of age.
alter table victim add age int
update Victim set age = 20 where victimid=1;
update Victim set age = 22 where victimid=2;
update Victim set age = 18 where victimid=3;

alter table suspect add age int
update Suspect set age = 31 where suspectid=1;
update Suspect set age = 25 where suspectid=2;
update Suspect set age = 27 where suspectid=3;

select incidenttype,v.name,v.age,s.name,s.age from 
crime c inner join Victim v on c.CrimeID=v.CrimeID
inner join Suspect s on c.CrimeID=s.CrimeID
order by v.age, s.age desc

-- 6. Find the average age of persons involved in incidents.
select avg(victim.age) as avg_age_victims ,avg(Suspect.age) as avg_age_suspects from Victim,Suspect


-- 7. List incident types and their counts, only for open cases.
select incidenttype, count(crimeid) as No_of_crimes from crime 
where Status='open'
group by IncidentType


-- 8. Find persons with names containing 'Doe'.
(select name from Victim where name like '%doe%') union (select name from suspect where name like '%doe%')


-- 9. Retrieve the names of persons involved in open cases and closed cases.

select v.Name as person_in_open_closed from Victim v inner join Crime c on v.CrimeID=c.CrimeID
where c.Status in ('open', 'closed')
group by v.name,c.Status
having count(v.CrimeID) =2

-- 10. List incident types where there are persons aged 30 or 35 involved.
 select distinct(IncidentType) from crime c inner join Victim v on c.CrimeID= v.CrimeID 
 inner join Suspect s on c.CrimeID=s.CrimeID
 where (v.age in  (20 ,35)) or (s.age in (20 ,35))

-- 11. Find persons involved in incidents of the same type as 'Robbery'.
 select IncidentType,v.name as victim ,s.name as suspect from crime c inner join Victim v on c.CrimeID= v.CrimeID 
 inner join Suspect s on c.CrimeID=s.CrimeID
 where IncidentType='robbery'


-- 12. List incident types with more than one open case.
select IncidentType,count(*) as  Total_NO_OF_Incidents from Crime
where Status='open'
group by IncidentType
having count(*)>1


-- 13. List all incidents with suspects whose names also appear as victims in other incidents.
select distinct (c.incidenttype),v.crimeid,v.name as victim ,s.crimeid ,s.name as suspect 
from crime c inner join victim v on c.crimeid= v.crimeid inner join suspect s on s.name = v.name

-- 14. Retrieve all incidents along with victim and suspect details.
select IncidentType,v.name ,s.name from crime c 
inner join Victim v on c.CrimeID= v.CrimeID 
inner join Suspect s on c.CrimeID=s.CrimeID

-- 15. Find incidents where the suspect is older than any victim.
select distinct(incidenttype),c.CrimeID from crime c inner join Victim v on c.CrimeID=v.CrimeID
where v.age < (select age from Suspect where CrimeID=v.CrimeID)

-- 16. Find suspects involved in multiple incidents:
select name, count(crimeid) as No_of_Crimes from Suspect
group by name 
having count(crimeid)> 1


-- 17. List incidents with no suspects involved.
select c.CrimeID,c.incidenttype,s.SuspectID from crime c left join Suspect s on c.CrimeID = s.CrimeID where s.SuspectID is null
--or
select incidentType from Crime where crimeid  not in (select crimeid from Suspect);


-- 18. List all cases where at least one incident is of type 'Homicide' and all other incidents are of type  'Robbery'.
select * from crime where crimeid in ( 
(select top 1 CrimeID from crime where IncidentType='homicide') union (select CrimeID from Crime where IncidentType='robbery'))


-- 19. Retrieve a list of all incidents and the associated suspects, showing suspects for each incident, or  'No Suspect' if there are none.
select Crime.CrimeID,Crime.IncidentType ,COALESCE(Name, 'No Suspect') from crime 
left join Suspect on Crime.CrimeID=Suspect.CrimeID 

-- 20. List all suspects who have been involved in incidents with incident types 'Robbery' or 'Assault'
 select name from suspect s inner join crime c on s.crimeid=c.crimeid  where incidenttype in ('robbery', 'assualt')