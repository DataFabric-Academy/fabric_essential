# Workshop 4-1 + 4-2 — Dataflow Gen2 เข้า Warehouse

## ผลลัพธ์สุดท้าย

```text
My workspace
├── Get Internet Sales   (Dataflow Gen2, refresh succeeded)
├── Get Products         (Dataflow Gen2, refresh succeeded)
└── AdventureworksDW
    ├── staging.internetsales  (10 คอลัมน์, มีข้อมูล)
    └── staging.product        (6 คอลัมน์, มีข้อมูล, category/subcategory ครบ)
```

Connection ต้องมีสองอัน: Blob (Access Key) และ Azure SQL (Basic auth) — ตั้งชื่อให้ค้นเจอ

## วิธีตรวจ (รันบน Warehouse)

```sql
-- 4-1
SELECT COUNT(*) AS rows_total,
       MIN(SalesAmount) AS min_amt, MAX(SalesAmount) AS max_amt,
       SUM(CASE WHEN CustomerKey IS NULL THEN 1 ELSE 0 END) AS null_customers
FROM staging.internetsales;
-- rows_total = ____ (จากการซ้อมผู้สอน), มี NULL ของ key บางแถวได้ (มองเห็นตอนสร้าง view)

-- 4-2
SELECT COUNT(*) AS rows_total,
       SUM(CASE WHEN EnglishProductCategoryName IS NULL THEN 1 ELSE 0 END) AS null_cat,
       SUM(CASE WHEN ModelName IS NULL THEN 1 ELSE 0 END) AS null_model
FROM staging.product;
-- rows_total = ____ ; ค่า NULL เหล่านี้คือของที่ staging.TransformProduct จะทำความสะอาดใน Workshop 6-2
```

## จุดพังที่พบ

| อาการ | แก้ |
|---|---|
| rows_total โตเท่าตัวเมื่อ publish ซ้ำ | destination ยัง Append → เปลี่ยนเป็น Replace |
| คอลัมน์ไม่ครบ 10/6 | กลับ Choose columns ใน Power Query |
| connect ไม่ผ่าน | Access Key/พารามิเตอร์ผิดหรือติดช่องว่าง — คัดลอกใหม่จาก Link.txt |

ค่าตัวเลขอ้างอิงห้อง: `____` (จาก instructor/preclass-checklist.md)
