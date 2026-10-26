# Workshop 13 — ETL ด้วย Notebook

> ⏱ 25 นาที · Start state: `AdventureworksLH` มี `Files/Source/DimReseller.csv` + `Files/Source/DimGeopraphy.csv` (โมดูล 11)

## Goal / เป้าหมาย

รัน `LH/ETL DimReseller.ipynb` จบและได้ Delta tables สองตัว — `manage_DimReseller` และ `external_DimReseller` — พร้อมพิสูจน์ด้วยตัวเองว่า managed กับ external ต่างกันอย่างไร

## Steps / ขั้นตอน

1. Upload notebook: ที่ workspace กด New → Import notebook → เลือกไฟล์ `LH/ETL DimReseller.ipynb`

2. ผูก Lakehouse: ใน notebook → แถบ Explorer → Add → `AdventureworksLH` (เลือกเป็น default lakehouse)

3. รันทีละ cell ตามลำดับ พร้อมสังเกต:

   - cell อ่าน CSV ครั้งแรก: สังเกตคอลัมน์เยอะและ type ทั้งหมดเป็น string — นี่คือของดิบ
   - cell หลัง drop: เหลือคอลัมน์ธุรกิจที่ใช้จริง
   - cell หลัง join: คอลัมน์ geography มาต่อท้าย — เช็กว่าแถวไม่หาย (ถ้า join คืน 0 แถว แปลว่า key สองฝั่งชนิดไม่ตรง)
   - cell rename + cast: ResellerKey กลายเป็น Integer
   - cell เขียน managed table: รอจนเสร็จ
   - cell เขียน external table: รอจนเสร็จ

4. ตรวจผลใน Lakehouse Explorer → กด **Refresh**

   ผลที่ควรเห็น: Tables มี `manage_DimReseller` และ `external_DimReseller` และที่ `Files/external/external_DimReseller` มีไฟล์ Parquet + `_delta_log`

5. ตรวจทาง SQL endpoint: สลับไป SQL analytics endpoint → New SQL query

   ```sql
   SELECT COUNT(*) FROM manage_DimReseller;
   SELECT COUNT(*) FROM external_DimReseller;
   ```

   ผลที่ควรเห็น: สองตารางจำนวนแถวเท่ากัน — เพราะเขียนจาก DataFrame เดียวกัน

6. พิสูจน์ความต่าง managed/external ด้วยมือของคุณ:

   - ลบ `external_DimReseller` ใน Explorer → กลับไปดู `Files/external/external_DimReseller` — **ไฟล์ยังอยู่ครบ**
   - รัน cell เขียน external อีกครั้ง — table กลับมา ชี้ไปไฟล์ชุดเดิม

   จำภาพนี้ไว้ — มันคือความต่างที่หนังสือเรียนพยายามอธิบายทั้งหน้า

## ✅ Checkpoint

- [ ] ทั้งสอง table ปรากฏใน Tables
- [ ] COUNT ผ่าน SQL endpoint เท่ากันสองตาราง
- [ ] ลบ external แล้วเห็นด้วยตัวว่าไฟล์ไม่หาย
- [ ] ชี้ได้ว่า cell ไหนตัดสิน managed/external (มี/ไม่มี `path=`)

## 🛠 Troubleshooting

| อาการ | สาเหตุ | แก้ |
|---|---|---|
| `Path not found Files/Source/...` | notebook ไม่ผูก lakehouse หรือชื่อไฟล์ไม่ตรง | Add lakehouse แล้วตรวจชื่อไฟล์ (DimGeopraphy.csv) |
| `Delta table already exists` | รัน saveAsTable ซ้ำโดยไม่มี overwrite | คง `mode("overwrite")` ตาม notebook เดิม |
| join คืนแถว 0 | key สองฝั่งชนิดไม่ตรง (string vs int) | cast ให้เหมือนกันก่อน join หรือทำตามลำดับ notebook |
| Explorer ไม่เห็นตารางใหม่ | metadata ยัง sync | กด Refresh หรือรอครู่เดียว |
| SQL endpoint ไม่เห็นตาราง | endpoint ยังไม่ refresh metadata | กด Refresh ที่ endpoint (หรือรอ auto sync) |

## 🆘 Behind? Catch up

โครงสร้างสุดท้ายและ SQL ตรวจอยู่ที่ [`solutions/12-notebook-etl/SOLUTION.md`](../../solutions/12-notebook-etl/SOLUTION.md) — ผลของแล็บนี้จำเป็นต่อโมดูล 13–15 ให้ทำให้จบ

## Stretch / ต่อยอด

เพิ่ม cell: `spark.sql("DESCRIBE DETAIL manage_DimReseller").show()` — ดูจำนวนไฟล์ ขนาด และ format ของ Delta table แล้วเทียบกับ `DESCRIBE DETAIL external_DimReseller` — สังเกต path ที่ต่างกันของสองตาราง
