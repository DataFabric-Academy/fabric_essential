# Module 11 — Lakehouse: Delta Table, Upload CSV และ Fabric DataFrame

> ⏱ ~60 นาที (สอง workshop) · 🎯 สร้าง Lakehouse อัปโหลด CSV เขียน DataFrame อ่านด้วย Data Wrangler และเข้าใจ Delta Table · Tables are Delta; Files are everything else.

## Key idea / แนวคิดหลัก — เล่าเรื่อง

วันแรกคุณเดินผ่าน Warehouse — โลกที่มีทุกอย่างเป็นตารางที่สะอาดแล้ว แต่งานข้อมูลจริงเริ่มก่อนหน้านั้น: มีไฟล์ CSV กองโต, ไฟล์ Excel จากทีมอื่น, JSON จากระบบใหม่ ๆ ข้อมูลหลากหลายรูปแบบที่ยังไม่ผ่านการ "จัดระเบียบ" **Lakehouse** คือบ้านของโลกนั้น — แพลตฟอร์มจัดเก็บ-จัดการ-วิเคราะห์ข้อมูลทั้งที่มีและไม่มีโครงสร้าง บน compute เดียวกับ Spark

หัวใจของ Lakehouse คือ **Delta Table** ให้เลิกนึกว่า "ตาราง" ในที่นี้คือสิ่งที่อยู่ในกล่องสี่เหลี่ยม — Delta Table เป็น**นามธรรมของ data files**: ด้านล่างมันคือโฟลเดอร์หนึ่งที่เก็บไฟล์ **Parquet** (ข้อมูลจริง) และโฟลเดอร์ `_delta_log` (บันทึก transaction เป็น JSON) ขอบคุณ log นี้ ทำให้ Delta Lake นำคุณสมบัติ **ACID** มาสู่โลกของ Spark — หลายคนเขียน-หลายคนอ่านพร้อมกันได้อย่างปลอดภัยในระดับ Serializable สิ่งที่โลก warehouse ถือเป็นเรื่องปกติ โลก data lake เพิ่งมีได้ด้วยเทคโนโลยีนี้

Lakehouse แบ่งโลกสองฝั่งให้เห็นชัดใน Explorer: **Tables** (โลก Delta — เครื่องอ่านได้ด้วย SQL endpoint และ Spark) กับ **Files** (โลกดิบ — ไฟล์อะไรก็ได้ ใช้ผ่าน Spark) ข้อจำกัดที่ต้องจำ: อัปโหลดผ่าน Explorer แล้วกดให้กลายเป็น Delta table ได้เฉพาะ `.csv` และ `.parquet` ไฟล์อื่นยังอัปโหลดได้แต่ต้องใช้ผ่าน Spark และของฟรีที่มาพร้อม Lakehouse มีสองชิ้น — **SQL analytics endpoint** (T-SQL อ่านอย่างเดียว) และความสามารถสร้าง semantic model จากตาราง Delta

เกร็ดความทันสมัย: ตอนสร้าง Lakehouse ปัจจุบันคุณจะเจอตัวเลือก **schema-enabled lakehouse** (เปิด schema ให้ตารางมี namespace เหมือน SQL ได้ มี default schema ชื่อ dbo ให้) — เหมาะกับโครงการใหญ่ที่ต้องการความเป็นระเบียบ หลักสูตรนี้ใช้แบบดั้งเดิมเพื่อความเรียบง่าย แต่ควรรู้ว่าทางเลือกมี

แล็บสองชุด: **12-1** สร้าง Lakehouse + โฟลเดอร์ + อัปโหลด CSV และ **12-2** notebook เขียน **Fabric DataFrame** อย่างง่าย แล้วเปิดด้วย **Data Wrangler** — เครื่องมือแก้ข้อมูลแบบ interactive ที่ทำให้คุณเห็นข้อมูลแบบสเปรดชีตและเลือก transform เป็น click

> EN: One lakehouse, two folders — Tables (Delta) and Files (raw) — plus a read-only SQL door.

