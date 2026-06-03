
CREATE TABLE taxi_licences (
    taxi_id             SERIAL PRIMARY KEY,
    number_of_licences  INT NOT NULL,
    year                INT NOT NULL,
    month               INT NOT NULL,
    source              VARCHAR(20)
);
CREATE TABLE statfin_population (
    population_id       SERIAL PRIMARY KEY,
    year                INT NOT NULL,
    category            VARCHAR(50),
    value_pct           DECIMAL(4,1),
    source              VARCHAR(20)
);
CREATE TABLE statfin_employment (
    employment_id       SERIAL PRIMARY KEY,
    category            VARCHAR(50),
    rate                DECIMAL(4,1),
    year                INT NOT NULL,
    month               INT NOT NULL,
    source              VARCHAR(20)
);
CREATE TABLE fred_finland_unemployment (
    unemployment_id     SERIAL PRIMARY KEY,
    unemployment_rate   DECIMAL(4,1),
    year                INT NOT NULL,
    month               INT NOT NULL,
    source              VARCHAR(20)
);
CREATE TABLE eurostat_unemployment (
    unemployment_id     SERIAL PRIMARY KEY,
    geo                 VARCHAR(10),
    geopolitical_entity VARCHAR(50),
    obs_value           DECIMAL(6,1),
    year                INT NOT NULL,
    month               INT NOT NULL,
    source              VARCHAR(20)
);
CREATE TABLE google_trends (
    trend_id            SERIAL PRIMARY KEY,
    search_interest     INT NOT NULL,
    year                INT NOT NULL,
    month               INT NOT NULL,
    search_term         VARCHAR(50),
    source              VARCHAR(20)
);



