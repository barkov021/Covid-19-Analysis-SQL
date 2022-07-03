
 -- Looking at death rate in the US 
SELECT Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS DeathPercentage 
FROM coviddeath
WHERE location like '%states%';

-- Looking at what percentage of populatiuon got COVID

SELECT Location, date, total_cases, population, total_deaths, (total_cases/population)*100 AS PercentOfPopulationInfected
FROM coviddeath
WHERE location like '%states%';


-- Looking at countries  with highest infection rate compared to population 

SELECT Location,  MAX(total_cases) AS HighestInfectionCount, population,  (MAX(total_cases)/population)*100 AS PercentOfPopulationInfected
FROM coviddeath
WHERE continent IS NOT NULL
GROUP BY location, population
ORDER BY 4 desc; 

-- Show countries with the highest death rate

SELECT Location,  MAX(total_deaths)  AS TotalDeath, population,  (MAX(total_deaths)/population)*100 AS DeathRate
FROM coviddeath
WHERE continent IS NOT NULL
GROUP BY location, population
ORDER BY 4 desc; 

-- Calculate global death percent 

SELECT SUM(new_cases) AS total_cases, SUM(new_deaths) AS total_deaths,  (SUM(new_deaths)/SUM(new_cases))*100 AS DeathPercentage
FROM coviddeath 
WHERE continent IS NOT NULL ;

-- Looking at total population VS vaccinations
With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
SELECT coviddeath.location, coviddeath.continent, coviddeath.date, coviddeath.population,  covidvaccination.new_vaccinations, SUM(covidvaccination.new_vaccinations) OVER (Partition by coviddeath.Location Order by coviddeath.location, coviddeath.Date)
 as RollingPeopleVaccinated
FROM coviddeath coviddeath 
JOIN covidvaccination 
	ON  coviddeath.location = covidvaccination.location
WHERE COVIDDEATH.continent IS NOT NULL
ORDER BY 2, 3
)
Select *, (RollingPeopleVaccinated/Population)*100
From PopvsVac; 



-- Creating view for future use

DROP VIEW IF EXISTS PercentPopulationVaccinated ;
CREATE  view 
PercentPopulationVaccinated as 
SELECT coviddeath.location, coviddeath.continent, coviddeath.date, coviddeath.population,  covidvaccination.new_vaccinations, SUM(covidvaccination.new_vaccinations) OVER (Partition by coviddeath.Location Order by coviddeath.location, coviddeath.Date)
 as RollingPeopleVaccinated
FROM coviddeath coviddeath 
JOIN covidvaccination 
	ON  coviddeath.location = covidvaccination.location
WHERE COVIDDEATH.continent IS NOT NULL;



