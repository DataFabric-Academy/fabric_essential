# Module 16 — Posttest + Big Data NYC Taxi Demo

> ⏱ ~50 นาที · 🎯 ปิดหลักสูตรด้วยงานรวมจากทุกโมดูล แล้วชม Warehouse ยุบ 170 ล้านแถวอย่างที่ไม่มีใครเห็นบ่อย · Everything from Day 1 to Day 2 lands in one posttest — and the NYC demo shows why.

## Key idea / แนวคิดหลัก — เล่าเรื่อง

หลักสูตรสองวันมีสองอย่างที่ต้องจบตอนท้าย อย่างแรกคือ **Posttest** — งานรวมที่ตั้งใจให้คุณทำโดยไม่มีคนเดินพา: สร้าง/แก้ semantic model บน Lakehouse ให้ใช้งานได้จริง (relationship ถูก, hierarchy เหมาะสม, measures ตามไฟล์ `LH/Measure.txt`) แล้วต่อยอดเป็นรายงานสองแบบ — auto-create และรายงานที่สร้างเองบน attributes/measures ที่ auto-create ไม่ได้ให้มา ถ้าคุณทำจบ คุณพิสูจน์แล้วว่าเดินทางทั้งหมดได้ด้วยตัวเอง ตั้งแต่กดสร้าง Warehouse วันแรก จนถึง shortcut และ model บน endpoint

อย่างที่สองคือ**สาธิตที่ตอบคำถามที่ยังไม่มีใครถาม**: "ทำไมต้องใช้ Fabric ทั้งกองไหม — ทำไมไม่ใช้ SQL Server เครื่องเดียวก็พอ?" คำตอบคือ demo **NYC Taxi** ดัดแปลงจาก tutorial "Load New York Taxicab data" ของ Synapse ซึ่งผู้สอนจะเดินให้ดู: นำเข้าข้อมูล taxi ปี 2013 จาก Azure Blob รวมกันราว 9 GB และ fact table ประมาณ 170 ล้านแถว ด้วยไฟล์สี่ตัวในโฟลเดอร์ `Demo/` — ผู้เข้าอบรมแค่สังเกต ผู้สอนสาธิต

สิ่งที่ demo พยายามให้เห็นมีสามชั้น ชั้นแรก: `COPY INTO` (T-SQL) กลืนไฟล์เป็นพัน ๆ ไฟล์เข้าตารางได้โดยไม่ต้องเปิดหน้าจอ UI แม้แต่อันเดียว ชั้นที่สอง: คิวรี่ JOIN 170 ล้านแถวกับตาราง dim ยังตอบในไม่กี่วินาที เพราะ engine แบบกระจาย ชั้นที่สามและลึกที่สุด: ผ่าน `DISCOVER_STORAGE_TABLE_COLUMN_SEGMENTS` คุณจะเห็นกลไกภายในของ storage — คอลัมน์ข้อมูลถูกเก็บเป็น segment แยกกัน มีค่า **TEMPERATURE** บอกว่าข้อมูลส่วนไหน "เย็น" (cold cache — ยังไม่ถูกเรียกใช้เป็นเวลานาน) กับ "ร้อน" (hot cache — อยู่ในแคชแล้ว) และเมื่อคิวรี่อ่านครั้งแรก ระบบจะ **on-demand load** — โหลดเฉพาะคอลัมน์ที่จำเป็นลงแคช ไม่ใช่ทั้งตาราง — นี่คือผลลัพธ์ของการเก็บข้อมูลเป็น Parquet ที่เราพูดถึงตั้งแต่วันแรก มาโชว์ตัวจริงให้ดูตอนปิดหลักสูตร

> EN: Posttest proves the class can do it alone; the NYC demo proves the platform scales.

## Concept / เนื้อหา

- โจทย์ Posttest ในสองข้อ:
  1. Semantic model บน Lakehouse ใช้งานได้ — relationship ถูก, hierarchies เหมาะสม, measures จาก `LH/Measure.txt`
  2. Power BI report จาก model: auto-create + custom report ที่ใช้ attributes/measures นอกเหนือจากที่ auto-create ให้
