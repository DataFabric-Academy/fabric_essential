# Workshop 6-1 + 6-2 — Data Pipeline

## ผลลัพธ์สุดท้าย

```text
My workspace
├── Copy DimDate        (pipeline: Copy data → Script, เส้น On Success)
├── ETL DimProduct      (pipeline: Dataflow → TransformProduct → LoadDimProduct)
└── AdventureworksDW
    ├── staging.date          (จาก Copy — Load to new table)
    ├── dw.DimDate            (จาก Script CTAS)
    ├── staging.TransformProduct (proc)
    ├── dw.LoadDimProduct        (proc)
    └── dw.DimProduct         (โหลดแล้ว, ไม่มี 'NA')
```

## ปม rerun (คำถามใน Workshop 6-1) — เฉลยเต็ม

- **เพราะอะไร**: Script activity ใช้ CTAS — `CREATE TABLE dw.DimDate AS SELECT ...` สร้างตารางที่มีชื่ออยู่แล้วไม่ได้ รอบที่สองแดงที่ Script
- **แก้ (a)**: re-runnable — `IF EXISTS ... DROP TABLE;` ก่อน CTAS (ตามไฟล์ `DW/4` — ถ้าผู้สอนสอนให้ copy จากไฟล์ตัดบรรทัดนี้ออกก่อนเพื่อให้ปมเกิด)
- **แก้ (b)**: แยกขั้น — สร้าง typed table ครั้งเดียว + `INSERT INTO dw.DimDate SELECT ... FROM staging.date;` ทุกรอบ (แนวคิด `DW/Fix_error.sql`; ไฟล์นั้นเป็น scratch ที่ยังขาด INSERT และอ้าง `dbo.DimDate` ผิด — ใช้อธิบายได้แต่อย่า copy เป็นคำตอบ)
- **Copy activity รอบสอง** ก็แดงเหมือนกัน (Load to new table สร้าง staging.date ซ้ำ) — แก้โดยชี้ตารางเดิม

## ตรวจ (CHECK.sql)

รันไฟล์ [`CHECK.sql`](CHECK.sql) บน Warehouse — คาดหวังทุกแถว `OK`

## จุดพังที่พบ

| อาการ | แก้ |
|---|---|
| Script แดงตอน rerun | ใช้แนวแก้ a หรือ b ด้านบน |
| proc หาไม่เจอใน activity | ยังไม่รันไฟล์ DW/5, DW/6 |
| dim ยังมี 'NA' | เส้นลำดับผิด — Load ต้องมาหลัง Transform (On Success) |
| schedule ทำงานเองตลอด | ปิด schedule ทิ้งหลังโชว์ — trial จัดการคิวนาน |
