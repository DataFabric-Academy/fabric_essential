# Module 10 — Semantic Link: อ่าน Semantic Model จาก Python

> ⏱ ~30 นาที · 🎯 เรียก `fabric.read_table`, `evaluate_measure`, `list_relationships` ได้และอ่านความหมายผลลัพธ์ · The semantic model becomes a Python object — no data copy, no re-cleaning.

## Key idea / แนวคิดหลัก — เล่าเรื่อง

ถามว่าคุณค่าที่แท้ของ semantic model ที่คุณสร้างมาทั้งวันคืออะไร คำตอบไม่ใช่ "มี measures เจ็ดตัว" — แต่คือ**ความหมายที่ถูกปั้นไว้แล้ว**: relationship ที่บอกว่าข้อมูลเชื่อมกันยังไง, measure ที่นิยามคำศัพท์ธุรกิจ, และข้อมูลที่สะอาดแล้ว คำถามที่ตามมาคือ นักวิทยาศาสตร์ข้อมูลในองค์กรจะกินของดีตรงนั้นยังไง? ทางเก่าคือ export ข้อมูลมาแล้วเขียน pandas ต่อ — แต่แบบนั้นความหมายหลุดหมด: ตัวเลข Total Revenue ที่ model คำนวณ กับตัวเลขที่นักวิทยาศาสตร์เขียน sum เอง ไม่รับประกันว่าจะเท่ากัน

**Semantic Link** คือทางใหม่ — แพ็กเกจ Python (`semantic-link` + เนมสเปซ `sempy`) ที่ทำให้ semantic model กลายเป็น object ใน Python ได้ตรง ๆ คุณเรียก `fabric.read_table()` ก็ได้ตารางมาเป็น **Fabric DataFrame** (คลาสย่อยของ pandas DataFrame ที่พก metadata เชิงความหมายและ lineage มาด้วย) เรียก `fabric.evaluate_measure()` ก็ได้ผลการคำนวณ measure ที่**รันบน engine ของ model เอง** — ตัวเลขชุดเดียวกับที่รายงานแสดง เพราะมันคือคำนวณเดียวกัน

แล็บนี้คุณจะ upload ไฟล์ `Customer Profitability Sample.pbix` (ตัวอย่างของ Microsoft ที่มี model สวยพร้อมใช้) แล้วรัน notebook `Semantic_Link_Demo.ipynb` ทีละ cell เพื่อชมความสามารถเรียงจากง่ายไปยาก: อ่านตาราง → ดู type/shape → วาดผัง relationship ออกมาเป็นภาพ → ประเมิน measure เดี่ยวและแบบ group by → สุดท้ายตรวจ relationship violations คือหาแถวที่ key อ้างถึงกันไม่ตรงตามที่ model ประกาศไว้ — สิ่งที่ทำแบบมือคงใช้เวลาครึ่งวัน

> EN: One pbix, one notebook — read tables and evaluate measures straight from Python.

## Concept / เนื้อหา

API ที่แล็บใช้ (จาก notebook ใน repo):

| เรียก | คืนอะไร | ใช้ทำ |
|---|---|---|
| `fabric.read_table(model, table)` | Fabric DataFrame | อ่านตารางจาก model |
| `fabric.list_relationships(model)` | DataFrame | เห็น relationship ทั้งหมด |
| `plot_relationship_metadata(...)` | กราฟ | วาดผังความสัมพันธ์ |
| `fabric.list_measures(model)` | DataFrame | รายชื่อ measures |
| `fabric.evaluate_measure(model, measure, groupby_columns=...)` | DataFrame | รัน measure + group by ผ่าน relationship |
| `fabric.list_relationship_violations(tables, relationships)` | DataFrame | ตรวจ key ที่ซื้อขายกันไม่ตรง |

สองแนวคิดที่ต้องแยกให้ออก:

- **Fabric DataFrame** ตอบ `df.shape` และใช้ฟังก์ชัน pandas ปกติได้ทุกอย่าง — ต่างที่มันพก semantic info ติดตัวมา เวลาส่งต่อให้ ML pipeline ความหมายไม่หลุด
- **evaluate_measure กับการเขียนคำนวณเอง** — อดีตคือคำนวณที่ engine ของ model (เชื่อกับรายงาน 100%) อดีตแบบที่สองคือ copy ข้อมูลมา sum เอง (เชื่อแค่ว่าเท่ากันเอง) งานจริงเลือกอดีตเสมอเมื่อตัวเลขต้องตรวจสอบย้อนได้

## ลงมือทำตามลำดับ

ตาม [LAB.md](LAB.md) — ไฟล์ที่ใช้: `Customer Profitability Sample.pbix` + `Semantic_Link_Demo.ipynb` (อยู่ราก repo)

## Common pitfalls / กับดัก

- ลืม upload pbix ก่อน — `read_table` จะโยน ModelNotFound ตั้งแต่ cell แรก
- รัน cell กระโดด — notebook มีการ import ที่ cell บน ๆ (`import sempy.fabric as fabric`) ทุก session ใหม่ต้องรันจากบนลงล่าง
- ชื่อ model ต้องตรงเป๊ะ (`Customer Profitability Sample`) — ตรวจจาก workspace ก่อนแก้ค่าใน notebook
- ใช้ `%pip install` ซ้ำทั้งที่ผูก environment แล้ว — ถ้า Environment ของโมดูลก่อนมี `semantic-link` อยู่ ลบ cell install ออกได้

## Quick check / ทบทวน

<details>
<summary>1. Fabric DataFrame ต่างจาก pandas ยังไง</summary>
เป็นคลาสย่อยของ pandas แต่พก semantic metadata + lineage ของ Fabric มาด้วย
</details>

<details>
<summary>2. evaluate_measure ทำอะไรที่ read_table ทำไม่ได้</summary>
รัน measure ที่นิยามไว้ใน model (เช่น Total Revenue) บน engine ของ model และ group by ผ่าน relationship ได้ — ตัวเลขชุดเดียวกับรายงาน
</details>

<details>
<summary>3. list_relationship_violations จับอะไร</summary>
แถวที่ key อ้างถึงกันไม่ตรงตาม relationship ที่ประกาศไว้ — ขยะที่หลุดเข้ามาก่อน model ถูกปั้น
</details>

## Go deeper

- [Semantic Link overview](https://learn.microsoft.com/en-us/fabric/data-science/semantic-link-overview)
- [sempy API reference](https://learn.microsoft.com/en-us/python/api/semantic-link-sempy/sempy?view=semantic-link-python)
