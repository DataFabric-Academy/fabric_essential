# บททดสอบ 5 — นำเข้า DimCustomer ด้วยตัวเอง

> ⏱ 25 นาที · โจทย์สี่ข้อตาม README ของโมดูล — ทำโดยไม่เปิดตัวอย่างทีละจอ

## Goal / เป้าหมาย

ได้ตาราง `dw.DimCustomer` ที่มีข้อมูลครบ 7 คอลัมน์ โดยสร้าง `CustomerName` เอง (Merge Columns) และ expand จาก DimGeography เอง

## Steps / ขั้นตอน (ขั้นตรวจเป็นหลัก — วิธีคิดเป็นของคุณ)

1. สร้างตารางปลายทาง: New SQL query → วางไฟล์ `DW/3. Create DimCustomer Table.sql` → Run (ถ้า schema `dw` ยังไม่มี ให้ uncomment สองบรรทัดแรกของไฟล์)

2. New Dataflow Gen2 → ตั้งชื่อ **`Get Customers`**

3. Source: **Azure SQL Database** — ใช้ connection เดิมของ Workshop 4-2 (Use existing) → เลือกตาราง **DimCustomer**

4. สร้างคอลัมน์ `CustomerName` จาก FirstName + MiddleName + LastName — เครื่องมือที่ต้องหาเจอคือ Merge Columns และคุณต้องตัดสินใจเองว่าจะจัดการแถวที่ MiddleName ว่างอย่างไร

5. Expand relationship ไป **DimGeography** — ดึงเฉพาะคอลัมน์ที่ตารางปลายทางต้องการ (เทียบชื่อในขั้น 1)

6. Choose columns ให้ตรงกับ 7 คอลัมน์ของ `dw.DimCustomer` — รวมการแมปชื่อต้นทาง-ปลายทางให้ครบ

7. Destination: `dw.DimCustomer` → **Replace** → Publish

8. ตรวจ:

   ```sql
   SELECT TOP 10 * FROM dw.DimCustomer;
   SELECT COUNT(*) AS rows_total,
          COUNT(*) - COUNT(CustomerName) AS null_names
   FROM dw.DimCustomer;
   ```

   ผลที่ควรเห็น: มีข้อมูล และ `null_names = 0`

## ✅ Checkpoint

- [ ] dataflow `Get Customers` สถานะ succeeded
- [ ] `dw.DimCustomer` ครบ 7 คอลัมน์: CustomerKey, CustomerName, MaritalStatus, Gender, City, Province, Country
- [ ] CustomerName ไม่มีค่าว่าง
- [ ] publish สองรอบได้ COUNT เท่าเดิม (Replace ทำงาน)

## 🛠 Troubleshooting

| อาการ | สาเหตุ | แก้ |
|---|---|---|
| destination เห็นแต่ New table | ลืมสร้าง `dw.DimCustomer` หรือ schema `dw` ยังไม่มี | รันขั้น 1 ก่อน (uncomment CREATE SCHEMA dw) |
| CustomerName มีช่องว่างซ้ำ ๆ | MiddleName ว่างแล้ว Merge เว้นช่อง | Merge เฉพาะคอลัมน์ที่มีค่า หรือใช้ conditional column กัน null — อย่างน้อยต้องอธิบายได้ว่าเกิดอะไรขึ้น |
| Province/Country ว่างหมด | expand ตารางผิด (ไม่ใช่ DimGeography) | กลับ Applied steps ไปแก้ step expand |
| COUNT โตทุกครั้งที่ publish | destination เป็น Append | เปลี่ยน destination settings เป็น Replace แล้ว publish ใหม่ |

## 🆘 Behind? Catch up

ติดเกิน 10 นาที = เปิดเฉลยได้: [`solutions/05-dimcustomer/SOLUTION.md`](../../solutions/05-dimcustomer/SOLUTION.md) — อ่านทีละขั้นแล้วทำตาม ไม่ใช่ copy ผล

## Stretch / ต่อยอด

เพิ่มคอลัมน์ที่สองจากการ Merge (เช่น FirstName+LastName เท่านั้น) แล้วนับว่าช่องว่างซ้ำต่างจาก CustomerName กี่แถว — ตัวเลขนี้คือราคาของการ merge โดยไม่ดู NULL
