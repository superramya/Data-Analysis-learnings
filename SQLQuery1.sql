SELECT *
FROM RamyaPortfolio..CovidDeaths
WHERE continent is not null
ORDER BY 3,4

SELECT *
FROM RamyaPortfolio..CovidVaccinations
WHERE continent is not null
ORDER BY 3,4

SELECT Location, date, total_cases, new_cases, total_deaths, population
FROM RamyaPortfolio..CovidDeaths
WHERE continent is not null
ORDER By 1,2

--Looking at total deaths and total cases percentage

SELECT Location, date, total_cases, total_deaths, (cast(total_deaths as float)/cast(total_cases as float))*100 as DeathPercentage
FROM RamyaPortfolio..CovidDeaths
WHERE continent is not null
ORDER By 1,2

--Looking at the population that is infected

SELECT Location, date, total_cases, population, (total_cases/population)*100 as InfectedPercentage
FROM RamyaPortfolio..CovidDeaths
WHERE location like '%india%' and continent is not null
ORDER By 1,2

--Looking at the maximum cases and infected population

SELECT Location, population, MAX(total_cases) as HighestInfected, MAX((cast(total_cases as int)/population))*100 as InfectedPercentage
FROM RamyaPortfolio..CovidDeaths
WHERE continent is not null
GROUP BY Location, population
ORDER By InfectedPercentage desc

--Looking at highest number of deaths

SELECT Location, MAX(cast(total_deaths as int)) as totalDeathCount
FROM RamyaPortfolio..CovidDeaths
WHERE continent is not null
GROUP BY Location
ORDER By totalDeathCount desc

--Looking at the data that is continent based

SELECT location, MAX(cast(total_deaths as int)) as totalDeathCount
FROM RamyaPortfolio..CovidDeaths
WHERE continent is null
GROUP BY location
ORDER By totalDeathCount desc

--showing continent data with highest deaths

SELECT continent, MAX(cast(total_deaths as int)) as totalDeathCount
FROM RamyaPortfolio..CovidDeaths
WHERE continent is not null
GROUP BY continent
ORDER By totalDeathCount desc

--Global numbers

SELECT date, SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths
FROM RamyaPortfolio..CovidDeaths
WHERE continent is not null
GROUP BY date
ORDER By 1,2

SELECT SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths
FROM RamyaPortfolio..CovidDeaths
WHERE continent is not null
--GROUP BY date
ORDER By 1,2

--Joining two tables deaths and vaccinations

SELECT *
FROM RamyaPortfolio..CovidDeaths as death
Join RamyaPortfolio..CovidVaccinations as vacctn
	ON death.location = vacctn.location
	and death.date = vacctn.date

--Looking at Total population vs Vaccinations

SELECT death.continent, death.location, death.date, death.population, vacctn.new_vaccinations
FROM RamyaPortfolio..CovidDeaths as death
Join RamyaPortfolio..CovidVaccinations as vacctn
	ON death.location = vacctn.location
	and death.date = vacctn.date
WHERE death.continent is not null
ORDER BY 2,3

SELECT death.continent, death.location, death.date, death.population, vacctn.new_vaccinations
, SUM(cast(vacctn.new_vaccinations as bigint)) OVER (PARTITION BY death.location ORDER BY death.location, death.date) as RollingPopulnVaccinated
FROM RamyaPortfolio..CovidDeaths as death
Join RamyaPortfolio..CovidVaccinations as vacctn
	ON death.location = vacctn.location
	and death.date = vacctn.date
WHERE death.continent is not null
ORDER BY 2,3

-- USE CTE - temporary table, people vaccinated

with popnvac (continent, location, date, population, new_vaccinations, RollingPopulnVaccinated)
as
(
SELECT death.continent, death.location, death.date, death.population, vacctn.new_vaccinations
, SUM(cast(vacctn.new_vaccinations as bigint)) OVER (PARTITION BY death.location ORDER BY death.location, death.date) as RollingPopulnVaccinated
FROM RamyaPortfolio..CovidDeaths as death
Join RamyaPortfolio..CovidVaccinations as vacctn
	ON death.location = vacctn.location
	and death.date = vacctn.date
WHERE death.continent is not null
)
SELECT *, (RollingPopulnVaccinated/population)*100 as popvacpercentage
FROM popnvac

--Temp table

DROP TABLE if exists #PopVacPercent
CREATE TABLE #PopVacPercent
(
continent nvarchar(200),
location nvarchar(200),
date datetime,
population numeric,
new_vaccinations numeric,
RollingPopulnVaccinated numeric
)
INSERT INTO #PopVacPercent
SELECT death.continent, death.location, death.date, death.population, vacctn.new_vaccinations
, SUM(cast(vacctn.new_vaccinations as bigint)) OVER (PARTITION BY death.location ORDER BY death.location, death.date) as RollingPopulnVaccinated
FROM RamyaPortfolio..CovidDeaths as death
Join RamyaPortfolio..CovidVaccinations as vacctn
	ON death.location = vacctn.location
	and death.date = vacctn.date
WHERE death.continent is not null
SELECT *, (RollingPopulnVaccinated/population)*100 as popvacpercentage
FROM #PopVacPercent

-- working on view

CREATE VIEW Percentageofpopvac as
SELECT death.continent, death.location, death.date, death.population, vacctn.new_vaccinations
, SUM(cast(vacctn.new_vaccinations as bigint)) OVER (PARTITION BY death.location ORDER BY death.location, death.date) as RollingPopulnVaccinated
FROM RamyaPortfolio..CovidDeaths as death
Join RamyaPortfolio..CovidVaccinations as vacctn
	ON death.location = vacctn.location
	and death.date = vacctn.date
WHERE death.continent is not null

SELECT *
FROM Percentageofpopvac

