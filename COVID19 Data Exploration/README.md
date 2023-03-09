# Exploration of the COVID19 data set.
This is a SQL Data Exploration portfolio project.<br>
Data set is retrieved from https://ourworldindata.org/covid-deaths, using dates from 01-01-2020 to 30-11-2022.<br>
This large file is then divided into 2 separate Excel files, one for COVID death and another for COVID vaccinations.<br>
The software used for querying is Microsoft's SQL Server Management Studio.

<details><summary>Click to expand</summary>

## Skills used:
| Functions | Aggregate Functions | Windows Functions | Clauses |
| ------- | ------- | ------- | ------- |
| NULLIF() | MAX() | OVER() | PARTITION BY |
| CAST() | SUM() | | ORDER BY | |
|  |  | | GROUP BY | |

- Common Table Expression (CTE)
- Temp Table
- Create View

## The following are examples of question used to explore the data set:
1. The likelihood of dying if you contract COVID in Singapore
2. The percentage of Singapore population that contracted COVID
3. Comparison between highest infection rate and population of countries
4. Which _countries_ have the highest death count per population
5. Which _continents_ have the highest death count per population
6. What are the global numbers of total cases of COVID, total deaths, and death percentage
7. What is the total population vs vaccinations, including people who continue to be vaccinated
8. Finding the percentage of people who continue to be vaccinated

<!-- CAST  (SUM(CAST(vac.new_vaccinations AS bigint) ) OVER (PARTITION BY dea.location ORDER BY dea.location,
	   dea.date)    AS float) AS ContinuousVaccinatedPeople
the sum of new vaccinations over the same location where location is ordered by location and date to find number of people who continute to be vaccinated -->

</details>

# Exploration of the COVID19 data set for Tableau.
In this file, we have the queries used to create a Tableau dashboard on COVID19 deaths, which can be found below.<br>
After executing each query, the table produced can be exported by either saving the results as a .CSV file 
or by copying the table with headers into Excel and manually saving it as a .XLSX file.

<details><summary>Click to expand</summary>

## What we seek from each query:
1) The global numbers of total cases, total deaths and the death percentage

2) The total death count per continent

3) and 4. The percentage of the population that are infected per country

## Insights gained:
- Globally, from 1 Jan 2020 to 30 Nov 2022, there are 641,528,767 total cases,	6,597,177 total deaths, and a death percentage of 1.03%
- Europe has the highest total death count of 1,981,479 while Oceania has the lowest total death count of 20,848
- In Europe, the country Cyprus has the highest percentage of its population infected at 68.55% <br>
	
## Tableau Dashboard Visualisation
![Dashboard 1](https://user-images.githubusercontent.com/119298843/224124826-dafcc097-40e6-4438-a6ab-8afd6f013355.png) <br>
You can also interact with the location filter on [my tableau public](https://public.tableau.com/views/COVIDDashboard_16755919436880/Dashboard1?:language=en-GB&:display_count=n&:origin=viz_share_link) to change the countries of the population that are infected.

</details>


