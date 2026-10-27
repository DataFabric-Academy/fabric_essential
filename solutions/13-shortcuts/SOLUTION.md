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

---

# Workshop 14B — Shortcut จากแหล่งภายนอก (แล็บแทรก)

## ผลลัพธ์สุดท้าย

```text
AdventureworksLH
└── Tables
    ├── ... (ของ Workshop 14 เดิม)
    ├── GreenTaxi_201901   (shortcut transformation: Parquet สาธารณะ → Delta ใน OneLake)
    └── dimdate            (Stretch: pointer → Delta ที่ผู้สอนเผยแพร่)
```

## ตรวจ

1. Connection: Azure Blob Storage · Authentication kind = **Anonymous** · account `azureopendatastorage`
2. ต้นทาง: โฟลเดอร์ `nyctlc/green/puYear=2019/puMonth=1` (มีไฟล์ `*.snappy.parquet` ~16 MB)
3. SQL endpoint:

```sql
SELECT TOP 5 * FROM GreenTaxi_201901;
SELECT COUNT(*) FROM GreenTaxi_201901;   -- = ____ (จดจำนวนจริง, คาด ~7-8 แสนแถว)
```

4. ข้อสรุปที่ต้องตอบได้: W14 = pointer (storage ไม่โต), W14B = copy ที่ Fabric แปลงเป็น Delta ให้และ sync ทุก 2 นาที (storage โต) — ถ้าต้นทางเป็น Delta อยู่แล้ว (Stretch) จะไม่มีขั้น Transform เพราะเป็น pointer ล้วน

## จุดพังที่พบ

| อาการ | แก้ |
|---|---|
| หาช่อง Anonymous ไม่เจอ | สร้าง connection ผิดชนิด — ต้องเป็น **Azure Blob Storage** (ADLS Gen2 ไม่มี Anonymous) |
| เลือกทั้ง `puYear` หรือทั้ง container แล้วแปลงไม่จบ | ลบ shortcut สร้างใหม่ จำกัดที่เดือนเดียว |
| COUNT ไม่ออกหลังสร้างเสร็จ | การแปลงยัง sync — ดู Manage shortcut → Refresh history แล้วรอ |
| path dataset เปลี่ยน | ข้อมูลสาธารณะปรับได้ — browse หา `green/puYear=*/puMonth=*` ที่ยังมีอยู่ ใช้เดือนอื่นแทน |
