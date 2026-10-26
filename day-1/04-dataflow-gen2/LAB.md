# Workshop 4-1 + 4-2 — Dataflow Gen2 เข้า Warehouse

> ⏱ 70 นาที · Start state: `AdventureworksDW` มี `staging.internetsales` (0 แถว), มี `Link.txt`, มี Warehouse connection ที่ใช้งานได้

## Goal / เป้าหมาย

- 4-1: ได้ dataflow `Get Internet Sales` โหลด CSV จาก Azure Blob ลง `staging.internetsales` 10 คอลัมน์ (Replace)
- 4-2: ได้ dataflow `Get Products` โหลด DimProduct พร้อม expand ความสัมพันธ์สองชั้น ลง `staging.product` 6 คอลัมน์ (Replace)

## Steps — Workshop 4-1: Blob → Warehouse

1. เปิด Warehouse `AdventureworksDW` → ทูลบาร์ **Get data** → **New Dataflow Gen2** → ตั้งชื่อ **`Get Internet Sales`** ทันที

   คุณจะเข้าหน้า Power Query พร้อม query ว่าง — ตั้งชื่อตอนนี้เลย อย่ารอ เพราะชื่อซ้ำไม่ได้และชื่อที่เพิ่งลบจะค้างอยู่ช่วงหนึ่งถึงสองนาที

2. ใน dataflow: **Get data → More** → ค้นหา `blob` → เลือก **Azure Blobs**

3. หน้า Connect to data source: กรอก Account name และ Access Key จาก `Link.txt` → ตั้งชื่อ connection (เช่น `blob-course`) → Next

   คุณจะเห็นโฟลเดอร์ข้อมูลของหลักสูตรโผล่ให้เลือก — ตั้งชื่อ connection ตอนนี้เพราะทุก workshop ถัดไปจะใช้มันซ้ำผ่าน Use existing

4. เลือกโฟลเดอร์ `Internetsales` → **Create** → กลับมาที่ Power Query กด **Combine files**

   Power Query จะหยิบไฟล์หนึ่งเป็นตัวอย่าง เดาชื่อคอลัมน์ ตัวคั่น encoding และชนิดข้อมูล — ตรวจ preview ว่าแถวมีข้อมูลจริงและคอลัมน์ชื่อครบ ถ้า preview ดูแปลก (แถวแรกกลายเป็นชื่อคอลัมน์ซ้อนอยู่ในข้อมูล) แปลว่าตัวตรวจจับ header เพี้ยน ให้ลบ query สร้างใหม่แล้วเลือกไฟล์ตัวอย่างที่ครบ

5. บนทูลบาร์เลือก **Choose columns** — เหลือเฉพาะ 10 คอลัมน์ตามลิสต์นี้:

   `ProductKey, OrderDateKey, CustomerKey, OrderQuantity, UnitPrice, UnitPriceDiscountPct, DiscountAmount, TotalProductCost, SalesAmount, TaxAmt`

6. Data destination: กด **+** → **Warehouse** → เลือกตาราง `staging.internetsales` + โหมด **Replace** → Save settings

7. **Publish** → รอจน refresh succeeded (ดูสถานะจากหน้า dataflow ใน workspace)

8. ตรวจผลทาง SQL — กลับที่ Warehouse กด New SQL query:

   ```sql
   SELECT COUNT(*) AS rows_loaded, MIN(SalesAmount) AS min_amt, MAX(SalesAmount) AS max_amt
   FROM staging.internetsales;
   ```

   ผลที่ควรเห็น: แถวมากกว่า 0 (จำนวนจริงตาม dataset ของห้อง — เทียบกับตัวเลขที่ผู้สอนประกาศ) และจำนวนคอลัมน์เป๊ะ 10 ถ้า publish ซ้ำอีกรอบ COUNT ต้องเท่าเดิมเพราะ Replace

## Steps — Workshop 4-2: Azure SQL → Warehouse

1. เตรียมปลายทางก่อน: New SQL query → รันไฟล์ `DW/2. Create Staging Product Table.sql` (สร้าง `staging.product` 6 คอลัมน์)

