# Workshop 3 — สร้าง Warehouse แรก + staging.internetsales

> ⏱ 20 นาที · Start state: My workspace ว่าง มี Trial active

## Goal / เป้าหมาย

ได้ Warehouse ชื่อ `AdventureworksDW` ที่มี schema `staging` และตาราง `staging.internetsales` (ตารางว่าง) พร้อมรับข้อมูลจาก Workshop 4-1 ในบ่ายวันนี้

## Steps / ขั้นตอน

1. สร้าง Warehouse

   My workspace → **New item** → ค้นหา `Warehouse` → ตั้งชื่อ `AdventureworksDW` → **Create**

   คุณจะเข้าสู่หน้า Warehouse พร้อม SQL editor — สังเกตใน workspace ว่ามี item คู่ชื่อ `AdventureworksDW` อีกตัวโผล่มาด้วย (ชนิด semantic model) อย่างนี้คือปกติ และเราจะอธิบายบทบาทของมันในโมดูล 07

2. สร้าง schema และตาราง staging

   บนทูลบาร์กด **New SQL query** → เปิดไฟล์ `DW/1. Create Staging Internetsales  Table.sql` จาก repo → copy ทั้งไฟล์มาวาง → **Run**

   ```sql
   CREATE SCHEMA staging;
   GO

   CREATE TABLE staging.internetsales
   (
       ProductKey int NULL,
       OrderDateKey int NULL,
       CustomerKey int NULL,
       OrderQuantity int NULL,
       UnitPrice decimal(18,2) NULL,
       UnitPriceDiscountPct decimal(8,2) NULL,
       DiscountAmount decimal(18,2) NULL,
       TotalProductCost decimal(18,2) NULL,
       SalesAmount decimal(18,2) NULL,
       TaxAmt decimal(18,2) NULL
   )
   ```

   ผลที่ควรเห็น: ข้อความ "Command(s) completed successfully"

> 📚 **รู้เพิ่ม:** `GO` คือตัวแบ่ง batch ของ SQL editor — สองคำสั่งรันตามลำดับ ถ้า schema เคยมีอยู่แล้วคำสั่งแรกจะ error "already exists" ไม่เป็นไร ข้ามไปรันคำสั่งตารางต่อได้เลย

3. ตรวจผลใน Explorer

   แถบซ้ายของ Warehouse (Schema explorer) ต้องเห็น schema `staging` และตาราง `internetsales` ภายใต้มัน — ถ้ายังไม่เห็น กด **Refresh** บนทูลบาร์ของ Explorer หนึ่งครั้ง

4. ทดสอบ DML ครั้งแรก

   New SQL query → รัน:

   ```sql
   SELECT COUNT(*) AS rows_now FROM staging.internetsales;
   ```

   ผลที่ควรเห็น: `rows_now = 0` — ตารางว่างเพราะยังไม่มีใครเทข้อมูลลงมัน นี่คือสถานะที่ตั้งใจ

## ✅ Checkpoint

- [ ] Warehouse `AdventureworksDW` อยู่ใน My workspace
- [ ] schema `staging` และตาราง `staging.internetsales` เห็นใน Explorer
- [ ] `SELECT COUNT(*)` คืน 0

## 🛠 Troubleshooting

| อาการ | สาเหตุ | แก้ |
|---|---|---|
| `CREATE SCHEMA` error ซ้ำ | schema มีอยู่แล้วจากรอบก่อน | ข้ามคำสั่งนั้น รันต่อ CREATE TABLE |
| ตารางสร้างแล้วไม่เห็นใน Explorer | หน้าจอยังไม่ refresh | กด Refresh บนทูลบาร์ของ Explorer |
| Run แล้วค้างนาน | capacity ยุ่งช่วงห้องสร้างพร้อมกัน | Stop แล้ว Run ใหม่ |
| สร้าง Warehouse ชื่อซ้ำไม่ได้ | มี item เดิมค้าง (เช่น `SetupTest`) | ลบ item เดิม รอสักครู่ หรือใช้ชื่อใหม่ |

## 🆘 Behind? Catch up

สคริปต์คือทั้งหมดของแล็บนี้ — รันสองคำสั่งใน Step 2 ก็อยู่จุดเดียวกับห้อง ดูเฉลยเพิ่มที่ [`solutions/03-warehouse/SOLUTION.md`](../../solutions/03-warehouse/SOLUTION.md)

## Stretch / ต่อยอด

เขียนตาราง `staging.product` เองด้วยคอลัมน์ 6 ตัว: ProductKey (bigint), EnglishProductName, Color, ModelName, EnglishProductSubcategoryName, EnglishProductCategoryName (varchar) — เทียบกับเฉลยใน `DW/2. Create Staging Product Table.sql` (ไฟล์เดียวกันกับที่ Workshop 4-2 จะใช้)
