# Module 05 — บททดสอบ 5: นำเข้าตาราง DimCustomer ด้วยตัวเอง

> ⏱ ~25 นาที · 🎯 ทำ Dataflow Gen2 ครบวงจรเองโดยไม่ดูตัวอย่างทีละจอ · If you can expand two relationship hops and merge three name columns, you can wire any dimensional source.

## Key idea / แนวคิดหลัก — เล่าเรื่อง

นี่คือบททดสอบครั้งแรกของหลักสูตร — ต่างจาก workshop ก่อนหน้าที่ผู้สอนเดินพา ครั้งนี้โจทย์มาเป็นข้อความ และคุณต้องประกอบทุกอย่างจากทักษะที่เพิ่งฝึกมาเอง

โจทย์มีสี่ข้อ อ่านให้ครบก่อนเปิด Fabric: (1) โครงสร้างตารางดูจากไฟล์ `DW/3. Create DimCustomer Table.sql` — แปลว่าคุณต้องอ่าน DDL แล้วเข้าใจว่าปลายทางต้องการคอลัมน์อะไรบ้าง (2) ตั้งชื่อ dataflow ว่า **Get Customers** (3) คอลัมน์ `CustomerName` ต้องสร้างขึ้นเองจากการต่อ FirstName + MiddleName + LastName — เทคนิคใหม่ที่ยังไม่เคยฝึก คุณต้องหาเครื่องมือใน Power Query เอง (4) ใช้การ expand ไปดึงคอลัมน์จาก DimGeography เหมือนที่เพิ่งทำกับ Product

สิ่งที่บททดสอบนี้วัดจริง ๆ ไม่ใช่ความจำ — แต่คือวิธีที่คุณคิดเมื่อเจอโจทย์สองชั้น: ชั้นแรกคือ "ตารางปลายทางต้องการอะไร" (อ่านจาก DDL) ชั้นที่สองคือ "ตารางต้นทางมีอะไรให้ และต้องเปลี่ยนรูปยังไง" (Merge ชื่อ + Expand geography) เมื่อคิดสองชั้นนี้จบ ขั้นตอนกลายเป็นเรื่องปฏิบัติเท่านั้น

> EN: Same recipe, new twist — build the name column yourself, expand geography yourself.

## Concept / เนื้อหา

เทคนิคใหม่ที่โจทย์ต้องการคือการต่อคอลัมน์ ใน Power Query ทำได้ด้วย **Merge Columns**: เลือกหลายคอลัมน์พร้อมกัน (Ctrl+คลิก) → คลิกขวาที่หัวคอลัมน์ → Merge Columns → เลือก Separator และตั้งชื่อคอลัมน์ใหม่ จุดที่ต้องคิดเองคือ **MiddleName ว่างในบางแถว** — เมื่อคุณ merge สามคอลัมน์ด้วยช่องว่าง แถวที่ MiddleName ว่างจะได้ช่องว่างติดกันสองที่ ("Ada  Lopez" แทนที่จะเป็น "Ada Lopez") วิธีจัดการมีหลายระดับ ตั้งแต่ยอมรับและอธิบายได้ ไปจนถึงใช้ conditional column เลือก merge สองคอลัมน์เมื่อ MiddleName ว่าง — ระดับไหนก็ได้ แค่ต้อง**รู้ว่าเกิดอะไรขึ้น**

ส่วนการ expand DimGeography นั้นใช้ทักษะเดิมจาก Workshop 4-2 — ความยากที่ซ่อนอยู่คือเลือกตารางให้ถูก เพราะ DimProductSubcategory ยังค้างในความจำจากรอบก่อน และชื่อคอลัมน์ปลายทาง (Province, Country) ไม่ตรงเป๊ะกับชื่อคอลัมน์ต้นทาง (StateProvinceName, EnglishCountryRegionName) — การแมปชื่อข้ามสองตารางคือทักษะจริงของงาน ETL

## ลงมือทำตามลำดับ

ทำตาม [LAB.md](LAB.md) — ในนั้นไม่มีคำตอบ มีแค่ขั้นตรวจผล เฉลยอยู่ที่ [`solutions/05-dimcustomer/SOLUTION.md`](../../solutions/05-dimcustomer/SOLUTION.md) (เปิดเมื่อติดจริง ๆ หรือเมื่อทำเสร็จเพื่อเทียบแนวคิด)

## Common pitfalls / กับดัก

- ลืมสร้างตารางปลายทางก่อน — ตอนเลือก destination จะเห็นแต่ตัวเลือก New table ซึ่งสร้างใน schema ที่ยังไม่มี ทั้งที่โจทย์บอกให้ดูโครงจากไฟล์ DDL ไว้แล้ว
- Merge Columns แล้วลืมตั้งชื่อเป็น `CustomerName` — ตารางปลายทางรอคอลัมน์ชื่อนี้อยู่ คอลัมน์ชื่ออื่นจะทำให้ destination mapping ไม่ครบ
- expand ผิดตาราง — อ่านชื่อ relationship ใน Power Query ให้ครบก่อนกด
- ลืม Replace — พอ publish ซ้ำ COUNT จะโต และคุณจะได้เรียนรู้จุดเดียวกันด้วยวิธีแพงกว่า

## Quick check / ทบทวน

<details>
<summary>1. CustomerName สร้างด้วยคำสั่งอะไรใน Power Query</summary>
Merge Columns (เลือก 3 คอลัมน์ → Merge) ด้วย separator ช่องว่าง
</details>

<details>
<summary>2. เงื่อนไขสำคัญของ destination คืออะไร</summary>
ตาราง dw.DimCustomer ต้องถูกสร้างก่อน (ตามโครงใน DW/3) และโหมดเขียนตั้ง Replace
</details>

<details>
<summary>3. คอลัมน์ไหนมาจาก DimGeography</summary>
City, Province (จาก StateProvinceName), Country (จาก EnglishCountryRegionName)
</details>

## Go deeper

- แล็บเสริมคล้ายกัน: [`DFGen2/README.md`](../../DFGen2/README.md) Lab 1 (DimReseller)
- [Merge columns in Power Query](https://learn.microsoft.com/en-us/power-query/merge-columns)
