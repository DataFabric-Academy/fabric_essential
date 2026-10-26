# Workshop 6-1 + 6-2 — Data Pipeline

> ⏱ 70 นาที · Start state: `AdventureworksDW` มี dataflow `Get Products` (จากเช้าวันนี้), connection Azure SQL ใช้ได้

## Goal / เป้าหมาย

- 6-1: pipeline `Copy DimDate` — Copy data (`dbo.DimDate` → `staging.date`) ต่อด้วย Script สร้าง `dw.DimDate` ด้วย CTAS และตอบคำถามปม rerun ได้
- 6-2: pipeline `ETL DimProduct` — Dataflow → Stored procedure ทำความสะอาด → Stored procedure โหลด dim แล้วตั้ง schedule

## Steps — Workshop 6-1

1. ใน Warehouse: **Get data → New data pipeline** → ตั้งชื่อ **`Copy DimDate`**

2. Choose data source: **Azure SQL Database** → connection เดิมจาก Link.txt → เลือกตาราง **`dbo.DimDate`**

3. Choose data destination: **Load to new table** → ระบุ **`staging.date`** → Next → Settings ปล่อย default → Review → **Save + Run**

   ผลที่ควรเห็น: activity สีเขียว (succeeded) และตาราง `staging.date` เกิดใหม่ใน Warehouse พร้อมข้อมูล — สังเกตว่าโหมด "Load to new table" สร้างตารางให้เองทั้งโครงและข้อมูล

4. เพิ่ม Script activity: เมนู **Activities → Script** → ตั้งชื่อ `Create Table as SELECT` → แทป Settings: Storage type = **Workspace**, Warehouse = `AdventureworksDW`, Script type = **Query** → วางเนื้อไฟล์ `DW/4. Create Dimdate Table as SELECT (CTAS).sql`

5. เชื่อมลำดับ: ลากเส้นจาก Copy data → Script เลือก **On Success** (สีเขียว)

6. Run pipeline รอบแรก — ผลที่ควรเห็น: ทั้งสอง activity เขียว และตาราง `dw.DimDate` เกิดใหม่พร้อมข้อมูลครบ

7. **รันซ้ำรอบที่สอง** — ครั้งนี้ Script activity จะแดง นี่คือโจทย์ตั้งใจปล่อยไว้ ตอบให้ได้สองข้อ:

   - เพราะเหตุใด: CTAS (`CREATE TABLE dw.DimDate AS SELECT...`) สร้างตารางที่มีอยู่แล้วไม่ได้ รอบที่สองจึงชนตารางเก่าตายตั้งแต่คำสั่งแรก
   - แนวทางแก้ (เลือกอย่างใดอย่างหนึ่ง — ทั้งคู่ถูกต้อง):
     a. ทำสคริปต์ re-runnable — `IF EXISTS ... DROP TABLE;` ก่อน CTAS (รูปแบบที่ไฟล์ `DW/4` มีอยู่แล้ว)
     b. แยกสองขั้น — สร้างตารางเปล่าด้วย typed DDL ครั้งเดียว แล้วใช้ `INSERT INTO dw.DimDate SELECT ... FROM staging.date` ทุกรอบ

8. แก้สคริปต์ตามแนวทาง a แล้ว Run ซ้ำ — ผลที่ควรเห็น: เขียวสองรอบติดกัน และ:

   ```sql
   SELECT COUNT(*) FROM dw.DimDate;
   ```

   คืนจำนวนเท่าเดิมทุกรอบ — สังเกตว่าแนวทาง a ทำให้ pipeline นี้ "รันได้ตลอดชีวิต" ไม่ใช่แค่รอบนี้พอ

## Steps — Workshop 6-2

1. New SQL query → รันไฟล์ `DW/5. Create Proc Transform Product.sql` และ `DW/6. Create Proc Load DimProduct.sql`

   ผลที่ควรเห็น: มี proc สองตัว — `staging.TransformProduct` (ล้าง 'NA' และ NULL) และ `dw.LoadDimProduct` (ย้ายของสะอาดเข้า dim)

