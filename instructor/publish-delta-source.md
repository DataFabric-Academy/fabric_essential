# เผยแพร่ Delta tables ของคอร์สขึ้น Storage Account สาธารณะ (ฝั่งผู้สอน)

ทำครั้งเดียวก่อนคาบ — นักเรียนใช้ต่อใน Workshop 14B (Stretch) โดยไม่ต้องมี credential ใด ๆ

## ทำไมต้องทำเอง

ณ ต.ค. 2026 **ยังไม่มี storage สาธารณะที่เผยแพร่ Delta table ไว้ให้ shortcut โดยตรง** — Azure Open Datasets (`azureopendatastorage`) เป็น Parquet/CSV ธรรมดา (ใช้ได้ดีกับ shortcut transformation แต่ไม่ใช่ Delta) และ bucket สาธารณะของชุมชน (เช่น `delta-examples` บน S3) ถูกลบไปแล้ว ถ้าอยากให้นักเรียนเห็น **shortcut แบบ pointer ล้วนไปยัง Delta จริง** ต้องเผยแพร่เอง — คอร์สนี้จึงเตรียมสคริปต์ไว้ให้

## ขั้นตอน (ผู้สอน 1 คน)

1. **สร้าง container สาธารณะ** — ใช้ Storage Account เดิมของคอร์ส (ที่มี Internetsales/resellersales อยู่แล้ว) ได้เลย: สร้าง container `dwdelta` → access level **Blob (anonymous read)** — ถ้าบัญชียังปิด public access ให้เปิด "Allow Blob anonymous access" ที่ระดับ account ก่อน (หรือใช้บัญชีใหม่แยกต่างหาก จะได้ลบทิ้งรวดเดียวเมื่อจบคลาส)

2. **แปลงข้อมูลเป็น Delta บนเครื่องคุณ**:
   ```bash
   pip install "deltalake" pandas
   python tools/build_delta_publish.py --out publish_delta
   ```
   ได้ `publish_delta/dimdate` (ปฏิทิน AdventureWorksDW 2,192 วัน — เทียบ COUNT กับ `dw.DimDate` ได้) และ `publish_delta/FactInternetSales` (รวมจาก `export_internet_sales/*.csv`)

3. **อัปโหลดทั้งโฟลเดอร์**:
   ```bash
   azcopy copy "./publish_delta/*" "https://<account>.blob.core.windows.net/dwdelta" --recursive
   ```
   (หรือลากวางใน Azure Storage Explorer — ขอแค่คงโครงสร้างโฟลเดอร์เดิม)

4. **ทดสอบแบบ anonymous ก่อนเข้าห้อง** — เปิดในเบราว์เซอร์โดยไม่ล็อกอิน:
   `https://<account>.blob.core.windows.net/dwdelta/dimdate/_delta_log/00000000000000000000.json`
   ต้องเห็น JSON ธรรมดา ไม่มี 401/403 — แล้วเพิ่มข้อเช็กนี้ลง [`preclass-checklist.md`](preclass-checklist.md)

5. **ในห้อง** (สั่งนักเรียน 1 นาที): Tables → New table shortcut → Azure Blob Storage → Anonymous → เลือกโฟลเดอร์ `dwdelta/dimdate` → Create — จะ**ไม่มีหน้า Transform** เพราะ Fabric เห็น `_delta_log` จึงเป็น pointer ล้วน → เทียบ `SELECT COUNT(*) FROM dimdate` กับ `dw.DimDate` จาก Workshop 14

## ข้อควรระวัง

- **ห้ามเผยแพร่ข้อมูลจริง/ข้อมูลลับ** — container นี้ใครก็อ่านได้ ใช้เฉพาะข้อมูลตัวอย่างคอร์ส
- **ต้นทุน egress** — ทุกคิวรี่ของนักเรียนดึงจากบัญชีคุณ: `dimdate` อยู่ระดับแสน byte ใช้สบาย ส่วน `FactInternetSales` (หลายสิบ MB) คิดก่อนใส่ และลบ container เมื่อจบคลาส
- ไม่อยากเปิด public จริง → ใช้ **SAS token** (สิทธิ์ read/list) แทน โดยให้นักเรียนเลือก Authentication kind = SAS ตอนสร้าง connection
- delta-rs เขียน Delta protocol มาตรฐานที่ Fabric อ่านได้ — ตรวจเวอร์ชันล่าสุดที่ [Delta Lake interoperability](https://learn.microsoft.com/en-us/fabric/fundamentals/delta-lake-interoperability)
