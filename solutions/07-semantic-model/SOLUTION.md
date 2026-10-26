# Workshop 7-1 — Semantic Model

## ผลลัพธ์สุดท้าย

```text
My workspace
└── Best AdventureworksDW Model      (semantic model)
    ├── Objects: vwFactInternetSales, DimDate, DimProduct, DimCustomer
    ├── Relationships: 3 เส้น (ProductKey, CustomerKey, OrderDateKey↔DateKey)
    ├── Hierarchy: DimDate.Calendar (YearName → QuarterName → EnglishMonthName)
    ├── Date table: DimDate (FullDateAlternateKey)
    └── Measures: Revenue, Cost, Profit, Margin, YTD Revenue, Last Year Revenue, % Change
```

## ตรวจ

1. Model explorer → Relationships ต้องมีสามเส้นคาร์ดินาลิตี้ many-to-one จาก fact ไป dim
2. Measure ทดสอบ:

```dax
TestRows = COUNTROWS(vwFactInternetSales)
```

เทียบกับ SQL:

```sql
SELECT COUNT(*) FROM dw.vwFactInternetSales;   -- ต้องเท่ากัน
-- rows = ____
```

3. YTD ทำงาน: วาง `YTD Revenue` ใน card พร้อม slicer ปี — ค่าไม่เป็น blank

## สูตรอ้างอิงทั้งเจ็ด

อยู่ใน `DW/Measure.txt` (Revenue, Cost, Profit, Margin, Previous Year Revenue = Last Year Revenue) และสูตร YTD Revenue, Last Year Revenue, % Change ตาม README ของโมดูล

## จุดพังที่พบ

| อาการ | แก้ |
|---|---|
| Mark as date table ล้มเหลว | คอลัมน์ date ต้องเป็น date/datetime + ค่าไม่ซ้ำ/ไม่ว่าง — ตรวจ SQL ก่อน |
| สูตร error หาตารางไม่เจอ | ชื่อ fact ใน model คือ `vwFactInternetSales` (วิว) — ปรับสูตรตามชื่อจริง |
| YTD เพี้ยน | ยังไม่ mark date table หรือยังไม่ sort by column |
| เห็นตาราง staging ปน | Remove ออกจาก model — ให้เหลือ dw objects |
