
CREATE TABLE dbo.sector_report (
    sector NVARCHAR(100),
    avg_price_earning FLOAT,
    avg_earnings_share FLOAT,
    avg_dividend_yield FLOAT,
    eps_std_dev FLOAT,
    company_count INT,
    max_dividend_yield FLOAT,
    avg_price_book FLOAT,
    avg_price_sales FLOAT,
    avg_price_volatility FLOAT,
    avg_growth_estimate FLOAT,
    top_dividend_stock_name NVARCHAR(255),
    top_dividend_stock_symbol NVARCHAR(20)
);


WITH sector_stats AS (
    SELECT 
        sector,
        AVG(Price_Earnings) AS avg_price_earning,
        AVG(earnings_share) AS avg_earnings_share,
        AVG(dividend_yield) AS avg_dividend_yield,
        STDEV(earnings_share) AS eps_std_dev,
        COUNT(*) AS company_count,
        MAX(dividend_yield) AS max_dividend_yield,
        AVG(price_book) AS avg_price_book,
        AVG(price_sales) AS avg_price_sales,
        AVG(CASE 
            WHEN _52_Week_Low IS NOT NULL AND _52_Week_High IS NOT NULL AND _52_Week_Low != 0 
            THEN (_52_Week_High - _52_Week_Low) / _52_Week_Low 
        END) AS avg_price_volatility,
        AVG(CASE 
            WHEN Price_Earnings IS NOT NULL AND earnings_share IS NOT NULL 
            THEN Price_Earnings * earnings_share 
        END) AS avg_growth_estimate
    FROM dbo.constituents
    WHERE Price_Earnings IS NOT NULL 
      AND earnings_share IS NOT NULL 
      AND dividend_yield IS NOT NULL
    GROUP BY sector
), top_dividend AS (
    SELECT 
        sector,
        name AS top_dividend_stock_name,
        symbol AS top_dividend_stock_symbol,
        dividend_yield,
        ROW_NUMBER() OVER (PARTITION BY sector ORDER BY dividend_yield DESC) AS rn
    FROM dbo.constituents
    WHERE dividend_yield IS NOT NULL
)
INSERT INTO dbo.sector_report
SELECT 
    s.sector,
    s.avg_price_earning,
    s.avg_earnings_share,
    s.avg_dividend_yield,
    s.eps_std_dev,
    s.company_count,
    s.max_dividend_yield,
    s.avg_price_book,
    s.avg_price_sales,
    s.avg_price_volatility,
    s.avg_growth_estimate,
    t.top_dividend_stock_name,
    t.top_dividend_stock_symbol
FROM sector_stats s
LEFT JOIN top_dividend t
    ON s.sector = t.sector AND t.rn = 1;