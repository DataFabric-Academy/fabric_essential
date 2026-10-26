# Workshop 3 — สร้าง Warehouse + staging.internetsales

## ผลลัพธ์สุดท้าย

```text
My workspace
├── AdventureworksDW            (Warehouse)
│   └── schema staging → ตาราง internetsales (10 คอลัมน์, 0 แถว)
└── AdventureworksDW            (default Power BI semantic model)
```

## วิธีตรวจ

1. Explorer ของ Warehouse เห็น schema `staging` และตาราง `internetsales`
2. New SQL query:

```sql
SELECT COUNT(*) AS rows_now FROM staging.internetsales;      -- ควรเป็น 0
SELECT COLUMN_NAME, DATA_TYPE FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA='staging' AND TABLE_NAME='internetsales'; -- 10 แถว, เงินเป็น decimal
```

## จุดพังที่พบ

- CREATE SCHEMA error ซ้ำ → ข้ามรันตารางต่อ
- Explorer ไม่ refresh → กด Refresh บนทูลบาร์

เกินนี้อ่าน [`reference/failure-modes.md`](../../reference/failure-modes.md)
