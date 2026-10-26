# Module 07 — Semantic Model: ชั้นความหมายของข้อมูล และ DAX

> ⏱ ~50 นาที · 🎯 สร้าง semantic model ของตัวเอง ตั้ง relationship, hierarchy, sort และเขียน measures พื้นฐานถึง Time Intelligence · The semantic model is where business meaning lives — measures, not raw tables.

## Key idea / แนวคิดหลัก — เล่าเรื่อง

ตารางที่โหลดเข้า Warehouse รู้เรื่องตัวเองแค่ "ข้อมูล" — มันไม่รู้ว่า `SalesAmount` คือยอดขาย, ไม่รู้ว่า `staging.internetsales` ต้องจับมือกับ `DimDate` ที่แถวไหน, และไม่รู้ว่า "กำไร" หมายถึงอะไร **Semantic model** คือชั้นความหมายที่คุณปั้นเพิ่มเข้าไป: ประกาศว่าตารางไหนต่อกันด้วย key ไหน (relationship), ระดับชั้นเวลาไล่ยังไง (hierarchy), และคำศัพท์ธุรกิจอย่าง "ยอดขาย กำไร อัตรากำไร" คำนวณยังไง (measure) — ภาษาที่ใช้เขียน measure เรียกว่า **DAX** (Data Analysis Expressions)

ถ้าคุณเคยใช้ Power BI มาก่อน อาจเคยรู้จักสิ่งนี้ในชื่อ Power BI Data Model หรือ Tabular Model — บน Fabric มันคือ item ชนิดหนึ่งที่อยู่ใน workspace แยกออกมาให้เห็นชัด และนี่คือจุดที่ต้องอัปเดตความเข้าใจ: ในอดีต Fabric เคยสร้าง "default semantic model" ให้อัตโนมัติพร้อม Warehouse แต่**ระบบนั้นถูกยกเลิกไปแล้วทั้งกระบวนการ** (ตั้งแต่ปลายปี 2025 — ไม่สร้างอัตโนมัติแล้ว ตัวเดิมที่เคยมีถูกแปลงเป็น model ปกติ) วิธีทำงานวันนี้จึงเป็น "สร้างเองอย่างมีเจตนา" ด้วยปุ่ม **New semantic model** — เลือกตารางที่จะให้อยู่ใน model, ตั้งชื่อที่สื่อความหมาย แล้วจัดการทุกอย่างใน model explorer ซึ่งจริง ๆ แล้วดีกว่า เพราะ model ที่ดีต้องถูกออกแบบเพื่อคำถามของธุรกิจ ไม่ใช่รวมทุกตารางที่มี

งานของโมดูลนี้คือสร้าง model ชื่อ **Best AdventureworksDW Model** จากวิว `dw.vwFactInternetSales` (view ที่ตัดแถว key ว่างออกตั้งแต่ SQL ก่อนถึง model — ทำความสะอาดตั้งแต่ปลายน้ำสูงสุด) ผูก relationship สามเส้น ตั้ง hierarchy ปฏิทิน แล้วเขียน measures เจ็ดตัวที่ไล่ระดับจากง่ายไป Time Intelligence

> EN: Relationships define how tables talk; measures define what the talk means — and today you build the model on purpose, not by default.

## Concept / เนื้อหา

