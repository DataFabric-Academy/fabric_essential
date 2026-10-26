# Workshop 14 — Shortcut จาก Warehouse

## ผลลัพธ์สุดท้าย

```text
AdventureworksLH
└── Tables
    ├── manage_DimReseller          (ของจริง จาก notebook)
    ├── external_DimReseller        (ของจริง จาก notebook)
    ├── DimDate                     (shortcut → AdventureworksDW.dw.DimDate)
    └── DimProduct                  (shortcut → AdventureworksDW.dw.DimProduct)
```

## ตรวจ

1. Tables แสดง DimDate/DimProduct ด้วย icon shortcut
2. SQL endpoint:

```sql
SELECT TOP 5 DateKey, FullDateAlternateKey, EnglishMonthName FROM DimDate;
SELECT COUNT(*) FROM DimProduct;          -- = ____ (เท่ากับ dw.DimProduct ฝั่ง Warehouse)
SELECT TOP 5 ResellerName, Province FROM manage_DimReseller;   -- ของจริงยังใช้ได้ร่วมงาน
```

3. พิสูจน์ read-only: INSERT ผ่าน shortcut → error (พฤติกรรมที่ต้องการ)

## จุดพังที่พบ

| อาการ | แก้ |
|---|---|
| ไม่เห็น Warehouse ในหน้าเลือก | item คนละ workspace — รวมไว้ My workspace เดียว |
| รายการตารางว่าง | ฝั่ง Warehouse ยังไม่มี dw.DimDate/DimProduct — กลับ Workshop 6-1/6-2 |
| คิวรี่ error ทันทีหลังสร้าง | metadata sync — รอแล้ว Refresh |
