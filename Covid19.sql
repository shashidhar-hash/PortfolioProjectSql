select * 
from portfolio..CovidDeaths
where continent is not null
order by 3,4

--select * 
--from portfolio..Vaccination
--order by 3,4

select location, date,total_cases,new_cases, total_deaths, population
from portfolio..CovidDeaths
order by 1,2

select location, date,total_cases, total_deaths,(total_deaths/total_cases)*100 as DeathPercentage
from portfolio..CovidDeaths
where location like '%states%'
order by 1,2

--percentage of population got covid
select location, date,total_cases,population,(total_cases/population)*100 as PercentagepopulationInfected
from portfolio..CovidDeaths
where location like '%states%' and continent is not null
order by 1,2

--infection rate compare to population
select location,population,MAX(total_cases)as HighestInfectionCount,MAX((total_cases/population))*100 as PercentagepopulationInfected
from portfolio..CovidDeaths
where continent is not null
--where location like '%states%'
group by location , population
order by PercentagepopulationInfected desc


--Showing Countries with Highest death count per population
select location,MAX(cast(total_deaths as int)) as deathperpopulation
from portfolio..CovidDeaths
where continent is not null
group by location 
order by deathperpopulation desc

---break by continent
select continent,MAX(cast(Total_deaths as int)) as deathperpopulation
from portfolio..CovidDeaths
where continent is not null
Group by continent 
order by deathperpopulation desc

--showing continent with highest death count
select continent,MAX(cast(Total_deaths as int)) as deathCount
from portfolio..CovidDeaths
where continent is not null
Group by continent 
order by deathCount desc

--Global Numbers by date
select date,sum(cast(new_deaths as int)) as Total_deaths,sum(new_cases) as Total_cases,
sum(cast(new_deaths as int))/sum(new_cases)*100 as deathpercentage
from portfolio..CovidDeaths
where continent is not null
Group by date 
order by 1,2

-- Looking at total Population vs Vaccination
select dea.continent, dea.location,dea.date,dea.population,vac.new_vaccinations,
sum(CONVERT(int,vac.new_vaccinations)) over (Partition by dea.location order by dea.location,
dea.date)as RollingPeopleVaccinated
--(RollingPeopleVaccinated/population)*100
from portfolio..CovidDeaths dea
join portfolio..Vaccination vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3

--CTE

with PopvsVac(Continent,location,date,population,new_vaccinations,RollingPeopleVaccinated)
as
(
select dea.continent, dea.location,dea.date,dea.population,vac.new_vaccinations,
sum(CONVERT(int,vac.new_vaccinations)) over (Partition by dea.location order by dea.location,
dea.date)as RollingPeopleVaccinated
--(RollingPeopleVaccinated/population)*100
from portfolio..CovidDeaths dea
join portfolio..Vaccination vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3
)
select *,(RollingPeopleVaccinated/population)*100
from PopvsVac


--table
Create table #percentPopulationVaccinated
(
Continent nvarchar(255),
location nvarchar(255),
date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

insert into #percentPopulationVaccinated
select dea.continent, dea.location,dea.date,dea.population,vac.new_vaccinations,
sum(CONVERT(int,vac.new_vaccinations)) over (Partition by dea.location order by dea.location,
dea.date)as RollingPeopleVaccinated
--(RollingPeopleVaccinated/population)*100
from portfolio..CovidDeaths dea
join portfolio..Vaccination vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3


select *,(RollingPeopleVaccinated/population)*100
from #percentPopulationVaccinated

--Creating View for data visualization

create view percentPopulationVaccinated as
select dea.continent, dea.location,dea.date,dea.population,vac.new_vaccinations,
sum(CONVERT(int,vac.new_vaccinations)) over (Partition by dea.location order by dea.location,
dea.date)as RollingPeopleVaccinated
--(RollingPeopleVaccinated/population)*100
from portfolio..CovidDeaths dea
join portfolio..Vaccination vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3

select * 
from percentPopulationVaccinated