-- Looking at Total Cases vs Total Deaths

select location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 as DeatPercentage
from CovidDeaths
where location like 'Poland'
order by 1,2

-- Looking at Total Cases vs Populatio
-- Shows what percentage of population got Covid

select location,date,population, total_cases,(total_cases/population)*100 as DeatPercentage
from CovidDeaths
where location ='Poland'
order by 1,2 

-- Looking at Countries with Highest Infection Rate comapred to Population

select location,population,MAX(total_cases) as HighestInfection,(MAX(total_cases)/population )*100 as Rate
from CovidDeaths
group by location,population
order by 4 desc

-- Showing Countries with Highest Death Count per Population
select location,MAX(CAST(total_deaths as int)) as HighestDeath
from CovidDeaths
where continent is not null
group by location
order by 2 desc

-- Showing Continents with the highest death count per population

select continent,MAX(CAST(total_deaths as int)) as HighestDeath
from CovidDeaths
where continent is not null
group by continent
order by 2 desc

--GLOBAL NUMBERS

select SUM(new_cases) as total_cases,SUM(CAST(new_deaths as int)) as total_deaths,SUM(cast(new_deaths as int))/Sum(new_cases)* 100 as DeathPercentage
from CovidDeaths
where continent is not null
--group by date,total_cases,total_deaths
order by 1,2

-- Total Population vs Vaccinations

select cd.continent,cd.location,cd.date,cd.population,cv.new_vaccinations,
SUM(CONVERT(int,cv.new_vaccinations)) OVER (Partition by cd.location ) as RollingVaccination
from CovidDeaths cd
JOIN CovidVaccinations cv 
ON cd.location=cv.location
AND cd.date=cv.date
where cd.continent is not null
--group by cd.continent,cd.location,cd.date,cv.new_vaccinations
order by 2,3

Select cd.continent, cd.location, cd.date, cd.population, vc.new_vaccinations
, SUM(CONVERT(int,vc.new_vaccinations)) OVER (Partition by cd.Location Order by cd.location, cd.Date) as RollingPeopleVaccinated
From CovidDeaths cd
Join CovidVaccinations vc
	On cd.location = vc.location
	and cd.date = vc.date
where cd.continent is not null 
order by 2,3

--USE CTE

With PopulationvsVaccinations ( continent, location, date, population,new_vaccinations,RollingPeopleVaccinated)
as
(
Select cd.continent, cd.location, cd.date, cd.population, vc.new_vaccinations
, SUM(CONVERT(int,vc.new_vaccinations)) OVER (Partition by cd.Location Order by cd.location, cd.Date) as RollingPeopleVaccinated
From CovidDeaths cd
Join CovidVaccinations vc
	On cd.location = vc.location
	and cd.date = vc.date
where cd.continent is not null 
--order by 2,3
)
Select *,(RollingPeopleVaccinated/population)*100 from PopulationvsVaccinations

--Create View

CREATE View  PopulationvsVaccinationsPercent as
Select cd.continent, cd.location, cd.date, cd.population, vc.new_vaccinations
, SUM(CONVERT(int,vc.new_vaccinations)) OVER (Partition by cd.Location Order by cd.location, cd.Date) as RollingPeopleVaccinated
From CovidDeaths cd
Join CovidVaccinations vc
	On cd.location = vc.location
	and cd.date = vc.date
where cd.continent is not null 