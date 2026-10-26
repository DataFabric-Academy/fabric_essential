# Failure modes — จุดที่แล็บพังบ่อยและวิธีรับมือ

จากการเดินหลักสูตรจริงและข้อจำกัดของแพลตฟอร์ม เรียงตามโมดูลที่เจอ

## ทั่วไป

| อาการ | เหตุผล | รับมือ |
|---|---|---|
| ชื่อ item สร้างซ้ำไม่ได้ทันทีหลังลบ | Fabric ล้างชื่อช้า 1–2 นาที | ใช้ชื่อชั่วคราว/ต่อท้ายเลข แล้วเปลี่ยนทีหลัง — เตือนห้องตั้งแต่สร้าง dataflow แรก แล้วมันจะเกิดกับห้องเสมอ |
| New SQL query Run ค้าง | capacity ห้องรับพร้อมกันช่วงแรก | Stop → Run ใหม่ หรือเปิด query tab ใหม่ |
| SQL endpoint ไม่เห็น Delta table ใหม่ | metadata sync ช้าครู่เดียว | Refresh รอ 1–2 นาที |
| Trial หมดกลางคอร์ส | เปิดค้างนาน (item ถูกลบ 7 วันหลังหมดอายุ) | เตรียมบัญชีสำรอง (ดู preclass checklist) |
| หน้าจอต่างจากเอกสาร/สไลด์ | Fabric UI เปลี่ยนเร็ว | ยึดชื่อปุ่ม/ไดอะลอกใน LAB.md — อ้าง [ms-learn-map](ms-learn-map.md) |
| Desktop ล็อกอินคนละบัญชีกับ Fabric | บัญชีทำงานหลายตัว | Sign in ให้ตรงก่อนสร้างรายงาน — อาการคือ "เห็น model ไม่ครบ" ย้อนหาต้นเหตุยาก |

## Module 04 — Dataflow Gen2

- **Connection ซ้ำซ้อน**: ให้ห้องตั้งชื่อ connection และกด Use existing ตอนทำ workshop ถัดไป ไม่งั้นจะมี connection ค้างเก็บไม่หมด
- **Publish แล้วข้อมูลซ้อน**: destination ไม่ได้ตั้ง Replace ให้เปิด dataflow → destination settings → Replace → publish ซ้ำ
- **Access Key ค้างในหน้าจอ**: กันเห็น key กันเอง — ปิดไดอะลอกหลัง connect สำเร็จ
- **ของใหม่ที่อาจโผล่บนจอ**: Fast Copy (งาน ingest ใหญ่บาง connector จะบอกว่าวิ่งบน Copy engine) — พฤติกรรมปกติ ไม่ใช่ความผิดพลาดของผู้เรียน

## Module 06 — Pipeline (ปม rerun ที่ปลูกไว้)

- **Rerun แล้ว Script activity พัง** — CTAS (`CREATE TABLE AS SELECT`) สร้างตารางที่มีอยู่แล้วไม่ได้ สองแนวแก้:
  1. ทำสคริปต์ re-runnable: `IF EXISTS ... DROP TABLE;` ก่อน CTAS (รูปแบบของ `DW/4`)
  2. แยกสองขั้น: สร้างตารางเปล่าด้วย typed DDL ครั้งเดียว + `INSERT INTO ... SELECT` ทุกรอบ
- **Load to new table รอบสองแดง** — โหมดนี้ออกแบบมาสร้างตารางใหม่ รอบถัดไปต้องชี้ตารางเดิม
- `DW/Fix_error.sql` คือไฟล์ระหว่างแก้จริงของผู้สอน (มี CONVERT เพิ่มเพราะคอลัมน์ตัวเลขมาเป็น varchar จาก copy) — ใช้ประกอบการอธิบาย ไม่ใช่สคริปต์มาตรฐานให้ห้อง copy
- **ของใหม่ที่ควรบรรยายประกอบ**: Copy job — ทางเลือก low-code สำหรับงาน copy ล้วน มี incremental/CDC ในตัว เรียกจาก pipeline ได้

## Module 07/15 — Semantic Model

