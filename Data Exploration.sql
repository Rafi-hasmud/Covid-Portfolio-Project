Select *
FROM PortfolioProject.dbo.CovidDeaths
Order By 3,4 
Select *
FROM PortfolioProject.dbo.CovidVaccinations
Order By 3,4

--Select the data that we going to be using

Select Location, date, total_cases, new_cases, total_deaths, population
FROM PortfolioProject.dbo.CovidDeaths
order by 1,2


--Looking at total cases vs total deaths 
--Shows likelihood of dying if you contract covid in your country

Select Location, date, total_cases, total_deaths,(total_deaths/total_cases)*100 as DeathPercentage
FROM PortfolioProject.dbo.CovidDeaths
Where location like '%states%'
order by 1,2


--Looking at total cases vs population
--shows what percentage of population got covid

Select Location, date, population, total_cases, (total_cases/population)*100 as PercentofPopulationInfected
FROM PortfolioProject.dbo.CovidDeaths
Where location like '%states%'
order by 1,2

--Looking at countries with highest infection rate compared to population

Select Location, population, MAX (total_cases) as HighestInfectionCOunt, MAX ((total_cases/population))*100 as PercentofPopulationInfected
FROM PortfolioProject.dbo.CovidDeaths
--Where location like '%states%'
Group By Location, population
order by PercentofPopulationInfected desc

--Showing countries with highest death count per population 

Select Location, MAX (cast (Total_deaths as int)) as TotalDeathCount
FROM PortfolioProject.dbo.CovidDeaths
--Where location like '%states%'
Where continent is not null
Group By Location
order by TotalDeathCount desc

--Break things down by continent

Select continent, MAX (cast (Total_deaths as int)) as TotalDeathCount
FROM PortfolioProject.dbo.CovidDeaths
--Where location like '%states%'
Where continent is not null
Group By continent
order by TotalDeathCount desc 

--Showing continent with highest death count per population

Select continent, MAX (cast (Total_deaths as int)) as TotalDeathCount
FROM PortfolioProject.dbo.CovidDeaths
--Where location like '%states%'
Where continent is not null
Group By continent
order by TotalDeathCount desc 


--Global Numbers

 Select  date, SUM (new_cases) as total_cases, SUM (cast (new_deaths as int)) as total_deaths, 
 SUM (cast (new_deaths as int))/SUM (new_cases)*100 as DeathPercentage
FROM PortfolioProject.dbo.CovidDeaths
--Where location like '%states%'
Where continent is not null
Group By date
order by 1,2

 Select SUM (new_cases) as total_cases, SUM (cast (new_deaths as int)) as total_deaths, 
 SUM (cast (new_deaths as int))/SUM (new_cases)*100 as DeathPercentage
FROM PortfolioProject.dbo.CovidDeaths
--Where location like '%states%'
Where continent is not null
--Group By date
order by 1,2

--Total population vs vaccination 

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM (cast(vac.new_vaccinations as int)) OVER (Partition by dea.location Order BY dea.location, dea.date)
as RollingPeopleVaccinated
From PortfolioProject..CovidDeaths dea
JOIN  PortfolioProject..CovidVaccinations vac 
On dea.location=vac.location
and dea.date=vac.date
Where dea.continent is not null
Order By 2,3

--USE CTE 
With PopvsVac(continent, location, date, population, new_vaccinations, RollingPeopleVaccinated)
as
(Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM (cast(vac.new_vaccinations as int)) OVER (Partition by dea.location Order BY dea.location, dea.date)
as RollingPeopleVaccinated
From PortfolioProject..CovidDeaths dea
JOIN  PortfolioProject..CovidVaccinations vac 
On dea.location=vac.location
and dea.date=vac.date
Where dea.continent is not null
)
Select *, (RollingPeopleVaccinated/population)*100
From PopvsVac


--Temp Table

DROP table if exists #PercentPopulationVaccinated
Create table #PercentPopulationVaccinated
(
  continent nvarchar(255),
  location nvarchar (255),
  date datetime,
  population numeric,
  new_vaccinations numeric,
  RollingPeopleVaccinated numeric
  )
insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM (cast(vac.new_vaccinations as int)) OVER (Partition by dea.location Order BY dea.location, dea.date)
as RollingPeopleVaccinated
From PortfolioProject..CovidDeaths dea
JOIN  PortfolioProject..CovidVaccinations vac 
On dea.location=vac.location
and dea.date=vac.date
--Where dea.continent is not null
--Order By 2,3

Select *, (RollingPeopleVaccinated/population)*100
From #PercentPopulationVaccinated


--Creating view to store data for later visualizations

Create View PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM (cast(vac.new_vaccinations as int)) OVER (Partition by dea.location Order BY dea.location, dea.date)
as RollingPeopleVaccinated
From PortfolioProject..CovidDeaths dea
JOIN  PortfolioProject..CovidVaccinations vac 
On dea.location=vac.location
and dea.date=vac.date
Where dea.continent is not null
--Order By 2,3
--DROP VIEW PercentPopulationVaccinated

Select *
from dbo.PercentPopulationVaccinated