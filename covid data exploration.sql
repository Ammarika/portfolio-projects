# data exploration
use portfolio;
select * from vaccination;
select * from covid 
order by location;
SELECT 
    location,
    date,
    total_cases,
    new_cases,
    total_deaths,
    population
from covid
order by location ;
# total cases against total death
SELECT 
    location,
    date,
    total_cases,
    new_cases,
    total_deaths,
    (total_deaths/total_cases) * 100 as death_percentage
from covid
where location like '%states%'
order by location ;
# high infiction
SELECT 
    location,
    population,
    MAX(total_cases) AS high_infiction,
    MAX(total_cases / population) * 100 AS infiction_rate
FROM
    covid
GROUP BY location , population
ORDER BY infiction_rate DESC;
# countries with highest death rate 
SELECT 
    location,
    population,
    MAX(total_deaths) AS high_deaths,
    MAX(total_deaths / population) * 100 AS death_rate
FROM
    covid
WHERE
    continent != '0'
GROUP BY location , population
ORDER BY death_rate DESC;
select location , max(total_deaths)
from covid
where continent !='0'
group by location
order by  max(total_deaths) desc;
# death per continent 
select continent, max(total_deaths)
from covid
where continent !='0'
group by continent
order by  max(total_deaths) desc;
select location , max(total_deaths)
from covid
where continent ='0'
group by location
order by  max(total_deaths) desc;
# showing continent with high death count per population
select continent , max(total_deaths) as total_death
from covid
where continent !='0'
group by continent
order by  max(total_deaths) desc;
# whole world numbers
select  date  , total_cases, total_deaths , (total_deaths/total_cases)*100  as death_percentage
from covid
where continent != '0'
group by date ;
# joining covid and vaccination table 
select*
from covid join vaccination on 
covid.location = vaccination.location and covid.date = vaccination.date;
# total people who take vaccination
select covid.continent , covid.location ,covid.date ,covid.population, vaccination.new_vaccinations,
sum(vaccination.new_vaccinations) over (partition by covid.location order by covid.location , covid.date) 
as sum_people_vaccinated
from covid join vaccination on 
covid.location = vaccination.location and covid.date = vaccination.date
where covid.continent != '0';
# CTE
with people_vaccinated (continent , location , date , population , new_vaccinations ,
sum_people_vaccinated) as(
select covid.continent , covid.location ,covid.date ,covid.population, vaccination.new_vaccinations,
sum(vaccination.new_vaccinations) over (partition by covid.location order by covid.location , covid.date) 
as sum_people_vaccinated
from covid join vaccination on 
covid.location = vaccination.location and covid.date = vaccination.date
where covid.continent != '0');
select* ,(sum_people_vaccinated/population)*100 as vacc_percentage
from people_vaccinated;
# save result in a table
drop table if exists vaccinations_percentage ;
create table vaccinations_percentage as
 select covid.continent , covid.location ,covid.date ,covid.population, vaccination.new_vaccinations,
sum(vaccination.new_vaccinations) over (partition by covid.location order by covid.location , covid.date) 
as sum_people_vaccinated
from covid join vaccination on 
covid.location = vaccination.location and covid.date = vaccination.date ;
select* from vaccinations_percentage ;












