-- Covid19 Data Exploration
-- Skills used: Joins, CTEs, Temp Tables, Windows Functions, Aggregate Functions, Creating Views, Converting Data Types

SELECT *
FROM `project-21793.Covid.Covid_deaths`
WHERE continent is not null
ORDER BY location,population


-- Select data that I will be using

SELECT  
    location, 
    date, 
    total_cases, 
    new_cases, 
    total_deaths, 
    population
FROM `project-21793.Covid.Covid_deaths`
ORDER BY location, date


-- Total Cases vs Total Deaths
-- Shows the likelyhood of dying if you contract covid in your country

SELECT  
    location, 
    date, 
    total_cases, 
    total_deaths, 
    (total_deaths/total_cases)*100 AS death_percentage
FROM `project-21793.Covid.Covid_deaths`
WHERE location LIKE "%States%"
ORDER BY location, date

SELECT  
    location, 
    date, 
    total_cases, 
    total_deaths, 
    (total_deaths/total_cases)*100 AS death_percentage
FROM `project-21793.Covid.Covid_deaths`
WHERE location LIKE "%States%" AND
    continent is not null
ORDER BY location, date


-- Total Cases vs Population
-- Shows what percentage of population infected with Covid

SELECT  
    location, 
    date, 
    population, 
    total_cases, 
    (total_cases/population)*100 AS percent_population_infected
FROM `project-21793.Covid.Covid_deaths`
ORDER BY location, date


-- Countries with hightest infection rate compared to population

SELECT  
    location, 
    population, 
    MAX(total_cases) as highest_infection_count, 
    MAX((total_cases/population))*100 AS percent_population_infected
FROM `project-21793.Covid.Covid_deaths`
GROUP BY location, population
ORDER BY percent_population_infected DESC


-- Countries with the highest death count per population

SELECT  
    location, 
    MAX(total_deaths) as total_death_count
FROM `project-21793.Covid.Covid_deaths`
WHERE continent is not null
GROUP BY location
ORDER BY total_death_count DESC


-- Breaking data down by continent
-- Continents with highest death count per population

SELECT  
    location, 
    MAX(total_deaths) as total_death_count
FROM `project-21793.Covid.Covid_deaths`
WHERE continent is null
GROUP BY location
ORDER BY total_death_count DESC

SELECT  
    continent, 
    MAX(total_deaths) as total_death_count
FROM `project-21793.Covid.Covid_deaths`
WHERE continent is not null
GROUP BY continent
ORDER BY total_death_count DESC


-- Global numbers

SELECT 
    date, 
    SUM(new_cases) AS total_cases, 
    SUM(new_deaths) AS total_deaths, 
    (SUM(new_deaths)/SUM(new_cases))*100 AS death_percentage
FROM `project-21793.Covid.Covid_deaths`
WHERE continent is not null
GROUP BY date
ORDER BY date, total_cases

SELECT 
    SUM(new_cases) AS total_cases, 
    SUM(new_deaths) AS total_deaths, 
    (SUM(new_deaths)/SUM(new_cases))*100 AS death_percentage
FROM `project-21793.Covid.Covid_deaths`
WHERE continent is not null
ORDER BY total_cases, total_deaths


-- Joining Covid_deaths table and Covid_vaccinations table

SELECT *
FROM `project-21793.Covid.Covid_deaths` dea
JOIN `project-21793.Covid.Covid_vaccinations` vac
    ON dea.location = vac.location
    and dea.date = vac.date


-- Total Population vs Vaccinations
-- Shows percentage of population that has recieved at least one covid vaccine

SELECT 
    dea.continent, 
    dea.location, 
    dea.date, 
    dea.population, 
    vac.new_vaccinations, 
    SUM(vac.new_vaccinations) OVER (Partition by dea.location ORDER BY dea.location, dea.date) AS rolling_vacc_count
FROM `project-21793.Covid.Covid_deaths` dea
JOIN `project-21793.Covid.Covid_vaccinations` vac
    ON dea.location = vac.location
    and dea.date = vac.date
WHERE dea.continent is not null
ORDER BY dea.location, dea.date


-- Use CTE to perform calculation on partition by in previous query

