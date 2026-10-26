# บททดสอบ 17 (Posttest) — เกณฑ์ตรวจ

## สิ่งที่งานที่ส่งต้องมี

```text
My workspace
├── semantic model บน Lakehouse     (default ที่แก้ หรือ New model)
│   ├── relationship 3 เส้นครบ
│   ├── hierarchy ≥ 2 (Calendar, Product category)
│   └── measures จาก LH/Measure.txt (Revenue, Cost, Profit, Margin ฝั่ง reseller)
├── Posttest Auto Report            (auto-create จาก model)
└── custom report                   (ใช้ attribute/measure เกินที่ auto ให้)
```

## ตารางให้คะแนน (รายละเอียดใน instructor/README.md)

| เกณฑ์ | เต็ม |
|---|---|
| Relationship ถูกต้อง (เส้นทาง + คาร์ดินาลิตี้) | 30% |
| Hierarchies เหมาะสม + drill ได้จริง | 20% |
| Measures ครบตาม Measure.txt | 20% |
| รายงานสองแบบ + custom ใช้ของเกินจาก auto | 20% |
| อธิบายปม date table (โบนัส) | 10% |

## SQL ตรวจระดับ model (ตรวจที่ endpoint)

```sql
-- orphan ต้องเป็น 0 ทั้งสามเส้น
SELECT COUNT(*) FROM FactResellerSales f LEFT JOIN DimDate d ON f.OrderDateKey=d.DateKey WHERE d.DateKey IS NULL;
SELECT COUNT(*) FROM FactResellerSales f LEFT JOIN manage_DimReseller r ON f.ResellerKey=r.ResellerKey WHERE r.ResellerKey IS NULL;
SELECT COUNT(*) FROM FactResellerSales f LEFT JOIN DimProduct p ON f.ProductKey=p.ProductKey WHERE p.ProductKey IS NULL;
```

## โบนัสคำถามที่ตรวจปากเปล่า

1. ทำไม Time Intelligence ยังไม่ทำงานถึงแม้ relationship ครบ? (ยังไม่ mark date table — และปม type ของคอลัมน์)
2. FactResellerSales เกิดขึ้นด้วยเครื่องมืออะไร แล้ว DimDate มาถึงตรงนี้ได้ไหง? (Dataflow + shortcut)
3. ถ้าจะนำ model นี้ให้ทีม data science ใช้ ต่อยอดอะไร? (Semantic Link — โมดูล 10)
