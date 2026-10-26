# Module 08 — Power BI Report: จาก model สู่รายงาน

> ⏱ ~90 นาที · 🎯 สร้างรายงานได้สองแนวทาง (auto-create และสร้างเองใน Desktop) ใช้ visuals หลักครบและ publish กลับเข้า Fabric · The report is the last mile — model does the math, visuals do the storytelling.

## Key idea / แนวคิดหลัก — เล่าเรื่อง

คุณมี semantic model ที่คำนวณกำไร อัตรากำไร และเทียบปีก่อนได้แล้ว — แต่มันคือของที่อยู่แค่ใน workspace คนทำข้อมูลเท่านั้นที่เห็น ของชิ้นถัดไปที่คนธุรกิจจะแตะจริงคือ**รายงาน** และหลักสูตรนี้จะพาไปสองแนวทาง เพื่อให้คุณเลือกได้ว่าเมื่อไหร่ใช้ทางไหน

แนวทางแรกคือ **auto-create**: จาก model เดียวกัน กดให้ Fabric ประกอบรายงานให้อัตโนมัติ — มันอ่าน schema, เลือก visuals ที่เหมาะกับฟิลด์, วาง layout ให้พร้อมใช้ภายในไม่กี่สิบวินาที แนวทางนี้ดีที่สุดในสองสถานการณ์: เวลาคุณอยาก "ชำระตา" ข้อมูลชุดใหม่เร็ว ๆ ก่อนตัดสินใจว่าควรวาดอะไร และเวลาคุณทำแล็บตามไม่ทันและต้องมีรายงานส่ง

แนวทางที่สองคือ **สร้างเองใน Power BI Desktop** — เปิด Desktop เชื่อมเข้า model ของ Fabric ผ่าน **Data hub** (หน้ารวม semantic models ที่คุณเห็นวันแรก) แล้ววาด visuals เองทีละชิ้น Desktop ให้ควบคุมเต็มที่: การจัดรูปแบบ, filters ซับซ้อน, interaction ระหว่าง visual — เวลาจะสร้างงานที่คนใช้จริงดูทุกวัน ทางนี้คือทางจริง

หนึ่งประเด็นที่หลายคนพลาด: รายงานที่ทำใน Desktop ไม่ได้ "อยู่ในเครื่องคุณ" มันถูก **publish กลับเข้า workspace ของ Fabric** ที่ model อาศัยอยู่ — จบเรื่องด้วยสถาปัตยกรรมที่สวยงาม: model หนึ่งตัว รายงานได้หลายตัว ทุกตัวอ่านตัวเลขจากแหล่งเดียวกัน

บทสรุปของโมดูลคือบททดสอบสืบเสาะ: คุณจะใช้รายงานที่สร้างเองเพื่อหาคำตอบธุรกิจ 5 ข้อ — สินค้าตัวไหนขายดีสุดปี 2014, เดือนไหนสูงสุด, ประเทศไหนที่กลุ่ม Bike แข็งแรงสุด — คำถามแบบที่คนบริหารถามจริง และที่ model ที่คุณสร้างทั้งวันพร้อมตอบอยู่แล้ว

> EN: Auto-create for speed, Desktop for control — both read the same semantic model.

## Concept / เนื้อหา

Visuals ที่หลักสูตรใช้ — แต่ละตัวมี "จุดพลาด" ประจำตัว:

| Visual | ใช้เมื่อ | จุดตั้งค่าที่สอน | จุดพลาด |
|---|---|---|---|
| New Card | แสดงค่าเดียว (เช่น Margin) | ใส่ image, accent bar, รูปซ้าย-เลขขวา | ลืมว่าควรใช้ measure ไม่ใช่คอลัมน์ดิบ |
| Table | รายละเอียดต่อแถว (ยอดขายต่อ Model) | เลือกฟิลด์ + aggregation | ไม่ sort ก่อนเสนอผู้บริหาร |
| Top N filter | Top 10 สินค้าขายดี | Filter type = Top N, by value = Revenue | ลืมช่อง by value → filter ไม่ทำงานเงียบ ๆ |
| Clustered column | ยอดขายรายปี/ไตรมาส/เดือน | ใช้ date hierarchy + drill down/up | ยังไม่เปิดโหมด drill ก่อนคลิกแท่ง |
| Map | ยอดขายตามประเทศ/จังหวัด/เมือง | geography hierarchy + Revenue | Power BI จับ geography ไม่ได้ถ้าไม่ตั้ง Data category |
| Slicer | กรองทั้งหน้า | Slicer settings = Tile | ลืมว่า slicer กระทบเฉพาะหน้าตัวเอง |

ส่วนการต่อเชื่อม: ใน Desktop ให้ไปที่ **Data hub** → Power BI semantic models → เลือก model → Connect การเชื่อมแบบนี้เป็น live connection — Desktop ของคุณไม่มีข้อมูลคัดลอกมาเก็บ มันแค่เป็นหน้าจอวาดที่อ่าน model จาก Fabric

## ลงมือทำตามลำดับ

ตาม [LAB.md](LAB.md) — Workshop 8 (auto-create) → Workshop 9-10 (Desktop + visuals) → บททดสอบ 10-1 (หา insights 5 ข้อ)

## Common pitfalls / กับดัก

- Publish เข้า workspace ผิด — ต้องเลือก My workspace ที่ model อาศัยอยู่ ถ้าปลายทางผิด รายงานจะไม่เห็น model
- Map ว่าง — คอลัมน์ geography ไม่ถูกรู้จำ ให้ตั้ง Data category ให้คอลัมน์ (Country/State/City) และใช้ hierarchy ที่สร้างไว้ใน model
- Drill down กดแล้วไม่ลงลึก — ต้องเปิดโหมด drill (icon ลูกศรลงบน visual) ก่อนคลิกแท่ง
- Top N ไม่ทำงาน — เงื่อนไขต้องครบสองส่วน: จำนวนอันดับ และ by value
- ใช้ field ดิบแทน measure — ตัวเลขใน visual จะต่างจาก measure ที่นิยามไว้ (เช่น SUM ของ SalesAmount ที่ไม่ผ่าน view กรอง key ว่าง) ยึด measure เสมอ

## Quick check / ทบทวน

<details>
<summary>1. Auto-create เหมาะกับเมื่อไหร่</summary>
ต้องการรายงานเริ่มต้นเร็ว ๆ จาก model เพื่อชำระตาข้อมูลหรือเริ่มวาด — แล้วค่อยปรับต่อเอง
</details>

<details>
<summary>2. Desktop ต่อ Fabric model ทางไหน</summary>
Data hub → Power BI semantic models → เลือก model → Connect (live connection)
</details>

<details>
<summary>3. Drill down ทำงานกับอะไร</summary>
Hierarchy — เช่น Year → Quarter → Month หรือ Country → Province → City ที่สร้างไว้ใน model
</details>

## Go deeper

- [Create reports on semantic models in Fabric](https://learn.microsoft.com/en-us/fabric/data-warehouse/create-reports)
- [Power BI Desktop docs](https://learn.microsoft.com/en-us/power-bi/fundamentals/desktop-what-is-desktop)
- [Mark date tables](https://learn.microsoft.com/en-us/power-bi/transform-model/desktop-date-tables)
