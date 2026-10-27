/*
    Corrected Script v2 for Microsoft Fabric / Synapse — แก้แหล่งข้อมูลที่ถูกย้าย/ปิด (ตรวจสอบ 2026-10-26)
    โหลด NYC Taxi ปี 2013 เต็มปี ~164.5 ล้านแถว (นับจาก parquet footer จริง 240 ไฟล์ — เกิน 50 ล้านตาม requirement ของ on-demand loading test)

    สถานะแหล่งข้อมูลเดิม (ที่รันไม่ผ่าน):
      - azuresynapsestorage.blob.core.windows.net (sampledata/nyctlc dimension CSVs) → storage account ถูกลบออกจาก DNS ทั้งตัว (dimension CSVs หาย)
      - nytaxiblob.blob.core.windows.net (2013 Trip CSV)                            → ปิด public access (PublicAccessNotPermitted)
      - azureopendatastorage.blob.core.windows.net/nyctlc/yellow/...   → ยังเปิดสาธารณะ = แหล่งเดียวที่เหลืออยู่ จึงใช้เป็นแหล่งหลัก

    การแก้ไข:
      1. Trip      : COPY จาก azureopendatastorage (raw parquet ปี 2013, 240 ไฟล์) เข้า staging ก่อน
                     เพราะ parquet ดิบใช้ชื่อคอลัมน์ต่างจากตาราง (Fabric COPY map parquet ตาม "ชื่อ" ไม่ใช่ลำดับ)
      2. Dimensions: CSV เดิม (Date/Time/Geography/Medallion/HackneyLicense/Weather) ตายพร้อม account จึงสร้างใน T-SQL แทน
                     - Date  : สร้างปี 2013 (+ buffer 2012-12-31 .. 2014-01-02 กันทริปที่ข้ามวัน)
                     - Time  : สร้าง 86,400 วินาที (TimeID = HHMMSS)
                     - Geography : ใช้ TLC Taxi Zone Lookup 265 zones (แหล่งทางการที่ยังมีชีวิต)
                     - Medallion / HackneyLicense : ดึงจาก vendorID ในข้อมูลจริง (CMT, VTS)
      3. Trip      : INSERT ... SELECT จาก staging แปลง raw → star schema (DateID = YYYYMMDD, TimeID = HHMMSS ฯลฯ)
      4. Weather   : แหล่งเดิมตาย ไม่มีแหล่งสาธารณะที่ตรง schema — ตารางถูกเก็บไว้แต่ไม่โหลด (ไม่ถูกใช้ใน 03_Test Perf)

    หมายเหตุ: ใช้ digit cross join สร้างชุดตัวเลข เพื่อรันได้ทั้ง Fabric DW และ Synapse dedicated pool
*/

-- ==========================================================
-- 0. ล้างข้อมูลเดิม (rerun ได้)
-- ==========================================================

IF OBJECT_ID('dbo.stg_TripRaw', 'U') IS NOT NULL
    DROP TABLE dbo.stg_TripRaw;

DELETE FROM [dbo].[Date];
DELETE FROM [dbo].[Geography];
DELETE FROM [dbo].[HackneyLicense];
DELETE FROM [dbo].[Medallion];
DELETE FROM [dbo].[Time];
DELETE FROM [dbo].[Trip];

-- ==========================================================
-- 1. Date (2012-12-31 .. 2014-01-02 = 368 วัน, ครอบคลุมทริปข้ามวัน)
--    DateID = YYYYMMDD
-- ==========================================================

INSERT INTO [dbo].[Date]
(
    [DateID], [Date], [DateBKey], [DayOfMonth], [DaySuffix], [DayName], [DayOfWeek],
    [DayOfWeekInMonth], [DayOfWeekInYear], [DayOfQuarter], [DayOfYear], [WeekOfMonth],
    [WeekOfQuarter], [WeekOfYear], [Month], [MonthName], [MonthOfQuarter], [Quarter],
    [QuarterName], [Year], [YearName], [MonthYear], [MMYYYY], [FirstDayOfMonth],
    [LastDayOfMonth], [FirstDayOfQuarter], [LastDayOfQuarter], [FirstDayOfYear],
    [LastDayOfYear], [IsHolidayUSA], [IsWeekday], [HolidayUSA]
)
SELECT
    y.yr * 10000 + y.mo * 100 + y.dy                                   AS [DateID]
,   x.d                                                                AS [Date]
,   CONVERT(char(10), x.d, 112)                                        AS [DateBKey]
,   CONVERT(varchar(2), y.dy)                                          AS [DayOfMonth]
,   CASE WHEN y.dy BETWEEN 11 AND 13 THEN 'th'
         ELSE CASE y.dy % 10 WHEN 1 THEN 'st' WHEN 2 THEN 'nd'
              WHEN 3 THEN 'rd' ELSE 'th' END END                       AS [DaySuffix]
,   DATENAME(WEEKDAY, x.d)                                             AS [DayName]
,   CONVERT(char(1), (y.wk % 7) + 1)                                   AS [DayOfWeek]   -- 1=Sunday .. 7=Saturday
,   CONVERT(varchar(2), ((y.dy - 1) / 7) + 1)                          AS [DayOfWeekInMonth]
,   CONVERT(varchar(2), ((DATEPART(DAYOFYEAR, x.d) - 1) / 7) + 1)      AS [DayOfWeekInYear]
,   CONVERT(varchar(3), DATEDIFF(DAY, y.qstart, x.d) + 1)              AS [DayOfQuarter]
,   CONVERT(varchar(3), DATEPART(DAYOFYEAR, x.d))                      AS [DayOfYear]
,   CONVERT(varchar(1), ((y.dy - 1) / 7) + 1)                          AS [WeekOfMonth]
,   CONVERT(varchar(2), (DATEDIFF(DAY, y.qstart, x.d) / 7) + 1)        AS [WeekOfQuarter]
,   CONVERT(varchar(2), DATEPART(WEEK, x.d))                           AS [WeekOfYear]
,   y.mo                                                               AS [Month]
,   DATENAME(MONTH, x.d)                                               AS [MonthName]
,   CONVERT(varchar(2), ((y.mo - 1) % 3) + 1)                          AS [MonthOfQuarter]
,   CONVERT(char(1), ((y.mo - 1) / 3) + 1)                             AS [Quarter]
,   CASE ((y.mo - 1) / 3) + 1 WHEN 1 THEN 'First' WHEN 2 THEN 'Second'
        WHEN 3 THEN 'Third' ELSE 'Fourth' END                          AS [QuarterName]
