# Workshop 8 + 9 + 10 + บททดสอบ 10-1 — รายงาน Power BI จาก Semantic Model

> ⏱ 80 นาที · Start state: Best AdventureworksDW Model พร้อม measures (Workshop 7-1), Power BI Desktop ติดตั้งและล็อกอินด้วยบัญชี Fabric แล้ว

## Goal / เป้าหมาย

- 8: สร้างรายงานแบบ auto-create และบันทึกลง workspace
- 9-10: สร้างรายงานเองใน Desktop ใช้ครบ 6 visuals และ publish กลับเข้า Fabric
- 10-1: ตอบ insights 5 ข้อจากรายงานของตัวเอง — เหมือนคำถามที่ผู้บริหารถามจริง

## Steps — Workshop 8: Auto-create

1. ใน workspace เปิด **Best AdventureworksDW Model** → ทูลบาร์ **Explore → Auto-create report** (ชื่อปุ่มอาจต่างเล็กน้อยตามรุ่น — หาคำว่า create report automatically)

2. รอรายงานถูกประกอบ → **Save** ตั้งชื่อ `Auto Sales Report`

   คุณจะเห็น Power BI report ใหม่ปรากฏต่อจาก model ใน workspace — สังเกตว่า Fabric เลือก visual ให้จากชนิดฟิลด์ (ตัวเลข→bar, เวลา→line) นี่คือจุดเริ่ม ไม่ใช่ผลลัพธ์สุดท้ายของงานรายงานจริง

## Steps — Workshop 9: Desktop ต่อ Fabric

1. เปิด Power BI Desktop → **OneLake data hub** (หรือ Get data → More → Microsoft Fabric) → **Power BI semantic models** → เลือก **Best AdventureworksDW Model** → Connect

2. ตรวจ Fields pane: ตารางและ measures เจ็ดตัวต้องแสดงครบ — ถ้าไม่ครบ ทักทายปัญหาบัญชี (ล็อกอิน Desktop คนละบัญชีกับ Fabric) ก่อนต้องวาดต่อ

## Steps — Workshop 10: สร้างรายงานเอง (หน้า `Sales Overview`)

สร้างหน้าเดียวให้ครบตามลิสต์ ทีละ visual:

1. **New Card — Revenue**: แทรก New card → ลาก measure `Revenue` → Format: ใส่ Image, เปิด Accent bar, จัดรูปซ้าย-ตัวเลขขวา

2. **Table — ยอดขายต่อ Model**: Table → `EnglishProductName` (หรือ ModelName) + `Revenue`

3. **Top 10**: ที่ Table นั้น → Filter pane → Filter type **Top N** → Top 10 → by value = **Revenue** → Apply → ตั้ง General → Title = `Top 10 Models`

   อย่าลืมช่อง by value — เงื่อนไข Top N ต้องมี "อันดับตามอะไร" ครบสองส่วนจึงทำงาน

4. **Clustered column — Revenue ต่อเวลา**: ใส่ hierarchy `Calendar` (Year → Quarter → Month) + `Revenue` → ลอง Drill down จากปี 2014 ลงถึงเดือน แล้ว Drill up กลับ

5. **Map — Revenue ตาม geography**: ใส่ hierarchy ประเทศ→จังหวัด→เมือง + `Revenue` — ถ้า map ว่าง ให้กลับ model ตั้ง Data category ให้คอลัมน์ geography (Country = Country, State = State or Province, City = City)

6. **Slicer — Category**: Slicer ที่ `EnglishProductCategoryName` แบบ Tile

7. ทดสอบ interaction: กด slicer แต่ละ category แล้วทุก visual ต้องเปลี่ยนตาม — นี่คือจุดที่คุณเห็นคุณค่าของ model เดียวรายงานหลายตัว

8. **Publish**: Home → Publish → เลือก **My workspace** → Select → รอจน success

   ผลที่ควรเห็น: report ปรากฏใน workspace คู่กับ model

## บททดสอบ 10-1 — หา Insights

ใช้รายงานที่สร้างตอบ 5 ข้อ (จดคำตอบ แล้วคุยกันท้ายแล็บ):

1. สินค้า Model ใดยอดขายสูงสุดในปี 2014
2. ตามข้อ 1 — เดือนใดมียอดขายสูงสุดในปีนั้น
3. ประเทศใดที่มียอดขายสินค้ากลุ่ม Bike สูงสุด
4. ยอดขายในข้อ 3 เท่าใด (จำนวนเงิน)
5. ตามข้อ 3 — City ใดในประเทศนั้นมียอดขายสูงสุด

เครื่องมือที่ควรใช้: slicer (ปี/category), Top N, drill down ของ map และ column chart — สังเกตว่าทุกคำถามตอบได้จากรายงานเดียว ถ้าคุณต้องออกไปเขียน SQL แปลว่า model หรือ hierarchy ยังขาดชิ้น

## ✅ Checkpoint

- [ ] Auto Sales Report ถูกบันทึกใน workspace
- [ ] Desktop ต่อ model ผ่าน Data hub สำเร็จ (live connection)
- [ ] หน้า Sales Overview ครบ 6 visuals
- [ ] Publish ลง My workspace สำเร็จ
- [ ] ตอบ insights ครบ 5 ข้อ

## 🛠 Troubleshooting

| อาการ | สาเหตุ | แก้ |
|---|---|---|
| Data hub ไม่เห็น model | ล็อกอิน Desktop คนละบัญชี หรือ tenant ผิด | Sign in ใหม่ให้ตรงบัญชี Fabric |
| Map ว่าง | Power BI จับ geography ไม่ได้ | ตั้ง Data category ให้คอลัมน์ หรือใช้ hierarchy ที่สร้างไว้ |
| Drill down ไม่ทำงาน | ยังไม่เปิดโหมด drill | กด icon ลูกศรลงบน visual ก่อนคลิก |
| Top N คืนทุกแถว | ลืมตั้ง by value | ใส่ Revenue แล้วกด Apply |
| เลขไม่ตรงกันระหว่าง visuals | ใช้ field ดิบแทน measure | ใช้ measure `Revenue` เสมอ |
| Publish ไม่เห็น workspace ปลายทาง | Desktop ผูก tenant อื่น | ตรวจ Sign in และ tenant มุมขวาบน |

## 🆘 Behind? Catch up

อย่างน้อยทำ Workshop 8 (auto-create) ให้จบ — ต่อแล็บวันหน้าได้ทันที ส่วน visuals เก็บทีหลังด้วยเฉลย [`solutions/08-reports/SOLUTION.md`](../../solutions/08-reports/SOLUTION.md)

## Stretch / ต่อยอด

สร้างหน้าที่สอง `Profit View` — Card % Margin + column chart % Change รายปี + ตาราง Top 10 ตาม Profit (ไม่ใช่ Revenue) แล้วเทียบสองลิสต์ว่าสลับกันกี่รายการ — คำถามธุรกิจคนละคำถาม ลิสต์ก็คนละลิสต์
