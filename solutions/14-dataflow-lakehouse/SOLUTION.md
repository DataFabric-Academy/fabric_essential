# Workshop 15 — Dataflow Gen2 → Lakehouse (FactResellerSales)

## ผลลัพธ์สุดท้าย

```text
My workspace
├── Get Reseller Sales          (Dataflow Gen2, succeeded)
└── AdventureworksLH
    └── Tables
        └── FactResellerSales   (10 คอลัมน์, New Table, Replace)
```

## ตรวจ (CHECK.sql)

รันไฟล์ [`CHECK.sql`](CHECK.sql) ที่ SQL endpoint — คาดหวังทุกแถว `OK`

ตัวเลขอ้างอิงห้อง (จากการซ้อม): rows = `____`, total_sales = `____`

## จุดพังที่พบ

| อาการ | แก้ |
|---|---|
| New Table ชนชื่อเดิม | ลบตัวเก่า (จาก Load to Tables ตอน stretch) หรือใช้ชื่อเดียวกันทั้งห้อง |
| publish ซ้ำข้อมูลซ้อน | destination settings → Replace |
| refresh failed | ตรวจ Choose columns ให้ครบ 10 ตามลิสต์ใน LAB |
| endpoint ไม่เห็นตาราง | รอ sync + Refresh |
