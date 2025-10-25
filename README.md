# 🦠 COVID-19 Data Analysis using SQL and Excel

## 📘 Project Overview
This project focuses on **analyzing global COVID-19 data** using **Microsoft Excel** and **SQL Server**.  
The goal was to extract meaningful insights such as infection rates, death percentages, and vaccination progress — by cleaning, importing, and querying large datasets efficiently.

---

## 🧩 Tools and Technologies
- **Microsoft Excel** — for data preparation and cleaning  
- **Microsoft SQL Server / SSMS** — for data import, transformation, and analysis  
- **SQL (T-SQL)** — for querying and calculations  

---

## ⚙️ Project Workflow

### 1. Data Collection
- Downloaded COVID-19 datasets (`CovidDeaths.xlsx` and `Vaccination.xlsx`) from trusted public sources (e.g., Our World in Data).
- Verified structure and consistency before import.

### 2. Data Import
- Imported Excel data into **SQL Server** using:
  - *SQL Server Import and Export Wizard*, or  
  - `OPENROWSET()` query for large datasets.
- Created separate tables:
  - `CovidDeaths`
  - `Vaccination`

### 3. Data Cleaning
- Checked for missing and duplicate values.
- Standardized data types (e.g., `date`, `nvarchar`, `numeric`).
- Removed aggregated or null continents.

### 4. SQL Analysis
Performed analytical queries to explore and understand the pandemic trends.

#### Examples:
- **Death Percentage**
  ```sql
  SELECT 
      location, 
      date, 
      total_cases, 
      (total_deaths / total_cases) * 100 AS DeathPercentage
  FROM CovidDeaths
  WHERE continent IS NOT NULL;
