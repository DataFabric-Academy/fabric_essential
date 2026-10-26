# Module 15 — Semantic Model บน SQL analytics endpoint

> ⏱ ~35 นาที · 🎯 สร้าง semantic model บน Lakehouse ให้เป็น star schema จริง และสืบสวนปัญหา Mark as date table ที่ปลูกไว้ · The endpoint mirrors Delta tables; the model adds meaning on top.

## Key idea / แนวคิดหลัก — เล่าเรื่อง

ตอนนี้ Lakehouse ของคุณมีข้อมูลครบแล้ว — fact จาก Dataflow, dim จาก notebook, วันที่-สินค้าผ่าน shortcut — แต่มันยังเป็นแค่ตาราง โลกของความหมาย (relationship, hierarchy, measure) ยังไม่ถูกเขียน โมดูลนี้คุณจะสร้างมันบนฝั่ง **SQL analytics endpoint**

ก่อนอื่นทำความเข้าใจกับกลไก: endpoint คือกระจกเงาของ Delta tables — ทุกครั้งที่ Delta table ถูกสร้างหรือแก้ endpoint จะสะท้อนให้เห็นผ่าน T-SQL อ่านอย่างเดียว มันจึงเป็นทางเดินของโลก SQL เข้ามาในโลก Lakehouse

และนี่คือจุดที่ต้องอัปเดตความรู้ตาม MS Learn ปัจจุบัน: สมัยก่อน endpoint มาพร้อม "default semantic model" และมีปุ่ม Manage default Power BI semantic model ให้แก้ — **กลไกนั้นถูกยกเลิกไปทั้งกระบวนการ** (ตั้งแต่ปลายปี 2025 ตามประกาศของ Microsoft: default models ไม่ถูกสร้างอัตโนมัติอีก ตัวเดิมถูกแปลงเป็น model ปกติ และ Reporting tab ที่พึ่งพามันถูกถอด) วิธีทำงานวันนี้: ที่ SQL analytics endpoint กด **New semantic model** เลือกตารางที่ต้องการ แล้วจัดการ relationship/hierarchy/hide/sort ใน model editor เหมือนที่คุณทำกับ Warehouse วันแรก

งานของแล็บมีสองชั้น ชั้นแรกคือสร้าง model ให้เป็น star schema จริง — relationship สามเส้นระหว่าง `FactResellerSales` กับ DimDate (shortcut), DimProduct (shortcut) และ `manage_DimReseller`

ชั้นที่สองคือ**สืบสวน** โจทย์ปล่อยคำถามไว้ว่า: ทำไมการ Mark as date table บนตาราง `DimDate` จึงไม่สำเร็จ และเมื่อมันไม่สำเร็จ Date Time Intelligence ก็ใช้ไม่ได้ — ให้ห้องตั้งสมมติฐานเองแล้วพิสูจน์ด้วย SQL สมมติฐานที่ดีมีสามชั้น: (1) ชนิดข้อมูลของ `FullDateAlternateKey` ผ่าน shortcut/endpoint ไม่ใช่ date/datetime — ปมย้อนหลังคือตารางนี้ถูก copy ด้วย "Load to new table" แล้วสร้างต่อด้วย CTAS ในวันแรก ชนิดข้อมูลที่ copy เดามาถูกคงไว้ (2) ค่าซ้ำหรือว่างในคอลัมน์ date (3) ข้อจำกัดเฉพาะของ default model — ซึ่งปัจจุบันไม่มี default แล้ว ให้เปลี่ยนเป็นการทดสอบบน model ที่คุณสร้างใหม่ ไม่ว่าสมมติฐานไหนจะจริง กระบวนการสืบสวนด้วย INFORMATION_SCHEMA คือทักษะที่อยู่กับคุณตลอด

> EN: The endpoint mirrors tables; meaning is added by hand — and the date table has a planted bug worth hunting.

## Concept / เนื้อหา