,   CONVERT(char(4), y.yr)                                             AS [Year]
,   'CY ' + CONVERT(char(4), y.yr)                                     AS [YearName]
,   LEFT(DATENAME(MONTH, x.d), 3) + ' ' + CONVERT(varchar(4), y.yr)    AS [MonthYear]
,   RIGHT('0' + CONVERT(varchar(2), y.mo), 2) + CONVERT(char(4), y.yr) AS [MMYYYY]
,   DATEFROMPARTS(y.yr, y.mo, 1)                                       AS [FirstDayOfMonth]
,   EOMONTH(x.d)                                                       AS [LastDayOfMonth]
,   y.qstart                                                           AS [FirstDayOfQuarter]
,   EOMONTH(x.d, 2 - ((y.mo - 1) % 3))                                 AS [LastDayOfQuarter]
,   DATEFROMPARTS(y.yr, 1, 1)                                          AS [FirstDayOfYear]
,   DATEFROMPARTS(y.yr, 12, 31)                                        AS [LastDayOfYear]
,   CASE WHEN x.d IN ('2012-12-31', '2013-01-01', '2013-01-21', '2013-02-18', '2013-05-27',
                      '2013-07-04', '2013-09-02', '2013-10-14', '2013-11-11', '2013-11-28',
                      '2013-12-25', '2014-01-01') THEN 1 ELSE 0 END    AS [IsHolidayUSA]
,   CASE WHEN y.wk <= 5 THEN 1 ELSE 0 END                              AS [IsWeekday]
,   CASE x.d
        WHEN '2013-01-01' THEN 'New Year''s Day'
        WHEN '2013-01-21' THEN 'Birthday of Martin Luther King, Jr.'
        WHEN '2013-02-18' THEN 'Washington''s Birthday'
        WHEN '2013-05-27' THEN 'Memorial Day'
        WHEN '2013-07-04' THEN 'Independence Day'
        WHEN '2013-09-02' THEN 'Labor Day'
        WHEN '2013-10-14' THEN 'Columbus Day'
        WHEN '2013-11-11' THEN 'Veterans Day'
        WHEN '2013-11-28' THEN 'Thanksgiving Day'
        WHEN '2013-12-25' THEN 'Christmas Day'
        WHEN '2014-01-01' THEN 'New Year''s Day'
        ELSE NULL END                                                  AS [HolidayUSA]
FROM (
    SELECT TOP (368) ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) - 1 AS n
    FROM (VALUES (0),(1),(2),(3),(4),(5),(6),(7),(8),(9)) a(v)
         CROSS JOIN (VALUES (0),(1),(2),(3),(4),(5),(6),(7),(8),(9)) b(v)
         CROSS JOIN (VALUES (0),(1),(2),(3),(4),(5),(6),(7),(8),(9)) c(v)
         CROSS JOIN (VALUES (0),(1),(2),(3),(4),(5),(6),(7),(8),(9)) d(v)
) s
CROSS APPLY (SELECT DATEADD(DAY, s.n, CAST('2012-12-31' AS date)) AS d) x
CROSS APPLY (
    SELECT YEAR(x.d) AS yr, MONTH(x.d) AS mo, DAY(x.d) AS dy,
           DATEFROMPARTS(YEAR(x.d), ((MONTH(x.d) - 1) / 3) * 3 + 1, 1) AS qstart,
           ((DATEPART(WEEKDAY, x.d) + @@DATEFIRST + 5) % 7) + 1 AS wk   -- Mon=1..Sun=7 (ไม่ขึ้นกับ DATEFIRST)
) y;

-- ==========================================================
-- 2. Time (86,400 แถว, TimeID = HHMMSS)
-- ==========================================================

INSERT INTO [dbo].[Time]
(
    [TimeID], [TimeBKey], [HourNumber], [MinuteNumber], [SecondNumber],
    [TimeInSecond], [HourlyBucket], [DayTimeBucketGroupKey], [DayTimeBucket]
)
SELECT
    y.hh * 10000 + y.mi * 100 + y.ss                                   AS [TimeID]
,   RIGHT('0' + CONVERT(varchar(2), y.hh), 2) + ':'
        + RIGHT('0' + CONVERT(varchar(2), y.mi), 2) + ':'
        + RIGHT('0' + CONVERT(varchar(2), y.ss), 2)                    AS [TimeBKey]
,   y.hh                                                               AS [HourNumber]
,   y.mi                                                               AS [MinuteNumber]
,   y.ss                                                               AS [SecondNumber]
,   s.n                                                                AS [TimeInSecond]
,   RIGHT('0' + CONVERT(varchar(2), y.hh), 2) + ':00'                  AS [HourlyBucket]
,   (y.hh / 6) + 1                                                     AS [DayTimeBucketGroupKey]
,   CASE WHEN y.hh <  6 THEN 'Night (00:00-05:59)'
         WHEN y.hh < 12 THEN 'Morning (06:00-11:59)'
         WHEN y.hh < 18 THEN 'Afternoon (12:00-17:59)'
         ELSE 'Evening (18:00-23:59)' END                              AS [DayTimeBucket]
FROM (
    SELECT TOP (86400) ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) - 1 AS n
    FROM (VALUES (0),(1),(2),(3),(4),(5),(6),(7),(8),(9)) a(v)
         CROSS JOIN (VALUES (0),(1),(2),(3),(4),(5),(6),(7),(8),(9)) b(v)
         CROSS JOIN (VALUES (0),(1),(2),(3),(4),(5),(6),(7),(8),(9)) c(v)
         CROSS JOIN (VALUES (0),(1),(2),(3),(4),(5),(6),(7),(8),(9)) d(v)
         CROSS JOIN (VALUES (0),(1),(2),(3),(4),(5),(6),(7),(8),(9)) e(v)
) s
CROSS APPLY (SELECT s.n / 3600 AS hh, (s.n % 3600) / 60 AS mi, s.n % 60 AS ss) y;

