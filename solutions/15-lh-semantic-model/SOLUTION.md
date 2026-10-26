# Workshop 16 — Semantic Model บน SQL endpoint + ปม date table

## ผลลัพธ์สุดท้าย

```text
AdventureworksLH (SQL analytics endpoint)
└── default semantic model (หรือ New semantic model ทางเลือก)
    ├── Objects: FactResellerSales, manage_DimReseller, DimDate (shortcut), DimProduct (shortcut)
    ├── Relationships: 3 เส้น (OrderDateKey→DateKey, ResellerKey, ProductKey)
    └── Hierarchy: DimDate.Calendar + DimProduct (Category→Sub→Product)
```

## เฉลยปม Mark as date table (โจทย์ใน Workshop 16)

สมมติฐานสามข้อ + วิธีพิสูจน์ (ผลจริงขึ้นกับ tenant/รอบข้อมูล — อัปเดตจากการซ้อม):

1. **Type ของ FullDateAlternateKey ไม่ใช่ date/datetime**
   ตรวจ: `SELECT COLUMN_NAME, DATA_TYPE FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='DimDate';`
   ที่มา: DimDate ถูก copy ด้วย Copy activity "Load to new table" แล้วสร้างต่อด้วย CTAS — type ที่ copy อนุมานมาถูกคงไว้ (`DW/Fix_error.sql` มี CONVERT เพราะเจอปัญหา type จริงในวันที่ 1)
2. **ค่าซ้ำ/ว่าง**
   ตรวจ: `SELECT COUNT(*), COUNT(DISTINCT FullDateAlternateKey), COUNT(FullDateAlternateKey) FROM DimDate;` สามเลขต้องเท่ากัน
3. **ข้อจำกัดของ default semantic model**
   ตรวจ: สร้าง New semantic model จาก endpoint แล้วลองเทียบ + จำว่า default semantic models กำลังถูก sunset — ทางออกระยะยาวคือแนว New semantic model

**ผลที่จดจากการซ้อมรอบล่าสุด (ผู้สอนเติม):** DATA_TYPE จริง = `____`, Mark as date table บน default = `____`, บน New model = `____`

## ตรวจ relationship

- Model explorer มีสามเส้น คาร์ดินาลิตี้ many-to-one จาก `FactResellerSales`
- คิวรี่ตรวจคู่ key:

```sql
SELECT COUNT(*) AS orphan_dates FROM FactResellerSales f
LEFT JOIN DimDate d ON f.OrderDateKey = d.DateKey WHERE d.DateKey IS NULL;
-- คาดหวัง 0
```
