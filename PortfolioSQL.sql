select * 
from Portfolio.dbo.CovidDeaths
where continent is not null
order by 3,4

--select * 
--from Portfolio.dbo.CovidVaccinations
--order by 3,4

select Location, date, total_cases, new_cases, total_deaths, population
from Portfolio..CovidDeaths
where continent is not null
order by 1,2

--Looking at Total Cases vs Total Deaths
--Shows likelihood of dying if you contract covid in every location
select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from Portfolio..CovidDeaths
where continent is not null
order by 1,2

--Shows likelihood of dying if you contract covid in the Philippines
select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from Portfolio..CovidDeaths
where location = 'Philippines' 
order by 1,2

--Looking at Total Cases vs Population
--Shows what percentage of population got Covid
select Location, date, population, total_cases,  (total_cases/population)*100 as ContractionPercentage
from Portfolio..CovidDeaths
--where location = 'Philippines'
order by 1,2

--Looking at Countries with Highest Infection Rate compare to Population
--Shows what Countries with Highest Infection Count to Population
select Location, population, Max(total_cases) as HighestInfection, Max((total_cases/population))*100 as ContractionPercentage
from Portfolio..CovidDeaths
--where location = 'Philippines'
group by Location, population
order by ContractionPercentage desc

--Shows what Countries with Highest Death Count to Population
select Location, max(cast(total_deaths as int)) as TotalDeathCount 
from Portfolio..CovidDeaths
where continent is not null
group by Location
order by TotalDeathCount desc


--Showing Highest Death Count to Continent
select continent, max(cast(total_deaths as int)) as TotalDeathCount 
from Portfolio..CovidDeaths
where continent is not null
group by continent
order by TotalDeathCount desc

--GLOBAL NUMBERS

select Sum(new_cases)as total_cases, sum(cast(new_deaths as int)) as total_deaths, sum(cast(new_deaths as int)) / sum(new_cases)*100 as DeathPercentage
from Portfolio..CovidDeaths
--where location = 'Philippines' 
where continent is not null
--group by date
order by 1,2

-- Looking at Total Population vs Vaccinations

select dea.continent, dea.location, dea.date, population, dea.new_vaccinations,
sum(convert(int,vac.new_vaccinations)) 
over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
from Portfolio.dbo.CovidDeaths as dea
join Portfolio.dbo.CovidVaccinations as vac
	on dea.location = vac.location 
	and dea.date = vac.date
where dea.continent is not null
order by 2,3

--CTE

With PopvsVac (Continent, Location, Date, Population, new_vaccinations, RollingPeopleVaccinated)
as
(
select dea.continent, dea.location, dea.date, population, vac.new_vaccinations,
sum(convert(int,vac.new_vaccinations))
over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
from Portfolio.dbo.CovidDeaths as dea
join Portfolio.dbo.CovidVaccinations as vac
	on dea.location = vac.location 
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3
)
Select *, (RollingPeopleVaccinated/Population)*100 as VaccinatedPercentage
from PopvsVac


--Temp Table
Drop table if exists #PercentagePopulationVaccinated
Create Table #PercentagePopulationVaccinated
(
Continent nvarchar (255), Location nvarchar (255), 
Date datetime, Population numeric, New_vaccination numeric, 
RollingPeopleVaccinated numeric
)

Insert into #PercentagePopulationVaccinated
select dea.continent, dea.location, dea.date, population, dea.new_vaccinations,
sum(convert(int,vac.new_vaccinations)) 
over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
from Portfolio.dbo.CovidDeaths as dea
join Portfolio.dbo.CovidVaccinations as vac
	on dea.location = vac.location 
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3

Select *, (RollingPeopleVaccinated/Population)*100 as VaccinatedPercentage
from #PercentagePopulationVaccinated


--Creating View to store data for later viz

Create view PercentPopulationVaccinated as 
select dea.continent, dea.location, dea.date, population, dea.new_vaccinations,
sum(convert(int,vac.new_vaccinations)) 
over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
from Portfolio.dbo.CovidDeaths as dea
join Portfolio.dbo.CovidVaccinations as vac
	on dea.location = vac.location 
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3

