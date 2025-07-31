CREATE OR ALTER VIEW dbo.income_per_dollar AS
SELECT 
    Symbol,
    Name,
    Sector,
    Price,
    Dividend_Yield,
    ROUND(Price * Dividend_Yield, 2) AS income_per_dollar
FROM dbo.constituents_financials
WHERE Price IS NOT NULL AND Dividend_Yield IS NOT NULL;