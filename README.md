# Portfolio Project Four Part Series 
#### Inspired by [Alex the Analyst](https://www.youtube.com/c/alextheanalyst)
-------------------------------------
<p>&nbsp;</p>

# Introduction
This is an excellent project for anyone new to data analytics. My goal for this portfolio project was to highlight my diverse skills and experience, along with the projects I’ve worked on.

## What's in This Portfolio
* **Part 1** - Data Exploration with SQL
* **Part 2** - Data Visuzlization with Tableau
* **Part 3** - Data Cleaning with SQL
* **Part 4** - Correlation in Python (Coming Soon)

## Resources
Datasets:
1. Covid-19 ([Deaths](https://www.youtube.com/redirect?event=video_description&redir_token=QUFFLUhqbUFBZ1EzQWRDYTZIVWNodm5hQ2lsV2pnXzJnZ3xBQ3Jtc0trX3BKaF90akFUcEotckZmTWpVS1NmdGhRZmZ4dlQ4Wjk3OXZoVGE0X1BfVlhMOTNGQjA2ZzlOd3F1YkFnU2UtOW43TG43MGVWSVBka1VDdjZXWnh4dU0xdEZmd1gwODNhRDhKeWxaaGRjcjBJa2x6SQ&q=https%3A%2F%2Fgithub.com%2FAlexTheAnalyst%2FPortfolioProjects%2Fblob%2Fmain%2FCovidDeaths.xlsx&v=qfyynHBFOsM) and [Vaccinations](https://www.youtube.com/redirect?event=video_description&redir_token=QUFFLUhqbXZycVpYM09UeF9oaFZXbHVlR1pVaFhiekhlZ3xBQ3Jtc0tuSkpRLWQ3TW5vN1k1OFYxc05SaHFvTkRJUXZic0JoT0x2Y3BmR1E0TDk3ZjFVNlRGYm05OUIwZm1uREVDNzZhNjZQYnRpczdSTjZHbDdwamJWaVI3alY1Tmk2S2pITXA0QlNEWUZLUUVzaF81SlJnTQ&q=https%3A%2F%2Fgithub.com%2FAlexTheAnalyst%2FPortfolioProjects%2Fblob%2Fmain%2FCovidVaccinations.xlsx&v=qfyynHBFOsM))
2. [Nashville Housing Data](https://github.com/AlexTheAnalyst/PortfolioProjects/blob/main/Nashville%20Housing%20Data%20for%20Data%20Cleaning.xlsx)
3. Movie Industry

# Part 1 - Data Exploration in BigQuery 
#### [SQL Code](https://github.com/AliciaMay/Portfolio-project/commit/39c5defe2b6524f5a8b57bad174f392939004bba)

**Skills used:** Joins, CTEs, Temp Tables, Window Functions, Aggregate Functions, Creating Views, Converting Data Types

Given the provided Covid-19 dataset to explore, here is a brief description of the most insightful topics chosen to further analyze with visualizations in part 2.

* death_percentage - (total_deaths/total_cases)
* total_deaths - SUM(new_deaths)
* percent_population_infected - (total_cases/population)
* percent_population_infected - MAX((total_cases/population))
* highest_infection_count - MAX(total_cases)

# Part 2 - Data Visualization in Tableau 
#### [Dashboard](https://public.tableau.com/views/GlobalCovid_16548842774390/Dashboard1?:language=en-US&:display_count=n&:origin=viz_share_link)

Here's a quick rundown of what was done to complete the data visualization project.

* Downloaded and saved sql results as individual .xlsx sheets.
* Created a new viz and uploaded each .xlsx as a data source for individual Tableau sheets.
* Filtered data down, formatted, and designed each sheet.
* Created a dashboard and made final design adjustments to develop a final product.

<div align="center">
  <img src="https://user-images.githubusercontent.com/105527562/175824796-e8a93d18-274a-4e7d-9df8-fcc7d67d4712.png" width="650"/>
</div>

# Part 3 - Data Cleaning in BigQuery 
#### [SQL Code](https://github.com/AliciaMay/Portfolio-project/commit/5f47d10eefbcc2b1a2011d81984edbba63a0c3a5)

**Skills used:** Joins, CTEs, Window Functions, String Manipulation

Upon converting the .xlsx to .csv and uploading the dataset into BigQuery, the process was canceled due to too many errors. After investigating the errors further, I found three rows where the address had been duplicated above each other. These rows were deleted in the .csv sheet and then uploaded into BigQuery with no other errors. 

Here is a brief explanation of the dataset's preparation, formatting, and updating steps.

* Standardized date format - FORMAT_DATE('%F', PARSE_DATE('%B %e, %Y', sale_date))
* Separate out property_address into individual columns - SPLIT(property_address, ",")[OFFSET(0)]
* Found duplicate rows - WITH RowNumCTE AS (SELECT, ROW_NUMBER() OVER (PARTITION BY
* Deleted duplicate rows - CREATE OR REPLACE TABLE
* Deleted unused columns (not recommended) - ALTER TABLE `dataset.table_name` DROP COLUMN owner_address
<p>&nbsp;</p>

*Thank you for reading to the end!*


