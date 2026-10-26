# Workshop 15 — Dataflow Gen2 → Lakehouse (FactResellerSales)

> ⏱ 30 นาที · Start state: Lakehouse `AdventureworksLH` พร้อม shortcuts (โมดูล 13), Blob connection จากวันแรกยังใช้ได้

## Goal / เป้าหมาย

ได้ dataflow `Get Reseller Sales` เขียนลง Delta table `FactResellerSales` (New Table, Replace) ใน `AdventureworksLH` — และตรวจว่ามันเข้าร่วม star schema กับของที่มีอยู่ได้จริง

## Steps / ขั้นตอน

1. เปิด **Lakehouse** `AdventureworksLH` → ทูลบาร์ **Get data → New Dataflow Gen2** → ตั้งชื่อ **`Get Reseller Sales`** ทันที

2. Get data → More → **Azure Blobs** → เลือก **Use existing connection** (connection `blob-course` ที่ตั้งไว้วันแรก)

3. เลือกโฟลเดอร์ `resellersales` → Create

4. Power Query: **Combine files** → เลือกไฟล์ตัวอย่างให้ตรวจ → OK

   ตรวจ preview: ชื่อคอลัมน์ครบและข้อมูลวิ่งถูกแถว — ถ้าเพี้ยน ลบ query สร้างใหม่พร้อมเลือกไฟล์ตัวอย่างที่ header ครบ

5. **Choose columns** เหลือ 10 คอลัมน์:

   `ProductKey, OrderDateKey, ResellerKey, OrderQuantity, UnitPrice, UnitPriceDiscountPct, DiscountAmount, TotalProductCost, SalesAmount, TaxAmt`

6. Data destination: กด **+** → **Lakehouse** → Settings → Lakehouse `AdventureworksLH` ถูกเลือกอยู่แล้ว → Next

7. Choose destination target: **New Table** → ตั้งชื่อ **`FactResellerSales`** → Next

8. Destination settings: **Replace** → Save settings → กลับมา **Publish** → ปิด Power Query

9. รอ refresh succeeded แล้วกลับ Lakehouse Explorer กด **Refresh**

   ผลที่ควรเห็น: `FactResellerSales` อยู่ใน Tables — ที่จริงมันเป็น Delta table คู่กับที่ notebook เขียนเองเมื่อเช้า

10. ตรวจทาง SQL endpoint:

    ```sql
    SELECT COUNT(*) AS rows_total, SUM(SalesAmount) AS total_sales
    FROM FactResellerSales;
    ```

    จดตัวเลขสองค่านี้ไว้ — publish ซ้ำควรได้เลขเดิม (Replace) และเทียบกับที่ผู้สอนประกาศ

11. เตรียมโมดูลถัดไป — คิวรี่ที่จะกลายเป็น star schema:

    ```sql
    SELECT TOP 5 f.SalesAmount, d.EnglishMonthName, r.ResellerName
    FROM FactResellerSales f
    JOIN DimDate d ON f.OrderDateKey = d.DateKey
    JOIN manage_DimReseller r ON f.ResellerKey = r.ResellerKey;
    ```

    ผลที่ควรเห็น: คิวรี่ผ่าน — fact อยู่ที่ Lakehouse (จาก Dataflow), DimDate ผ่าน shortcut (จาก Warehouse), DimReseller เป็น managed table ของคุณ (จาก notebook) — สามทางมาจุดบรรจบเดียว

## ✅ Checkpoint

- [ ] dataflow `Get Reseller Sales` succeeded
- [ ] `FactResellerSales` มี 10 คอลัมน์ใน Tables
- [ ] COUNT > 0 และ publish ซ้ำไม่ทำให้จำนวนโต (Replace)
- [ ] คิวรี่ join สามทางผ่าน

## 🛠 Troubleshooting

| อาการ | สาเหตุ | แก้ |
|---|---|---|
| Connection ให้สร้างใหม่ | เลือก Create new โดยไม่เห็นตัวเก่า | ค้นชื่อ connection ที่เคยตั้ง |
| New Table ชนชื่อเดิม | เคย Load to Tables ในโมดูล 11 | ลบตัวเก่าหรือใช้ชื่อเดียวกันทั้งห้อง |
| refresh failed หา columns ไม่เจอ | Combine รอบแรกเพี้ยนชนิดข้อมูล | ลบ query สร้างใหม่ เลือกไฟล์ตัวอย่างที่ครบ header |
| publish ซ้ำแล้วข้อมูลซ้อน | destination เป็น Append | แก้ settings เป็น Replace → publish ใหม่ |
| SQL endpoint ยังไม่เห็นตาราง | metadata sync ยังไม่เสร็จ | รอ 1–2 นาที กด Refresh ที่ endpoint |

## 🆘 Behind? Catch up

อย่างน้อยให้ `FactResellerSales` มีอยู่ใน Tables ก่อนโมดูลถัดไป — ดูเฉลย [`solutions/14-dataflow-lakehouse/SOLUTION.md`](../../solutions/14-dataflow-lakehouse/SOLUTION.md)

## Stretch / ต่อยอด

เพิ่ม step ใน Power Query: filter `OrderDateKey >= 20200101` แล้ว publish — เทียบ COUNT กับเพื่อนรอบข้างว่าต่างกันเท่าไร แล้วตอบว่า Replace ช่วยอะไรตรงนี้
