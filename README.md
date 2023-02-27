# Covid-Portfolio-Project

The Covid Portfolio Project is a data exploration project designed to interpret and figure out information about Covid-19 patients worldwide. The project uses two datasets, CovidDeaths.xlsx and CovidVaccinations.xlsx, which have been cleaned in Excel and loaded into a Microsoft SQL Server database for data exploration.

## Files
The project includes the following files:

**CovidDeaths.xlsx**: the dataset containing information on Covid-19 deaths worldwide

**CovidVaccinations.xlsx**: the dataset containing information on Covid-19 vaccinations worldwide


**Data Exploration.sql**: the SQL code used to explore the data in the database

## Data Exploration
The Data **Exploration.sql** file contains SQL queries for exploring the Covid-19 data. The following queries have been used in this project:


Select all data from the CovidDeaths table and order it by date and location.
``` sql
SELECT *
FROM PortfolioProject.dbo.CovidDeaths
ORDER BY 3,4 
```

Select all data from the CovidVaccinations table and order it by date and location.
```sql
SELECT *
FROM PortfolioProject.dbo.CovidVaccinations
ORDER BY 3,4
```

Select the data that we are going to be using for the analysis, including location, date, total_cases, new_cases, total_deaths, and population. Order the data by location and date.
```sql
SELECT Location, date, total_cases, new_cases, total_deaths, population
FROM PortfolioProject.dbo.CovidDeaths
ORDER BY 1,2
```

Look at total cases vs total deaths to show the likelihood of dying if you contract Covid-19 in your country. Order the data by location and date.
```sql
SELECT Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
FROM PortfolioProject.dbo.CovidDeaths
WHERE location like '%states%'
ORDER BY 1,2
```

Look at total cases vs population to show what percentage of the population has been infected with Covid-19. Order the data by location and date.
```sql
SELECT Location, date, population, total_cases, (total_cases/population)*100 as PercentofPopulationInfected
FROM PortfolioProject.dbo.CovidDeaths
WHERE location like '%states%'
ORDER BY 1,2
```

Look at countries with the highest infection rate compared to population. Group the data by location and population and order it by the percentage of the population infected in descending order.
```sql
SELECT Location, population, MAX (total_cases) as HighestInfectionCOunt, MAX ((total_cases/population))*100 as PercentofPopulationInfected
FROM PortfolioProject.dbo.CovidDeaths
GROUP BY Location, population
ORDER BY PercentofPopulationInfected DESC
```

Show countries with the highest death count per population. Group the data by location and order it by the total death count in descending order.
```sql
SELECT Location, MAX (cast (Total_deaths as int)) as TotalDeathCount
FROM PortfolioProject.dbo.CovidDeaths
WHERE continent is not null
GROUP BY Location
ORDER BY TotalDeathCount DESC
```

Break things down by continent. Group the data by continent and order it by the total death count in descending order.
```sql
SELECT continent, MAX (cast (Total_deaths as int)) as TotalDeathCount
FROM PortfolioProject.dbo.CovidDeaths
WHERE continent is not null
GROUP BY continent
ORDER BY TotalDeathCount DESC 
```

Show continents with the highest death count per population. Group the data by continent and order it by the total death count in descending order.
```sql
SELECT continent, MAX (cast (Total_deaths as int)) as TotalDeathCount
FROM Portfolio
```

## Usage

To use this project, you will need to have Microsoft SQL Server installed. You can then download the **CovidDeaths.xlsx** and **CovidVaccinations.xlsx** datasets, clean them in Excel, and load them into the SQL Server. Finally, you can run the SQL queries from the **Data Exploration.sql** file to explore the data.



## Tableau Visualization
<img src = "/Screenshots/tableau_ss1.JPG">
