# บททดสอบ 5 — DimCustomer

## ผลลัพธ์สุดท้าย

```text
My workspace
├── Get Customers          (Dataflow Gen2, succeeded)
└── AdventureworksDW
    └── dw.DimCustomer     (7 คอลัมน์, มีข้อมูล)
```

โครงตารางตาม `DW/3. Create DimCustomer Table.sql`:
CustomerKey (int), CustomerName (varchar), MaritalStatus, Gender, City, Province, Country

## ขั้นตอนอ้างอิง (เปิดเมื่อติดจริง)

1. รัน `DW/3` ก่อน (uncomment CREATE SCHEMA dw ถ้า schema ยังไม่มี)
2. Dataflow `Get Customers` → source Azure SQL → DimCustomer (connection เดิม)
3. **CustomerName**: เลือก FirstName + MiddleName + LastName (Ctrl+คลิก) → คลิกขวาหัวคอลัมน์ → **Merge Columns** → Separator = Space → ตั้งชื่อ `CustomerName`
4. **Expand** relationship ไป DimGeography → เอาเฉพาะ `City`, `StateProvinceName` (จะ rename เป็น Province หรือปล่อยไว้แล้ว map ตอนเลือกคอลัมน์), `EnglishCountryRegionName` (→ Country)
5. Choose columns ให้เหลือ 7 คอลัมน์ตรงโครงตาราง
6. Destination `dw.DimCustomer` → **Replace** → Publish

## ตรวจ

```sql
SELECT TOP 10 * FROM dw.DimCustomer;
SELECT COUNT(*) AS rows_total,
       COUNT(*) - COUNT(CustomerName) AS null_names,
       SUM(CASE WHEN Country IS NULL THEN 1 ELSE 0 END) AS null_country
FROM dw.DimCustomer;
-- rows_total = ____ ; null_names = 0
```

## กับดักที่พบจริง

- **ช่องว่างซ้ำใน CustomerName** จาก MiddleName ว่าง (เช่น "Ada   Lopez") — Merge Columns เว้นช่องตามจำนวนคอลัมน์เสมอ แนวแก้ระดับ class: เลือก Merge เฉพาะ FirstName+LastName เมื่อ MiddleName ว่าง (conditional column) หรือยอมรับและอธิบาย lineage
- expand ผิดตาราง (DimProductSubcategory) — กลับ Applied steps แก้ source ของ step expand
- ลืม Replace → COUNT โตทุกรอบ publish