-- ==========================================================
-- 3. Geography (TLC Taxi Zone Lookup — 265 zones ทางการของ NYC)
--    แหล่งเดิมเป็นระดับ zip code ซึ่งไม่มีแหล่งสาธารณะแล้ว จึงใช้ zone แทน
--    GeographyID = TLC LocationID (Trip ปี 2013 ไม่มีรหัสโซน คอลัมน์ GeographyID จะเป็น NULL)
-- ==========================================================

INSERT INTO [dbo].[Geography] ([GeographyID], [ZipCodeBKey], [County], [City], [State], [Country], [ZipCode])
VALUES
(1, '1', 'EWR', 'Newark Airport', 'NJ', 'USA', 'N/A'),
(2, '2', 'Queens', 'Jamaica Bay', 'NY', 'USA', 'N/A'),
(3, '3', 'Bronx', 'Allerton/Pelham Gardens', 'NY', 'USA', 'N/A'),
(4, '4', 'Manhattan', 'Alphabet City', 'NY', 'USA', 'N/A'),
(5, '5', 'Staten Island', 'Arden Heights', 'NY', 'USA', 'N/A'),
(6, '6', 'Staten Island', 'Arrochar/Fort Wadsworth', 'NY', 'USA', 'N/A'),
(7, '7', 'Queens', 'Astoria', 'NY', 'USA', 'N/A'),
(8, '8', 'Queens', 'Astoria Park', 'NY', 'USA', 'N/A'),
(9, '9', 'Queens', 'Auburndale', 'NY', 'USA', 'N/A'),
(10, '10', 'Queens', 'Baisley Park', 'NY', 'USA', 'N/A'),
(11, '11', 'Brooklyn', 'Bath Beach', 'NY', 'USA', 'N/A'),
(12, '12', 'Manhattan', 'Battery Park', 'NY', 'USA', 'N/A'),
(13, '13', 'Manhattan', 'Battery Park City', 'NY', 'USA', 'N/A'),
(14, '14', 'Brooklyn', 'Bay Ridge', 'NY', 'USA', 'N/A'),
(15, '15', 'Queens', 'Bay Terrace/Fort Totten', 'NY', 'USA', 'N/A'),
(16, '16', 'Queens', 'Bayside', 'NY', 'USA', 'N/A'),
(17, '17', 'Brooklyn', 'Bedford', 'NY', 'USA', 'N/A'),
(18, '18', 'Bronx', 'Bedford Park', 'NY', 'USA', 'N/A'),
(19, '19', 'Queens', 'Bellerose', 'NY', 'USA', 'N/A'),
(20, '20', 'Bronx', 'Belmont', 'NY', 'USA', 'N/A'),
(21, '21', 'Brooklyn', 'Bensonhurst East', 'NY', 'USA', 'N/A'),
(22, '22', 'Brooklyn', 'Bensonhurst West', 'NY', 'USA', 'N/A'),
(23, '23', 'Staten Island', 'Bloomfield/Emerson Hill', 'NY', 'USA', 'N/A'),
(24, '24', 'Manhattan', 'Bloomingdale', 'NY', 'USA', 'N/A'),
(25, '25', 'Brooklyn', 'Boerum Hill', 'NY', 'USA', 'N/A'),
(26, '26', 'Brooklyn', 'Borough Park', 'NY', 'USA', 'N/A'),
(27, '27', 'Queens', 'Breezy Point/Fort Tilden/Riis Beach', 'NY', 'USA', 'N/A'),
(28, '28', 'Queens', 'Briarwood/Jamaica Hills', 'NY', 'USA', 'N/A'),
(29, '29', 'Brooklyn', 'Brighton Beach', 'NY', 'USA', 'N/A'),
(30, '30', 'Queens', 'Broad Channel', 'NY', 'USA', 'N/A'),
(31, '31', 'Bronx', 'Bronx Park', 'NY', 'USA', 'N/A'),
(32, '32', 'Bronx', 'Bronxdale', 'NY', 'USA', 'N/A'),
(33, '33', 'Brooklyn', 'Brooklyn Heights', 'NY', 'USA', 'N/A'),
(34, '34', 'Brooklyn', 'Brooklyn Navy Yard', 'NY', 'USA', 'N/A'),
(35, '35', 'Brooklyn', 'Brownsville', 'NY', 'USA', 'N/A'),
(36, '36', 'Brooklyn', 'Bushwick North', 'NY', 'USA', 'N/A'),
(37, '37', 'Brooklyn', 'Bushwick South', 'NY', 'USA', 'N/A'),
(38, '38', 'Queens', 'Cambria Heights', 'NY', 'USA', 'N/A'),
(39, '39', 'Brooklyn', 'Canarsie', 'NY', 'USA', 'N/A'),
(40, '40', 'Brooklyn', 'Carroll Gardens', 'NY', 'USA', 'N/A'),
(41, '41', 'Manhattan', 'Central Harlem', 'NY', 'USA', 'N/A'),
(42, '42', 'Manhattan', 'Central Harlem North', 'NY', 'USA', 'N/A'),
(43, '43', 'Manhattan', 'Central Park', 'NY', 'USA', 'N/A'),
(44, '44', 'Staten Island', 'Charleston/Tottenville', 'NY', 'USA', 'N/A'),
(45, '45', 'Manhattan', 'Chinatown', 'NY', 'USA', 'N/A'),
(46, '46', 'Bronx', 'City Island', 'NY', 'USA', 'N/A'),
(47, '47', 'Bronx', 'Claremont/Bathgate', 'NY', 'USA', 'N/A'),
(48, '48', 'Manhattan', 'Clinton East', 'NY', 'USA', 'N/A'),
(49, '49', 'Brooklyn', 'Clinton Hill', 'NY', 'USA', 'N/A'),
(50, '50', 'Manhattan', 'Clinton West', 'NY', 'USA', 'N/A'),
(51, '51', 'Bronx', 'Co-Op City', 'NY', 'USA', 'N/A'),
(52, '52', 'Brooklyn', 'Cobble Hill', 'NY', 'USA', 'N/A'),
(53, '53', 'Queens', 'College Point', 'NY', 'USA', 'N/A'),
(54, '54', 'Brooklyn', 'Columbia Street', 'NY', 'USA', 'N/A'),
(55, '55', 'Brooklyn', 'Coney Island', 'NY', 'USA', 'N/A'),
(56, '56', 'Queens', 'Corona', 'NY', 'USA', 'N/A'),
(57, '57', 'Queens', 'Corona', 'NY', 'USA', 'N/A'),
(58, '58', 'Bronx', 'Country Club', 'NY', 'USA', 'N/A'),
(59, '59', 'Bronx', 'Crotona Park', 'NY', 'USA', 'N/A'),
(60, '60', 'Bronx', 'Crotona Park East', 'NY', 'USA', 'N/A'),
(61, '61', 'Brooklyn', 'Crown Heights North', 'NY', 'USA', 'N/A'),
(62, '62', 'Brooklyn', 'Crown Heights South', 'NY', 'USA', 'N/A'),
(63, '63', 'Brooklyn', 'Cypress Hills', 'NY', 'USA', 'N/A'),
(64, '64', 'Queens', 'Douglaston', 'NY', 'USA', 'N/A'),
(65, '65', 'Brooklyn', 'Downtown Brooklyn/MetroTech', 'NY', 'USA', 'N/A'),
(66, '66', 'Brooklyn', 'DUMBO/Vinegar Hill', 'NY', 'USA', 'N/A'),
(67, '67', 'Brooklyn', 'Dyker Heights', 'NY', 'USA', 'N/A'),
(68, '68', 'Manhattan', 'East Chelsea', 'NY', 'USA', 'N/A'),
(69, '69', 'Bronx', 'East Concourse/Concourse Village', 'NY', 'USA', 'N/A'),
(70, '70', 'Queens', 'East Elmhurst', 'NY', 'USA', 'N/A'),
(71, '71', 'Brooklyn', 'East Flatbush/Farragut', 'NY', 'USA', 'N/A'),
(72, '72', 'Brooklyn', 'East Flatbush/Remsen Village', 'NY', 'USA', 'N/A'),
(73, '73', 'Queens', 'East Flushing', 'NY', 'USA', 'N/A'),
(74, '74', 'Manhattan', 'East Harlem North', 'NY', 'USA', 'N/A'),
(75, '75', 'Manhattan', 'East Harlem South', 'NY', 'USA', 'N/A'),
(76, '76', 'Brooklyn', 'East New York', 'NY', 'USA', 'N/A'),
(77, '77', 'Brooklyn', 'East New York/Pennsylvania Avenue', 'NY', 'USA', 'N/A'),
(78, '78', 'Bronx', 'East Tremont', 'NY', 'USA', 'N/A'),
(79, '79', 'Manhattan', 'East Village', 'NY', 'USA', 'N/A'),
(80, '80', 'Brooklyn', 'East Williamsburg', 'NY', 'USA', 'N/A'),
(81, '81', 'Bronx', 'Eastchester', 'NY', 'USA', 'N/A'),
(82, '82', 'Queens', 'Elmhurst', 'NY', 'USA', 'N/A'),
(83, '83', 'Queens', 'Elmhurst/Maspeth', 'NY', 'USA', 'N/A'),
(84, '84', 'Staten Island', 'Eltingville/Annadale/Prince''s Bay', 'NY', 'USA', 'N/A'),
(85, '85', 'Brooklyn', 'Erasmus', 'NY', 'USA', 'N/A'),
(86, '86', 'Queens', 'Far Rockaway', 'NY', 'USA', 'N/A'),
(87, '87', 'Manhattan', 'Financial District North', 'NY', 'USA', 'N/A'),
(88, '88', 'Manhattan', 'Financial District South', 'NY', 'USA', 'N/A'),
(89, '89', 'Brooklyn', 'Flatbush/Ditmas Park', 'NY', 'USA', 'N/A'),
(90, '90', 'Manhattan', 'Flatiron', 'NY', 'USA', 'N/A'),
(91, '91', 'Brooklyn', 'Flatlands', 'NY', 'USA', 'N/A'),
(92, '92', 'Queens', 'Flushing', 'NY', 'USA', 'N/A'),
(93, '93', 'Queens', 'Flushing Meadows-Corona Park', 'NY', 'USA', 'N/A'),
(94, '94', 'Bronx', 'Fordham South', 'NY', 'USA', 'N/A'),
(95, '95', 'Queens', 'Forest Hills', 'NY', 'USA', 'N/A'),
(96, '96', 'Queens', 'Forest Park/Highland Park', 'NY', 'USA', 'N/A'),
(97, '97', 'Brooklyn', 'Fort Greene', 'NY', 'USA', 'N/A'),
(98, '98', 'Queens', 'Fresh Meadows', 'NY', 'USA', 'N/A'),
(99, '99', 'Staten Island', 'Freshkills Park', 'NY', 'USA', 'N/A'),
(100, '100', 'Manhattan', 'Garment District', 'NY', 'USA', 'N/A'),
(101, '101', 'Queens', 'Glen Oaks', 'NY', 'USA', 'N/A'),
(102, '102', 'Queens', 'Glendale', 'NY', 'USA', 'N/A'),
(103, '103', 'Manhattan', 'Governor''s Island/Ellis Island/Liberty Island', 'NY', 'USA', 'N/A'),
(104, '104', 'Manhattan', 'Governor''s Island/Ellis Island/Liberty Island', 'NY', 'USA', 'N/A'),
(105, '105', 'Manhattan', 'Governor''s Island/Ellis Island/Liberty Island', 'NY', 'USA', 'N/A'),
(106, '106', 'Brooklyn', 'Gowanus', 'NY', 'USA', 'N/A'),
(107, '107', 'Manhattan', 'Gramercy', 'NY', 'USA', 'N/A'),
(108, '108', 'Brooklyn', 'Gravesend', 'NY', 'USA', 'N/A'),
(109, '109', 'Staten Island', 'Great Kills', 'NY', 'USA', 'N/A'),
(110, '110', 'Staten Island', 'Great Kills Park', 'NY', 'USA', 'N/A'),
(111, '111', 'Brooklyn', 'Green-Wood Cemetery', 'NY', 'USA', 'N/A'),
(112, '112', 'Brooklyn', 'Greenpoint', 'NY', 'USA', 'N/A'),
(113, '113', 'Manhattan', 'Greenwich Village North', 'NY', 'USA', 'N/A'),
(114, '114', 'Manhattan', 'Greenwich Village South', 'NY', 'USA', 'N/A'),
(115, '115', 'Staten Island', 'Grymes Hill/Clifton', 'NY', 'USA', 'N/A'),
(116, '116', 'Manhattan', 'Hamilton Heights', 'NY', 'USA', 'N/A'),
(117, '117', 'Queens', 'Hammels/Arverne', 'NY', 'USA', 'N/A'),
(118, '118', 'Staten Island', 'Heartland Village/Todt Hill', 'NY', 'USA', 'N/A'),
(119, '119', 'Bronx', 'Highbridge', 'NY', 'USA', 'N/A'),
(120, '120', 'Manhattan', 'Highbridge Park', 'NY', 'USA', 'N/A'),
(121, '121', 'Queens', 'Hillcrest/Pomonok', 'NY', 'USA', 'N/A'),
(122, '122', 'Queens', 'Hollis', 'NY', 'USA', 'N/A'),
(123, '123', 'Brooklyn', 'Homecrest', 'NY', 'USA', 'N/A'),
(124, '124', 'Queens', 'Howard Beach', 'NY', 'USA', 'N/A'),
(125, '125', 'Manhattan', 'Hudson Sq', 'NY', 'USA', 'N/A'),
(126, '126', 'Bronx', 'Hunts Point', 'NY', 'USA', 'N/A'),
(127, '127', 'Manhattan', 'Inwood', 'NY', 'USA', 'N/A'),
(128, '128', 'Manhattan', 'Inwood Hill Park', 'NY', 'USA', 'N/A'),
(129, '129', 'Queens', 'Jackson Heights', 'NY', 'USA', 'N/A'),
(130, '130', 'Queens', 'Jamaica', 'NY', 'USA', 'N/A'),
(131, '131', 'Queens', 'Jamaica Estates', 'NY', 'USA', 'N/A'),
(132, '132', 'Queens', 'JFK Airport', 'NY', 'USA', 'N/A'),
(133, '133', 'Brooklyn', 'Kensington', 'NY', 'USA', 'N/A'),
(134, '134', 'Queens', 'Kew Gardens', 'NY', 'USA', 'N/A'),
(135, '135', 'Queens', 'Kew Gardens Hills', 'NY', 'USA', 'N/A'),
(136, '136', 'Bronx', 'Kingsbridge Heights', 'NY', 'USA', 'N/A'),
(137, '137', 'Manhattan', 'Kips Bay', 'NY', 'USA', 'N/A'),
(138, '138', 'Queens', 'LaGuardia Airport', 'NY', 'USA', 'N/A'),
(139, '139', 'Queens', 'Laurelton', 'NY', 'USA', 'N/A'),
(140, '140', 'Manhattan', 'Lenox Hill East', 'NY', 'USA', 'N/A'),
(141, '141', 'Manhattan', 'Lenox Hill West', 'NY', 'USA', 'N/A'),
(142, '142', 'Manhattan', 'Lincoln Square East', 'NY', 'USA', 'N/A'),
(143, '143', 'Manhattan', 'Lincoln Square West', 'NY', 'USA', 'N/A'),
(144, '144', 'Manhattan', 'Little Italy/NoLiTa', 'NY', 'USA', 'N/A'),
(145, '145', 'Queens', 'Long Island City/Hunters Point', 'NY', 'USA', 'N/A'),
(146, '146', 'Queens', 'Long Island City/Queens Plaza', 'NY', 'USA', 'N/A'),
(147, '147', 'Bronx', 'Longwood', 'NY', 'USA', 'N/A'),
(148, '148', 'Manhattan', 'Lower East Side', 'NY', 'USA', 'N/A'),
(149, '149', 'Brooklyn', 'Madison', 'NY', 'USA', 'N/A'),
(150, '150', 'Brooklyn', 'Manhattan Beach', 'NY', 'USA', 'N/A'),
(151, '151', 'Manhattan', 'Manhattan Valley', 'NY', 'USA', 'N/A'),
(152, '152', 'Manhattan', 'Manhattanville', 'NY', 'USA', 'N/A'),
(153, '153', 'Manhattan', 'Marble Hill', 'NY', 'USA', 'N/A'),
(154, '154', 'Brooklyn', 'Marine Park/Floyd Bennett Field', 'NY', 'USA', 'N/A'),
(155, '155', 'Brooklyn', 'Marine Park/Mill Basin', 'NY', 'USA', 'N/A'),
(156, '156', 'Staten Island', 'Mariners Harbor', 'NY', 'USA', 'N/A'),
(157, '157', 'Queens', 'Maspeth', 'NY', 'USA', 'N/A'),
(158, '158', 'Manhattan', 'Meatpacking/West Village West', 'NY', 'USA', 'N/A'),
(159, '159', 'Bronx', 'Melrose South', 'NY', 'USA', 'N/A'),
(160, '160', 'Queens', 'Middle Village', 'NY', 'USA', 'N/A'),
(161, '161', 'Manhattan', 'Midtown Center', 'NY', 'USA', 'N/A'),
(162, '162', 'Manhattan', 'Midtown East', 'NY', 'USA', 'N/A'),
(163, '163', 'Manhattan', 'Midtown North', 'NY', 'USA', 'N/A'),
(164, '164', 'Manhattan', 'Midtown South', 'NY', 'USA', 'N/A'),
(165, '165', 'Brooklyn', 'Midwood', 'NY', 'USA', 'N/A'),
(166, '166', 'Manhattan', 'Morningside Heights', 'NY', 'USA', 'N/A'),
(167, '167', 'Bronx', 'Morrisania/Melrose', 'NY', 'USA', 'N/A'),
(168, '168', 'Bronx', 'Mott Haven/Port Morris', 'NY', 'USA', 'N/A'),
(169, '169', 'Bronx', 'Mount Hope', 'NY', 'USA', 'N/A'),
(170, '170', 'Manhattan', 'Murray Hill', 'NY', 'USA', 'N/A'),
(171, '171', 'Queens', 'Murray Hill-Queens', 'NY', 'USA', 'N/A'),
(172, '172', 'Staten Island', 'New Dorp/Midland Beach', 'NY', 'USA', 'N/A'),
(173, '173', 'Queens', 'North Corona', 'NY', 'USA', 'N/A'),
(174, '174', 'Bronx', 'Norwood', 'NY', 'USA', 'N/A'),
(175, '175', 'Queens', 'Oakland Gardens', 'NY', 'USA', 'N/A'),
(176, '176', 'Staten Island', 'Oakwood', 'NY', 'USA', 'N/A'),
(177, '177', 'Brooklyn', 'Ocean Hill', 'NY', 'USA', 'N/A'),
(178, '178', 'Brooklyn', 'Ocean Parkway South', 'NY', 'USA', 'N/A'),
(179, '179', 'Queens', 'Old Astoria', 'NY', 'USA', 'N/A'),
(180, '180', 'Queens', 'Ozone Park', 'NY', 'USA', 'N/A'),
(181, '181', 'Brooklyn', 'Park Slope', 'NY', 'USA', 'N/A'),
(182, '182', 'Bronx', 'Parkchester', 'NY', 'USA', 'N/A'),
(183, '183', 'Bronx', 'Pelham Bay', 'NY', 'USA', 'N/A'),
(184, '184', 'Bronx', 'Pelham Bay Park', 'NY', 'USA', 'N/A'),
(185, '185', 'Bronx', 'Pelham Parkway', 'NY', 'USA', 'N/A'),
(186, '186', 'Manhattan', 'Penn Station/Madison Sq West', 'NY', 'USA', 'N/A'),
(187, '187', 'Staten Island', 'Port Richmond', 'NY', 'USA', 'N/A'),
(188, '188', 'Brooklyn', 'Prospect-Lefferts Gardens', 'NY', 'USA', 'N/A'),
(189, '189', 'Brooklyn', 'Prospect Heights', 'NY', 'USA', 'N/A'),
(190, '190', 'Brooklyn', 'Prospect Park', 'NY', 'USA', 'N/A'),
(191, '191', 'Queens', 'Queens Village', 'NY', 'USA', 'N/A'),
(192, '192', 'Queens', 'Queensboro Hill', 'NY', 'USA', 'N/A'),
(193, '193', 'Queens', 'Queensbridge/Ravenswood', 'NY', 'USA', 'N/A'),
(194, '194', 'Manhattan', 'Randalls Island', 'NY', 'USA', 'N/A'),
(195, '195', 'Brooklyn', 'Red Hook', 'NY', 'USA', 'N/A'),
(196, '196', 'Queens', 'Rego Park', 'NY', 'USA', 'N/A'),
(197, '197', 'Queens', 'Richmond Hill', 'NY', 'USA', 'N/A'),
(198, '198', 'Queens', 'Ridgewood', 'NY', 'USA', 'N/A'),
(199, '199', 'Bronx', 'Rikers Island', 'NY', 'USA', 'N/A'),
(200, '200', 'Bronx', 'Riverdale/North Riverdale/Fieldston', 'NY', 'USA', 'N/A'),
(201, '201', 'Queens', 'Rockaway Park', 'NY', 'USA', 'N/A'),
(202, '202', 'Manhattan', 'Roosevelt Island', 'NY', 'USA', 'N/A'),
(203, '203', 'Queens', 'Rosedale', 'NY', 'USA', 'N/A'),
(204, '204', 'Staten Island', 'Rossville/Woodrow', 'NY', 'USA', 'N/A'),
(205, '205', 'Queens', 'Saint Albans', 'NY', 'USA', 'N/A'),
(206, '206', 'Staten Island', 'Saint George/New Brighton', 'NY', 'USA', 'N/A'),
(207, '207', 'Queens', 'Saint Michaels Cemetery/Woodside', 'NY', 'USA', 'N/A'),
(208, '208', 'Bronx', 'Schuylerville/Edgewater Park', 'NY', 'USA', 'N/A'),
(209, '209', 'Manhattan', 'Seaport', 'NY', 'USA', 'N/A'),
(210, '210', 'Brooklyn', 'Sheepshead Bay', 'NY', 'USA', 'N/A'),
(211, '211', 'Manhattan', 'SoHo', 'NY', 'USA', 'N/A'),
(212, '212', 'Bronx', 'Soundview/Bruckner', 'NY', 'USA', 'N/A'),
(213, '213', 'Bronx', 'Soundview/Castle Hill', 'NY', 'USA', 'N/A'),
(214, '214', 'Staten Island', 'South Beach/Dongan Hills', 'NY', 'USA', 'N/A'),
(215, '215', 'Queens', 'South Jamaica', 'NY', 'USA', 'N/A'),
(216, '216', 'Queens', 'South Ozone Park', 'NY', 'USA', 'N/A'),
(217, '217', 'Brooklyn', 'South Williamsburg', 'NY', 'USA', 'N/A'),
(218, '218', 'Queens', 'Springfield Gardens North', 'NY', 'USA', 'N/A'),
(219, '219', 'Queens', 'Springfield Gardens South', 'NY', 'USA', 'N/A'),
(220, '220', 'Bronx', 'Spuyten Duyvil/Kingsbridge', 'NY', 'USA', 'N/A'),
(221, '221', 'Staten Island', 'Stapleton', 'NY', 'USA', 'N/A'),
(222, '222', 'Brooklyn', 'Starrett City', 'NY', 'USA', 'N/A'),
(223, '223', 'Queens', 'Steinway', 'NY', 'USA', 'N/A'),
(224, '224', 'Manhattan', 'Stuy Town/Peter Cooper Village', 'NY', 'USA', 'N/A'),
(225, '225', 'Brooklyn', 'Stuyvesant Heights', 'NY', 'USA', 'N/A'),
(226, '226', 'Queens', 'Sunnyside', 'NY', 'USA', 'N/A'),
(227, '227', 'Brooklyn', 'Sunset Park East', 'NY', 'USA', 'N/A'),
(228, '228', 'Brooklyn', 'Sunset Park West', 'NY', 'USA', 'N/A'),
(229, '229', 'Manhattan', 'Sutton Place/Turtle Bay North', 'NY', 'USA', 'N/A'),
(230, '230', 'Manhattan', 'Times Sq/Theatre District', 'NY', 'USA', 'N/A'),
(231, '231', 'Manhattan', 'TriBeCa/Civic Center', 'NY', 'USA', 'N/A'),
(232, '232', 'Manhattan', 'Two Bridges/Seward Park', 'NY', 'USA', 'N/A'),
(233, '233', 'Manhattan', 'UN/Turtle Bay South', 'NY', 'USA', 'N/A'),
(234, '234', 'Manhattan', 'Union Sq', 'NY', 'USA', 'N/A'),
(235, '235', 'Bronx', 'University Heights/Morris Heights', 'NY', 'USA', 'N/A'),
(236, '236', 'Manhattan', 'Upper East Side North', 'NY', 'USA', 'N/A'),
(237, '237', 'Manhattan', 'Upper East Side South', 'NY', 'USA', 'N/A'),
(238, '238', 'Manhattan', 'Upper West Side North', 'NY', 'USA', 'N/A'),
(239, '239', 'Manhattan', 'Upper West Side South', 'NY', 'USA', 'N/A'),
(240, '240', 'Bronx', 'Van Cortlandt Park', 'NY', 'USA', 'N/A'),
(241, '241', 'Bronx', 'Van Cortlandt Village', 'NY', 'USA', 'N/A'),
(242, '242', 'Bronx', 'Van Nest/Morris Park', 'NY', 'USA', 'N/A'),
(243, '243', 'Manhattan', 'Washington Heights North', 'NY', 'USA', 'N/A'),
(244, '244', 'Manhattan', 'Washington Heights South', 'NY', 'USA', 'N/A'),
(245, '245', 'Staten Island', 'West Brighton', 'NY', 'USA', 'N/A'),
(246, '246', 'Manhattan', 'West Chelsea/Hudson Yards', 'NY', 'USA', 'N/A'),
(247, '247', 'Bronx', 'West Concourse', 'NY', 'USA', 'N/A'),
(248, '248', 'Bronx', 'West Farms/Bronx River', 'NY', 'USA', 'N/A'),
(249, '249', 'Manhattan', 'West Village', 'NY', 'USA', 'N/A'),
(250, '250', 'Bronx', 'Westchester Village/Unionport', 'NY', 'USA', 'N/A'),
(251, '251', 'Staten Island', 'Westerleigh', 'NY', 'USA', 'N/A'),
(252, '252', 'Queens', 'Whitestone', 'NY', 'USA', 'N/A'),
(253, '253', 'Queens', 'Willets Point', 'NY', 'USA', 'N/A'),
(254, '254', 'Bronx', 'Williamsbridge/Olinville', 'NY', 'USA', 'N/A'),
(255, '255', 'Brooklyn', 'Williamsburg (North Side)', 'NY', 'USA', 'N/A'),
(256, '256', 'Brooklyn', 'Williamsburg (South Side)', 'NY', 'USA', 'N/A'),
(257, '257', 'Brooklyn', 'Windsor Terrace', 'NY', 'USA', 'N/A'),
(258, '258', 'Queens', 'Woodhaven', 'NY', 'USA', 'N/A'),
(259, '259', 'Bronx', 'Woodlawn/Wakefield', 'NY', 'USA', 'N/A'),
(260, '260', 'Queens', 'Woodside', 'NY', 'USA', 'N/A'),
(261, '261', 'Manhattan', 'World Trade Center', 'NY', 'USA', 'N/A'),
(262, '262', 'Manhattan', 'Yorkville East', 'NY', 'USA', 'N/A'),
(263, '263', 'Manhattan', 'Yorkville West', 'NY', 'USA', 'N/A'),
(264, '264', 'Unknown', 'N/A', 'NY', 'USA', 'N/A'),
(265, '265', 'N/A', 'Outside of NYC', 'NY', 'USA', 'N/A');

