# Workshop 14B — Shortcut จากแหล่งภายนอก: Storage Account สาธารณะ

> ⏱ 15 นาที · Start state: จบ Workshop 14 แล้ว (`AdventureworksLH` มี shortcut ไป Warehouse) — แต่ทำแยกต่างหากก็ได้ แล็บนี้ไม่พึ่งข้อมูลวันที่ 1

## Goal / เป้าหมาย

ทิศที่สองของ shortcut — **External sources**: ชี้ไป Storage Account ของจริงนอก OneLake โดยใช้ข้อมูลสาธารณะของ Microsoft (Azure Open Datasets) แบบ **ไม่ต้องมี credential ไม่ต้องมี Azure subscription** และจบแล็บด้วย Delta table จริงใน Tables ของ `AdventureworksLH`

> ต้นทางคือบัญชี `azureopendatastorage` (NYC Taxi — ไฟล์ Parquet จริง) ตรวจการเข้าถึงแบบ anonymous ล่าสุดเมื่อ 2026-10-26 — ข้อมูลสาธารณะเปลี่ยนได้เสมอ เดินตาม [`preclass-checklist`](../../instructor/preclass-checklist.md) ก่อนคาบทุกครั้ง

## Steps / ขั้นตอน

1. เปิด `AdventureworksLH` → Explorer → คลิกขวาที่ **Tables** (ถ้า lakehouse เปิด schemas: คลิกขวาที่ `dbo`) → **New table shortcut**

2. ในกล่อง New shortcut → External sources → **Azure Blob Storage** → **Create new connection**
   - Account name or URL: `azureopendatastorage`
   - Authentication kind: **Anonymous** — บัญชีนี้เปิดให้ใครก็อ่านได้ จึงไม่มี key ให้ใส่ (ชนิด ADLS Gen2 ไม่มีช่องนี้ — ต้องเป็น Azure Blob Storage)
   - **Create** → **Next**

3. Browse: container `nyctlc` → `green` → `puYear=2019` → **`puMonth=1`** → Next
   อย่าเลือกสูงกว่านี้ (ทั้ง `puYear` หรือทั้ง container) — ข้อมูลเต็ม ๆ เป็นสิบ GB การแปลงจะไม่จบในคาบ

4. ขั้น **Transform** — ของใหม่ที่ชื่อ **shortcut transformations**: Fabric จะแปลงไฟล์ Parquet ที่ต้นทางเป็น Delta table ให้เอง ตั้งชื่อ shortcut: `GreenTaxi_201901` → **Create**

5. รอการแปลงเสร็จ (ประมาณ 1–3 นาที ติดตามที่ **Manage shortcut**) — แล้ว `GreenTaxi_201901` จะโผล่ใน Tables เป็น Delta table แท้

6. พิสูจน์ — สลับ SQL analytics endpoint → New SQL query

   ```sql
   SELECT TOP 5 * FROM GreenTaxi_201901;
   SELECT COUNT(*) FROM GreenTaxi_201901;   -- จดจำนวนจริง (~7-8 แสนแถว)
   ```

7. เปิด **Manage shortcut** ของ `GreenTaxi_201901` → ดู **Refresh history**: Fabric ขุดตรวจต้นทางทุก 2 นาที ต้นทางเพิ่ม/ลบไฟล์เมื่อไหร่ ตารางเดินตามเอง

8. คำถามปิดแล็บ (ตอบให้ได้ก่อนออกจากห้อง): ตารางนี้เป็น pointer หรือ copy?
   - Workshop 14 (shortcut → Warehouse): **pointer ล้วน** — storage ไม่โต
   - Workshop 14B (transformation): **copy ที่แปลงเป็น Delta และ sync เอง** — storage โตขึ้นจริง
   - ถ้าต้นทางเป็น Delta อยู่แล้ว (Stretch ข้างล่าง) จะไม่มีขั้น Transform เลย — กลับไปเป็น pointer ล้วน
   - หน้าตาใน Explorer เหมือนกันหมด แต่ข้างในต่างกัน — "shortcut ทุกอันเบา" ไม่จริงเสมอไป

## ✅ Checkpoint

- [ ] connection สร้างด้วย **Anonymous** (ไม่ใส่ key เลย)
- [ ] `GreenTaxi_201901` โผล่ใน Tables เป็น Delta table
- [ ] SELECT + COUNT ผ่าน SQL endpoint ได้
- [ ] อธิบายต่าง pointer (W14) กับ transformation (W14B) ได้

## 🛠 Troubleshooting

| อาการ | สาเหตุ | แก้ |
|---|---|---|
| ไม่มีช่อง Anonymous ตอนสร้าง connection | เลือก External source ผิดชนิด | ต้องเป็น **Azure Blob Storage** — ADLS Gen2 ไม่รองรับ Anonymous |
| browse แล้วไม่เห็น container `nyctlc` | พิมพ์ account ผิด | ต้องเป็น `azureopendatastorage` ตัวเดียว |
| การแปลงไม่จบ/นานผิดปกติ | เลือกโฟลเดอร์ใหญ่ไป (ทั้งปี/ทั้ง container) | ลบ shortcut แล้วสร้างใหม่ จำกัดที่ `puMonth=1` เดือนเดียว |
| table ขึ้นแล้ว COUNT ว่าง | การแปลงยังไม่ sync ครบ | ดู Manage shortcut → Refresh history, รอแล้ว Refresh |
| path หรือโครงสร้าง dataset เปลี่ยน | ข้อมูลสาธารณะปรับอยู่เรื่อย ๆ | browse หา `green/puYear=*/puMonth=*` ที่ยังมีอยู่ ใช้เดือนอื่นแทนได้ |

## 🆘 Behind? Catch up

แล็บนี้ไม่ต้องมีตารางใดจากวันที่ 1 — ใครตามไม่ทันให้จดชื่อ connection ไว้แล้วกลับมาทำตอนท้ายคาบ

## Stretch / ต่อยอด

1. **Delta จริงจากต้นทาง (pointer ล้วน)**: ผู้สอนเผยแพร่ตาราง `dimdate` เป็น Delta ไว้ใน container สาธารณะแล้ว (วิธีทำฝั่งผู้สอน: [`instructor/publish-delta-source.md`](../../instructor/publish-delta-source.md)) — ทำซ้ำขั้น 1–3 แต่เลือกโฟลเดอร์ `dwdelta/dimdate` → จะไม่มีขั้น Transform เพราะ Fabric เห็น `_delta_log` → เทียบ `SELECT COUNT(*) FROM dimdate` กับ `dw.DimDate` จาก Workshop 14 — ตารางเดียวกัน สองต้นทาง สองแบบ shortcut
2. **เทียบสามประสบการณ์**: คลิกขวา **Files** → New shortcut ชี้ไปโฟลเดอร์ `puMonth=1` เดียวกัน — เห็นไฟล์ `.parquet` ดิบ ไม่ถูกแปลงเป็นตาราง สรุปร่วมกันว่า Files shortcut / table shortcut+transformation / delta shortcut ต่างกันตรงไหน