2. Get data → New Dataflow Gen2 → ตั้งชื่อ **`Get Products`**

3. Get data → More → **Azure SQL Database** → Server/Database/User/Password จาก `Link.txt` (Database: `AdventureworksDW`) → Next

4. Choose data: ค้นหา `Dim` → เลือก **DimProduct** เพียงตารางเดียว → Create

5. ใน Power Query — expand สองชั้น:

   - ที่ column ที่เป็น relationship ไปยัง DimProductSubcategory: กด expand icon → เลือกเอา `EnglishProductSubcategoryName`
   - คอลัมน์ relationship จะยังค้างอยู่ — expand ต่ออีกชั้นเข้า DimProductCategory เอา `EnglishProductCategoryName`

   สังเกตว่าคุณเพิ่งได้ชื่อหมวดหมู่สินค้าจากอีกสองตารางโดยไม่เขียน JOIN แม้แต่บรรทัดเดียว — นี่คือความคุ้มค่าของ expand บน relational source

6. Choose columns เหลือ 6 คอลัมน์:

   `ProductKey, EnglishProductName, Color, ModelName, EnglishProductSubcategoryName, EnglishProductCategoryName`

7. Data destination: Warehouse → ตาราง `staging.product` → **Replace** → Save → **Publish**

8. ตรวจ:

   ```sql
   SELECT TOP 10 * FROM staging.product;
   SELECT COUNT(*) FROM staging.product WHERE EnglishProductCategoryName IS NULL;
   ```

   ผลที่ควรเห็น: แถวสินค้าแสดง subcategory/category ครบ และค่า NULL ที่เหลือบ้างเป็นเรื่องปกติ — มันคือของสกปรกตัวจริงที่ Workshop 6-2 จะใช้ stored procedure ทำความสะอาดต่อ

## ✅ Checkpoint

- [ ] workspace มี dataflow `Get Internet Sales` และ `Get Products` สถานะ succeeded
- [ ] `staging.internetsales` มีข้อมูล (COUNT > 0) และ publish ซ้ำไม่ทำให้ COUNT โต
- [ ] `staging.product` ครบ 6 คอลัมน์และเห็น category
- [ ] ใช้ connection เดียวกันตลอด (Blob หนึ่ง SQL หนึ่ง) — ไม่มี connection ซ้ำชื่อไม่มีชื่อ

## 🛠 Troubleshooting

| อาการ | สาเหตุ | แก้ |
|---|---|---|
| Connect Blob ไม่ผ่าน | Access Key ผิด/ติดช่องว่าง/ขึ้นบรรทัด | คัดลอกใหม่ทั้งบรรทัดจาก Link.txt |
| ชื่อ dataflow ตั้งซ้ำ | เคยสร้างชื่อนี้ไว้ (แม้ลบแล้ว) | ใช้ชื่อใหม่ชั่วคราว รอ 1–2 นาทีค่อยกลับมาเปลี่ยนเป็นชื่อจริง |
| Publish แล้ว refresh failed | คอลัมน์ไม่ match กับตารางปลายทาง | เปิดรายละเอียด error แล้วกลับไปตรวจ Choose columns ให้ครบตามลิสต์ |
| COUNT โตขึ้นทุกครั้งที่ publish | destination เป็น Append | เปิด dataflow → แก้ destination settings เป็น Replace → publish ใหม่ |
| preview แถวแรกเป็นชื่อคอลัมน์ | Combine files เดา header เพี้ยน | ลบ query สร้างใหม่ เลือกไฟล์ตัวอย่างที่ header ครบ |

## 🆘 Behind? Catch up

ดูผลอ้างอิงที่ [`solutions/04-dataflows/SOLUTION.md`](../../solutions/04-dataflows/SOLUTION.md) แล้วรัน SQL ตรวจว่าอยู่จุดเดียวกับห้อง

## Stretch / ต่อยอด

สร้าง dataflow `Get Customers` เองตามโจทย์โมดูล 05 — นี่คือบททดสอบ ตามไปดูที่ `day-1/05-test-dimcustomer/`