-- ==========================================================
-- 4. Staging: COPY raw parquet ปี 2013 ทั้งปี (240 ไฟล์, ~164.5 ล้านแถว)
--    ชื่อคอลัมน์/ชนิดตรงกับไฟล์ parquet จริง (Fabric COPY จับคู่ตามชื่อ)
--    ไฟล์ที่ขึ้นต้นด้วย _ (_SUCCESS, _committed_*) ถูก COPY ข้ามอัตโนมัติ
-- ==========================================================

CREATE TABLE dbo.stg_TripRaw
(
    [vendorID]              varchar(10)   NULL,
    [tpepPickupDateTime]    datetime2(6)  NULL,
    [tpepDropoffDateTime]   datetime2(6)  NULL,
    [passengerCount]        int           NULL,
    [tripDistance]          float         NULL,
    [puLocationId]          varchar(10)   NULL,
    [doLocationId]          varchar(10)   NULL,
    [startLon]              float         NULL,
    [startLat]              float         NULL,
    [endLon]                float         NULL,
    [endLat]                float         NULL,
    [rateCodeId]            int           NULL,
    [storeAndFwdFlag]       varchar(2)    NULL,
    [paymentType]           varchar(10)   NULL,
    [fareAmount]            float         NULL,
    [extra]                 float         NULL,
    [mtaTax]                float         NULL,
    [improvementSurcharge]  varchar(20)   NULL,
    [tipAmount]             float         NULL,
    [tollsAmount]           float         NULL,
    [totalAmount]           float         NULL
);

