
----Covid 19 Data Exploration 
--Skills used: Joins, CTE's, Temp Tables, Windows Functions, Aggregate Functions, Creating Views, Converting Data Types



select *
from [PORTFOLIO PROJECT(1)]..CovidDeaths
where continent is not null
order by 3,4


--select *
--from [PORTFOLIO PROJECT(1)]..CovidVaccinations
--order by 3,4
--- selecting the data we are going to use
select  location, date, total_cases, new_cases, total_deaths, population
from [PORTFOLIO PROJECT(1)]..CovidDeaths
where continent is not null
order by 1,2

--


--looking at total_cases vs total_deaths
--shows possibity of dying if you contract covid in your country

select  location, date, total_cases,  total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from [PORTFOLIO PROJECT(1)]..CovidDeaths
where location = 'India'
and continent is not null
order by 1,2

--Total cases vs population
--what percentage of population got covid

select  location, date, population, total_cases,(total_cases/population)*100 as CovidInfectedPercent
from [PORTFOLIO PROJECT(1)]..CovidDeaths
where location = 'India'
order by 1,2

--Looking at countries with highest infection rate as compared with population

select  location, population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population))*100 as PercentPopulationInfected
from [PORTFOLIO PROJECT(1)]..CovidDeaths
--where location = 'India'
group by location,population
order by PercentPopulationInfected desc

--Showing countries with highest death count per population

select  location, MAX(cast(total_deaths as int)) as TotalDeathCount
from [PORTFOLIO PROJECT(1)]..CovidDeaths
--where location = 'India'
where continent is not null
group by location
order by TotalDeathCount desc


--Breaking things down by continent
--Showing continents with Highest death count per population

select  continent, MAX(cast(total_deaths as int)) as TotalDeathCount
from [PORTFOLIO PROJECT(1)]..CovidDeaths
--where location = 'India'
where continent is not null
group by continent
order by TotalDeathCount desc

--GLOBAL DEATH PERCENTAGE(ALL OVER THE WORLD)

select  SUM(new_cases) as total_cases , SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
from [PORTFOLIO PROJECT(1)]..CovidDeaths
--where location = 'India'
where continent is not null
--group by date
order by 1,2



--Total Populations VS Vaccinations
--Showing the percentage of Population that has recieved at least one Covid Vaccine

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
Sum(convert(int,vac.new_vaccinations)) OVER (Partition by dea.location order by dea.location, dea.date)
as RollingPeopleVaccinated
--(RollingPeopleVaccinated/Population)*100
from [PORTFOLIO PROJECT(1)]..CovidDeaths dea
join [PORTFOLIO PROJECT(1)]..CovidVaccinations vac
  On dea.location = vac.location
  and dea.date = vac.date
where dea.continent is not null
order by 2,3


--Using CTE to perform calculation on Partition By in previous query

With PopvsVac (Continent, Location, Date, Population, New_vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
Sum(convert(int,vac.new_vaccinations)) OVER (Partition by dea.location order by dea.location, dea.date)
as RollingPeopleVaccinated
--(RollingPeopleVaccinated/Population)*100
from [PORTFOLIO PROJECT(1)]..CovidDeaths dea
join [PORTFOLIO PROJECT(1)]..CovidVaccinations vac
  On dea.location = vac.location
  and dea.date = vac.date
where dea.continent is not null
--order by 2,3
)
Select*,(RollingPeopleVaccinated/Population)*100
from PopvsVac


--Temp Table
--Using temp table to perform Calculation on Partition By in previous query


Drop table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)
Insert into  #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
Sum(convert(int,vac.new_vaccinations)) OVER (Partition by dea.location order by dea.location, dea.date)
as RollingPeopleVaccinated
--(RollingPeopleVaccinated/Population)*100
from [PORTFOLIO PROJECT(1)]..CovidDeaths dea
join [PORTFOLIO PROJECT(1)]..CovidVaccinations vac
  On dea.location = vac.location
  and dea.date = vac.date
--where dea.continent is not null
--order by 2,3

Select*,(RollingPeopleVaccinated/Population)*100
from #PercentPopulationVaccinated

--Create View to store data for further visualization

Create View PercentPopulationVaccinated as 
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
Sum(convert(int,vac.new_vaccinations)) OVER (Partition by dea.location order by dea.location, dea.date)
as RollingPeopleVaccinated
--(RollingPeopleVaccinated/Population)*100
from [PORTFOLIO PROJECT(1)]..CovidDeaths dea
join [PORTFOLIO PROJECT(1)]..CovidVaccinations vac
  On dea.location = vac.location
  and dea.date = vac.date
where dea.continent is not null
--order by 2,3

Select*
From PercentPopulationVaccinated