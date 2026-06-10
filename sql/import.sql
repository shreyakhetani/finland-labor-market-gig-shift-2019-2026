-- NOTE: Replace <YOUR_PATH> with your local path to the data/cleaned folder

COPY statfin_population(year, category, value_pct, source)
FROM '<YOUR_PATH>\data\cleaned\statfin_population_by_activity_1987_2024.csv'
DELIMITER ','
CSV HEADER;

COPY statfin_employment(category, rate, year, month, source)
FROM '<YOUR_PATH>\data\cleaned\statfin_employment_rate_monthly_2010_2026.csv'
DELIMITER ','
CSV HEADER;

COPY fred_finland_unemployment(unemployment_rate, year, month, source)
FROM '<YOUR_PATH>\data\cleaned\fred_finland_unemployment_monthly_2019_2026.csv'
DELIMITER ','
CSV HEADER;

COPY eurostat_unemployment(geo, geopolitical_entity, obs_value, year, month, source)
FROM '<YOUR_PATH>\data\cleaned\eurostat_unemployment_monthly_eu_2025.csv'
DELIMITER ','
CSV HEADER;

COPY google_trends(search_interest, year, month, search_term, source)
FROM '<YOUR_PATH>\data\cleaned\google_trends_yrittajaksi_2019_2026.csv'
DELIMITER ','
CSV HEADER;

COPY google_trends(search_interest, year, month, search_term, source)
FROM '<YOUR_PATH>\data\cleaned\google_trends_keikkayto_2019_2026.csv'
DELIMITER ','
CSV HEADER;