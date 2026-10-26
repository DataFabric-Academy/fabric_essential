# Workshop 12-1 + 12-2 — Lakehouse เริ่มต้น: Upload + DataFrame

> ⏱ 45 นาที · Start state: My workspace ยังไม่มี Lakehouse, มีไฟล์ `LH/DimReseller.csv` และ `LH/DimGeopraphy.csv` จาก repo

## Goal / เป้าหมาย

- 12-1: Lakehouse `AdventureworksLH` มีโฟลเดอร์ `Source`, `external` และไฟล์ CSV สองตัวใน Source
- 12-2: notebook สร้าง Fabric DataFrame อย่างง่าย แปลงเป็น pandas และเปิดด้วย Data Wrangler

## Steps — Workshop 12-1

1. สร้าง Lakehouse: New item → **Lakehouse** → ตั้งชื่อ **`AdventureworksLH`** → Create (ถ้าเห็นตัวเลือก schema ให้คงค่า default — หลักสูตรนี้ใช้แบบไม่มี schema เพื่อความเรียบง่าย)

   คุณจะเห็น Explorer แบ่งสองโลก: **Tables** กับ **Files** — และใน workspace จะโผล่ item คู่ ๆ ติดมา: SQL analytics endpoint สำหรับคิวรี่ T-SQL แบบอ่านอย่างเดียว

2. สร้าง subfolder: คลิกขวาที่ **Files** → New subfolder → สร้างสองอัน: `Source` และ `external`

   ทำไมสองโฟลเดอร์: `Source` คือที่วางของดิบก่อนแปลง `external` คือที่ของ external Delta tables ที่คุณจะสร้างในโมดูลถัดไป — โครงสร้างก่อนข้อมูลเสมอ

3. อัปโหลด: คลิกขวา `Source` → Upload files → เลือก `LH/DimReseller.csv` และ `LH/DimGeopraphy.csv` จาก repo

   ผลที่ควรเห็น: ไฟล์สองตัวอยู่ใต้ `Files/Source/` — อีกครั้ง: พวกมันยังเป็นแค่ไฟล์ ไม่ใช่ตาราง

4. แวะ SQL endpoint: สลับมุมขวาบน Lakehouse → SQL analytics endpoint → New SQL query → พยายาม `SELECT TOP 5 * FROM <อะไรก็ได้>;`

   คุณจะพบว่าไม่มีอะไรให้ query — ถูกต้อง เพราะ Tables ยังว่าง endpoint อ่านได้เฉพาะโลก Tables ไม่ใช่ Files — นี่คือบทเรียนเงียบ ๆ ของขั้นนี้

## Steps — Workshop 12-2

1. สร้าง notebook ใต้ Lakehouse: เปิด `AdventureworksLH` → ทูลบาร์ **Open notebook → New notebook**

2. ผูก Lakehouse: แถบข้าง Explorer ใน notebook → Add → `AdventureworksLH` — notebook ทุกตัวต้องรู้จัก lakehouse ของตัวเองก่อนแตะ `Files/...` ได้

3. เขียน dataframe อย่างง่าย:

   ```python
   data = [("Bike", 1000.0), ("Helmet", 120.5), ("Jersey", 45.0)]
   df = spark.createDataFrame(data, ["Product", "Price"])

   display(df)

   # ข้ามฝั่งจาก Spark DataFrame ไป pandas/Fabric DataFrame
   pdf = df.toPandas()
   type(pdf)
   ```

   ผลที่ควรเห็น: ตาราง 3 แถวแสดงใน display และ `type(pdf)` เป็น pandas — คุณเพิ่งเห็นสองโลก DataFrame ที่ทำงานร่วมกันได้

4. เปิด **Data Wrangler**: ที่ผลลัพธ์ของ `display(pdf)` → กด Data Wrangler

   คุณจะเห็นหน้าแก้ข้อมูลแบบ interactive — ลองเลือก transform ให้เห็นว่ามันสร้าง code step ให้อัตโนมัติ แล้วปิดโดยไม่บันทึก สังเกตว่ารูปแบบการทำงานเหมือน Power Query ที่ซ้อนอยู่ใน notebook

5. ท้ายแล็บ: กลับไปดู Explorer ของ Lakehouse — Tables ยังว่าง ของจริงจะเกิดในโมดูลถัดไปเมื่อคุณเขียน Delta table ด้วยมือเอง

## ✅ Checkpoint

- [ ] `AdventureworksLH` สร้างแล้ว มี SQL endpoint ติดมา
- [ ] `Files/Source/` มี CSV 2 ตัว และมีโฟลเดอร์ `external`
- [ ] notebook รัน dataframe และ toPandas สำเร็จ
- [ ] เปิด Data Wrangler เห็นหน้า interactive

## 🛠 Troubleshooting

| อาการ | สาเหตุ | แก้ |
|---|---|---|
| หาไฟล์ที่อัปโหลดไม่เจอ | อัปโหลดลง Tables หรือ path อื่น | ตรวจที่ Files → Source แล้วอัปโหลดซ้ำให้ถูกโฟลเดอร์ |
| notebook ไม่เห็น Lakehouse | ยังไม่ Add lakehouse | แถบ Explorer ใน notebook → Add data source |
| `spark` ไม่ปรากฏ | session ยังไม่สตาร์ท | รัน cell แรกแล้วรอ 1–2 นาที |
| Data Wrangler ไม่เปิด | ผลที่รันเป็น Spark ไม่ใช่ pandas | ใช้กับ `pdf` (toPandas) ไม่ใช่ `df` |
| ชื่อไฟล์สะกด DimGeopraphy | ชื่อจริงใน repo สะกดแบบนี้ | อัปโหลดตามชื่อเดิม — notebook โมดูลถัดไปอ้างตรง ๆ |

## 🆘 Behind? Catch up

โครงสร้างที่ต้องมีต่อแล็บถัดไปมีแค่: Lakehouse + `Files/Source/DimReseller.csv` — ทำขั้น 1–3 ก็ต่อได้ ดู [`solutions/11-lakehouse/SOLUTION.md`](../../solutions/11-lakehouse/SOLUTION.md)

## Stretch / ต่อยอด

อัปโหลด CSV แล้วทดลอง **Load to Tables** ให้เกิด Delta table ก่อนเวลา — แล้วคิวรี่มันผ่าน SQL endpoint ดูว่าชนิดข้อมูลที่ระบบเดามาถูกไหม จดสิ่งที่เดาผิดไว้เล่าในโมดูลถัดไป
