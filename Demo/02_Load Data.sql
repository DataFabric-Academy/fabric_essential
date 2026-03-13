/*
    COPY INTO Document
    https://learn.microsoft.com/en-us/sql/t-sql/statements/copy-into-transact-sql?view=fabric&preserve-view=true
*/

COPY INTO [dbo].[Date]
FROM 'https://azureopendatasets.blob.core.windows.net/nyctlc/yellow/puYear=2013/Date'
WITH
(
    FILE_TYPE = 'CSV',
    FIELDTERMINATOR = ',',
    FIELDQUOTE = ''
);


COPY INTO [dbo].[Geography]
FROM 'https://azureopendatasets.blob.core.windows.net/nyctlc/yellow/puYear=2013/Geography'
WITH
(
    FILE_TYPE = 'CSV',
    FIELDTERMINATOR = ',',
    FIELDQUOTE = ''
);

COPY INTO [dbo].[HackneyLicense]
FROM 'https://azureopendatasets.blob.core.windows.net/nyctlc/yellow/puYear=2013/HackneyLicense'
WITH
(
    FILE_TYPE = 'CSV',
    FIELDTERMINATOR = ',',
    FIELDQUOTE = ''
);

COPY INTO [dbo].[Medallion]
FROM 'https://azureopendatasets.blob.core.windows.net/nyctlc/yellow/puYear=2013/Medallion'
WITH
(
    FILE_TYPE = 'CSV',
    FIELDTERMINATOR = ',',
    FIELDQUOTE = ''
);

COPY INTO [dbo].[Time]
FROM 'https://azureopendatasets.blob.core.windows.net/nyctlc/yellow/puYear=2013/Time'
WITH
(
    FILE_TYPE = 'CSV',
    FIELDTERMINATOR = ',',
    FIELDQUOTE = ''
);

COPY INTO [dbo].[Weather]
FROM 'https://azureopendatasets.blob.core.windows.net/nyctlc/yellow/puYear=2013/Weather'
WITH
(
    FILE_TYPE = 'CSV',
    FIELDTERMINATOR = ',',
    FIELDQUOTE = '',
    ROWTERMINATOR='0X0A'
);

COPY INTO [dbo].[Trip]
FROM 'https://azureopendatasets.blob.core.windows.net/nyctlc/yellow/puYear=2013/Trip2013'
WITH
(
    FILE_TYPE = 'CSV',
    FIELDTERMINATOR = '|',
    FIELDQUOTE = '',
    ROWTERMINATOR='0X0A',
    COMPRESSION = 'GZIP'
);
