# Module 06 — Data Pipeline: ประกอบกลไกจาก activities หลายตัว

> ⏱ ~90 นาที (สอง workshop) · 🎯 ประกอบ pipeline จาก Copy, Script และ Stored Procedure ผูกลำดับด้วย precedence constraint และเข้าใจว่าทำไม rerun จึงพัง · A pipeline is activities + edges; the edges decide the story.

## Key idea / แนวคิดหลัก — เล่าเรื่อง

Dataflow Gen2 ทำงานเดี่ยวได้ดี แต่ ETL จริงในโลกทำงานเป็นทีม: copy ข้อมูลมาก่อน แปลงทีหลัง ทำความสะอาด แล้วค่อยโหลดเข้าตาราง dim — ลำดับเหล่านี้**ต้องรอกัน** และถ้าขั้นก่อนหน้าพัง ขั้นถัดไปไม่ควรเดินต่อ **Data Pipeline** คือผืนผ้าใบสำหรับเรื่องนี้: คุณวาง activities ลงบน canvas แล้วลากเส้นบอกว่าใครรอใคร เส้นสามสีนั่นเองคือหัวใจ — สีเขียว (On Success) ทำต่อเมื่อก่อนหน้าสำเร็จ, สีแดง (On Failure) รันเมื่อล้มเหลว, สีน้ำเงิน (On Completion) รันเสมอไม่ว่าผลเป็นอย่างไร

Workshop แรก (**6-1**) เดินเรื่องเรียบ ๆ แต่ซ่อนบทเรียนสำคัญไว้: Copy Data ดึง `dbo.DimDate` จาก Azure SQL ลง `staging.date` (โหมด Load to new table) แล้วต่อด้วย activity ชนิด **Script** ที่รัน CTAS (`CREATE TABLE dw.DimDate AS SELECT ...`) เพื่อสร้างตาราง dimension จาก staging รอบแรกทุกอย่างเขียวหมด แต่พอกด Run **ซ้ำ** — Script แดง และโจทย์ปล่อยคำถามไว้ว่า "เพราะเหตุใด แนวทางแก้ไข" คำตอบคือ CTAS สร้างตารางที่มีชื่ออยู่แล้วไม่ได้ — ปัญหานี้มีสองแนวทางแก้ที่แต่ละอันสอนสิ่งลึกกว่าคำสั่ง SQL: ทำสคริปต์ให้ re-runnable (DROP ก่อน CTAS) หรือแยกสองขั้น (สร้างตารางครั้งเดียว + INSERT SELECT ทุกรอบ)

Workshop ที่สอง (**6-2**) ประกอบ pipeline ใหญ่ `ETL DimProduct` ที่เชื่อมสามวิธีการเข้าด้วยกัน: activity ชนิด **Dataflow** เรียก `Get Products` ที่คุณสร้างไว้ตอนเช้า แล้วต่อด้วย **Stored Procedure** `staging.TransformProduct` ที่ล้างค่า 'NA' และ NULL ตามด้วย Stored Procedure `dw.LoadDimProduct` ที่ย้ายของสะอาดเข้าตาราง dim — ลากเส้น On Success ทั้งสาย แล้วตั้ง schedule ให้ทำซ้ำ ที่จริงแล้วคุณกำลังสร้างกลไกที่จะรันเองต่อไปแม้คุณนอนอยู่

ของใหม่ที่ควรรู้เพื่อความทันสมัย: Data Factory ปัจจุบันมี item ใหม่ชื่อ **Copy job** — เครื่องมือ low-code สำหรับงาน copy ล้วน ๆ ที่มี incremental copy และ CDC ในตัว (เหมาะกับ "ขนข้อมูลจาก A ไป B ตลอดชีวิตโครงการ") ส่วน pipeline ยังคงครองแชมป์เมื่อต้องผสมหลายชนิดของ activity เข้าด้วยกันแบบที่คุณกำลังทำ — รู้จักทั้งคู่แล้วจะเลือกถูก

> EN: Copy lands raw, Script reshapes with CTAS, Stored procedures clean and load — all chained On Success.

## Concept / เนื้อหา