- **สร้าง model**: Warehouse → New semantic model → ตั้งชื่อ → เลือก objects (ตาราง/วิว) ที่จะให้ปรากฏ — เลือกน้อยที่แต่ใช้จริงดีกว่าเอาทุกอย่าง
- **Model explorer**: ที่นี่คุณจัด relationship, สร้าง attribute hierarchy, ซ่อน columns ที่ไม่ใช้กับ BI (เช่น key columns), และตั้ง Sort by column — สี่งานนี้ทำตอนเดียวจบ
- **Mark as date table** — กำหนดให้ Fabric รู้ว่าตารางไหนคือ "ปฏิทิน" พร้อมคอลัมน์ date หลัก โดยเงื่อนไขคือคอลัมน์นั้นต้องเป็นชนิด date/datetime และมีค่าไม่ซ้ำไม่ว่าง เงื่อนไขนี้จะกลับมาหลอกคุณอีกครั้งในวันที่สอง (ตาราง DimDate ฝั่ง Lakehouse)
- **DAX syntax** — `Total Sales = SUM( Sales[NetSales] )`: ชื่อ measure ก่อนเครื่องหมาย `=` ฟังก์ชันตามด้วย arguments ที่อ้างคอลัมน์แบบ `'Table'[Column]` เสมอ ส่วนการอ้าง measure อื่นใช้ `[MeasureName]` อย่างเดียว — สองรูปแบบนี้แยกกันเด็ดขาด
- **Measures ของหลักสูตร** (อยู่ใน `DW/Measure.txt`):

  ```dax
  Revenue = SUM( FactInternetSales[SalesAmount] )
  Cost = SUM( FactInternetSales[TotalProductCost] )
  Profit = [Revenue] - [Cost]
  % Margin = DIVIDE( [Profit], [Revenue] )
  YTD Revenue = TOTALYTD( [Revenue], 'dw.DimDate'[FullDateAlternateKey] )
  Last Year Revenue =
      CALCULATE(
          [Revenue],
          SAMEPERIODLASTYEAR('dw.DimDate'[FullDateAlternateKey])
      )
  % Change = DIVIDE( [Revenue] - [Last Year Revenue], [Last Year Revenue] )
  ```

  สังเกตเทคนิคสองจุด: ใช้ `DIVIDE` แทนเครื่องหมายหาร (กันหารศูนย์พังรายงาน) และ `CALCULATE` + `SAMEPERIODLASTYEAR` ซึ่งจะทำงานถูกก็ต่อเมื่อ Mark as date table เรียบร้อยแล้วเท่านั้น

## ลงมือทำตามลำดับ

1. เตรียม Fact view ก่อนถ้ายังไม่มี — รันไฟล์ `DW/Create View Fact InternetSales.sql` (มันคือ `staging.internetsales` ที่ตัดแถว key ว่างออก)
2. แล็บ: [LAB.md](LAB.md) — Workshop 7-1 สร้าง model ครบวงจรจนได้ measures เจ็ดตัวทำงานจริง

## Common pitfalls / กับดัก

- ลืม Mark as date table ก่อนใช้ Time Intelligence — สูตรไม่ error แต่เลขผิด ซึ่งอันตรายกว่า error อีก เพราะใครก็เชื่อตัวเลขที่ดูน่าใช้
- อ้างคอลัมน์แบบ `[Column]` เฉย ๆ — DAX จะเข้าใจว่าคุณอ้าง measure ชื่อนั้น แล้วหาไม่เจอ
- เลือก object เกินจำเป็นตอนสร้าง model — model บวมโดยไม่จำเป็น ใช้ Remove ตัดตารางที่ไม่เกี่ยวออก
- DIVIDE ด้วยเครื่องหมายหารธรรมดา — รายงานพังทันทีที่เจอหารศูนย์
- ยังคิดแบบ "default model จะวิ่งมาหาเอง" — ยุคนั้นจบแล้ว ความคุ้นเคยกับการสร้าง model เองคือทักษะหลักของงานจริงวันนี้

## Quick check / ทบทวน

<details>
<summary>1. Mark as date table ไว้ทำอะไร</summary>
ประกาศว่าตาราง/คอลัมน์ไหนคือปฏิทิน เพื่อให้ Time Intelligence (TOTALYTD, SAMEPERIODLASTYEAR) คำนวณถูกต้อง
</details>

<details>
<summary>2. [Revenue] กับ FactInternetSales[SalesAmount] ต่างกันยังไง</summary>
[Revenue] คือ measure ที่นิยามไว้แล้ว ส่วน 'Table'[Column] คือการอ้างคอลัมน์ดิบ
</details>

<details>
<summary>3. ทำไมต้องสร้าง model เองแทนที่จะพึ่งระบบสร้างให้</summary>
Fabric ยกเลิก default semantic models ไปแล้ว — และ model ที่ดีต้องถูกออกแบบเฉพาะคำถามธุรกิจ ไม่ใช่รวมทุกตารางโดยอัตโนมัติ
</details>

## Go deeper

- [DAX reference](https://learn.microsoft.com/en-us/dax/)
- [Power BI semantic models in Fabric DW](https://learn.microsoft.com/en-us/fabric/data-warehouse/semantic-models)
- [Manage a semantic model](https://learn.microsoft.com/en-us/fabric/data-warehouse/manage-semantic-model)
- [Sunsetting default semantic models (ประกาศอย่างเป็นทางการ)](https://community.fabric.microsoft.com/blog/fbc_fabricupdatesblogs/sunsetting-default-semantic-models---microsoft-fabric/5172667)
