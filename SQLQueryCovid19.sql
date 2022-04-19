Select *
From PortfolioProject1..CovidDeath
Where continent is not null
Order by 3,4

Select *
From PortfolioProject1..covidVaccination
Order by 3,4

Select Location, date, total_cases, new_cases, total_deaths, population 
From PortfolioProject1..CovidDeath
Where continent is not null
Order by 1,2

Select Location, date, total_cases, total_deaths, (Total_deaths/total_cases)*100 as DeathPercentage
From PortfolioProject1..CovidDeath
where location like '%Indonesia%'
and continent is not null
Order by 1,2



Select Location, date, population, total_cases, (total_cases/population)*100 as PercentPopulationInfected
From PortfolioProject1..CovidDeath
where location like '%Indonesia%'
Order by 1,2

Select Location, date, population, total_cases, (total_cases/population)*100 as PercentPopulationInfected
From PortfolioProject1..CovidDeath
--where location like '%Indonesia%'
Order by 1,2


Select Location, population, MAX(total_cases) as HighestInfectionCount, Max((total_cases/population))*100 as PercentPopulationInfected
From PortfolioProject1..CovidDeath
--where location like '%Indonesia%'
Group by Location, Population
Order by PercentPopulationInfected desc

Select Location, MAX(cast(total_deaths as bigint)) as TotalDeathCount
From PortfolioProject1..CovidDeath
--where location like '%Indonesia%'
Where continent is not null
Group by Location
Order by TotalDeathCount desc

Select continent, MAX(cast(total_deaths as int)) as TotalDeathCount
From PortfolioProject1..CovidDeath
--where location like '%Indonesia%'
Where continent is not null
Group by continent
Order by TotalDeathCount desc


Select date, Sum(new_cases) as total_cases, Sum(cast(new_deaths as bigint)) as total_deaths, SUM(cast(new_deaths as bigint))/SUM(new_cases)*100 as DeathPercentage
From PortfolioProject1..CovidDeath
--where location like '%Indonesia%'
where continent is not null
Group by date
Order by 1,2

Select Sum(new_cases) as total_cases, Sum(cast(new_deaths as bigint)) as total_deaths, SUM(cast(new_deaths as bigint))/SUM(new_cases)*100 as DeathPercentage
From PortfolioProject1..CovidDeath
--where location like '%Indonesia%'
where continent is not null
Order by 1,2


Select *
From PortfolioProject1..CovidDeath dea
Join PortfolioProject1..covidVaccination vac
on dea.location = vac.location
and dea.date = vac.date


Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
From PortfolioProject1..CovidDeath dea
Join PortfolioProject1..covidVaccination vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
order by 2,3

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (Partition by dea.Location order by dea.Location, dea.Date) as RollingPeopleVaccinated
From PortfolioProject1..CovidDeath dea
Join PortfolioProject1..covidVaccination vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
order by 2,3


With PopvsVac (continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated) 
as 
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (Partition by dea.Location order by dea.Location, dea.Date) as RollingPeopleVaccinated
From PortfolioProject1..CovidDeath dea
Join PortfolioProject1..covidVaccination vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
--order by 2,3
)
Select *
From PopvsVac


With PopvsVac (continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated) 
as 
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (Partition by dea.Location order by dea.Location, dea.Date) as RollingPeopleVaccinated
From PortfolioProject1..CovidDeath dea
Join PortfolioProject1..covidVaccination vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
--order by 2,3
)
Select *, (RollingPeopleVaccinated/Population)*100
From PopvsVac


--TEMP TABLE

Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
date datetime,
Population numeric,
New_vacinnactions nvarchar(255),
RollingPeopleVaccinated numeric
)

Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (Partition by dea.Location order by dea.Location, dea.Date) as RollingPeopleVaccinated
From PortfolioProject1..CovidDeath dea
Join PortfolioProject1..covidVaccination vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
--order by 2,3

Select *,(RollingPeopleVaccinated/Population)*100
From #PercentPopulationVaccinated


--Create view

Create view PopvsVac as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (Partition by dea.Location order by dea.Location, dea.Date) as RollingPeopleVaccinated
From PortfolioProject1..CovidDeath dea
Join PortfolioProject1..covidVaccination vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
--order by 2,3