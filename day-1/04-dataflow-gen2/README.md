# Module 04 — Dataflow Gen2: ดึงข้อมูลจาก Blob และ Azure SQL เข้า Warehouse

> ⏱ ~90 นาที (สอง workshop) · 🎯 สร้าง Dataflow Gen2 ต่อ 2 แหล่งข้อมูล ผ่าน Power Query ถึง Warehouse destination · Dataflow Gen2 can write to a chosen destination — that is what Gen1 could not.

## Key idea / แนวคิดหลัก — เล่าเรื่อง

ข้อมูลของหลักสูตรนี้อยู่สองที่: ไฟล์ CSV กองใหญ่บน Azure Blob (ยอดขาย) และตาราง dimension บน Azure SQL Database (สินค้า ลูกค้า วันที่) ทั้งคู่ต้องมาอยู่บน Warehouse `AdventureworksDW` ที่คุณเพิ่งสร้าง — คำถามคือ "ใครเป็นคนขน"

มีสามทางเลือก: เขียน T-SQL ขนเอง, ให้ pipeline ขน (โมดูลถัดไป) หรือวิธีที่คนทำงานข้อมูลส่วนใหญ่ถึงมือที่สุด — **Dataflow Gen2** มันคือ Power Query ที่คุณคุ้นเคยจาก Excel/Power BI แต่รันบน compute ของ Fabric และจุดต่างที่ทำให้มันคุ้มค่ากับคำว่า "Gen 2" คือการที่มัน**เลือกปลายทางได้**: จบ transform แล้วเขียนลง Warehouse, Lakehouse หรือ Azure SQL โดยตรง ไม่ต้องกลับมา copy อีกรอบ (Gen1 เก่าเขียนลง cloud storage ของตัวเองแล้วคุณต้องหาทางต่อเอง)

งานของโมดูลนี้มีสองชุดที่ออกแบบให้คุณเห็นสองลักษณะงานที่ต่างกัน ชุดแรก (**4-1**) คือไฟล์ CSV หลายไฟล์กองอยู่ในโฟลเดอร์ blob เดียว — ปัญหาคลาสสิกที่ Power Query มีปุ่มให้พร้อม: **Combine files** จะอ่านไฟล์ตัวอย่าง เดาชื่อคอลัมน์ ตัวคั่น encoding และชนิดข้อมูล แล้วรวมทุกไฟล์เป็น query เดียว ชุดที่สอง (**4-2**) คือตาราง relational จาก Azure SQL — ที่นี่ความมหัศจรรย์อยู่ที่ **Expand**: เลือก DimProduct มาแล้ว Power Query รู้ว่ามันผูกกับ DimProductSubcategory และผ่านตัวกลางนั้นไปต่อถึง DimProductCategory — คุณดึงชื่อหมวดหมู่จากอีกสองตารางโดยไม่เขียน JOIN แม้แต่บรรทัดเดียว

ทั้งสองชุดจบด้วยทางเดียวกัน: เลือกตารางปลายทางบน Warehouse ตั้งโหมดเขียนเป็น **Replace** แล้วกด Publish — Replace คือสัญญาว่า "ทุกครั้งที่ dataflow นี้ทำงาน ข้อมูลชุดใหม่จะทับชุดเก่าเสมอ" ซึ่งทำให้รันซ้ำได้ปลอดภัย

> EN: One dataflow per source; every flow ends at a Warehouse table with Replace.

## Concept / เนื้อหา

สี่เรื่องที่ต้องค้างในหัวก่อนลงมือ:

- **ตั้งชื่อ dataflow ทันทีที่สร้าง** — ชื่อซ้ำกันทั้ง workspace ไม่ได้ และแม้ลบแล้วชื่อจะยังค้างอยู่ช่วงหนึ่งถึงสองนาทีก่อนใช้ใหม่ได้ นี่คือกับดักคลาสสิกของทุกห้องเรียน: คนที่ทำพังแล้วลบ กลับมาสร้างชื่อเดิมทันทีแล้วงงว่าทำไมสร้างไม่ได้
- **Combine files ทำงานอย่างไร** — มันหยิบไฟล์หนึ่งมาเป็นตัวอย่าง สร้าง schema จากมัน แล้ว apply กับไฟล์ทุกไฟล์ในโฟลเดอร์ ถ้าไฟล์ไหนโครงไม่ตรง (คอลัมน์เลื่อน header หลุด) จุดพังคือตรงนี้
- **Expand คือ JOIN ที่ซ่อน SQL ไว้** — เห็น column ที่เป็น relationship ใน Power Query กด expand เลือกคอลัมน์ที่ต้องการ มันจะไล่ไปดึงที่ตารางปลายทางให้ ทำได้ซ้อนหลายชั้นเหมือนที่คุณจะทำใน 4-2 (Product → Subcategory → Category)
- **โหมดเขียนของ destination มี Replace กับ Append** — ในหลักสูตรนี้เราใช้ Replace เสมอ เพราะงานเราคือ "snapshot ข้อมูลชุดใหม่ทับชุดเก่า" ไม่ใช่การเก็บประวัติสะสม

