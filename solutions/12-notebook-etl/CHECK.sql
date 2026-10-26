-- CHECK.sql — Workshop 13: ตรวจ manage/external_DimReseller ผ่าน SQL analytics endpoint ของ Lakehouse

SELECT CASE WHEN COUNT(*) > 0 THEN 'OK' ELSE 'FAIL: manage_DimReseller ว่าง/ไม่มี' END AS check_manage
FROM manage_DimReseller;

SELECT CASE WHEN COUNT(*) > 0 THEN 'OK' ELSE 'FAIL: external_DimReseller ว่าง/ไม่มี' END AS check_external
FROM external_DimReseller;

-- จำนวนแถวสองตารางต้องเท่ากัน (เขียนจาก DataFrame เดียวกัน)
SELECT CASE WHEN (SELECT COUNT(*) FROM manage_DimReseller) = (SELECT COUNT(*) FROM external_DimReseller)
            THEN 'OK' ELSE 'FAIL: จำนวนแถวไม่เท่ากัน' END AS check_rowcount;

-- คอลัมน์ Province/Country มาจาก join DimGeography — ต้องไม่ว่างทั้งตาราง
SELECT CASE WHEN COUNT(*) = 0 THEN 'OK' ELSE 'FAIL: มี Province ว่าง (join หลุด)' END AS check_geo
FROM manage_DimReseller WHERE Province IS NULL;

-- ResellerKey ถูก cast เป็น integer แล้ว
SELECT CASE WHEN COUNT(*) = 0 THEN 'OK' ELSE 'FAIL: ResellerKey ยังเป็น string' END AS check_cast
FROM (SELECT TRY_CAST(ResellerKey AS INT) AS rk FROM manage_DimReseller) t
WHERE rk IS NULL;