-- ทั้งปี 2013 (default) — เกิน 50 ล้านแถว
COPY INTO dbo.stg_TripRaw
FROM 'https://azureopendatastorage.blob.core.windows.net/nyctlc/yellow/puYear=2013/puMonth=*/*.parquet'
WITH (FILE_TYPE = 'PARQUET');

-- ถ้าต้องการทดลองเร็ว ๆ ในห้องเรียน (1 เดือน ≈ 14 ล้านแถว) ให้ใช้:
-- COPY INTO dbo.stg_TripRaw
-- FROM 'https://azureopendatastorage.blob.core.windows.net/nyctlc/yellow/puYear=2013/puMonth=1/*.parquet'
-- WITH (FILE_TYPE = 'PARQUET');

-- ==========================================================
-- 5. Medallion / HackneyLicense จาก vendorID จริงในข้อมูล (CMT, VTS)
-- ==========================================================

INSERT INTO [dbo].[Medallion] ([MedallionID], [MedallionBKey], [MedallionCode])
SELECT ROW_NUMBER() OVER (ORDER BY v.vendorID), v.vendorID, v.vendorID
FROM (SELECT DISTINCT ISNULL(vendorID, 'UNKNOWN') AS vendorID FROM dbo.stg_TripRaw) v;

INSERT INTO [dbo].[HackneyLicense] ([HackneyLicenseID], [HackneyLicenseBKey], [HackneyLicenseCode])
SELECT ROW_NUMBER() OVER (ORDER BY v.vendorID), v.vendorID, v.vendorID
FROM (SELECT DISTINCT ISNULL(vendorID, 'UNKNOWN') AS vendorID FROM dbo.stg_TripRaw) v;