- **Default semantic models ยกเลิกแล้ว** — ตั้งแต่ปลายปี 2025: ไม่สร้างอัตโนมัติ, ตัวเดิมถูกแปลงเป็น regular model, Reporting tab ถูกถอด ผลต่อห้อง: ปุ่ม/รายการ "default semantic model" อาจไม่ปรากฏเลย ทุกขั้นตอนเริ่มจาก **New semantic model** ซึ่งเป็นแนวที่หลักสูตรใช้อยู่แล้ว อย่าสร้างแล็บที่ต้องพึ่ง default อย่างเดียว (ประกาศของ Microsoft: [Sunsetting announcement](https://community.fabric.microsoft.com/blog/fbc_fabricupdatesblogs/sunsetting-default-semantic-models---microsoft-fabric/5172667))
- **Mark as date table ล้มเหลวบน DimDate ฝั่ง Lakehouse** — ตรวจตามลำดับ: (1) type ของ `FullDateAlternateKey` ผ่าน `INFORMATION_SCHEMA.COLUMNS` (2) ค่าซ้ำ/ว่าง (3) เงื่อนไขเฉพาะของ model — ลอง New semantic model เทียบ หลักฐานและแนวเฉลยใน `solutions/15-lh-semantic-model/SOLUTION.md`
- **DIVIDE ด้วย / ธรรมดา** — หารศูนย์แล้ว report แตก ใช้ DIVIDE เสมอ
- **Time Intelligence เพี้ยน** — ยังไม่ mark date table หรือ sort by column ยังไม่ตั้ง

## Module 08 — Power BI

- **Desktop เห็น model ไม่ครบ** — บัญชี Desktop ≠ บัญชี Fabric หรือล็อก tenant อื่น
- **Map ว่าง** — ตั้ง Data category ให้คอลัมน์ geography และใช้ hierarchy ที่สร้างเอง
- **Publish ไปผิด workspace** — ชี้ My workspace ให้ชัดตอนกด Publish

## Module 11–12 — Lakehouse / Notebook

- **ชื่อไฟล์ `DimGeopraphy.csv`** (สะกดผิดเจตนาใน repo) — notebook ETL อ้างชื่อนี้ตรง ๆ ห้ามเปลี่ยนชื่อไฟล์โดยไม่แก้ notebook
- **SaveAsTable ซ้ำ schema ชน** — คง `mode("overwrite").option("overwriteSchema","true")`
- **ลบ external table แล้วเข้าใจว่าไฟล์หาย** — ไฟล์ยังอยู่ที่ `Files/external/...` ใช้จุดนี้สอน managed vs external
- **schema-enabled lakehouse** — ถ้าผู้เรียนเผลอเปิดตัวเลือก schema ตอนสร้าง Lakehouse โครงตารางจะมี namespace และ SQL query อาจต้องระบุ schema — ห้องควรใช้ตัวเลือกเดียวกันทั้งห้อง

## Module 16 — NYC Taxi demo

- **COPY INTO ใช้เวลานาน** — 170 ล้านแถว/9 GB ใช้ warehouse แยก และโหลดล่วงหน้าก่อนคาบถ้าทำได้ มิฉะนั้นสาธิตด้วยไฟล์ parquet 1–2 เดือนก่อนแล้วแสดงตัวเลข 170M จากรอบที่เตรียมไว้
- **DISCOVER_STORAGE_TABLE_COLUMN_SEGMENTS ต้องระบุ DATABASE_NAME ตรง** — ชื่อต้องเป็น warehouse ที่รัน demo (เช่น `New York Taxi Perf`)
- **DELETE ท้ายไฟล์ 03** — อย่ารันพลาดที่ warehouse สอน

## สิ่งที่ยังต้องมีคนเดินทดสอบจริงก่อนวันสอน

รายการเดียวกับ `instructor/preclass-checklist.md` — โดยเฉพาะ: สถานะ default semantic model บน tenant ของห้อง (หลัง sunset มักไม่มีแล้ว), runtime ที่ tenant ให้ (2.0 หรือ 1.3 LTS), ผล Mark as date table บน DimDate shortcut ใน tenant ล่าสุด และ availability ของ Copilot บน SKU ห้อง