2. New data pipeline ตั้งชื่อ **`ETL DimProduct`**

3. เพิ่ม activity **Dataflow** → เลือก `Get Products` (ที่ publish ไว้เช้านี้)

4. เพิ่ม activity **Stored procedure** → เลือก `staging.TransformProduct` → ตั้งชื่อ activity ให้สื่อความ (เช่น `Clean Product`)

5. เพิ่ม activity **Stored procedure** อีกตัว → เลือก `dw.LoadDimProduct` (ชื่อ `Load DimProduct`)

6. เชื่อมเส้น: Dataflow → Clean Product → Load DimProduct ทั้งหมด **On Success** — คลิกที่เส้นตรวจสีให้ชัด

7. Run pipeline — ผลที่ควรเห็น: เขียวทั้งสาย

8. ตรวจผลทาง SQL:

   ```sql
   SELECT COUNT(*) FROM staging.product;                       -- รวมทั้งสกปรก/สะอาด
   SELECT COUNT(*) FROM staging.product WHERE Color = 'NA';    -- ต้องเป็น 0 หลัง Transform
   SELECT TOP 5 * FROM dw.DimProduct;                          -- dim ที่โหลดแล้ว ไม่มี NULL ของ ModelName
   ```

9. ตั้ง schedule: pipeline → Schedule → ตั้งทำซ้ำคาบระดับนาที (เช่น ทุก 60 นาที) → ในห้องตั้งให้เห็นว่ามีอยู่ แล้ว**ปิดทิ้ง** — อย่าทิ้ง schedule ถี่ ๆ ไว้ใน Trial

## ✅ Checkpoint

- [ ] `staging.date` และ `dw.DimDate` มีข้อมูล
- [ ] rerun `Copy DimDate` ผ่านหลังแก้ (หรือตอบแนวแก้ได้ถูกต้องสองแนว)
- [ ] `ETL DimProduct` เขียวทั้งสาย และ `dw.DimProduct` ไม่มี 'NA' หรือ ModelName NULL
- [ ] อธิบายสามสีของ precedence constraint ได้พร้อมตัวอย่างใช้จริง
- [ ] schedule ถูกตั้งและปิดแล้ว

## 🛠 Troubleshooting

| อาการ | สาเหตุ | แก้ |
|---|---|---|
| Script activity แดงตอน rerun | ตาราง dw.DimDate มีอยู่แล้ว | ใช้แนวแก้ a (DROP ก่อน) หรือ b (INSERT เท่านั้น) |
| Copy รอบสองเตือน table exists | Load to new table ออกแบบมาสร้างใหม่ | เปลี่ยน destination ไปชี้ `staging.date` เดิม |
| หา Stored procedure activity ไม่เจอ | อยู่ลึกในเมนู Activities | พิมพ์ค้น `Stored procedure` ในช่องค้นหา |
| `dw.LoadDimProduct` แดง | proc ยังไม่ถูกสร้าง | รันไฟล์ DW/6 ก่อนรัน pipeline |
| dim ยังมี 'NA' | ลำดับเส้นผิด (Load วิ่งก่อน Clean) หรือใช้ On Completion | ตรวจเส้น On Success จาก Dataflow → Clean → Load |

## 🆘 Behind? Catch up

เฉลยรวมและ SQL ตรวจที่ [`solutions/06-pipeline/SOLUTION.md`](../../solutions/06-pipeline/SOLUTION.md) ปม rerun อ่านเพิ่มที่ [`reference/failure-modes.md`](../../reference/failure-modes.md)

## Stretch / ต่อยอด

เติม activity ที่สี่: On Failure ของ Dataflow ไปยัง activity ชนิดอื่น (เช่น Office 365 Outlook) เพื่อแจ้งเตือน — แล้วตั้งใจทำให้ dataflow พังหนึ่งรอบเพื่อดูเส้นแดงทำงานจริง
