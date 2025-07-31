CREATE VIEW dbo.valuation_outliers AS
SELECT 
    symbol,
    name,
    sector,
    ROUND(price, 2) AS price,
    ROUND(Price_Earnings, 2) AS price_earning,
    ROUND(earnings_share, 2) AS earnings_share
FROM dbo.constituents
WHERE Price_Earnings > 50
   OR (earnings_share < 0 AND Price_Earnings > 20);