- **Precedence constraint สามสี** — สีเขียว On Success (ทำต่อเมื่อสำเร็จ), สีแดง On Failure (ทำเมื่อพัง), สีน้ำเงิน On Completion (ทำเสมอ) การเลือกผิดสีคือบั๊กระดับโครงการ เช่น ใช้ On Completion กับงานที่ต้องรอความสะอาด แล้วได้ข้อมูลสกปรกเข้า dim เงียบ ๆ
- **Script activity** รัน T-SQL โดยตรง — ตั้ง Storage type = Workspace, เลือก Warehouse, ชนิด Query ใช้กับงานที่ต้องรัน SQL คำสั่งเดียวจบ เช่น CTAS
- **CTAS** (CREATE TABLE AS SELECT) — วิธีที่เร็วและง่ายสุดในการสร้างตารางใหม่จากผล SELECT แต่ข้อจำกัดของมันคือ "สร้างใหม่ทับของเดิมไม่ได้" — จุดนี้คือปม workshop 6-1
- **Dataflow activity** เรียก dataflow ที่ publish ไว้ให้ทำงาน — ทำให้ logic ของ Power Query กลายเป็นชิ้นส่วนหนึ่งของ orchestration
- **Schedule** ของ pipeline ตั้งคาบเวลาทำซ้ำได้ละเอียดถึงระดับนาที — ใน Trial อย่าตั้งถี่เกินเพราะคิว capacity จะยาวและคุณจะเห็นผลช้า
- สรุปแนวทางนำเข้า Warehouse ที่วันแรกเดินครบ: COPY INTO (T-SQL), Dataflow Gen2, Pipeline ผ่าน activities, cross-warehouse, INSERT INTO…SELECT, SELECT INTO, CTAS — พร้อม Copy job ตัวใหม่สำหรับงาน copy ล้วน

## ลงมือทำตามลำดับ

- [LAB.md](LAB.md) Workshop 6-1: Copy DimDate + Script CTAS + สืบสวนปม rerun
- [LAB.md](LAB.md) Workshop 6-2: ETL DimProduct (Dataflow → Transform → Load) + schedule
- แล็บเสริมนอกห้อง: [`Pipeline/README.md`](../../Pipeline/README.md)

## Common pitfalls / กับดัก

- Rerun แล้ว Script activity พัง — ตามที่เล่าด้านบน นี่ตั้งใจให้เกิด อย่ารีบ "แก้โดยลบตารางทิ้งมือ" ให้ตอบคำถามสองข้อก่อน: เพราะอะไร และแก้อย่างไรให้รันได้ตลอดกาล
- Copy รอบสองแดงเหมือนกัน — โหมด Load to new table ออกแบบมาเพื่อสร้างตารางใหม่ รอบถัดไปต้องชี้ตารางเดิม ไม่ใช่สร้างใหม่
- ลากเส้นผิดสี — คลิกที่เส้นแล้วเลือก On Success ให้ชัด โดยเฉพาะเส้นระหว่าง Dataflow กับ Stored procedure แรก
- รัน pipeline ทั้งที่ dataflow ยัง failed — ดู run history ของ dataflow ก่อนเสมอ
- ตั้ง schedule ระดับนาทีทิ้งไว้ใน Trial — คิว capacity ยาวทำให้รันไม่ทันเห็นผลในห้อง ตั้งโชว์แล้วปิดทิ้ง

## Quick check / ทบทวน

<details>
<summary>1. เส้นสีเขียว-แดง-น้ำเงินคืออะไร</summary>
Precedence constraint: On Success / On Failure / On Completion
</details>

<details>
<summary>2. ทำไม rerun แล้ว CTAS error</summary>
CREATE TABLE AS SELECT สร้างตารางที่มีชื่ออยู่แล้วไม่ได้ — ต้อง DROP ก่อน หรือแยกเป็นสร้างครั้งเดียว + INSERT ทุกรอบ
</details>

<details>
<summary>3. Dataflow activity ต่างจาก Copy activity ยังไง</summary>
Copy ย้ายข้อมูลตรง ๆ ระหว่างแหล่ง-ปลายทาง ส่วน Dataflow activity เรียก dataflow Gen2 (Power Query logic) ให้ทำงาน
</details>

## Go deeper

- [Copy activity in Fabric](https://learn.microsoft.com/en-us/fabric/data-factory/copy-data-activity)
- [Stored Procedure activity](https://learn.microsoft.com/en-us/fabric/data-factory/stored-procedure-activity)
- [What is Copy job in Data Factory](https://learn.microsoft.com/en-us/fabric/data-factory/what-is-copy-job)
- [CTAS — Ingest data using T-SQL](https://learn.microsoft.com/en-us/fabric/data-warehouse/ingest-data-tsql)
