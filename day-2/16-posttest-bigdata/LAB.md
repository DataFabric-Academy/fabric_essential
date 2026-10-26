# บททดสอบ 17 (Posttest) — Lakehouse Semantic Model + Report

> ⏱ 40 นาที · Start state: ผลลัพธ์ทุกโมดูลวันที่ 2 (FactResellerSales, manage_DimReseller, shortcuts DimDate/DimProduct) และไฟล์ `LH/Measure.txt`

## Goal / เป้าหมาย

1. Semantic model บน Lakehouse ใช้งานได้จริง — relationship ถูกต้อง, hierarchies เหมาะสม, measures ตาม `LH/Measure.txt`
2. รายงานสองแบบ: auto-create และ custom report ที่ใช้ attributes/measures อื่นนอกเหนือจากที่ auto-create ให้

## Steps / ขั้นตอน

1. เลือก model ที่จะส่ง — สร้าง New semantic model จาก SQL analytics endpoint ต่อจาก Workshop 16 (หรือปรับตัวที่ทำไว้แล้วให้สมบูรณ์)

2. ตรวจ relationship ครบสามเส้น:

   ```text
   FactResellerSales[OrderDateKey] → DimDate[DateKey]
   FactResellerSales[ResellerKey]  → manage_DimReseller[ResellerKey]
   FactResellerSales[ProductKey]   → DimProduct[ProductKey]
   ```

3. Attribute hierarchies ที่เหมาะสม — อย่างน้อย: DimDate (Calendar: Year → Quarter → Month) และ DimProduct (Category → Subcategory → Product)

4. สร้าง measures จากไฟล์ `LH/Measure.txt` (ฝั่ง reseller — ปรับชื่อตารางในสูตรให้ตรงชื่อจริงใน model ของคุณ):

   ```dax
   Revenue = SUM(FactResellerSales[SalesAmount])
   Cost = SUM(FactResellerSales[TotalProductCost])
   Profit = [Revenue] - [Cost]
   Margin = [Profit]/[Revenue]
   Total Orders = SUM(FactResellerSales[OrderQuantity])
   Previous Year Revenue =
       CALCULATE(
           [Revenue],
           SAMEPERIODLASTYEAR('DimDate'[FullDateAlternateKey])
       )
   ```

   หมายเหตุ: measure ที่เกี่ยวกับ Time Intelligence ทำงานได้เมื่อ Mark as date table เรียบร้อย — ถ้ายังติดปม อธิบายเหตุผลไว้ในงานก็ได้คะแนนโบนัส

5. Auto-create: จาก model → Explore → auto-create report → Save ชื่อ `Posttest Auto Report`

6. Custom report: สร้างรายงานใหม่จาก model เดียวกัน มีอย่างน้อย:

   - ตาราง/visual บน attributes ที่ auto-create ไม่ได้วางให้ (เช่น ResellerName ต่อ Province ผ่าน hierarchy ที่คุณสร้าง)
   - measure ที่คุณสร้างเองอย่างน้อยหนึ่งตัว (นอกจากที่ Measure.txt มี เช่น Revenue per Quantity)

7. ส่งงาน: เว้น workspace ไว้ตรวจร่วมกัน — item ที่ต้องมี:

   ```text
   - semantic model ที่แก้/สร้าง
   - Posttest Auto Report
   - custom report ของคุณ
   ```

## เกณฑ์ตรวจ (ผู้ตรวจใช้)

- [ ] relationship สามเส้นถูกต้องทั้งเส้นทางและคาร์ดินาลิตี้
- [ ] hierarchy อย่างน้อยสองชุดและใช้ drill ได้จริงในรายงาน
- [ ] measures ครบตาม Measure.txt
- [ ] มีรายงานทั้งสองแบบ และ custom ใช้ attribute/measure ที่ auto-create ไม่มี
- [ ] (โบนัส) อธิบายปม Mark as date table ของ DimDate ได้

## 🛠 Troubleshooting

| อาการ | สาเหตุ | แก้ |
|---|---|---|
| measures error หาตารางไม่เจอ | ชื่อ fact ใน Measure.txt ไม่ตรง model | ปรับชื่อตารางในสูตรให้ตรง model ของคุณ |
| hierarchy ไม่ยอม drill | ลำดับ level ผิด | Year → Quarter → Month ตามลำดับชั้นจริงของข้อมูล |
| auto-create แล้ว visual ว่าง | เลือก model ผิดตัว | ตรวจว่า auto-create จาก model ที่ส่ง |
| ไม่เห็นตาราง shortcut ใน model | ยังไม่เลือกตารางใน model | กลับไปเลือกตารางที่ model |

## 🆘 Behind? Catch up

ทำให้ได้รายงาน auto-create ก่อน — เกณฑ์หลักอยู่ที่ model เสริมจาก [`solutions/16-posttest/SOLUTION.md`](../../solutions/16-posttest/SOLUTION.md)

## Stretch / ต่อยอด

เหมือนหน้างานจริง: เพิ่ม measure `Revenue LY` ฝั่ง reseller แล้วพูด 30 วินาทีว่าทำไม Time Intelligence ต้องรอ Mark as date table ก่อน — คำอธิบายนี้คือหลักฐานว่าคุณเข้าใจ lineage ของตาราง ไม่ใช่แค่กดปุ่ม
