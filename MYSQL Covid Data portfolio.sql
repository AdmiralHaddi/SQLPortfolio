--Countries with highest infaction
SELECT 
    location, 
    population, 
    MAX(total_cases) AS HighestInfactionCount, 
    MAX(total_cases/population)* 100 AS PercentagePopulationInfected
FROM coviddeaths
GROUP BY location, population
ORDER BY PercentagePopulationInfected DESC


--Showing the countries with highest death count per population
SELECT location, MAX(total_deaths) AS TotalDeathCount
FROM coviddeaths
GROUP BY location
ORDER BY TotalDeathCount DESC


--Death Count by continent
SELECT continent, MAX(CAST(total_deaths AS float)) AS TotalDeathCount
FROM coviddeaths
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY TotalDeathCount DESC

--Showing percentage
SELECT 
    date, 
    SUM(new_cases) AS total_cases, 
    SUM(new_deaths) AS total_deaths, 
    SUM(new_deaths)/SUM(new_cases) * 100 AS deatheercentage
FROM coviddeaths
WHERE continent IS NOT NULL
GROUP BY date
ORDER BY 1,2

--Final data
SELECT 
    death.continent, 
    death.location, 
    death.date, 
    death.population, 
    vaccine.new_vaccinations, 
    SUM( vaccine.new_vaccinations) OVER (PARTITION BY death.location ORDER BY death.location,death.date) AS PeopleVaccinated, 
    (SUM(vaccine.new_vaccinations) OVER (PARTITION BY death.location ORDER BY death.date) / death.population) AS Percentage
    
FROM coviddeaths AS death
JOIN covidvaccinations AS vaccine
    ON death.location = vaccine.location
    AND death.date = vaccine.date
WHERE death.continent IS NOT NULL