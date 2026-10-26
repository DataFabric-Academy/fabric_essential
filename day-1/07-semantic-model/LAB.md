# Workshop 7-1 — สร้าง Semantic Model ของตัวเอง

> ⏱ 40 นาที · Start state: `dw.DimDate`, `dw.DimProduct`, `dw.DimCustomer`, และ view `dw.vwFactInternetSales` พร้อมข้อมูล (จาก Workshop 3, 5, 6)

## Goal / เป้าหมาย

ได้ semantic model **Best AdventureworksDW Model** มี relationship ครบสามเส้น, DimDate ถูก mark เป็น date table, และ measures ครบเจ็ดตัวทำงานได้จริง

## Steps / ขั้นตอน

1. เตรียม Fact view (ถ้ายังไม่มี): New SQL query → รันไฟล์ `DW/Create View Fact InternetSales.sql`

   ```sql
   CREATE VIEW dw.vwFactInternetSales AS
   SELECT * FROM staging.internetsales
   WHERE CustomerKey IS NOT NULL AND ProductKey IS NOT NULL AND OrderDateKey IS NOT NULL;
   ```

   เหตุผลที่ใช้ view: แถวที่ key ว่างคือขยะจากขั้นตอน load พวกมันต้องไม่เข้า model ไม่งั้น relationship จะมีแถว "ลอย" ที่จับคู่ไม่ได้

2. สร้าง model: เปิด Warehouse → **New semantic model** → ตั้งชื่อ **Best AdventureworksDW Model** → เลือก objects: `dw.vwFactInternetSales`, `dw.DimDate`, `dw.DimProduct`, `dw.DimCustomer` → Confirm

   อย่าเลือกตาราง staging — model นี้คือโลกของของสะอาด

3. ตั้ง relationship ที่ Model explorer → Relationships — ตรวจ/สร้างสามเส้น:

   - `vwFactInternetSales[ProductKey] → DimProduct[ProductKey]` (many to one)
   - `vwFactInternetSales[CustomerKey] → DimCustomer[CustomerKey]`
   - `vwFactInternetSales[OrderDateKey] → DimDate[DateKey]`

   ถ้า Fabric จับคู่ให้อัตโนมัติตั้งแต่สร้าง (บาง tenant ทำให้) ตรวจชื่อ key ทั้งสามเส้นให้แน่ใจว่าถูกตัว

4. Hierarchy + Sort by column (ที่ DimDate):

   - สร้าง hierarchy ชื่อ `Calendar`: YearName → QuarterName → EnglishMonthName
   - Sort by column: `EnglishMonthName` เรียงตาม `MonthNumberOfYear`, `QuarterName` เรียงตามเลข quarter

   เหตุผล: ถ้าไม่ sort มกราคมจะไปยืนต่อจากพฤศจิกายนเพราะตัวอักษร A มาก่อน J — ผิดทางของโลกปฏิทิน

5. Mark as date table: เลือก `DimDate` → กำหนด date column = `FullDateAlternateKey`

   ถ้าปุ่มล้มเหลว อ่านข้อความ error — เงื่อนไขคือคอลัมน์ต้องเป็น date/datetime และไม่ซ้ำไม่ว่าง ตรวจด้วย:

   ```sql
   SELECT COUNT(*), COUNT(DISTINCT FullDateAlternateKey) FROM dw.DimDate;
   ```

   สองเลขต้องเท่ากัน

6. สร้าง measures เจ็ดตัว: copy จาก `DW/Measure.txt` ทีละตัว (Revenue, Cost, Profit, Margin, YTD Revenue, Last Year Revenue, % Change) — ระวังชื่อตารางในสูตรให้ตรงกับชื่อจริงใน model ของคุณ

   ผลที่ควรเห็น: ทุก measure ไม่มีเครื่องหมายเตือนใน formula bar

7. ทดสอบเร็วด้วย measure ชั่วคราว:

   ```dax
   TestRows = COUNTROWS(vwFactInternetSales)
   ```

   เทียบกับ `SELECT COUNT(*) FROM dw.vwFactInternetSales;` ใน Warehouse — ต้องเท่ากัน แล้วลบ measure ชั่วคราวทิ้ง

8. ตรวจท้ายงาน: ใน workspace ต้องเห็น **Best AdventureworksDW Model** — model นี้คือของที่จะต่อเนื่องไปทั้งบ่ายวันนี้และเป็นแบบเทียบให้วันที่สอง

## ✅ Checkpoint

- [ ] model สร้างจาก 4 objects ครบ (ไม่มี staging ปน)
- [ ] relationship สามเส้นครบ ผูก key ถูกตัว
- [ ] hierarchy Calendar + sort by column ทำแล้ว (เดือนเรียงถูก)
- [ ] Mark as date table สำเร็จบน DimDate
- [ ] measures ครบเจ็ดตัว ไม่มี error
- [ ] TestRows ตรงกับ SQL แล้วลบทิ้ง

## 🛠 Troubleshooting

| อาการ | สาเหตุ | แก้ |
|---|---|---|
| Mark as date table เทา/ล้มเหลว | คอลัมน์ date ไม่ใช่ชนิด date/datetime หรือมีค่าซ้ำ/ว่าง | ตรวจ COUNT vs COUNT DISTINCT ด้านบน แล้วกลับไปแก้ที่ตารางต้นทาง |
| YTD ให้ค่าแปลก | ยังไม่ mark date table หรือ sort เพี้ยน | ทำขั้น 4–5 ก่อนแล้วทดสอบใหม่ |
| relationship ผูกไม่ได้ | ชนิดข้อมูล key ไม่ตรง (int กับ varchar) | กลับไปแก้ที่ตาราง staging/CTAS ให้ชนิดตรง แล้ว refresh model |
| measures error อ้างตารางหาไม่เจอ | ชื่อตารางใน model ต่างจากสูตร (วิวชื่อ vwFactInternetSales) | เปิด Model explorer ดูชื่อจริง แล้วแก้สูตรให้ตรง |

## 🆘 Behind? Catch up

เฉลยและคิวรีตรวจที่ [`solutions/07-semantic-model/SOLUTION.md`](../../solutions/07-semantic-model/SOLUTION.md)

## Stretch / ต่อยอด

เพิ่ม measure `Margin LY` ด้วยตัวเอง: CALCULATE ของ Margin เมื่อปีก่อน (ใช้ SAMEPERIODLASTYEAR ตามรูปแบบ Last Year Revenue) — ถ้าทำได้ คุณเขียน Time Intelligence ได้แล้วจริง
