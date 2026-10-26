# Module 03 — Warehouse: สร้าง Warehouse และตารางแรกด้วย T-SQL

> ⏱ ~35 นาที · 🎯 สร้าง Warehouse และ staging table ด้วย DDL รู้ว่า Schema กับ Staging ทำหน้าที่อะไร · DDL first, load later — the staging table is the landing pad of your ETL.

## Key idea / แนวคิดหลัก — เล่าเรื่อง

เวลาคุณกดสร้าง Warehouse ใน Fabric มันไม่ได้ให้แค่ "ตัว editor SQL ว่าง ๆ" — ด้านหลังมีตัวประมวลผล T-SQL แบบกระจายที่เตรียมทำงานกับข้อมูลระดับพันล้านแถว และข้อมูลของคุณจะถูกเก็บจริงเป็นไฟล์ **Parquet** รูปแบบ column-oriented ปิดท้ายด้วย Delta log ทำให้จ่ายแค่คิวรี่ที่ใช้จริงเมื่ออ่านผ่าน Power BI โหมด Direct Lake

ทีนี้คำถามคือ ก่อนข้อมูลจะ "สะอาด" มันมาจากไหน? จากไฟล์ CSV ที่กองบน blob จากฐานข้อมูลระบบขาย จาก export ของซอฟต์แวร์เก่า ๆ — ของพวกนี้มักมีคอลัมน์เกิน, ค่า NULL แปลก ๆ, และ key ที่หาย ถ้าคุณพุ่งเข้าเขียนลงตาราง dimension ของ BI โดยตรง ความสกปรกจะติดไปกับรายงานทุกใบ

หลักการที่หลักสูตรนี้ยึดจึงเป็นแนวคิดเก่าแก่ของโลก DW: แยกบ้านสองหลังด้วย **schema** — บ้านแรกชื่อ `staging` รับของดิบทุกอย่างลง **staging table** (โต๊ะรับของของกลไก ETL) บ้านที่สองชื่อ `dw` เก็บของที่ล้างแล้วและพร้อมให้ BI ใช้ และเพราะ schema ใน SQL เป็นขอบเขตด้าน security ด้วย คุณตัดสิทธิ์ให้ทีม ETL เห็นแค่ staging โดยไม่แตะ dw ได้ในบรรทัดเดียว

โมดูลนี้คุณยังไม่โหลดข้อมูลจริง — คุณกำลัง "วางโต๊ะรับของ" คือสร้าง `staging.internetsales` ที่มีโครง 10 คอลัมน์ รอข้อมูลจาก Workshop ถัดไปเทลงมา

> EN: Staging is the landing zone; dw is the clean zone. Schemas fence them apart.

## Concept / เนื้อหา

สามสิ่งที่จะได้ใช้ตลอดหลักสูตร:

- **Warehouse เก็บ Parquet + Delta log** — นี่ไม่ใช่รายละเอียดยิบย่อย แต่คือเหตุผลที่คิวรี่กับข้อมูลใหญ่ยังเร็ว และที่ Power BI Direct Lake อ่านข้อมูลได้โดยไม่ต้อง import
- **Schema คือขอบเขต** — แยกความสกปรก (staging) ออกจากความสะอาด (dw) และเป็นจุดกำหนดสิทธิ์ที่หยิบง่าย
- **แนวทางนำเข้ามีหลายแนวทาง และวันแรกเราจะทำครบ** — COPY INTO (T-SQL), Dataflow Gen2, Data Pipeline ผ่าน activities ต่าง ๆ, cross-warehouse, INSERT INTO…SELECT / SELECT INTO / CTAS แต่ละแนวทางมีที่ยืนของตัวเอง และตอนจบวันคุณควรเลือกได้ว่างานแบบไหนใช้อะไร

สคริปต์ที่ใช้ในโมดูลนี้: `DW/1. Create Staging Internetsales  Table.sql` — สร้าง schema `staging` และตาราง `internetsales` (10 คอลัมน์: keys และตัวเลขของ FactInternetSales)

## ลงมือทำตามลำดับ

1. แล็บ: [LAB.md](LAB.md) — สร้าง Warehouse `AdventureworksDW` และตาราง `staging.internetsales`
2. หลังจบแล็บ สังเกตสองอย่างใน Explorer: schema `staging` พร้อมตารางภายใต้มัน และรายการ semantic model ที่ปรากฏคู่ Warehouse ใน workspace — ตัวหลังจะกลายเป็นประเด็นพิเศษในโมดูล 07

## Common pitfalls / กับดัก

- `CREATE SCHEMA staging` รันซ้ำจะ error — ในคลาสนี้รันครั้งเดียวต่อ Warehouse ถ้าต้องการสคริปต์ re-runnable จริง ให้ใช้รูปแบบ `CREATE SCHEMA IF NOT EXISTS` ตามที่ไฟล์ `Pipeline/01_Create Staging DimDate.sql` ทำให้ดู
- คิวรี่ชี้ตารางผิด schema — ตรวจชื่อให้ครบ `staging.internetsales` ไม่ใช่ `dbo.internetsales`
- ตั้งชื่อ Warehouse ชนกับ item เดิมที่เพิ่งลบ — ชื่อซ้ำไม่ได้ทันที ระบบต้องใช้เวลา 1–2 นาทีล้างชื่อเก่า
- ตำแหน่งปุ่ม Get data บนหน้าจอคุณอาจต่างจากเพื่อนรอบข้าง — UI ของ Fabric เปลี่ยนบ่อย ยึดชื่อปุ่มเป็นหลัก ไม่ใช่ตำแหน่งบนจอ

## Quick check / ทบทวน

<details>
<summary>1. ทำไมแยก schema staging กับ dw</summary>
staging รับข้อมูลดิบของ ETL dw เก็บของสะอาดที่ BI ใช้ และ schema เป็นขอบเขต security ให้กำหนดสิทธิ์รวดเดียว
</details>

<details>
<summary>2. ข้อมูลจริงใต้ Warehouse เก็บรูปแบบอะไร</summary>
Parquet column-oriented + Delta log — จึงรองรับ Direct Lake และอ่านเฉพาะคอลัมน์ที่ใช้
</details>

<details>
<summary>3. ตาราง staging.internetsales วันนี้มีข้อมูลไหม</summary>
ยังไม่มี — มันคือโต๊ะรับของ ข้อมูลจะเทลงมาใน Workshop 4-1 ผ่าน Dataflow Gen2
</details>

## Go deeper

- [Create tables in the Warehouse](https://learn.microsoft.com/en-us/fabric/data-warehouse/create-table)
- [Ingest data using Transact-SQL](https://learn.microsoft.com/en-us/fabric/data-warehouse/ingest-data-tsql)
- [T-SQL surface area](https://learn.microsoft.com/en-us/fabric/data-warehouse/tsql-surface-area)
- [Warehouse overview](https://learn.microsoft.com/en-us/fabric/data-warehouse/data-warehousing)
