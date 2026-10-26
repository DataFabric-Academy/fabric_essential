# Workshop 14 — สร้าง Shortcut จาก Warehouse

> ⏱ 15 นาที · Start state: `AdventureworksLH` มี manage/external_DimReseller แล้ว, Warehouse `AdventureworksDW` มี `dw.DimDate`, `dw.DimProduct` (จากวันที่ 1)

## Goal / เป้าหมาย

`AdventureworksLH` มี Delta tables ผ่าน shortcut: `DimDate` และ `DimProduct` ชี้ไป Warehouse จริง — พร้อมพิสูจน์ว่าเป็น pointer จริง ๆ

## Steps / ขั้นตอน

1. เปิด `AdventureworksLH` → Explorer → คลิกขวาที่ **Tables** → **New shortcut**

2. ในกล่อง New shortcut → **Internal sources → Microsoft OneLake**

3. เลือก **AdventureworksDW** (Warehouse จากวันที่ 1) → Next

4. เลือกตาราง: ✅ `dw.DimDate` ✅ `dw.DimProduct`

5. ปล่อยชื่อ shortcut ตามที่ระบบตั้ง → **Create**

   ผลที่ควรเห็น: Tables เพิ่ม `DimDate`, `DimProduct` แสดงด้วย icon shortcut — และ storage ของคุณไม่โตขึ้น นั่นแหละคือหลักฐานแรกว่าไม่มีอะไรถูก copy

6. พิสูจน์ที่สอง — อ่านได้จริง: สลับไป SQL analytics endpoint → New SQL query

   ```sql
   SELECT TOP 5 DateKey, FullDateAlternateKey, EnglishMonthName FROM DimDate;
   SELECT COUNT(*) FROM DimProduct;   -- ต้องเท่ากับ dw.DimProduct ฝั่ง Warehouse
   ```

7. พิสูจน์ที่สาม — อ่านอย่างเดียว (ตั้งใจให้ล้ม): New notebook → รัน

   ```python
   spark.sql("INSERT INTO DimDate VALUES (1, NULL, 1, 'x', 'x', 1, 'x', 'x')")
   ```

   ผลที่ควรเห็น: error — ยืนยันว่า shortcut ไม่รับการเขียน เขียนได้ที่ต้นทางเท่านั้น

8. ท้ายแล็บ: เปิดตาราง shortcut ใน Explorer แล้วดูรายละเอียด — จะเห็นว่ามันอ้าง item ต้นทาง ไม่ใช่ไฟล์ใน lakehouse ของคุณ

## ✅ Checkpoint

- [ ] `DimDate` + `DimProduct` โผล่ใน Tables ด้วย icon shortcut
- [ ] SELECT ผ่าน SQL endpoint ได้ และ COUNT ตรงกับฝั่ง Warehouse
- [ ] INSERT ผ่าน shortcut ล้มเหลว (เห็นด้วยตัวเอง)
- [ ] storage ไม่โตและอธิบายได้ว่าทำไม

## 🛠 Troubleshooting

| อาการ | สาเหตุ | แก้ |
|---|---|---|
| ไม่เห็น Warehouse ในหน้าเลือก | item อยู่ workspace อื่น | รวมทุกอย่างไว้ My workspace เดียวกัน |
| เลือกตารางแล้วรายการว่าง | Warehouse ยังไม่มีตาราง dw | กลับไปเช็ก Workshop 6-1 (`dw.DimDate`) และ 6-2 (`dw.DimProduct`) |
| shortcut สร้างแล้วคิวรี่ error ชั่วคราว | metadata กำลัง sync | รอ 30 วินาที กด Refresh แล้วคิวรี่ใหม่ |
| INSERT ผ่าน?! | คุณเขียนลงตาราง managed ไม่ใช่ shortcut | ตรวจชื่อตารางในคำสั่ง |

## 🆘 Behind? Catch up

ต้องมี `dw.DimDate` กับ `dw.DimProduct` จากวันที่ 1 — อ่านทางกลับที่ [`solutions/06-pipeline/SOLUTION.md`](../../solutions/06-pipeline/SOLUTION.md) แล้วสร้าง shortcut ทำขั้น 1–5

## Stretch / ต่อยอด

สร้าง shortcut อีกแบบ: คลิกขวาที่ **Files** → New shortcut → ชี้ไปโฟลเดอร์ `Files/external/external_DimReseller` ของ lakehouse เดียวกัน — เทียบประสบการณ์ internal → item กับ internal → โฟลเดอร์ แล้วตอบว่า shortcut ที่แรก "ยืม" อะไรมาให้คุณจริง ๆ
