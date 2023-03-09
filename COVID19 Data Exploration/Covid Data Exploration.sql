/*

Queries used for Covid'19 Data Exploration
Skills used: Joins, CTE's, Temp Tables, Windows Functions, Aggregate Functions, Creating Views, Converting Data Types

*/ 

SELECT *
FROM PortfolioProject..CovidDeaths
WHERE continent <> '' --- or WHERE continent IS NOT NULL
ORDER BY 3,4;


--- select data that will be used

SELECT location, date, total_cases, new_cases, total_deaths, population
FROM PortfolioProject..CovidDeaths
WHERE continent <> ''
ORDER BY 1,2;


-- looking at total cases vs total deaths
-- shows likelihood of dying if you contract covid in your country

SELECT location, date, total_cases, total_deaths, (total_deaths/NULLIF(total_cases, 0))*100 AS death_percentage
FROM PortfolioProject..CovidDeaths
WHERE location LIKE '%Singapore%'
ORDER BY 1,2;


-- looking at total cases vs population
-- shows what percentage of population contracted covid

SELECT location, date, population, total_cases, (total_cases/NULLIF(population, 0))*100 AS infectedpopulation_percentage
FROM PortfolioProject..CovidDeaths
WHERE location LIKE '%Singapore%'
ORDER BY 1,2;


-- looking at countries with highest infection rate vs population

SELECT location, population, MAX(total_cases) AS HighestInfectionCount, MAX((total_cases/NULLIF(population, 0)))*100 AS infectedpopulation_percentage
FROM PortfolioProject..CovidDeaths
WHERE continent <> ''
GROUP BY location, population
ORDER BY 4 desc;


-- showing countries with highest death count per population

SELECT location, MAX(total_deaths) AS TotalDeathCount
FROM PortfolioProject..CovidDeaths
WHERE continent <> ''
GROUP BY location
ORDER BY TotalDeathCount desc;


-- showing continents with highest death count per population

SELECT continent, MAX(total_deaths) AS TotalDeathCount
FROM PortfolioProject..CovidDeaths
WHERE continent <> ''
GROUP BY continent
ORDER BY TotalDeathCount desc;


-- global numbers

SELECT date, SUM(new_cases) AS total_cases, SUM(new_deaths) AS total_deaths,
(SUM(new_deaths)/NULLIF(SUM(new_cases), 0))*100 AS deathpercentage
FROM PortfolioProject..CovidDeaths
WHERE continent <> ''
GROUP BY date
ORDER BY 1,2;



--- vaccination table

SELECT *
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date;


--- looking at total population vs vaccinations

SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
	   CAST(SUM(CAST(vac.new_vaccinations AS bigint)) OVER (PARTITION BY dea.location ORDER BY dea.location,
	   dea.date) AS float) AS ContinuousVaccinatedPeople
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent <> ''
ORDER BY 2,3;


--- using CTE

WITH PopvsVac (Continent, Location, Date, Population, New_Vaccinations, ContinuousVaccinatedPeople)
AS
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
	   CAST(SUM(CAST(vac.new_vaccinations AS bigint)) OVER (PARTITION BY dea.location ORDER BY dea.location,
	   dea.date) AS float) AS ContinuousVaccinatedPeople
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent <> ''
)
SELECT *, (ContinuousVaccinatedPeople/Population)*100
FROM PopvsVac;


--- TEMP TABLE
DROP TABLE IF EXISTS PercentPopulationVaccinated
CREATE TABLE PercentPopulationVaccinated
(
	continent nvarchar(255),
	location nvarchar(255),
	date datetime,
	population numeric,
	new_vaccinations bigint,
	ContinuousVaccinatedPeople float
)

INSERT INTO PercentPopulationVaccinated
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
	   CAST(SUM(CAST(vac.new_vaccinations AS bigint)) OVER (PARTITION BY dea.location ORDER BY dea.location,
	   dea.date) AS float) AS ContinuousVaccinatedPeople
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date

SELECT *, (ContinuousVaccinatedPeople/NULLIF(Population, 0))*100
FROM PercentPopulationVaccinated


-- an example of how to create view to store data for later visualisations

USE PortfolioProject
GO
CREATE VIEW PercentPopulationVaccinatedView AS
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
	   CAST(SUM(CAST(vac.new_vaccinations AS bigint)) OVER (PARTITION BY dea.location ORDER BY dea.location,
	   dea.date) AS float) AS ContinuousVaccinatedPeople
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
	WHERE dea.continent <> ''

SELECT * FROM PercentPopulationVaccinatedView;