- ไฟล์ demo (โฟลเดอร์ `Demo/`) เรียงตามบทบาท:
  - `01_Create Tables.sql` — ตาราง dim (Date, Geography, Medallion...) + Trip
  - `02_Load Data.sql` — **COPY INTO** จาก public blob (CSV dims + Parquet trips ปี 2013)
  - `03_Test Perf.sql` — COUNT 170 ล้านแถว, aggregate ต่อเดือน, และสคริปต์เก็บกวาด (DELETE — อย่ารันพลาด)
  - `04_Semantic Model Storage Discover.sql` — ดู column segments, TEMPERATURE (hot/cold), LAST_ACCESSED
- ศัพท์ที่ demo ใช้: **cold cache** = ข้อมูลในแคชที่ไม่ถูกเรียกใช้นาน โหลดกลับช้ากว่า; **on-demand loading** = โหลดเฉพาะคอลัมน์ที่จำเป็นลงแคช ประหยัดเวลาและทรัพยากร
- ข้อจริงของ demo: ต้องใช้ Warehouse แยก (เช่น `New York Taxi Perf`) และเวลา load จริงหลายนาที — ผู้สอนควรเตรียมล่วงหน้า

## ลงมือทำตามลำดับ

- สอบ: [LAB.md](LAB.md) — เกณฑ์ให้คะแนนอยู่ในเฉลยผู้สอน
- ชม demo: ผู้สอนเดินสี่ไฟล์ `Demo/` ตามลำดับ จนถึง DISCOVER_STORAGE ก่อน-หลังคิวรี่ เพื่อเห็น cold กลายเป็น hot

## Common pitfalls / กับดัก

- อ้าง measure ผิดตาราง — model นี้เป็นฝั่ง reseller: fact คือ `FactResellerSales` ไม่ใช่ FactInternetSales
- ลืมว่า DimDate มาจาก shortcut — ถ้าปม Mark as date table ยังไม่แก้ Time Intelligence จะทำงานไม่ได้ (เฉลยอยู่ในโมดูลก่อนหน้า)
- ให้คะแนนจากความสวยของ report — เกณฑ์จริงคือ relationship/hierarchy/measures ที่ถูกต้องตามโจทย์
- รัน demo ไฟล์ `02_Load Data.sql` ใน Warehouse ที่ใช้สอบ — ใช้ Warehouse แยกเสมอ ไม่ใช่ `AdventureworksDW` ที่ใช้มาทั้งคอร์ส

## Quick check / ทบทวน

<details>
<summary>1. Posttest ต้องมีอะไรอย่างน้อย</summary>
Semantic model ที่ใช้ได้ (relationship + hierarchy + measures จาก LH/Measure.txt) และรายงานสองแบบ
</details>

<details>
<summary>2. COPY INTO ต่างจาก Dataflow ตรงไหน</summary>
COPY INTO คือ T-SQL โหลดไฟล์เข้า Warehouse โดยตรง — เร็ว ไม่ต้องมี UI เหมาะกับไฟล์ใหญ่จำนวนมาก
</details>

<details>
<summary>3. on-demand loading คืออะไร</summary>
โหลดเฉพาะคอลัมน์ที่คิวรี่/visual ต้องใช้ลงแคช — ทำงานได้เพราะข้อมูลเป็น Parquet columnar
</details>

## Go deeper

- [Ingest data using T-SQL (COPY INTO, CTAS)](https://learn.microsoft.com/en-us/fabric/data-warehouse/ingest-data-tsql)
- [Azure Open Datasets — NYC Yellow Taxi](https://learn.microsoft.com/en-us/azure/open-datasets/dataset-taxi-yellow)
- [Warehouse overview (columnar + Direct Lake)](https://learn.microsoft.com/en-us/fabric/data-warehouse/data-warehousing)
