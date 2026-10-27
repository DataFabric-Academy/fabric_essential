# Preclass checklist — เดินเองก่อนวันสอน 1 สัปดาห์

ทุกข้อในนี้ต้องมีคนทำจริงหนึ่งรอบบนเบราว์เซอร์จริง สคริปต์เดินแทนไม่ได้

## สัปดาห์ก่อนเรียน

- [ ] ส่ง SETUP.md ให้ผู้เรียน + เปิด Trial ล่วงหน้าทุกบัญชี (อย่ารอวันสอน — tenant ละ 5 ครั้ง, item ถูกลบ 7 วันหลังหมดอายุ)
- [ ] เตรียมบัญชีสำรอง ≥ 2 ที่ยังไม่เคยใช้ Trial
- [ ] ตรวจจำนวน CU/ระยะเวลาของ Trial ปัจจุบันที่ [Fabric trial](https://learn.microsoft.com/en-us/fabric/fundamentals/fabric-trial) (ณ วันตรวจล่าสุด: 60 วัน / 64 CU / OneLake 1 TB)
- [ ] **ตรวจสถานะ default semantic model บน tenant ห้อง** — หลังการ sunset (ปลายปี 2025) ระบบไม่สร้าง default แล้ว ถ้า tenant ยังมี model ตกค้างจากยุค default ให้ใช้เป็นตัวเทียบในโมดูล 07/15 ได้ แต่สอน flow หลักด้วย **New semantic model** (ดู [ประกาศ sunset](https://community.fabric.microsoft.com/blog/fbc_fabricupdatesblogs/sunsetting-default-semantic-models---microsoft-fabric/5172667))
- [ ] ตรวจ **Spark runtime** ที่ tenant ห้องให้บริการ — ถ้ามี Runtime 2.0 (GA, Spark 4.1) ให้โชว์ตอนสร้าง Environment; ถ้ายัง 1.3 ก็ใช้ 1.3 (LTS ถึง มี.ค. 2027) — ประกาศให้ห้องทราบรุ่นที่ใช้จริง
- [ ] ตรวจว่า tenant เปิด Copilot ให้ SKU อะไร (ใช้ได้กับ paid F SKU F2+ เท่านั้น) — ถ้าห้อง Trial มักจะไม่ได้ใช้ ประกาศล่วงหน้าว่าเรื่อง Copilot เป็นบรรยายอย่างเดียว

## ข้อมูล + บัญชีระบบ

- [ ] ทดสอบ Azure Blob (Internetsales, resellersales) ด้วย Access Key จาก Link.txt — connect ผ่าน Dataflow จริงหนึ่งรอบ
- [ ] ทดสอบ Azure SQL (AdventureworksDW: DimDate, DimProduct, DimCustomer, DimGeography) ด้วย user จาก Link.txt
- [ ] เตรียม `Link.txt` ต่อผู้เรียนทุกคน (แจกไฟล์ ไม่ประกาศบนจอ)
- [ ] ยืนยัน quota/capacity ว่าห้องไม่ชนลิมิตตอนทุกคน copy พร้อมกัน (ช่วง Workshop 4-1 คือจุดพีค)
- [ ] เตรียมบัญชีคู่ 2 บัญชี (องค์กรเดียวกัน) สำหรับโมดูล 17 ทดสอบสิทธิ์

## ซ้อมโฟลว์วันแรก

- [ ] Workshop 3: สร้าง Warehouse + `staging.internetsales` จาก `DW/1`
- [ ] Workshop 4-1: `Get Internet Sales` → Replace → `staging.internetsales` มีข้อมูล จด **จำนวนแถวจริง** ไว้เทียบห้อง
- [ ] Workshop 4-2: `Get Products` จาก Azure SQL (expand 2 ชั้น) จดจำนวนแถว
- [ ] บททดสอบ 5: `Get Customers` + Merge Columns — จดจำนวนแถวและแถบที่ MiddleName ว่าง
- [ ] Workshop 6-1: pipeline `Copy DimDate` — **ลบบรรทัด IF EXISTS ออกชั่วคราวเวลาสอน** เพื่อให้ปม rerun เดินได้ แล้วเปิดเฉลยจาก `DW/4` ตอนแก้
- [ ] Workshop 6-2: สร้าง proc 2 ตัว + pipeline ETL DimProduct จบเขียว
- [ ] Workshop 7-1: model Best AdventureworksDW + measures 7 ตัว (บน tenant ใหม่จะไม่มี default model — ทุกอย่างเริ่มจาก New semantic model) — จดตัวเลข Revenue/YTD อ้างอิงสำหรับตรวจห้อง
- [ ] Workshop 8: auto-create + Desktop connect + publish — ตรวจว่า Desktop รุ่นล่าสุดเชื่อม Data hub ได้

## ซ้อมโฟลว์วันที่สอง

- [ ] โมดูล 09: สร้าง Environment ติดตั้ง `semantic-link` จาก PyPI — จดเวลา publish จริง และรุ่น runtime ที่เลือกได้จริง
- [ ] Workshop 11-1: upload pbix + import `Semantic_Link_Demo.ipynb` — รันจบทุก cells จด shape ของ Customer และค่า Total Revenue
- [ ] Workshop 12-1/12-2: upload CSV (จำชื่อไฟล์ `DimGeopraphy.csv` ตามจริง) + dataframe + Data Wrangler — ยืนยันว่าทุกคนสร้าง Lakehouse ด้วยตัวเลือก schema เดียวกัน
- [ ] Workshop 13: `ETL DimReseller.ipynb` — ได้ manage/external สองตาราง
- [ ] Workshop 14: shortcuts DimDate/DimProduct + ยืนยัน INSERT ผ่าน shortcut แดงจริง
- [ ] Workshop 14B (แล็บแทรก): connection `azureopendatastorage` แบบ **Anonymous** → เลือก `nyctlc/green/puYear=2019/puMonth=1` → transformation → ยืนยัน path ยัง browse ได้จริงก่อนคาบ + จดจำนวนแถวจริง ([LAB-EXTERNAL.md](../day-2/13-shortcuts/LAB-EXTERNAL.md))
- [ ] (ถ้าใช้ Stretch 14B) เผยแพร่ `dwdelta` container แบบ public แล้วทดสอบเปิด `_delta_log/00000000000000000000.json` แบบ anonymous ได้ ([publish-delta-source.md](publish-delta-source.md))
- [ ] Workshop 15: `Get Reseller Sales` → `FactResellerSales` จดจำนวนแถว + ยอด SUM(SalesAmount)
- [ ] Workshop 16: New semantic model จาก endpoint + relationship 3 เส้น — **ยืนยันผล Mark as date table บน tenant ปัจจุบัน** และบันทึกสาเหตุจริงที่เจอ (type? ค่าซ้ำ?) — อัปเดต `solutions/15-lh-semantic-model/SOLUTION.md` หลังซ้อม
- [ ] Posttest: ทำจบหนึ่งชุดเป็นตัวอย่างเทียบ
- [ ] NYC demo: สร้าง Warehouse `New York Taxi Perf` + รัน `Demo/01`, `Demo/02` ล่วงหน้า (170M แถว) — เตรียมแผนสำรอง copy 1–2 เดือนสดถ้าโหลดไม่ทัน; ซ้อม `03` และ `04` แล้วจดเวลา cold→hot cache ที่เห็นจริง

## เช้าวันสอน (30 นาทีก่อนเริ่ม)

- [ ] เช็ก Trial ทุกเครื่องด้วยลิสต์ผู้เรียน (เปิด Account manager)
- [ ] เช็กตัวเลขจากการซ้อม (จำนวนแถวทุก workshop) วางไว้หน้าจอผู้สอน
- [ ] เปิดสไลด์ v6.1 (ไฟล์ `…Version 6.1.pptx` ใน Trainer_Docs) และเปิด repo ใน VS Code
- [ ] แจก Link.txt
- [ ] ยืนยันเครื่องสาธิตไม่มี cache เก่าทำให้เห็นข้อมูลปลอม

## หลังจบหลักสูตร

- [ ] อัปเดต `solutions/08-reports/SOLUTION.md` (คำตอบ insights จาก dataset จริง)
- [ ] อัปเดต `solutions/15-lh-semantic-model/SOLUTION.md` (สาเหตุ date table ที่เจอจริง)
- [ ] อัปเดต `reference/failure-modes.md` ถ้าเจอพังใหม่
- [ ] จด UI ที่เปลี่ยนจากเด็คเพื่อปรับเด็ครอบถัดไป (ต่อท้าย `slide-updates-v6.1.md`)
