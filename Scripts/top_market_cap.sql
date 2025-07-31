CREATE VIEW dbo.top_market_cap AS
WITH ranked_companies AS (
    SELECT *,
        RANK() OVER (ORDER BY market_cap DESC) AS rk
    FROM dbo.constituents
    WHERE market_cap IS NOT NULL
), total_market AS (
    SELECT SUM(market_cap) AS total_market_cap
    FROM dbo.constituents
    WHERE market_cap IS NOT NULL
)
SELECT 
    r.symbol,
    r.name,
    r.sector,
    r.market_cap,
    ROUND(r.market_cap * 100.0 / t.total_market_cap, 2) AS market_cap_pct
FROM ranked_companies r
CROSS JOIN total_market t
WHERE rk <= 10;