-- ==========================================================
-- 6. Trip: แปลง raw → star schema
--    DateID = YYYYMMDD จาก pickup, TimeID = HHMMSS,
--    TripDurationSeconds = dropoff - pickup, SurchargeAmount = extra, TaxAmount = mtaTax
--    Pickup/DropoffGeographyID = NULL (ข้อมูลปี 2013 ไม่มีรหัสโซน — puLocationId ว่างทั้งหมด)
-- ==========================================================

INSERT INTO [dbo].[Trip]
(
    [DateID], [MedallionID], [HackneyLicenseID], [PickupTimeID], [DropoffTimeID],
    [PickupGeographyID], [DropoffGeographyID],
    [PickupLatitude], [PickupLongitude], [PickupLatLong],
    [DropoffLatitude], [DropoffLongitude], [DropoffLatLong],
    [PassengerCount], [TripDurationSeconds], [TripDistanceMiles], [PaymentType],
    [FareAmount], [SurchargeAmount], [TaxAmount], [TipAmount], [TollsAmount], [TotalAmount]
)
SELECT
    YEAR(p.tpepPickupDateTime) * 10000 + MONTH(p.tpepPickupDateTime) * 100 + DAY(p.tpepPickupDateTime)
                                                                       AS [DateID]
,   m.MedallionID                                                       AS [MedallionID]
,   h.HackneyLicenseID                                                  AS [HackneyLicenseID]
,   ISNULL(DATEPART(HOUR,   p.tpepPickupDateTime)  * 10000
         + DATEPART(MINUTE, p.tpepPickupDateTime)  * 100
         + DATEPART(SECOND, p.tpepPickupDateTime), 0)                   AS [PickupTimeID]
