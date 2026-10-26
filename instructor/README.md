# ผู้สอนเท่านั้น

โฟลเดอร์นี้ไม่ใช่ทางเดินของผู้เรียน — มีจังหวะในห้อง เฉลยปมที่ปลูกไว้ เกณฑ์ให้คะแนน และบันทึกการอัปเดตเด็ค

## จังหวะในห้อง

**วันแรกเช้า** (โมดูล 01–03): SETUP ที่มอบหมายล่วงหน้าต้องผ่านทุกเครื่องก่อนเปิดคาบ — เครื่องไหน Trial ไม่ขึ้นให้ใช้บัญชีสำรองทันที อย่ารอ โมดูล 03 ต้องจบ Workshop 3 ก่อนพักเที่ยง (staging.internetsales ตารางว่างพร้อมโหลด)

**วันแรกบ่าย** (โมดูล 04–08): Workshop 4-1 + 4-2 ต้องจบก่อนบททดสอบ 5 — ถ้าห้องช้า ให้บททดสอบ 5 ทำแบบกึ่ง guided (เปิด README ของโมดูลได้) Workshop 6-2 ตัด stretch เมื่อเหลือเวลาน้อย Workshop 8 อย่างน้อยให้จบ auto-create ส่วน Desktop visuals ยืดหยุ่นได้ เพราะ Posttest วันหน้าไม่ได้วัดมัน

**วันที่สองเช้า** (โมดูล 09–11): Environment เป็น guided demo ประมาณ 20 นาที ถ้า tenant ช้าให้ข้ามไปใช้ `%pip install` inline ในโมดูล 10 แทน Workshop 11-1 ต้องจบก่อนพัก — มันเป็นประตูของ notebook ทั้งบ่าย

**วันที่สองบ่าย** (โมดูล 12–17): โมดูล 12 (ETL notebook) และ 13 (shortcut) ต้องจบก่อนโมดูล 14 จะเริ่มได้ ถ้าห้องตามไม่ทัน ให้ผู้สอนเตรียม `FactResellerSales` สำรองไว้ (สร้างใน workspace ที่ share ไม่ได้ — ให้เพื่อนบ้านแชร์หน้าจอแทน) โมดูล 15 ปม date table คือช่วงคุยที่ดีที่สุดของหลักสูตร เก็บเวลาไว้ให้มัน ปิดท้ายด้วย Posttest + NYC demo ก่อน Permission (ยืดหยุ่นสุด)

**กติกา Trial**: ห้ามเปิด Trial ในห้อง เว้นแต่ของทุกเครื่องพังพร้อมกัน — มีบัญชีสำรองอย่างน้อย 2

## เฉลยปมที่ปลูกไว้

### Pipeline rerun error (Workshop 6-1)

คำถามที่ปล่อยไว้: "หากทำการ Run ซ้ำ จะพบ Error เพราะเหตุใด แนวทางแก้ไข"

- **เพราะอะไร**: Script activity ใช้ CTAS — `CREATE TABLE dw.DimDate AS SELECT ...` สร้างตารางที่มีอยู่แล้วไม่ได้ รอบที่สองจึงชนตารางเก่า
- **แนวแก้ (a)**: ทำสคริปต์ re-runnable — `IF EXISTS ... DROP TABLE` ก่อน CTAS (ไฟล์ `DW/4` เตรียมแบบนี้ไว้แล้วตั้งแต่แรก — ถ้าห้อง copy จากไฟล์นี้รอบแรกจะไม่เจอ error ต้องตั้งใจลบบรรทัด IF EXISTS ออกก่อนให้ห้อง copy เพื่อให้ปมเดินได้ หรือสอนให้เปรียบเทียบสองเวอร์ชัน)
- **แนวแก้ (b)**: แยกขั้น — สร้างตารางเปล่า typed DDL ครั้งเดียว + `INSERT INTO ... SELECT` ทุกรอบ (แนวคิด `DW/Fix_error.sql` — ไฟล์นั้นคือ scratch ของการแก้จริง ยังขาด INSERT และชี้ตารางต้นทางผิดเป็น `dbo.DimDate` — ใช้เป็นตัวอย่าง "สคริปต์ระหว่างแก้" ได้)
- ข้อสังเกตเพิ่ม: Copy activity "Load to new table" ก็รอบสองแดงด้วยเหตุเดียวกัน (สร้าง staging.date ซ้ำ) — นี่คือเหตุผลที่ของจริงต้องชี้ตารางเดิม + Replace