ของใหม่ที่ควรรู้เพื่อความทันสมัย: Dataflow Gen2 ปัจจุบันมีความสามารถ **Fast Copy** (งาน ingest ข้อมูลใหญ่จาก connector ที่รองรับจะวิ่งบน Copy engine โดยตรง ไม่ต้องผ่านกระบวนการ transform) และมีตัวแปร **Dataflow Gen2 with CI/CD** สำหรับเก็บ definition ลง Git — เรื่องพวกนี้ไม่ได้ใช้ในแล็บ แต่ควรรู้ว่ามีเวลาโครงการจริงถามถึง

## ลงมือทำตามลำดับ

- [LAB.md](LAB.md) Workshop 4-1: Blob → `staging.internetsales` (Combine files + Choose columns + Replace)
- [LAB.md](LAB.md) Workshop 4-2: Azure SQL `DimProduct` → `staging.product` (Expand สองชั้น) — เตรียมตารางปลายทางด้วย `DW/2. Create Staging Product Table.sql` ก่อน
- แล็บเสริมสำหรับฝึกต่อนอกห้อง: [`DFGen2/README.md`](../../DFGen2/README.md)

## Common pitfalls / กับดัก

- ไม่ตั้งชื่อ dataflow ตอนสร้าง → Fabric ตั้งชื่อมั่ว ๆ ให้ และเวลาลบ-สร้างใหม่ชื่อจะค้าง — เรื่องนี้เจอในห้องทุกรอบ ตั้งชื่อทันทีคือทางแก้ที่ถูกและถูกที่สุด
- ลืมกด Combine Files ก่อน — จะได้ query ที่ "แถวเดียวคือไฟล์หนึ่ง" แทนข้อมูลจริง ดูแปลก ๆ ตั้งแต่ preview แรก
- Choose destination แล้วปล่อยโหมดเขียน default → บางกรณีเป็น Append ทำให้ข้อมูลกองซ้ำเมื่อ publish ซ้ำ สังเกตได้จาก COUNT ที่โตขึ้นทุกครั้ง
- Access Key คัดลอกติดช่องว่างหรือขึ้นบรรทัด → Connect ไม่ผ่านตลอด คัดลอกใหม่ทั้งบรรทัดจากต้นไฟล์เสมอ
- สร้าง connection ใหม่ทุกครั้งที่เจอหน้า Connect → ทำให้ credentials กระจัดกระจาย ใช้ **Use existing** กับ connection ที่ตั้งชื่อไว้แล้ว

## Quick check / ทบทวน

<details>
<summary>1. Gen2 ต่างจาก Gen1 ข้อเด่นสุดของหลักสูตรนี้</summary>
เลือก data destination ได้ — เขียนลง Warehouse/Lakehouse ตรงจาก Power Query จบงานรอบเดียว
</details>

<details>
<summary>2. ทำไม destination ตั้ง Replace</summary>
ให้ publish/refresh ซ้ำได้โดยข้อมูลชุดใหม่ทับชุดเก่า ไม่กองซ้ำ
</details>

<details>
<summary>3. คอลัมน์ EnglishProductCategoryName มาจากไหน</summary>
Expand relationship สองชั้น: DimProduct → DimProductSubcategory → DimProductCategory
</details>

## Go deeper

- [Dataflows Gen2 overview](https://learn.microsoft.com/en-us/fabric/data-factory/dataflows-gen2-overview)
- [Quickstart: create your first dataflow](https://learn.microsoft.com/en-us/fabric/data-factory/create-first-dataflow-gen2)
- [Dataflow Gen2 with CI/CD and Git integration](https://learn.microsoft.com/en-us/fabric/data-factory/dataflow-gen2-cicd-and-git-integration)
- [Ingest data with Dataflows Gen2 (training)](https://learn.microsoft.com/en-us/training/modules/use-dataflow-gen-2-fabric)