,   ISNULL(DATEPART(HOUR,   p.tpepDropoffDateTime) * 10000
         + DATEPART(MINUTE, p.tpepDropoffDateTime) * 100
         + DATEPART(SECOND, p.tpepDropoffDateTime), 0)                  AS [DropoffTimeID]
,   NULL                                                                AS [PickupGeographyID]
,   NULL                                                                AS [DropoffGeographyID]
,   p.startLat                                                          AS [PickupLatitude]
,   p.startLon                                                          AS [PickupLongitude]
,   CASE WHEN p.startLat IS NULL OR p.startLon IS NULL THEN NULL
         ELSE CONCAT(CONVERT(varchar(20), p.startLat), ', ',
                     CONVERT(varchar(20), p.startLon)) END               AS [PickupLatLong]
,   p.endLat                                                            AS [DropoffLatitude]
,   p.endLon                                                            AS [DropoffLongitude]
,   CASE WHEN p.endLat IS NULL OR p.endLon IS NULL THEN NULL
         ELSE CONCAT(CONVERT(varchar(20), p.endLat), ', ',
                     CONVERT(varchar(20), p.endLon)) END                AS [DropoffLatLong]
,   p.passengerCount                                                    AS [PassengerCount]
,   DATEDIFF(SECOND, p.tpepPickupDateTime, p.tpepDropoffDateTime)       AS [TripDurationSeconds]
,   p.tripDistance                                                      AS [TripDistanceMiles]
,   p.paymentType                                                       AS [PaymentType]
,   p.fareAmount                                                        AS [FareAmount]
,   p.extra                                                             AS [SurchargeAmount]
,   p.mtaTax                                                            AS [TaxAmount]
,   p.tipAmount                                                         AS [TipAmount]
,   p.tollsAmount                                                       AS [TollsAmount]
,   p.totalAmount                                                       AS [TotalAmount]
FROM dbo.stg_TripRaw p
INNER JOIN dbo.Medallion       m ON m.MedallionBKey       = ISNULL(p.vendorID, 'UNKNOWN')
INNER JOIN dbo.HackneyLicense  h ON h.HackneyLicenseBKey  = ISNULL(p.vendorID, 'UNKNOWN')
WHERE p.tpepPickupDateTime IS NOT NULL;

