-- =============================================================
-- Project: Finland Labor Market & Gig Economy Shift (2019-2026)
-- File: queries.sql
-- Author: Shreya Khetani
-- Description: 11 analysis queries exploring the relationship 
--              between rising unemployment and gig economy 
--              participation in Finland (2019-2026)
-- Data Sources: FRED/OECD, Statistics Finland, Traficom, 
--               Google Trends, Eurostat
-- =============================================================

1. How did Finland's unemployment rate change year by year 2019–2026?

-- Finding: Pre-COVID baseline was 6.8% in 2019. COVID pushed it to 7.8% in 2020.
-- Brief recovery in 2021-2022, then a second wave of rises from 2023 onwards.
-- 2026 is the highest point at 10.4% - worse than COVID peak.
-- Why it matters: Unlike COVID which was a temporary external shock, the post-2022 
-- rise is structural -- driven by construction sector collapse, tech layoffs and 
-- geopolitical headwinds, making recovery significantly harder.

	SELECT  
		year,
		ROUND(AVG(unemployment_rate), 1 )
	FROM fred_finland_unemployment
	GROUP BY year
	ORDER BY year;

2. How did taxi licences grow over time?

-- Finding: Sharp spike in late 2018 due to Finnish taxi market deregulation.
-- Peak in 2019 at 12,332 licences. Declined post-2021 as market stabilized.
-- COVID had minimal impact on taxi registrations compared to deregulation effect.
-- Why it matters: The deregulation spike shows that policy changes can flood the 
-- gig market independently of unemployment -- meaning licence numbers reflect 
-- regulation history more than actual worker desperation.

	SELECT 
		month, year, number_of_licences
	FROM taxi_licences
	ORDER BY year, month;

3.How did gig work search interest trend over time?

-- 'keikkatyö' (gig work) searches nearly doubled from 35.8 in 2019 to 80.3 in 2024, 
-- closely mirroring the rise in unemployment over the same period.
-- 'yrittäjäksi' (become entrepreneur) searches declined steadily from 77.8 in 2019 
-- to 39.6 in 2026 -- suggesting people are seeking survival income through gig work 
-- rather than confidently starting businesses.
-- Why it matters: The divergence between these two search terms tells the real story --
-- people are not choosing gig work, they are being pushed into it as traditional 
-- employment opportunities disappear.

	SELECT 
		search_term,
		year,
		ROUND(AVG(search_interest),1) as avg_search_interest 
	FROM google_trends
	GROUP BY year, search_term
	ORDER BY year,search_term;

4.How did the yearly employment rate trend over time?

-- Finding: Employment rate was 76.0% in 2019 pre-COVID baseline.
-- COVID caused a dip to 75.2% in 2020, followed by a strong recovery peaking at 78.2% in 2022.
-- From 2023 onwards employment rate declined consistently, reaching 74.8% in 2026 
-- the lowest point in the entire dataset, even below COVID levels.
-- This aligns with the unemployment rate hitting 10.4% in 2026, confirming Finland's 
-- current job market is worse than during the COVID period.
-- Why it matters: The 2022 peak followed by a sharp reversal suggests Finland's 
-- labor market recovery was real but fragile -- vulnerable to the construction crisis 
-- and export demand collapse that followed ECB rate hikes.

	SELECT 
		category,
		year,
		Round(AVG(rate), 1) as avg_rate
	FROM statfin_employment
	WHERE category = 'Employment rate'
	GROUP BY year, category
	ORDER BY year;

4b.Finland employment rate monthly detail (2019-2026)

-- Finding: Clear seasonal pattern visible every year -- employment peaks in May-June 
-- and dips in January-February regardless of economic conditions.
-- Highest employment rates were recorded in 2022-2023 reaching up to 79% in June.
-- From mid-2023 onwards a consistent decline is visible month by month, with 2026 
-- showing the lowest monthly readings of the entire dataset.
-- Monthly detail confirms the yearly trend, Finland's labor market has been 
-- deteriorating steadily since its 2022 peak.
-- Why it matters: The seasonal pattern makes mid-2023 more significant -- the decline 
-- started even during what should have been the peak employment months, confirming 
-- the deterioration was structural not seasonal.

	SELECT 
		category,
		month,
		year,
		Round(AVG(rate), 1) as avg_rate
	FROM statfin_employment
	WHERE category = 'Employment rate'
	GROUP BY year,month, category
	ORDER BY year, month;

5.Population activity breakdown
-- employed vs outside labour force (2019-2024)
-- Finding: While the unemployed share rose from 4.7% to 5.7%, the share of people 
-- outside the labour force entirely also crept up from 3.2% to 3.3%.
-- This suggests some workers stopped job searching altogether -- meaning the 
-- unemployment rate may slightly understate the true extent of labor market weakness.
-- Note: Data only available until 2024 from stat.fi

	SELECT
        year,
        ROUND(MAX(CASE WHEN category = 'Employed' THEN value_pct END), 1) AS employed_pct,
        ROUND(MAX(CASE WHEN category = 'Unemployed' THEN value_pct END), 1) AS unemployed_pct,
        ROUND(MAX(CASE WHEN category = 'Other persons outside the labour force' THEN value_pct END), 1) AS outside_labour_force_pct
    FROM statfin_population
    GROUP BY year
    ORDER BY year;

