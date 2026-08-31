# Climate Patterns Across Sri Lanka (2000–2025)

A SQL & Python data analysis case study exploring temperature and rainfall trends across six Sri Lankan cities using 26 years of real climate data.

## Overview

This project turns raw NASA satellite climate data into a structured, queryable dataset, then uses SQL and data visualization to answer real questions about Sri Lanka's weather patterns:

- How does temperature vary by city and geography?
- When do the monsoon seasons show up in the rainfall data?
- Are cities warming or cooling over time?
- Is there a relationship between temperature and rainfall?

## Data Source

- **NASA POWER API** (Prediction of Worldwide Energy Resources) — monthly climate data by coordinates
- **Cities:** Anuradhapura, Batticaloa, Colombo, Jaffna, Kandy, Matara
- **Time range:** 2000–2025
- **Parameters:** T2M (temperature, °C), RH2M (relative humidity, %), PRECTOTCORR (corrected precipitation, mm)

## Methodology

1. **Data collection** — downloaded monthly CSV exports per city from NASA POWER
2. **Data cleaning (Python/pandas)** — dynamic header detection to handle variable-length metadata blocks in the raw files
3. **Data reshaping** — converted wide-format data (months as columns) into long-format data (one row per city/parameter/year/month) using `pandas.melt()`
4. **Database** — loaded into PostgreSQL via SQLAlchemy
5. **Analysis (SQL)** — `GROUP BY` aggregations, window functions (`LAG`/`PARTITION BY`), `CASE` statements for custom month ordering, and self-joins to combine temperature and rainfall into a single row per city/month/year
6. **Visualization** — built in both Tableau Public and Microsoft Power BI

## Key Findings

**Temperature varies strongly by geography** — Jaffna (northern dry zone) is the warmest city on average, while Kandy (hill country) is the coolest, with a roughly 3°C spread driven mainly by elevation.

**Rainfall reveals Sri Lanka's dual monsoon system** — nearly all cities show a sharp rainfall peak around October–November (northeast monsoon), while Colombo shows a distinct second peak in April–May tied to the southwest monsoon and its coastal position. June–July is consistently the driest period.

**Warming/cooling trends differ by city** — comparing 2000–2012 against 2013–2025, Colombo shows a modest warming trend (possibly linked to urban development), while Badulla shows a slight cooling trend — suggesting local factors matter more than a single uniform national trend.

**Temperature and rainfall are not simply correlated** — a city-level comparison shows no clean linear relationship; rainfall appears to be driven more by monsoon exposure and coastal position than by temperature alone.

*(See the findings document for full tables and detailed discussion.)*

## Dashboard

[📊 View the Power BI Dashboard (PDF)](Climate%20Patterns%20Across%20Sri%20Lanka%20(2000-2025).pdf)

The dashboard includes four charts: average temperature by city, monthly rainfall pattern (monsoon detection), year-over-year temperature trend, and a temperature-vs-rainfall scatter plot.

## Tools & Skills

| Category | Details |
|---|---|
| **Python** | pandas (`read_csv`, `melt`, `groupby`), dynamic file parsing, SQLAlchemy |
| **SQL** | `GROUP BY`, aggregate functions, `WHERE` filtering, `CASE` statements, window functions (`LAG`/`PARTITION BY`), self-joins |
| **Database** | PostgreSQL |
| **Visualization** | Tableau Public, Microsoft Power BI |

## Repository Structure

```
├── weather.ipynb                                  → Python data cleaning & reshaping
├── weather_sri_lanka.sql                          → SQL analysis queries
├── anuradhapura.csv, batticaloa.csv, colombo.csv,
│   jaffna.csv, kandy.csv, matara.csv              → Raw NASA POWER data per city
├── Climate Patterns Across Sri Lanka (2000-2025).pdf         → Power BI dashboard export
└── Climate Patterns Across Sri Lanka (2000-2025) - Findings Document.docx → Full written findings
```

## Possible Next Steps

- Incorporate humidity (RH2M) analysis
- Extend the trend analysis with statistical significance testing
- Cross-reference known flood/drought years as outliers
- Combine all charts into a single interactive dashboard
