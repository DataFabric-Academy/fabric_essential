# Module 14 — Dataflow Gen2 ไป Lakehouse: สร้าง FactResellerSales

> ⏱ ~40 นาที · 🎯 ต่อ Dataflow Gen2 จาก Azure Blob ลง Lakehouse เป็น Delta table ใหม่ด้วย Power Query · Same flow, new destination — Lakehouse tables are created from the choose-target dialog.

## Key idea / แนวคิดหลัก — เล่าเรื่อง

เช้าวันแรกคุณให้ Dataflow Gen2 เขียนลง **ตารางที่มีอยู่แล้ว** บน Warehouse ตอนนี้เปลี่ยนบทสนทนาเล็กน้อยแต่หลักการใหญ่: ปลายทางคือ **Lakehouse** และครั้งนี้ไม่มีตารางรออยู่ — คุณจะให้ Power Query **สร้างตารางใหม่ให้เอง** ชื่อ `FactResellerSales` จากไฟล์ resellersales กองบน Azure Blob

เสน่ห์ของงานนี้อยู่ที่ว่าทุกอย่างคุณทำมาแล้ว: สร้าง dataflow, ตั้งชื่อทันที, ใช้ connection เดิม (Use existing — คุณเก็บชื่อ connection ไว้ตั้งแต่เช้าแรก), Combine files, Choose columns สิบตัว, และจบด้วย Replace สิ่งที่เพิ่มมีอย่างเดียวคือหน้า **Choose destination target** ที่มีตัวเลือก **New Table** — ตั้งชื่อตารางเอง และข้อมูลจะกลายเป็น Delta table โดยอัตโนมัติเมื่อ publish

หลัง publish เสร็จ กลับไปที่ Lakehouse Explorer กด Refresh — คุณจะเห็น `FactResellerSales` ปรากฏใน Tables ตัวเดียวกับที่ notebook ของคุณเขียน Delta table เองเมื่อเช้า นี่คือจุดที่สองโลกมาบรรจบกัน: ข้อมูลจาก Power Query (โลก low-code) กับข้อมูลจาก PySpark (โลกโค้ด) อยู่ Tables เดียวกัน อ่านด้วยเครื่องมือเดียวกัน

ประโยคที่ควรค้างในใจ: ถ้าเห็น COUNT โตขึ้นทุกครั้งที่ publish — นั่นคือ Append ทำงาน กลับไปตั้ง Replace ก่อนงานต่อไปเริ่ม เพราะโมดูลถัดไปจะเอาตารางนี้ไปเป็น fact table ของ star schema

> EN: Destination = Lakehouse, target = New Table — Power Query creates the Delta table for you.

## Concept / เนื้อหา

- **Connection เดิม** — ตัวเลือก Use existing ช่วยชีวิตคุณจากการกรอก Access Key ซ้ำและจาก connection ทิ้งข้ามทั้ง workspace
- **Combine files รอบนี้** — เลือกไฟล์ตัวอย่างให้ Power Query ตรวจ schema ก่อนรวม (สังเกตว่าขั้นตอนเหมือนเดิมแต่ UI ให้เลือกไฟล์ตัวอย่างเอง)
- **Choose columns 10 ตัว** — `ProductKey, OrderDateKey, ResellerKey, OrderQuantity, UnitPrice, UnitPriceDiscountPct, DiscountAmount, TotalProductCost, SalesAmount, TaxAmt` — จำนวนเป๊ะสิบ เพราะโมดูลถัดไปจะผูก relationship กับทุกตัว
- **New Table + Replace** — New Table สร้างโครงตาม schema ของ query, Replace ทำให้ publish ซ้ำได้ปลอดภัย
- **ผลสุดท้าย** — Delta table `FactResellerSales` ใน Tables ของ `AdventureworksLH` (Parquet + `_delta_log` เบื้องหลัง ไม่ต่างจากที่ notebook สร้าง)

## ลงมือทำตามลำดับ

ตาม [LAB.md](LAB.md)

## Common pitfalls / กับดัก

- สร้าง connection ใหม่ทั้งที่มี — ค้นชื่อ connection เดิมก่อนกด Create new
- ตั้งชื่อตารางชนตัวเก่า — ถ้าคุณเคยทำ Load to Tables ตอน stretch ของโมดูล 11 ตารางชื่อคล้ายกันอาจค้างอยู่ จัดการให้ชื่อเดียวกันทั้งห้อง (`FactResellerSales`)
- ลืม Replace — ข้อมูลกองซ้ำเมื่อ publish ซ้ำ
- Choose columns ไม่ครบ 10 — workshop ถัดไปจะผูก relationship ไม่ครบเส้น

## Quick check / ทบทวน

<details>
<summary>1. ปลายทางรอบนี้ต่างจาก Workshop 4-1 อย่างไร</summary>
เลือก Lakehouse + New Table — Fabric สร้าง Delta table ให้ใหม่จากชื่อที่ตั้ง
</details>

<details>
<summary>2. ข้อมูลจบลงที่ไหนในรูปแบบอะไร</summary>
Delta table ชื่อ FactResellerSales ใน Tables ของ AdventureworksLH (Parquet + _delta_log)
</details>

<details>
<summary>3. ทำไมใช้ Combine files</summary>
โฟลเดอร์ blob มีหลายไฟล์ — combine รวมทุกไฟล์เป็น query เดียวด้วย schema ที่ตรวจจับได้
</details>

## Go deeper

- [Dataflows Gen2 overview](https://learn.microsoft.com/en-us/fabric/data-factory/dataflows-gen2-overview)
- [Quickstart: first dataflow](https://learn.microsoft.com/en-us/fabric/data-factory/create-first-dataflow-gen2)
- [Lakehouse overview](https://learn.microsoft.com/en-us/fabric/data-engineering/lakehouse-overview)