6. Unemployment vs gig search interest side by side by year

-- Finding: A clear correlation between unemployment and keikkatyö (gig work) searches, 
-- especially from 2022 onwards -- as unemployment rose from 6.8% to 10.4%.
-- Gig work searches nearly doubled from 35.8 to 80.3 in 2024.
-- Note: 2026 only covers 4 months so direct year comparison is not fully fair, 
-- however at 64.6 search interest it remains elevated -- similar to 2022 levels 
-- when the gig search trend first started accelerating.
-- Contrasting trend: yrittäjäksi (become entrepreneur) searches declined consistently 
-- from 77.8 in 2019 to 39.6 in 2026, suggesting that rising unemployment is reducing
-- people's confidence and purchasing power to start new businesses.
-- Why it matters: The divergence between these two search terms tells the real story --
-- people are not choosing gig work, they are being pushed into it as traditional 
-- employment opportunities disappear.

	SELECT 
		fred_finland_unemployment.year,
		ROUND(AVG(fred_finland_unemployment.unemployment_rate),1) AS avg_Unemployment, 
		ROUND(AVG(google_trends.search_interest),1) as avg_gig_search_interest, 
		google_trends.search_term
	FROM fred_finland_unemployment
	JOIN google_trends ON fred_finland_unemployment.year = google_trends.year
	GROUP BY fred_finland_unemployment.year, google_trends.search_term
	ORDER BY fred_finland_unemployment.year; 

7. Unemployment vs taxi licence growth side by side

-- Finding: Taxi licence numbers declined consistently from 12,332 in 2019 to 9,860 
-- in 2023 despite fluctuating unemployment rates over the same period.
-- However this decline is largely explained by a market correction following Finland's 
-- 2018 taxi deregulation boom, rather than people leaving gig work.
-- Limitation: Traficom data only available until 2023, making it impossible to compare 
-- with the 2024-2026 period when unemployment reached its highest levels.
-- Conclusion: Taxi licences alone are not a reliable proxy for gig economy participation. 
-- Google Trends keikkatyö data is a stronger indicator of actual gig work interest.
-- Why it matters: This is an important methodological finding -- it shows why using 
-- multiple data sources matters. A single source would have told the wrong story.
	SELECT 
		fu.year,
		ROUND(AVG(fu.unemployment_rate), 1) AS avg_unemplyment_rate,
		tl.number_of_licences

	FROM fred_finland_unemployment fu
	JOIN taxi_licences tl ON fu.year = tl.year
	GROUP BY fu.year, tl.number_of_licences
	ORDER BY fu.year;

8.Finland vs neighboring countries monthly unemployment comparison (2025-2026)

-- Finding: Finland's unemployment rose consistently from 9.7% in July 2025 to 11.2% in April 2026, a 15.5% increase in just 10 months.
-- Neighbouring countries (DE, FR, SE, DK, EE, LV, LT) rose from 6.9% to 8.6% over the same period a 24.6% relative increase.
-- While Finland's absolute unemployment numbers remain significantly higher, the rate of increase is actually faster in neighbouring countries.
-- This suggests the current labor market downturn is a broader European trend, not just a Finland-specific problem.
-- Note: Eurostat data only available from July 2025 onwards in this dataset.


	SELECT 
		year,
		month,
		ROUND(AVG(CASE WHEN geo = 'FI' AND obs_value < 30 THEN obs_value END), 1) AS finland_unemployment,
		ROUND(AVG(CASE WHEN geo IN ('DE', 'FR', 'SE', 'DK', 'EE', 'LV', 'LT') 
				AND obs_value < 30 THEN obs_value END), 1) AS neighboring_countries_avg
	FROM eurostat_unemployment
	GROUP BY year, month
	ORDER BY year, month;

9. Year over year change in Finland unemployment rate (2019-2026)

-- Finding: The biggest single year jump was in 2025 (+1.3%) followed by 2024 (+1.2%), confirming the post-2022 deterioration as the most severe period in the dataset.
-- After a COVID recovery low of 6.8% in 2022, unemployment rose continuously, reaching EU-highest levels by 2025-2026.

-- Notable: 2021 and 2022 showed negative change (-0.2 and -0.8) confirming a genuine recovery was underway before structural issues reversed the trend in 2023.
-- This makes the post-2022 reversal more significant -- it interrupted a real recovery.