- **สร้าง model จาก endpoint**: Lakehouse → สลับเป็น SQL analytics endpoint → **New semantic model** → เลือกตาราง → จัดการใน model editor
- **ตารางที่ใช้**: `FactResellerSales`, `manage_DimReseller`, `DimDate` (shortcut), `DimProduct` (shortcut) — สังเกตว่าข้อมูลมาจากสามทางแต่ model มองเห็นเป็นตารางเดียวกัน
- **Relationship ที่ต้องมี**:
  - `FactResellerSales[OrderDateKey] → DimDate[DateKey]`
  - `FactResellerSales[ResellerKey] → manage_DimReseller[ResellerKey]`
  - `FactResellerSales[ProductKey] → DimProduct[ProductKey]`
- **เครื่องมือสืบสวน** — `INFORMATION_SCHEMA.COLUMNS` ดู DATA_TYPE จริงของทุกคอลัมน์, COUNT vs COUNT DISTINCT ตรวจค่าซ้ำ — เครื่องมือพวกนี้ใช้ได้ทุก endpoint ในอนาคตของคุณ
- **ข้อสังเกตเรื่อง default model** — บาง tenant เก่าอาจยังมี default model ค้างอยู่ในรูป regular model หลังการแปลง อย่าปนกับของใหม่ — ทำงานบน model ที่คุณสร้างเอง

## ลงมือทำตามลำดับ

ตาม [LAB.md](LAB.md) — Workshop 16 สร้าง model + สืบสวนปม date table

## Common pitfalls / กับดัก

- หาปุ่ม Manage default semantic model ไม่เจอ — มันถูกถอดไปแล้วพร้อมการ sunset ใช้ New semantic model เป็นหลัก
- relationship ผูกคอลัมน์ผิด (ResellerKey ไป ProductKey) — อ่านชื่อ key ให้ครบทั้งสองฝั่งเส้น
- คาดหวังว่า model จะ sync ตามตารางอัตโนมัติทุกจุด — ตารางใน model คือสิ่งที่คุณเลือกเอง แก้ที่ตารางแล้ว refresh model เมื่อจำเป็น
- ข้ามการสืบสวนปม date table — นี่คือแก่นการสอนของโมดูลนี้ และเป็นโจทย์ที่ Posttest ยังถามต่อ

## Quick check / ทบทวน

<details>
<summary>1. SQL analytics endpoint คืออะไรและ sync เมื่อไหร่</summary>
กระจก T-SQL อ่านอย่างเดียวของ Delta tables — สะท้อนตามเมื่อตารางถูกสร้าง/แก้
</details>

<details>
<summary>2. ทำไม DimDate จาก shortcut ถึงอาจ mark as date table ไม่ได้</summary>
ชนิดข้อมูลของ FullDateAlternateKey อาจไม่ใช่ date/datetime (จากท่อ copy → CTAS → shortcut) หรือมีค่าซ้ำ/ว่าง — พิสูจน์ด้วย INFORMATION_SCHEMA
</details>

<details>
<summary>3. ผลของปัญหานี้กับรายงาน</summary>
Time Intelligence (YTD, SAMEPERIODLASTYEAR) คำนวณไม่ได้หรือเพี้ยนจนแก้คอลัมน์ date ให้ถูก
</details>

## Go deeper

- [SQL analytics endpoint for lakehouse](https://learn.microsoft.com/en-us/fabric/data-engineering/lakehouse-sql-analytics-endpoint)
- [Manage a semantic model](https://learn.microsoft.com/en-us/fabric/data-warehouse/manage-semantic-model)
- [Mark date tables](https://learn.microsoft.com/en-us/power-bi/transform-model/desktop-date-tables)
- [Sunsetting default semantic models (ประกาศอย่างเป็นทางการ)](https://community.fabric.microsoft.com/blog/fbc_fabricupdatesblogs/sunsetting-default-semantic-models---microsoft-fabric/5172667)
