-- CHECK.sql — Workshop 15: ตรวจ FactResellerSales ผ่าน SQL analytics endpoint ของ Lakehouse

SELECT CASE WHEN COUNT(*) > 0 THEN 'OK' ELSE 'FAIL: FactResellerSales ว่าง/ไม่มี' END AS check_fact
FROM FactResellerSales;

-- คอลัมน์ครบ 10
SELECT CASE WHEN COUNT(*) = 10 THEN 'OK' ELSE 'FAIL: คอลัมน์ไม่ครบ 10 (เจอ ' + CAST(COUNT(*) AS VARCHAR(5)) + ')' END AS check_columns
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'FactResellerSales';

-- Replace ทำงาน: SUM(SalesAmount) ควรคงที่เมื่อ publish ซ้ำ — จดค่าอ้างอิง
SELECT COUNT(*) AS rows_total, SUM(SalesAmount) AS total_sales FROM FactResellerSales;

-- ยังมีข้อมูลวันที่ 2010-2014 ช่วงตาม source
SELECT CASE WHEN COUNT(*) > 0 THEN 'OK' ELSE 'FAIL: ช่วงวันที่ผิด' END AS check_dates
FROM FactResellerSales
WHERE OrderDateKey BETWEEN 20100101 AND 20141231;
