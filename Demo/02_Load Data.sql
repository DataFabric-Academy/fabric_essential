/*
    Corrected Script for Microsoft Fabric / Synapse
    Separating Sample Dimensions (CSV) from Open Dataset Trips (Parquet)
*/

-- ==========================================================
-- 1. Dimension Tables (From Sample Data Endpoint - CSV)
-- ==========================================================

COPY INTO [dbo].[Date]
FROM 'https://azuresynapsestorage.blob.core.windows.net/sampledata/nyctlc/date'
WITH (FILE_TYPE = 'CSV', FIELDTERMINATOR = ',', FIELDQUOTE = '', FIRSTROW = 2);

COPY INTO [dbo].[Geography]
FROM 'https://azuresynapsestorage.blob.core.windows.net/sampledata/nyctlc/geography'
WITH (FILE_TYPE = 'CSV', FIELDTERMINATOR = ',', FIELDQUOTE = '', FIRSTROW = 2);

COPY INTO [dbo].[HackneyLicense]
FROM 'https://azuresynapsestorage.blob.core.windows.net/nyctlc/hackney_license'
WITH (FILE_TYPE = 'CSV', FIELDTERMINATOR = ',', FIELDQUOTE = '', FIRSTROW = 2);

COPY INTO [dbo].[Medallion]
FROM 'https://azuresynapsestorage.blob.core.windows.net/nyctlc/medallion'
WITH (FILE_TYPE = 'CSV', FIELDTERMINATOR = ',', FIELDQUOTE = '', FIRSTROW = 2);

COPY INTO [dbo].[Time]
FROM 'https://azuresynapsestorage.blob.core.windows.net/nyctlc/time'
WITH (FILE_TYPE = 'CSV', FIELDTERMINATOR = ',', FIELDQUOTE = '', FIRSTROW = 2);

COPY INTO [dbo].[Weather]
FROM 'https://azuresynapsestorage.blob.core.windows.net/sampledata/nyctlc/weather'
WITH (FILE_TYPE = 'CSV', FIELDTERMINATOR = ',', FIELDQUOTE = '', ROWTERMINATOR='0X0A', FIRSTROW = 2);

-- ==========================================================
-- 2. Trip Data (From Open Dataset Endpoint - Parquet)
-- สำหรับปี 2013 ทั้งปี
-- ==========================================================

COPY INTO [dbo].[Trip]
FROM 'https://azureopendatastorage.blob.core.windows.net/nyctlc/yellow/puYear=2013/puMonth=*/*.parquet'
WITH (FILE_TYPE = 'PARQUET');