WITH PopvsVac AS
(
  SELECT 
        dea.continent, 
        dea.location, 
        dea.date, 
        dea.population, 
        vac.new_vaccinations,
        SUM(vac.new_vaccinations) OVER (Partition by dea.location ORDER BY dea.location, dea.date) AS rolling_vacc_count,
  FROM `project-21793.Covid.Covid_deaths` dea
  JOIN `project-21793.Covid.Covid_vaccinations` vac
      ON dea.location = vac.location
      and dea.date = vac.date
  WHERE dea.continent is not null
)
SELECT 
      continent,
      location, 
      date, 
      population,
      new_vaccinations,
      rolling_vacc_count,
      (rolling_vacc_count/population)*100
FROM PopvsVac


-- Temp Table

DROP TABLE IF EXISTS Covid.Percent_Population_Vaccinated
CREATE TABLE Covid.Percent_Population_Vaccinated
(
    continent STRING,
    locatoin STRING,
    date DATE,
    population INTEGER,
    new_vaccinations INTEGER,
    rolling_vacc_count INTEGER
)

INSERT INTO Covid.Percent_Population_Vaccinated
    SELECT 
        dea.continent, 
        dea.location, 
        dea.date, 
        dea.population, 
        vac.new_vaccinations,
        SUM(vac.new_vaccinations) OVER (Partition by dea.location ORDER BY dea.location, dea.date) AS rolling_vacc_count,
   FROM `project-21793.Covid.Covid_deaths` dea
   JOIN `project-21793.Covid.Covid_vaccinations` vac
      ON dea.location = vac.location
      and dea.date = vac.date


SELECT *, (rolling_vacc_count/population)*100
FROM `project-21793.Covid.Percent_Population_Vaccinated`


-- Creating view to store data for later visualizations

CREATE VIEW Covid.Percent_Population_Vaccinated AS
  SELECT 
        dea.continent, 
        dea.location, 
        dea.date, 
        dea.population, 
        vac.new_vaccinations,
        SUM(vac.new_vaccinations) OVER (Partition by dea.location ORDER BY dea.location, dea.date) AS rolling_vacc_count
  FROM `project-21793.Covid.Covid_deaths` dea
  JOIN `project-21793.Covid.Covid_vaccinations` vac
      ON dea.location = vac.location
      and dea.date = vac.date
  WHERE dea.continent is not null


-- Table 1 for Tableau visualization

SELECT 
    SUM(new_cases) AS total_cases, 
    SUM(new_deaths) AS total_deaths, 
    (SUM(new_deaths)/SUM(new_cases))*100 AS death_percentage
FROM `project-21793.Covid.Covid_deaths`
WHERE continent is not null
ORDER BY total_cases, total_deaths


-- Table 2 for Tableau visualiztion

SELECT 
    location, 
    SUM(new_deaths) AS total_deaths 
FROM `project-21793.Covid.Covid_deaths`
WHERE continent is null AND
    location NOT IN ("World", "European Union", "International")
GROUP BY location
ORDER BY total_deaths DESC


-- Table 3 for Tableau visualization

SELECT  
    location, 
    population, 
    MAX(total_cases) as highest_infection_count, 
    MAX((total_cases/population))*100 AS percent_population_infected
FROM `project-21793.Covid.Covid_deaths`
GROUP BY location, population
ORDER BY percent_population_infected DESC


-- Table 4 for Tableau visualization

SELECT  
    location, 
    population,
    date, 
    MAX(total_cases) as highest_infection_count, 
    MAX((total_cases/population))*100 AS percent_population_infected
FROM `project-21793.Covid.Covid_deaths`
GROUP BY location, population, date
ORDER BY percent_population_infected DESC


-- Other possibilities for tables
-- Option 1

SELECT 
    location, 
    date,
    population,
    total_cases,
    total_deaths 
FROM `project-21793.Covid.Covid_deaths`
WHERE continent is null
ORDER BY location, date


-- Option 2

WITH PopvsVac AS
(
  SELECT 
        dea.continent, 
        dea.location, 
        dea.date, 
        dea.population, 
        vac.new_vaccinations,
        SUM(vac.new_vaccinations) OVER (Partition by dea.location ORDER BY dea.location, dea.date) AS rolling_vacc_count,
  FROM `project-21793.Covid.Covid_deaths` dea
  JOIN `project-21793.Covid.Covid_vaccinations` vac
      ON dea.location = vac.location
      and dea.date = vac.date
  WHERE dea.continent is not null
)
SELECT 
      continent,
      location, 
      date, 
      population,
      new_vaccinations,
      rolling_vacc_count,
      (rolling_vacc_count/population)*100 AS rolling_vacc_count_percentage
FROM PopvsVac


