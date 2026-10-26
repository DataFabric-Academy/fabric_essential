# Microsoft Fabric Essential for Business — Hands-on Labs

หลักสูตร 2 วัน (MS-FB-101) สอน Microsoft Fabric แบบ hands-on 12 ชม. เดินเรื่องจากจุดที่ข้อมูลยังกระจัดกระจายในองค์กร ไปจนถึงรายงานที่ตอบคำถามผู้บริหารได้ และพิสูจน์ด้วยข้อมูล 170 ล้านแถวว่าทำไมทุกอย่างจึงยังเร็วได้

เอกสารนี้ภาษาไทย ศัพท์เทคนิคและคำสั่ง SQL/PySpark เป็นอังกฤษ สไลด์ประกอบการสอนอยู่ที่ `Trainer_Docs/` (Version 6.1 — อัปเดตเนื้อหาให้ทันกับ MS Learn ปัจจุบัน อ่านสรุปการเปลี่ยนแปลงที่ `instructor/slide-updates-v6.1.md`) เอกสารใน repo นี้**ไม่ผูกกับเลขหน้าสไลด์** — ยึดชื่อ item, ชื่อปุ่ม และชื่อไดอะลอกเป็นตัวชี้นำ เพราะ UI ของ Fabric เปลี่ยนบ่อยกว่าเนื้อหา

## ได้อะไรจากสองวันนี้

1. เปิดใช้งาน Fabric Trial และจัดการ Workspace ได้เองตั้งแต่เช้าวันแรก
2. เลือกพื้นที่จัดเก็บได้ถูกงาน — Warehouse เมื่อโลกเป็น T-SQL, Lakehouse เมื่อโลกเป็น Spark/Delta และรู้ว่าอีกฝั่งมองเข้ามาได้อย่างไร
3. นำเข้าข้อมูลได้หลายแนวทางและเลือกได้ว่าอะไรเหมาะกับงานไหน — Dataflow Gen2, Data Pipeline, Copy job, และ T-SQL (COPY INTO / CTAS)
4. สร้าง semantic model ของตัวเองใส่ relationship, hierarchy และ DAX measures — เข้าใจด้วยว่าทำไมวันนี้เราไม่พึ่ง "default model" อีกต่อไป
5. ต่อยอดเป็นรายงาน Power BI ทั้งแบบ auto-create และสร้างเองใน Desktop แล้ว publish กลับเข้า Fabric
6. ลงมือบน Lakehouse — upload, Notebook PySpark ETL, Delta table managed/external, Shortcut ที่ทำให้ข้อมูลอยู่ที่เดียวโดยไม่ต้องคัดลอก
7. ปิดท้ายด้วยสิทธิ์และ License — workspace role, item sharing, Trial vs F vs P vs PPU

## เหมาะกับใคร

ผู้เรียนที่ใช้เบราว์เซอร์ได้ มีพื้นฐาน SQL (SELECT/CREATE TABLE) เบื้องต้น PySpark และ Power BI เป็นประโยชน์แต่ไม่บังคับ — ทุกสคริปต์ที่ต้องพิมพ์มีให้ครบใน repo นี้ ส่วนความเข้าใจจะเกิดจากการเล่าเรื่องในแต่ละโมดูล

## กำหนดการ

### วันที่ 1 — Warehouse + การนำเข้าข้อมูล + Semantic Model + Report

