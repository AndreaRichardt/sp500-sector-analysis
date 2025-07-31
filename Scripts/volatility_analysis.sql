CREATE OR ALTER VIEW dbo.volatility_analysis AS
SELECT 
    Symbol,
    Name,
    Sector,
    _52_Week_Low AS low,
    _52_Week_High AS high,
    ROUND((_52_Week_High - _52_Week_Low) * 100.0 / [_52_Week_Low], 2) AS volatility_pct
FROM dbo.constituents_financials
WHERE _52_Week_Low IS NOT NULL AND _52_Week_High IS NOT NULL
  AND _52_Week_High >= _52_Week_Low;