### Mark as date table บน Lakehouse (Workshop 16)

โจทย์ให้ห้องตั้งสมมติฐาน สามสมมติฐานที่ควรโผล่และวิธีพิสูจน์:

1. **Type ของ FullDateAlternateKey ไม่ใช่ date/datetime** — ตรวจ `INFORMATION_SCHEMA.COLUMNS` ฝั่ง endpoint; เทียบกับฝั่ง Warehouse ปมย้อนหลัง: DimDate เกิดจาก Copy "Load to new table" (type อาจมาเป็น varchar) แล้ว CTAS คง type เดิม (`DW/Fix_error.sql` มี CONVERT เพราะเจอปัญหานี้จริง)
2. **ค่าซ้ำ/ว่าง** — `SELECT COUNT(*), COUNT(DISTINCT FullDateAlternateKey) FROM DimDate;` ต้องเท่ากันและไม่มี NULL
3. **เงื่อนไขเฉพาะของ model** — ลองสร้าง New semantic model แล้วลองเทียบ และจำบริบทปัจจุบัน: **default semantic models ถูกยกเลิกทั้งกระบวนการ** (ตั้งแต่ปลายปี 2025 — ดู [ประกาศของ Microsoft](https://community.fabric.microsoft.com/blog/fbc_fabricupdatesblogs/sunsetting-default-semantic-models---microsoft-fabric/5172667)) ดังนั้นห้องที่ตาม flow ปัจจุบันจะทำงานบน model ที่สร้างเองตั้งแต่ต้น ซึ่งไม่ติดปัญหาที่ผูกกับ default — ถ้า tenant เก่ายังมี model ปกติตกค้างจากยุค default ให้ใช้มันเป็นตัวเทียบได้

ผลที่คาดหวังจากห้อง: อย่างน้อยหนึ่งกลุ่มตรวจ INFORMATION_SCHEMA แล้วเจอ type จริง — จบด้วยการอธิบาย lineage: Copy → staging.date → CTAS → shortcut → endpoint → model

### บททดสอบ 5 — DimCustomer

เฉลยขั้นตอนอยู่ `solutions/05-dimcustomer/SOLUTION.md` — กับดักที่เจอจริง: Merge Columns ทิ้งช่องว่างตรง MiddleName ว่าง (คนละช่องว่างกับ NULL ตัวเดียว) และการ expand ผิดตาราง (DimProductSubcategory จากรอบก่อนยังฝังในความจำ)

### บททดสอบ 10-1 — Insights

คำตอบขึ้นกับ dataset ที่ห้องโหลด (blob Internetsales + AdventureworksDW) — **วิธีหา** (นี่คือสิ่งที่เก็บคะแนน):

1. Top model ปี 2014: column chart + slicer ปี 2014 (หรือ Top N by Revenue)
2. เดือนสูงสุดในปีนั้น: drill down เดียวกับข้อ 1
3. ประเทศที่ Bike ขายดีสุด: slicer category = Bikes → Map/Bar by Country
4. ยอดขายข้อ 3: tooltip/card จาก visual เดียวกัน
5. City สูงสุดในประเทศนั้น: drill down map ลง City

เตรียมตัวเลขอ้างอิงจาก dataset ที่คุณซ้อมก่อนเรียนและเก็บไว้ที่ `solutions/08-reports/SOLUTION.md` (repo เว้นช่องไว้ให้กรอก)

### NYC demo (โมดูล 16)

- ใช้ Warehouse แยกชื่อ `New York Taxi Perf` — อย่าวิ่งบน AdventureworksDW ที่ห้องใช้
- โหลดล่วงหน้าก่อนคาบถ้าเครือข่ายอนุญาต; แผนสำรอง: สาธิต COPY INTO 1–2 เดือนสด แล้วจับเวลา COUNT ที่โหลดไว้แล้ว (170M)
- `04_Semantic Model Storage Discover.sql` ต้องระบุ `DATABASE_NAME='New York Taxi Perf'` — แสดงคอลัมน์ TEMPERATURE/LAST_ACCESSED ก่อน-หลังคิวรี่ จะเห็น cold → hot ทำงาน
- อย่ารัน DELETE ท้าย `03_Test Perf.sql` ต่อหน้าห้องโดยไม่ตั้งใจ — มันเช็ดทั้ง warehouse

## เกณฑ์ให้คะแนน Posttest

| เกณฑ์ | น้ำหนักโดยประมาณ |
|---|---|
| Relationship ถูกต้องครบสามเส้น (คาร์ดินาลิตี้รวม) | 30% |
| Hierarchies เหมาะสม + ใช้ drill ได้จริงในรายงาน | 20% |
| Measures ครบตาม `LH/Measure.txt` | 20% |
| Report สองแบบ (auto-create + custom ที่ใช้ของเกินจาก auto) | 20% |
| อธิบายปม date table ได้ (โบนัส) | 10% |

## ของใหม่จากแพลตฟอร์มที่ควรบรรยายแทรก (เมื่อถึงโมดูลนั้น)

| โมดูล | ของใหม่ที่ควรพูดถึง | จุดพูด |
|---|---|---|
| 01 | Trial: 60 วัน/64 CU/1 TB, tenant ละ 5 ครั้ง, ลบ item 7 วันหลังหมดอายุ | ตอนเปิด Trial |
| 04 | Fast Copy ของ Dataflow Gen2; ตัวแปร CI/CD สำหรับ Git | ตอน publish dataflow แรก |
| 06 | **Copy job** — low-code copy + incremental/CDC ในตัว เรียกจาก pipeline ได้ | ตอนสรุปแนวทางนำเข้า |
| 07/15 | **Default semantic model ยกเลิกแล้ว** — สอน New semantic model เป็นหลัก | ตอนสร้าง model |
| 09 | **Runtime 2.0 GA** (Spark 4.1, Delta 4); 1.3 LTS ถึง มี.ค. 2027 | ตอนสร้าง Environment |
| 11 | schema-enabled lakehouse (ตัวเลือกตอนสร้าง) | ตอนสร้าง Lakehouse |
| 13 | OneLake security GA + shortcut transformations | ตอนปิดโมดูล shortcut |
| 17 | Copilot ใช้ได้กับ paid F SKU (F2+) ไม่รวม Pro/PPU | ตอนเรื่อง license |

รายละเอียดและแหล่งอ้างอิงเต็มอยู่ที่ [`../reference/ms-learn-map.md`](../reference/ms-learn-map.md) และบันทึกการแก้เด็คอยู่ที่ [`slide-updates-v6.1.md`](slide-updates-v6.1.md)

## ที่ย้ายมา / อยู่ที่ไหน

| ของเดิม | ตอนนี้อยู่ |
|---|---|
| สไลด์ทั้งเล่ม (เด็คเดิม v6) | `Trainer_Docs/` (นอก git ตาม .gitignore) |
| เด็คฉบับแก้ให้ทันสมัย | `Trainer_Docs/…Version 6.1.pptx` — รายการแก้ที่ `slide-updates-v6.1.md` |
| แล็บ Dataflows/Pipeline/Shortcuts ฉบับเดิม | `DFGen2/`, `Pipeline/`, `Shortcuts/` — ใช้เป็นแล็บเสริมนอกห้อง ถูกอ้างจากโมดูล 04, 06, 13 |
| ตัวอย่าง Human Resources Sample PBIX | ราก repo — สำรองใช้สาธิต ไม่ผูกกับแล็บ |
| เฉลย SQL | `solutions/*/` ทั้ง SOLUTION.md และ CHECK.sql |
| เอกสารก่อนเรียน | `instructor/preclass-checklist.md` |
