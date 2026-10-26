-- CHECK.sql — Workshop 6-1 + 6-2 ผ่านครบเมื่อทุกผลลัพธ์แสดง OK
-- รันบน Warehouse AdventureworksDW

-- 6-1: staging.date และ dw.DimDate มีข้อมูล
SELECT CASE WHEN (SELECT COUNT(*) FROM staging.date) > 0 THEN 'OK' ELSE 'FAIL: staging.date ว่าง' END AS check_staging_date;
SELECT CASE WHEN (SELECT COUNT(*) FROM dw.DimDate) > 0 THEN 'OK' ELSE 'FAIL: dw.DimDate ว่าง' END AS check_dw_dimdate;

-- 6-1: ปีครบตาม source (ไม่มีแถวหลุด) — เทียบจำนวนแถวสองฝั่ง
SELECT CASE WHEN (SELECT COUNT(*) FROM staging.date) = (SELECT COUNT(*) FROM dw.DimDate)
            THEN 'OK' ELSE 'WARN: จำนวนแถว staging.date กับ dw.DimDate ไม่เท่ากัน' END AS check_rowcount;

-- 6-2: proc มีอยู่
SELECT CASE WHEN COUNT(*) >= 2 THEN 'OK' ELSE 'FAIL: proc ขาด' END AS check_procs
FROM INFORMATION_SCHEMA.ROUTINES
WHERE ROUTINE_NAME IN ('TransformProduct', 'LoadDimProduct');

-- 6-2: transform ทำงานแล้ว (Color 'NA' ถูกแทน)
SELECT CASE WHEN (SELECT COUNT(*) FROM staging.product WHERE Color = 'NA') = 0
            THEN 'OK' ELSE 'FAIL: ยังมี Color = NA (Transform ยังไม่รัน)' END AS check_clean;

-- 6-2: dw.DimProduct โหลดแล้วและสะอาด
SELECT CASE WHEN (SELECT COUNT(*) FROM dw.DimProduct) > 0 THEN 'OK' ELSE 'FAIL: dw.DimProduct ว่าง' END AS check_dimproduct;
SELECT CASE WHEN (SELECT COUNT(*) FROM dw.DimProduct WHERE ModelName IS NULL) = 0
            THEN 'OK' ELSE 'FAIL: dw.DimProduct มี ModelName NULL' END AS check_dimproduct_clean;