| ช่วง | โมดูล | แล็บ |
|---|---|---|
| เช้า | [01 รู้จัก Fabric, OneLake และ Workspace](day-1/01-fabric-onelake/README.md) | เปิด Trial + สำรวจหน้าจอ (guided) |
| เช้า | [02 สองประตูเข้าสู่ข้อมูล — Warehouse กับ Lakehouse](day-1/02-storage-approaches/README.md) | — (เล่าเรื่อง) |
| เช้า | [03 Warehouse และตารางแรกด้วย T-SQL](day-1/03-warehouse-tsql/README.md) | [Workshop 3](day-1/03-warehouse-tsql/LAB.md) |
| บ่าย | [04 Dataflow Gen2 — ดึงข้อมูลจาก Blob และ Azure SQL](day-1/04-dataflow-gen2/README.md) | [Workshop 4-1, 4-2](day-1/04-dataflow-gen2/LAB.md) |
| บ่าย | [05 บททดสอบ — DimCustomer](day-1/05-test-dimcustomer/README.md) | [บททดสอบ 5](day-1/05-test-dimcustomer/LAB.md) |
| บ่าย | [06 Data Pipeline — ประกอบกลไกจาก activities](day-1/06-data-pipeline/README.md) | [Workshop 6-1, 6-2](day-1/06-data-pipeline/LAB.md) |
| บ่าย | [07 Semantic Model — ชั้นความหมายและ DAX](day-1/07-semantic-model/README.md) | [Workshop 7-1](day-1/07-semantic-model/LAB.md) |
| ท้ายวัน | [08 Power BI Report — จาก model สู่รายงาน](day-1/08-power-bi-report/README.md) | [Workshop 8 + 10 + บททดสอบ 10-1](day-1/08-power-bi-report/LAB.md) |

### วันที่ 2 — Spark + Lakehouse + Advanced

| ช่วง | โมดูล | แล็บ |
|---|---|---|
| เช้า | [09 Spark — ทำไม Fabric เลือกมัน และควบคุมมันอย่างไร](day-2/09-spark-environment/README.md) | Environment (guided demo) |
| เช้า | [10 Semantic Link — อ่าน model จาก Python](day-2/10-semantic-link/README.md) | [Workshop 11-1](day-2/10-semantic-link/LAB.md) |
| เช้า | [11 Lakehouse — Delta Table และ Fabric DataFrame](day-2/11-lakehouse-basics/README.md) | [Workshop 12-1, 12-2](day-2/11-lakehouse-basics/LAB.md) |
| บ่าย | [12 ETL ด้วย Notebook — managed กับ external](day-2/12-notebook-etl/README.md) | [Workshop 13](day-2/12-notebook-etl/LAB.md) |
| บ่าย | [13 Shortcut — ใช้ข้อมูลร่วมกันโดยไม่คัดลอก](day-2/13-shortcuts/README.md) | [Workshop 14](day-2/13-shortcuts/LAB.md) |
| บ่าย | [14 Dataflow Gen2 ไป Lakehouse — FactResellerSales](day-2/14-dataflow-to-lakehouse/README.md) | [Workshop 15](day-2/14-dataflow-to-lakehouse/LAB.md) |
| บ่าย | [15 Semantic Model บน SQL analytics endpoint](day-2/15-lakehouse-semantic-model/README.md) | [Workshop 16](day-2/15-lakehouse-semantic-model/LAB.md) |
| ท้ายวัน | [16 Posttest + Big Data NYC Taxi Demo](day-2/16-posttest-bigdata/README.md) | [บททดสอบ 17](day-2/16-posttest-bigdata/LAB.md) |
| ท้ายวัน | [17 Permission และ License](day-2/17-permission-license/README.md) | ทดสอบสิทธิ์คู่กับเพื่อน |

จังหวะในห้องและเวลาต่อโมดูลอยู่ที่ [`instructor/README.md`](instructor/README.md)

## สิ่งที่ต้องมีก่อนวันเรียน

