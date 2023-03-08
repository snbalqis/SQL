/*

Queries used for Tableau Visualisation

*/

-- 1)

SELECT SUM(new_cases) AS total_cases, SUM(new_deaths) AS total_deaths,
(SUM(new_deaths)/NULLIF(SUM(new_cases), 0))*100 AS deathpercentage
FROM PortfolioProject..CovidDeaths
WHERE continent <> ''
ORDER BY 1,2;

-- 2)

SELECT location, SUM(new_deaths) AS TotalDeathCount
FROM PortfolioProject..CovidDeaths
WHERE continent = ''
AND location not in ('World', 'European Union', 'International', 'High income', 'Upper middle income', 'Lower middle income',
					 'Low income')
GROUP BY location
ORDER BY TotalDeathCount desc;

-- 3)
																		
SELECT location, population, MAX(total_cases) AS HighestInfectionCount,  MAX(total_cases/NULLIF(population, 0))*100 AS PercentPopulationInfected
From PortfolioProject..CovidDeaths
GROUP BY location, population
ORDER BY PercentPopulationInfected desc;

-- 4)

SELECT location, population, date, MAX(total_cases) AS HighestInfectionCount,  MAX(total_cases/NULLIF(population, 0))*100 AS PercentPopulationInfected
From PortfolioProject..CovidDeaths
GROUP BY location, population, date
ORDER BY PercentPopulationInfected desc;