## Concept / เนื้อหา

- **Managed vs External** — managed table: Fabric เป็นเจ้าของไฟล์ในโฟลเดอร์ Tables (ลบ table = ไฟล์หาย) external table: metadata อยู่ใน lakehouse แต่ไฟล์อยู่ที่ path ที่คุณชี้ (ลบ table = ไฟล์ยังอยู่) — เรื่องนี้จะจับต้องได้จริงในโมดูลถัดไป
- **_delta_log** — transaction log JSON ที่ทำให้ Delta table มี ACID และ concurrency ระดับ Serializable — มันคือเหตุผลที่ Delta Table "ทนแข็งแรงกว่า" โฟลเดอร์ Parquet เปล่า ๆ
- **Fabric DataFrame** — คลาสย่อยของ pandas DataFrame (คุณเห็นแล้วใน Semantic Link) บน Spark อีกฝั่งคือ Spark DataFrame — notebook วันนี้ทำให้เห็นทั้งสองฝั่งและการเดินทางระหว่างกัน (`toPandas`)
- **Data Wrangler** — แก้ข้อมูลแบบ interactive เห็นทีละ step เหมือน Power Query แต่อยู่ใน notebook
- ไฟล์ที่ใช้: `LH/DimReseller.csv`, `LH/DimGeopraphy.csv` — ชื่อไฟล์หลังสะกด "Geopraphy" ตาม repo จริง **อย่าเปลี่ยนชื่อ** เพราะ notebook ETL ของโมดูลถัดไปอ้าง path นี้ตรง ๆ

## ลงมือทำตามลำดับ

- [LAB.md](LAB.md) Workshop 12-1: สร้าง `AdventureworksLH` + subfolder `Source`, `external` + อัปโหลด 2 CSV
- [LAB.md](LAB.md) Workshop 12-2: notebook สร้าง dataframe อย่างง่าย + Data Wrangler

## Common pitfalls / กับดัก

- อัปโหลด CSV แล้วหาไม่เจอ — ไฟล์ไปอยู่ที่ **Files** ไม่ใช่ Tables การกลายเป็น Delta table คือขั้นแยกต่างหาก (Load to Tables)
- เปลี่ยนชื่อไฟล์ `DimGeopraphy.csv` — notebook ของโมดูล 12 จะพังทันที อย่าแตะชื่อ
- เข้าใจว่า SQL endpoint เขียนได้ — อ่านอย่างเดียวเสมอ เหมือนที่เตือนไว้ตั้งแต่โมดูล 02
- ใช้ Data Wrangler กับ Spark DataFrame — มันอยู่กับ pandas ฝั่ง ให้แปลงเป็น pandas ก่อน (`toPandas`)

## Quick check / ทบทวน

<details>
<summary>1. _delta_log คืออะไร</summary>
Transaction log รูปแบบ JSON ที่ทำให้ Delta table มี ACID และ concurrent ระดับ Serializable
</details>

<details>
<summary>2. ไฟล์ชนิดไหนอัปโหลดแล้วกดเป็น Delta table ตรง ๆ ได้</summary>
เฉพาะ .csv และ .parquet — ชนิดอื่นใช้ผ่าน Spark
</details>

<details>
<summary>3. ของฟรีสองชิ้นที่มาพร้อม Lakehouse</summary>
SQL analytics endpoint (T-SQL อ่านอย่างเดียว) และความสามารถสร้าง semantic model จากตาราง Delta
</details>

## Go deeper

- [What is a lakehouse?](https://learn.microsoft.com/en-us/fabric/data-engineering/lakehouse-overview)
- [Lakehouse and Delta Lake tables](https://learn.microsoft.com/en-us/fabric/data-engineering/lakehouse-and-delta-tables)
- [SQL analytics endpoint for lakehouse](https://learn.microsoft.com/en-us/fabric/data-engineering/lakehouse-sql-analytics-endpoint)
- [Data Wrangler](https://learn.microsoft.com/en-us/fabric/data-science/data-wrangler)