-- Key drivers behind the post-2022 rise (sourced from Nordea, YLE, Bank of Finland):
-- 1. Construction Crisis: ECB rapid rate hikes to curb inflation devastated residential construction, causing sector vacancies to drop by nearly half.
-- 2. Government Policy: Austerity measures and cuts to unemployment benefits pushed more people into active job seeking in a market with heavily reduced openings.
-- 3. Geopolitical Impact: Russia-Ukraine war triggered prolonged recession, soaring inflation and sluggish Eurozone growth reduced consumer confidence and overall demand in Finland's export-dependent economy.
-- 4. Tech Sector Layoffs: Nokia and other Finnish tech companies made significant workforce reductions in 2023-2024, adding white-collar unemployment on top of the construction crisis -- hitting two major sectors simultaneously.

	WITH yearly_unemployment AS (
		SELECT 
			year,
			ROUND(AVG(unemployment_rate), 1) AS avg_unemployment
		FROM fred_finland_unemployment
		GROUP BY year
	)
	SELECT 
		year,
		avg_unemployment,
		LAG(avg_unemployment) OVER (ORDER BY year) AS previous_year,
		ROUND(avg_unemployment - LAG(avg_unemployment) OVER (ORDER BY year), 1) AS year_over_year_change
	FROM yearly_unemployment
	ORDER BY year;

10. Gig search interest during high vs low unemployment years

-- Finding: During High unemployment years (2020, 2021, 2024, 2025, 2026)
-- keikkatyö (gig work) search interest averaged significantly higher compared to Low unemployment years (2019, 2022, 2023).
-- Peak keikkatyö interest of 80.3 was recorded in 2024 a High unemployment year.
-- people search for gig work more actively when traditional employment opportunities are scarce.
--
-- Contrasting trend: yrittäjäksi (entrepreneur) searches are higher during Low unemployment years, confirming people only consider starting businesses when they feel financially secure.
--
-- Key drivers behind High unemployment periods:
-- 1. COVID shock (2020-2021): Sudden economic freeze across all sectors.
-- 2. Construction crisis (2024-2026): Interest rate hikes caused sector unemployment of 14-16%, one of the hardest hit industries in Finland.
-- 3. IT sector slowdown: Junior and generalist tech roles saw 6-7% unemployment as AI automation and VC funding cuts reduced demand.
-- 4. Increased labor supply: Growing labor force participation outstripped subdued job demand, keeping unemployment structurally elevated.
-- 5. Structural mismatches: Regional and skill-based gaps concentrated unemployment  among vulnerable groups in high cost areas like Helsinki.
--
-- Conclusion: High unemployment periods consistently drive people toward gig work 
-- as a survival mechanism, while low unemployment periods restore confidence 
-- and interest in entrepreneurship.

	SELECT 
			fu.year, 
			ROUND(AVG(fu.unemployment_rate), 1) as avg_unemployment_rate,
			ROUND(AVG(gt.search_interest),1) AS avg_search_interest,  
			gt.search_term,
				
			CASE WHEN ROUND(AVG(fu.unemployment_rate), 1) < 7.5 THEN 'Low'
				ELSE 'High' END
				AS unemployment_category
			
		FROM fred_finland_unemployment fu
		JOIN google_trends gt ON fu.year = gt.year
		GROUP BY fu.year, gt.search_term
		ORDER BY fu.year, gt.search_term;

11. Finland labor market full picture

-- unemployment, gig search interest and taxi licences combined
-- Finding: Three distinct phases emerge when all signals are viewed together.
--
-- Phase 1 (2019-2021): Gig searches low (33-40), entrepreneur searches high (55-77),
-- taxi licences high (10k-12k) -- gig work was a choice, not a necessity.
--
-- Phase 2 (2022): Unemployment at its lowest (6.8%) yet gig searches had already 
-- jumped to 66, nearly double the 2019 level of 35.8.
--
-- Phase 3 (2023-2026): Unemployment climbs from 7.2% to 10.4%, gig searches surge
-- to 80 then remain elevated, entrepreneur searches collapse from 50 to 39.
-- Taxi data ends in 2023 but Google Trends data alone confirms the trend.
--
-- Note: Taxi licence data only available until 2023, NULL values for 2024-2026 are expected.
-- Note: 2026 covers only 4 months so figures are not directly comparable to full years.

	SELECT
		fu.year,
		ROUND(AVG(fu.unemployment_rate), 1) AS unemployment_rate,
		ROUND(AVG(gt.search_interest) FILTER (WHERE gt.search_term = 'keikkatyö'), 1) AS gig_searches,
		ROUND(AVG(gt.search_interest) FILTER (WHERE gt.search_term = 'yrittäjäksi'), 1) AS entrepreneur_searches,
		MAX(tl.number_of_licences) AS taxi_licences
	FROM fred_finland_unemployment fu
	LEFT JOIN google_trends gt ON fu.year = gt.year
	LEFT JOIN taxi_licences tl ON fu.year = tl.year
	GROUP BY fu.year
	ORDER BY fu.year;