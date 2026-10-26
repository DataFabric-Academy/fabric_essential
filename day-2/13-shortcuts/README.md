# Module 13 — Shortcut: ใช้ข้อมูลร่วมกันโดยไม่คัดลอก

> ⏱ ~25 นาที · 🎯 สร้าง shortcut ข้าม Lakehouse → Warehouse แล้วคิวรี่ข้อมูลข้ามโลกได้ · A shortcut is a pointer, not a copy.

## Key idea / แนวคิดหลัก — เล่าเรื่อง

ในโลกที่ไม่มี shortcut คำถามง่าย ๆ อย่าง "ผมอยาก join ตารางวันที่ของทีม DW เข้ากับข้อมูลของผม" จบลงด้วยการ copy ตารางมาอีกกอง — พอต้นทางเปลี่ยน กองของคุณก็เก่า อีกสามเดือนผ่านไปทั้งองค์กรมีตาราง DimDate อยู่ห้ากองที่เลขไม่ตรงกัน นี่คือโรคเดิมที่ Fabric ตั้งใจรักษาด้วย **OneLake**

**Shortcut คือหัวใจของแนวคิด OneLake** — มันคือตัวชี้ (pointer) ไม่ใช่ข้อมูล คุณสร้าง shortcut ที่ Lakehouse ของคุณชี้ไปตารางของ Warehouse อีกตัว แล้วข้อมูลนั้นจะโผล่ใน Lakehouse ของคุณเหมือนอยู่ตรงนั้นจริง แต่ด้านหลังไม่มีการคัดลอกแม้แต่ byte เดียว ทุกคิวรี่วิ่งไปอ่านที่ต้นทางเสมอ ต้นทางอัปเดตปุ๊บ คุณเห็นของใหม่ปั๊บ

Shortcut สร้างได้สองทิศ: **ต้นทางภายใน** (Internal — ข้อมูลใน OneLake เอง เช่น ตาราง Warehouse อีกตัว) และ **ต้นทางภายนอก** (External — ADLS Gen2, S3, Azure Blob และอื่น ๆ) แล็บนี้เราทำทิศแรก: Lakehouse `AdventureworksLH` จะ "ยืม" `dw.DimDate` และ `dw.DimProduct` จาก Warehouse `AdventureworksDW` ของคุณเอง — ผลลัพธ์คือ Lakehouse หนึ่งตัวที่มีทั้งข้อมูลของโลก Spark และข้อมูลของโลก SQL อยู่ใน Tables เดียวกัน

กฎที่ต้องจำสองข้อ: ข้อมูลผ่าน shortcut เป็น**อ่านอย่างเดียว**ที่ฝั่งผู้ชี้ (เขียนต้องกลับไปที่ต้นทาง) และ storage ของคุณ**ไม่โต**ขึ้นเวลาสร้าง shortcut — ถ้าโต แปลว่าคุณทำผิดปุ่ม

และเก็บคำถามไว้ก่อน เพราะมันจะกลับมาแบบมีเงื่อน: ตาราง DimDate ที่มาผ่าน shortcut นี้ ต่อไปจะถูกเรียกใช้ใน semantic model — แล้ว Mark as date table จะเจออะไร โมดูลสองตัวถัดไปมีคำตอบที่ไม่ควรพลาด

> EN: Data stays in the warehouse; the lakehouse sees it through a shortcut.

## Concept / เนื้อหา

- **สร้างได้จากไหน**: คลิกขวาที่ **Tables** (หรือโฟลเดอร์ไหนก็ได้ใน Files) → New shortcut → Internal sources → Microsoft OneLake → เลือก item ปลายทาง → เลือกตาราง → Create
- **ตัวชี้ไปตาราง Warehouse จะโผล่เป็น Delta table** พร้อมใช้ใน Explorer, Spark และ SQL endpoint ของคุณ
- **ข้อดี** — ไม่เสีย storage ซ้ำ, ข้อมูลล่าสุดเสมอจากต้นทาง, ต้นทางอยู่ไหนก็ได้ (รวมถึงภายนอก OneLake)
- **ข้อจำกัด** — อ่านอย่างเดียวที่ฝั่งผู้ชี้
- ของใหม่ที่ควรรู้เพื่อความทันสมัย: ปัจจุบันมี **shortcut transformations** (แปลงข้อมูลระหว่างทางตอน shortcut ดึงเข้ามา) และ **OneLake security** ที่ GA ไปแล้ว (กำหนดสิทธิ์ระดับโฟลเดอร์/ตาราง รวมถึง row-level และ column-level) — เรื่องพวกนี้ไม่ใช่ในแล็บ แต่คือภาพว่า shortcut กำลังเติบโตเป็นกลไกจริงจังขององค์กร ไม่ใช่แค่ทางลัด

## ลงมือทำตามลำดับ

ตาม [LAB.md](LAB.md) — แล็บเสริมนอกห้อง: [`Shortcuts/README.md`](../../Shortcuts/README.md)

## Common pitfalls / กับดัก

- คลิกขวาผิดที่ (Files แทน Tables) — shortcut ไปตาราง Warehouse ต้องสร้างที่ Tables
- เลือก Warehouse ผิดตัว — ห้องที่ตามไม่ทันมักมี Warehouse ค้างหลายชื่อ ดูให้ตรง `AdventureworksDW`
- เชื่อว่าต้อง copy — ถ้า storage โตขึ้นหลังสร้าง shortcut แปลว่าทำผิด
- ลอง INSERT ผ่าน shortcut — พังเพราะอ่านอย่างเดียว และแล็บจะให้คุณพังเองเพื่อเรียนรู้

## Quick check / ทบทวน

<details>
<summary>1. Shortcut ต่างจาก COPY INTO ยังไง</summary>
COPY INTO คัดลอกข้อมูลจริง shortcut เป็น metadata pointer ชี้ข้อมูลเดิม — ไม่มีข้อมูลไหนย้ายที่
</details>

<details>
<summary>2. ต้นทาง Warehouse อัปเดต ฝั่ง Lakehouse เห็นไหม</summary>
เห็นทันที — มันคือข้อมูลชุดเดิม ไม่มีการ sync
</details>

<details>
<summary>3. เขียนข้อมูลผ่าน shortcut ได้ไหม</summary>
ไม่ได้ — ตารางผ่าน shortcut เป็น read-only ที่ฝั่งผู้ชี้
</details>

## Go deeper

- [OneLake shortcuts](https://learn.microsoft.com/en-us/fabric/onelake/onelake-shortcuts)
- [Shortcuts in a lakehouse](https://learn.microsoft.com/en-us/fabric/data-engineering/lakehouse-shortcuts)
- [Create a same-tenant OneLake shortcut](https://learn.microsoft.com/en-us/fabric/onelake/shortcuts/create-onelake-shortcut)
