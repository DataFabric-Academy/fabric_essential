# Workshop 11-1 — Semantic Link และ Notebook

> ⏱ 25 นาที · Start state: ไฟล์ `Customer Profitability Sample.pbix` (ราก repo) ยังไม่ได้ upload, notebook environment พร้อม

## Goal / เป้าหมาย

รัน `Semantic_Link_Demo.ipynb` จบทั้งไฟล์: อ่านตาราง ดู relationships ประเมิน measure และตรวจ violations — แล้วอ่านความหมายของแต่ละผลได้

## Steps / ขั้นตอน

1. Upload pbix: My workspace → **Upload → Browse** → เลือก `Customer Profitability Sample.pbix`

   คุณจะเห็น 3 items เกิดขึ้นพร้อมกัน — Power BI Report, Semantic Model และ Dashboard — model ตัวใหม่นี้คือแหล่งข้อมูลที่ notebook จะเรียกใช้ทั้งไฟล์

2. Import notebook: New → **Import notebook** → เลือก `Semantic_Link_Demo.ipynb`

3. เตรียม library: รัน cell แรก (`%pip install semantic-link`) แล้วรอ session รีสตาร์ท — ถ้าคุณผูก Environment ที่มี `semantic-link` อยู่แล้วจากโมดูลก่อน ข้าม cell นี้ได้

4. รัน cell ตามลำดับ พร้อมจดสิ่งที่สังเกตในแต่ละจุด:

   - `read_table(model, 'Customer')` — ตารางลูกค้าแสดงเป็น DataFrame ปกติ
   - `type(customer_df)` — ต้องเห็น pandas/Fabric DataFrame (ไม่ใช่ Spark) — สังเกตว่ามันคือ pandas ยกทั้งโลกมา
   - `customer_df.shape` — จดจำนวนแถว/คอลัมน์ของ Customer
   - `list_relationships` — รายการ relationship ของ model
   - `plot_relationship_metadata` — กราฟผังความสัมพันธ์แสดงออกมาเป็นภาพ — นี่คือ "เห็น" model ที่คุณอ่านจาก JSON ไม่ไหว
   - `list_measures` — รายชื่อ measures (ต้องเห็น `Total Revenue`)
   - `evaluate_measure(model, 'Total Revenue')` — ตัวเลขเดียว — เทียบกับรายงาน pbix ที่เปิดใน workspace: ต้องเท่ากันเป๊ะ เพราะคำนวณที่ engine เดียวกัน
   - `evaluate_measure(..., groupby_columns=["Product[Product]"])` — ยอดต่อสินค้าหลายแถว — สังเกตว่าการ group by ข้ามตารางเกิดจาก relationship ที่ model มีอยู่
   - `list_relationship_violations` — ตารางผลตรวจ (คาดหวังว่างหรือใกล้ศูนย์)

5. ท้ายแล็บตอบสองคำถาม: (1) ถ้า definition ของ Total Revenue เปลี่ยนใน model ใครต้องแก้โค้ด Python บ้าง (คำตอบ: ไม่มีใคร — โค้ดเรียกชื่อ measure เดิม) (2) ถ้าเขียน pandas sum เองแทน evaluate_measure ต้องรับความเสี่ยงอะไร

## ✅ Checkpoint

- [ ] workspace มี report + model + dashboard จาก pbix
- [ ] notebook import และรันจบทุก cells
- [ ] จด shape ของ Customer และค่า Total Revenue ได้ และค่านั้นตรงกับรายงาน pbix
- [ ] อธิบาย groupby_columns ทำงานยังไง

## 🛠 Troubleshooting

| อาการ | สาเหตุ | แก้ |
|---|---|---|
| `ModelNotFound` | pbix ยังไม่ upload หรือชื่อไม่ตรง | อัปโหลดก่อน แล้วตรวจชื่อ model ใน workspace |
| `ModuleNotFoundError: sempy` | `%pip install` ยังไม่รัน/session รีเซ็ต | รัน cell ติดตั้ง แล้วรันใหม่จากบนลงล่าง |
| session ตายกลางทาง | idle นานหรือ resource ห้องแน่น | Restart session แล้วรันตามลำดับ |
| กราฟ relationship ไม่วาด | library plot ไม่ครบใน session | รัน cell ซ้ำหลังติดตั้งเสร็จ |
| evaluate_measure error หา column ไม่เจอ | ชื่อ group by ผิดรูปแบบ `Table[Column]` | คงรูปแบบ `Product[Product]` ตาม notebook |

## 🆘 Behind? Catch up

ผลอ้างอิงทีละ cell อยู่ที่ [`solutions/10-semantic-link/SOLUTION.md`](../../solutions/10-semantic-link/SOLUTION.md)

## Stretch / ต่อยอด

เขียน cell ใหม่: `evaluate_measure(model, "Total Revenue", groupby_columns=["Customer[Industry]"])` แล้วหา industry ที่ให้รายได้สูงสุด 3 อันดับ — คำถามระดับผู้บริหาร ตอบด้วย Python หนึ่ง cell