DROP TABLE dbo.stg_TripRaw;

-- ==========================================================
-- 7. Weather: ข้าม — แหล่งเดิม (sampledata) ถูกลบ และไม่มีแหล่งสาธารณะที่ตรง schema
--    ตารางถูกเก็บไว้ให้ semantic model ครบ แต่ไม่มีข้อมูล (ไม่ถูกใช้ใน 03_Test Perf)
-- ==========================================================

-- ==========================================================
-- 8. ตรวจสอบผลการโหลด
-- ==========================================================

SELECT 'Date' AS TableName, COUNT(*) AS RowsLoaded FROM dbo.Date
UNION ALL SELECT 'Time', COUNT(*) FROM dbo.Time
UNION ALL SELECT 'Geography', COUNT(*) FROM dbo.Geography
UNION ALL SELECT 'Medallion', COUNT(*) FROM dbo.Medallion
UNION ALL SELECT 'HackneyLicense', COUNT(*) FROM dbo.HackneyLicense
UNION ALL SELECT 'Trip', COUNT_BIG(*) FROM dbo.Trip;

-- ทริปเดือนละเดือน (ควรได้ ~14-15 ล้านแถว/เดือน รวม >50 ล้านแถว/ปี)
SELECT
    D.Month
,   D.MonthName
,   FORMAT(COUNT_BIG(*), '#,##0')                 AS cntrow
,   FORMAT(SUM(T.TotalAmount), '#,##0')           AS TotalAmount
FROM dbo.Trip AS T
INNER JOIN dbo.Date AS D ON T.DateID = D.DateID
GROUP BY D.Month, D.MonthName
ORDER BY D.Month;
