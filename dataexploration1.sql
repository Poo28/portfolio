-- data exploration on coviddatasets series 1
- selecting the columns which is required right now

Select location, population, date, total_cases,total_deaths from covid_deaths;

-- lets sort the data by loation and date 

 Select location, population, date, total_cases,total_deaths from covid_deaths order by location desc;
Select location, population, date, total_cases,total_deaths from covid_deaths order by location , date;

 -- selecting date where totalcases are not null
 Select date, total_cases from covid_deaths where total_cases is not null;

 Select location, population, date, total_cases,total_deaths from covid_deaths where location like '_fg%';

 Select continent,max(total_cases) as maxcases, max(total_deaths) as maxdeaths from covid_deaths group by continent;

-- Calculating month wise data
Select datename(month, date) as monthwise, sum(total_cases) as monthwisecases, sum(total_deaths) as monthwisedeaths from covid_deaths group by datename(month, date);

Select continent,max(total_cases) as maxcases, max(total_deaths) as maxdeaths from covid_deaths group by continent having continent='asia';

--calculating year wise data
Select datename(year, date) as yearwise, sum(total_cases) as yearwisecases, sum(total_deaths) as yearwisedeaths from covid_deaths group by datename(year, date);

-- calculating deathrate compared to total cases
 Select location, population, date, total_cases,total_deaths , (total_deaths/ total_cases)*100 as deathrate from covid_deaths where total_cases  is not null and total_deaths is not null;

 -- looking at total cases per population
  Select location, population, date, total_cases,total_deaths , round((total_cases/ population)*100,2) as totalcasepopulationrate from covid_deaths where total_cases  is not null and total_deaths is not null;

 --looking at the countries with highest infection rate compared to population
  Select location, population, max(round((total_cases/ population)*100,2)) as infectionrate 
  from covid_deaths where total_cases  is not null and total_deaths is not null group by location, population order by location;

  --looking at total_cases vs new_cases per day
 Select location , date , total_cases, new_cases, (new_cases/total_cases)*100 as newcasespercent from covid_deaths where total_cases is not null and new_cases is not null;

 -- looking at vaccination side
 Select location,date, total_tests,total_vaccinations,people_vaccinated from covid_vaccines;

 ---looking at the first date where vaccinantion started

 Select Top 1 date , location , total_vaccinations  from covid_vaccines where total_vaccinations is not null;

 --looking at total_cases sand total vaccinations all together

 Select covid_deaths.location, covid_deaths.date, total_cases, total_tests, total_vaccinations,people_vaccinated
 from covid_deaths 
 Inner Join covid_vaccines
 on covid_deaths.location = covid_vaccines.location and covid_deaths.date = covid_vaccines.date;

 --looking at total_cases sand total vaccinations all together where total_cases , total_tests, total_vaccinations, people_vaccinated is not null
 Select covid_deaths.location, covid_deaths.date, total_cases, total_tests, total_vaccinations,people_vaccinated
 from covid_deaths 
 Inner Join covid_vaccines
 on covid_deaths.location = covid_vaccines.location and covid_deaths.date = covid_vaccines.date 
 where total_cases is not null and total_tests is not null and total_vaccinations is not null and people_vaccinated is not null
  order by location, date;


  --looking at each data for every continent

  Select covid_deaths.continent , sum(total_cases) as totalcases, sum(total_tests) as totaltests, sum(total_vaccinations)  as totalvaccines,sum(people_vaccinated) as totalpeoplevaccines
 from covid_deaths 
 Inner Join covid_vaccines
 on covid_deaths.location = covid_vaccines.location and covid_deaths.date = covid_vaccines.date 
 where total_cases is not null and total_tests is not null and total_vaccinations is not null and people_vaccinated is not null
  group by covid_deaths.continent;

 --- lets compare totaltests vs total cases and total vaccines vs totalpeoplevaccines continent wise

  temp tables
 Drop table if exists #sorteddatacontwise
 Create table #sorteddatacontwise(
 Continent varchar(50),
 totalcases numeric,
 totaltests numeric,
 totalvaccines numeric,
 totalpeoplevaccines numeric);

 Insert into #sorteddatacontwise 
 Select covid_deaths.continent , sum(total_cases) as totalcases, sum(total_tests) as totaltests, sum(total_vaccinations)  as totalvaccines,sum(people_vaccinated) as totalpeoplevaccines
 from covid_deaths 
 Inner Join covid_vaccines
 on covid_deaths.location = covid_vaccines.location and covid_deaths.date = covid_vaccines.date 
 where total_cases is not null and total_tests is not null and total_vaccinations is not null and people_vaccinated is not null
  group by covid_deaths.continent;

 Select * , (totaltests/ totalcases)*100 from #sorteddatacontwise;

 --- use of partition by 

 Select covid_deaths.continent, covid_deaths.location, covid_deaths.date, max(total_tests)  over(partition by covid_deaths.continent)
 from covid_deaths 
 Inner Join covid_vaccines
 on covid_deaths.location = covid_vaccines.location and covid_deaths.date = covid_vaccines.date;

 --creating view to store data for later visualization

Create view  sorteddatacontwise as  
Select covid_deaths.continent , sum(total_cases) as totalcases, sum(total_tests) as totaltests, sum(total_vaccinations)  as totalvaccines,sum(people_vaccinated) as totalpeoplevaccines
 from covid_deaths 
 Inner Join covid_vaccines
 on covid_deaths.location = covid_vaccines.location and covid_deaths.date = covid_vaccines.date 
 where total_cases is not null and total_tests is not null and total_vaccinations is not null and people_vaccinated is not null
 group by covid_deaths.continent;







 






 