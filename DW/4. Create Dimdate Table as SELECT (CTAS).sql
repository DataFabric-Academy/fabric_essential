IF EXISTS (SELECT * FROM sys.tables WHERE name='DimDate')
    DROP TABLE dw.DimDate;

CREATE TABLE dw.DimDate
AS
select [DateKey],
    [FullDateAlternateKey],
    [DayNumberOfWeek],
    [EnglishDayNameOfWeek],
    [EnglishMonthName],
    [MonthNumberOfYear],
    'Y'+CONVERT(char(4),CalendarYear)+' '+'Q'+CONVERT(char(1),CalendarQuarter) as QuarterName,
    'Y'+CONVERT(char(4),CalendarYear) as YearName
from [AdventureworksDW].[staging].[date]