- บัญชี Microsoft สำหรับเปิด [Fabric Trial](https://learn.microsoft.com/en-us/fabric/fundamentals/fabric-trial) — เปิดล่วงหน้าก่อนวันสอน
- เบราว์เซอร์รุ่นล่าสุด (Edge / Chrome)
- [Power BI Desktop](https://www.microsoft.com/en-us/download/details.aspx?id=58494) รุ่นล่าสุด ล็อกอินด้วยบัญชีเดียวกับ Fabric
- พื้นฐาน SQL (แนะนำ) พื้นฐาน Python/PySpark (แนะนำ สำหรับวันที่ 2)
- ไฟล์ `Link.txt` จากผู้จัด — มี Storage account + Access Key และ Azure SQL server + user + password ของหลักสูตร

รายการเตรียมตัวทีละขั้นอยู่ที่ [SETUP.md](SETUP.md)

## เช็กลิสต์ก่อนเริ่ม

1. Fabric Trial active — ตรวจจาก Account manager ที่มุมขวาบน
2. ใช้ **My workspace** ของตัวเองตลอดหลักสูตร — เห็นปุ่ม New item แปลว่าพร้อม
3. รับ `Link.txt` จากผู้สอน อย่าเปิดเผย Access Key ในห้อง
4. Power BI Desktop ล็อกอินด้วยบัญชีเดียวกัน (ใช้ตอนบ่ายวันแรก)

## ถ้าตามไม่ทัน

ทุกแล็บมีผลอ้างอิงใน [`solutions/`](solutions/README.md) — เปิด SOLUTION.md ของแล็บนั้น อ่าน "ผลลัพธ์สุดท้าย" แล้วรัน SQL ในไฟล์ CHECK.sql (ถ้ามี) เพื่อกลับเข้าจังหวะเดียวกับห้องทันที

## แผนที่ repo

| ที่ | ใช้ทำอะไร |
|---|---|
| `day-1/`, `day-2/` | บทเรียนแบบเล่าเรื่อง (README) และแล็บแนะมือ (LAB) |
| `DW/` | สคริปต์ T-SQL ของวันที่ 1 — staging, dim, proc, view, measures |
| `DFGen2/` `Pipeline/` | แล็บเสริม Dataflow Gen2 และ Pipeline สำหรับฝึกนอกห้อง |
| `LH/` | ไฟล์ CSV + notebook ETL ของ Lakehouse + measures สำหรับ Posttest |
| `Demo/` | NYC Taxi big data demo (COPY INTO 170 ล้านแถว) |
| `*.pbix` | ตัวอย่างสำหรับ Workshop 11-1 (Semantic Link) |
| `solutions/` | ผลอ้างอิงของแต่ละแล็บ + SQL ตรวจ |
| `reference/` | อภิธาน, failure modes, แผนที่ MS Learn |
| `instructor/` | ของผู้สอนเท่านั้น — จังหวะห้อง, เฉลยปมที่ปลูกไว้, checklist, บันทึกการอัปเดตสไลด์ |

## ข้อมูลอ้างอิงที่เอกสารชุดนี้ตรวจแล้ว

| รายการ | ค่า | อ้างอิง |
|---|---|---|
| Default semantic model | ยกเลิกแล้วทั้งกระบวนการ (ตั้งแต่ปลายปี 2025) — สอนด้วย New semantic model | [Sunsetting announcement](https://community.fabric.microsoft.com/blog/fbc_fabricupdatesblogs/sunsetting-default-semantic-models---microsoft-fabric/5172667) |
| Fabric Trial | 60 วัน, 64 CU, OneLake 1 TB, tenant ละ 5 trial, ลบ item 7 วันหลังหมดอายุ | [Fabric trial](https://learn.microsoft.com/en-us/fabric/fundamentals/fabric-trial) |
| Spark runtime | Runtime 2.0 GA (Spark 4.1, Delta 4); 1.3 เข้า LTS ถึง มี.ค. 2027 | [Runtime 2.0](https://learn.microsoft.com/en-us/fabric/data-engineering/runtime-2-0) |
| วันตรวจ | 2026-10-25 | รายละเอียดทั้งหมดใน [`reference/ms-learn-map.md`](reference/ms-learn-map.md) |

UI ของ Fabric เปลี่ยนบ่อย — ตำแหน่งปุ่มอาจต่างเล็กน้อยจากภาพในสไลด์ ยึดชื่อปุ่ม/ชื่อไดอะลอกใน LAB.md และ[แผนที่ MS Learn](reference/ms-learn-map.md)เป็นหลัก

## วิธีใช้ในห้อง

ทุกแล็บทำในเบราว์เซอร์บน Fabric (app.fabric.microsoft.com) ยกเว้นโมดูล 08 ที่เปิด Power BI Desktop สคริปต์ทั้งหมด copy-paste จากโฟลเดอร์ของ repo ตามที่ LAB.md ระบุ — บางสคริปต์ตั้งใจให้ห้องแก้เองเพื่อเรียนรู้ปัญหา จึงไม่ควรจดจากสไลด์
