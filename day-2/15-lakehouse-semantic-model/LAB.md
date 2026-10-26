# Workshop 16 — Semantic Model บน Lakehouse + สืบสวน date table

> ⏱ 30 นาที · Start state: `FactResellerSales` (Workshop 15), shortcuts `DimDate`/`DimProduct` (Workshop 14), `manage_DimReseller` (Workshop 13)

## Goal / เป้าหมาย

- ได้ semantic model บน Lakehouse มี relationship ครบสามเส้น + hierarchy ที่ใช้ได้
- ตอบได้ว่าทำไม Mark as date table บน DimDate (shortcut) ไม่สำเร็จ — พร้อมหลักฐาน SQL ที่คุณรวบรวมเอง

## Steps / ขั้นตอน

1. เปิด `AdventureworksLH` → สลับมุมขวาบนเป็น **SQL analytics endpoint**

2. กด **New semantic model** → ตั้งชื่อ (เช่น `Reseller Star Model`) → เลือกตาราง: `FactResellerSales`, `manage_DimReseller`, `DimDate`, `DimProduct` → Confirm

   เพราะ default model ถูกยกเลิกไปแล้ว นี่คือหนทางเดียวที่ทำงานปัจจุบัน — และมันให้ความเป็นเจ้าของกับคุณเต็ม ๆ

3. ตั้ง relationship สามเส้นที่ Model explorer:

   - `FactResellerSales[OrderDateKey] → DimDate[DateKey]`
   - `FactResellerSales[ResellerKey] → manage_DimReseller[ResellerKey]`
   - `FactResellerSales[ProductKey] → DimProduct[ProductKey]`

4. Attribute hierarchy + sort: ที่ DimDate สร้าง hierarchy จาก YearName/QuarterName/EnglishMonthName (เหมือน Workshop 7-1 วันแรก) และซ่อน columns ที่ไม่ใช้

5. **สืบสวนปม Mark as date table**: ลองกำหนด DimDate เป็น date table ด้วยคอลัมน์ `FullDateAlternateKey` — สังเกตผลแล้วตั้งสมมติฐาน

6. พิสูจน์ด้วย SQL ที่ endpoint:

   ```sql
   -- ชนิดข้อมูลจริงของทุกคอลัมน์
   SELECT COLUMN_NAME, DATA_TYPE
   FROM INFORMATION_SCHEMA.COLUMNS
   WHERE TABLE_NAME = 'DimDate'
   ORDER BY ORDINAL_POSITION;

   -- ค่าซ้ำ/ว่างของคอลัมน์ date
   SELECT COUNT(*) AS total_rows,
          COUNT(DISTINCT FullDateAlternateKey) AS distinct_dates,
          COUNT(FullDateAlternateKey) AS non_null_dates
   FROM DimDate;

   -- เทียบกับฝั่ง Warehouse (ที่มาของ shortcut)
   SELECT COLUMN_NAME, DATA_TYPE
   FROM INFORMATION_SCHEMA.COLUMNS
   WHERE TABLE_NAME = 'DimDate';
   -- รันบน Warehouse AdventureworksDW แล้วเทียบ DATA_TYPE ทั้งสองฝั่ง
   ```

   บันทึกหลักฐาน: ชนิดจริงของ FULLDATEALTERNATEKEY ฝั่ง endpoint คืออะไร ต่างจากฝั่ง Warehouse ไหม

7. ทดสอบสมมติฐานที่สาม: ลอง Mark as date table บน model ที่คุณเพิ่งสร้าง — ถ้าผ่านบน model ใหม่แต่ไม่ผ่านที่อื่น จงบันทึกเงื่อนไขที่ต่างกัน

8. จบแล็บ: จดสมมติฐาน + หลักฐานที่เจอ แล้วเทียบกับเฉลยใน `solutions/15-lh-semantic-model/SOLUTION.md` — สิ่งที่คุณสร้างวันนี้คือ model ที่ Posttest จะใช้ต่อ

## ✅ Checkpoint

- [ ] relationship ครบสามเส้น
- [ ] hierarchy สร้างและ sort ถูก
- [ ] บันทึกสมมติฐานเรื่อง date table ได้อย่างน้อยสองข้อ
- [ ] มีหลักฐาน SQL (ชนิดคอลัมน์ + ค่าซ้ำ) มาสนับสนุน
- [ ] มี semantic model ที่ใช้ต่อใน Posttest ได้

## 🛠 Troubleshooting

| อาการ | สาเหตุ | แก้ |
|---|---|---|
| relationship ผูกไม่ได้ | key คนละ type ข้าม endpoint | ตรวจ INFORMATION_SCHEMA.COLUMNS ทั้งสองฝั่ง เทียบ type |
| INFORMATION_SCHEMA ไม่มีแถวตาราง | ใส่ชื่อไม่ตรงที่ endpoint ตั้ง | `SELECT TABLE_SCHEMA, TABLE_NAME FROM INFORMATION_SCHEMA.TABLES;` ดูชื่อจริงก่อน |
| Mark as date table ผ่านบาง model บาง model ไม่ผ่าน | เงื่อนไขเฉพาะของแต่ละ model/ข้อมูล | บันทึกเงื่อนไขที่ต่าง — นี่คือคำตอบที่โจทย์ต้องการ |
| model ไม่เห็นตาราง shortcut | ยังไม่เลือกตารางตอนสร้าง model | แก้ที่ model → เพิ่มตาราง |

## 🆘 Behind? Catch up

ทำ relationship ให้ครบก็พอสอบต่อ — ส่วนปม date table อ่านเฉลยที่ [`solutions/15-lh-semantic-model/SOLUTION.md`](../../solutions/15-lh-semantic-model/SOLUTION.md)

## Stretch / ต่อยอด

เพิ่ม measures จากไฟล์ `LH/Measure.txt` (Revenue, Cost, Profit, Margin ฝั่ง reseller) ใส่ model — นี่คือไฟล์ที่ Posttest อ้างถึง ทำไว้ก่อนคือได้เวลาสอบเพิ่ม
