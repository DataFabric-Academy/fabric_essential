-- =============================================================================
-- Pipeline Lab 1: Copy Data Activity — นำเข้าข้อมูลจาก Azure SQL Database
-- =============================================================================
-- ไฟล์นี้ใช้สำหรับสร้างตารางปลายทางบน Fabric Data Warehouse
-- Pipeline Copy Activity จะทำหน้าที่คัดลอกข้อมูลจาก Azure SQL Database มาใส่ตารางนี้

CREATE SCHEMA IF NOT EXISTS staging;
GO

-- สร้างตาราง staging สำหรับรับข้อมูล DimDate จาก Azure SQL Database
CREATE TABLE staging.DimDate
(
    DateKey INT NOT NULL,
    FullDateAlternateKey DATE NULL,
    DayNumberOfWeek INT NULL,
    EnglishDayNameOfWeek VARCHAR(10) NULL,
    EnglishMonthName VARCHAR(10) NULL,
    MonthNumberOfYear INT NULL,
    CalendarQuarter INT NULL,
    CalendarYear INT NULL
);
GO
