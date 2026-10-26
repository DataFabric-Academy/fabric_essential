# LAB — Environment (guided demo) + ตั้งค่า Spark ของ Workspace

> ⏱ 20 นาที · Start state: ว่าง — ทำร่วมกับผู้สอนทีละขั้น

## Goal / เป้าหมาย

มี Environment หนึ่งตัวที่ตั้ง runtime/compute/libraries แล้ว publish พร้อมใช้กับ notebook ของโมดูล 10–12 และรู้ว่าตั้งอะไรที่ workspace settings กับที่ Environment

## Steps / ขั้นตอน

1. สำรวจ Spark settings ของ workspace (ชั้นล่างของการควบคุม):

   ที่ชื่อ workspace (… มุมขวาบน) → **Workspace settings** → **Data Engineering/Science** → Spark settings

   คุณจะเห็น Starter pool และ timeout ของ session — ในห้องปล่อย default แต่จดไว้ว่ามันอยู่ตรงนั้น เพราะ "session ปิดเองเมื่อ idle" คือเหตุผลที่ notebook ค้างครึ่งวันไม่หายรายจ่าย

2. สร้าง Environment (ชั้นกลาง): New item → **Environment** → ตั้งชื่อ `Fabric Course Env`

3. เลือก **Runtime** — เลือกรุ่นที่ tenant ห้องให้บริการ (ถ้ามี Runtime 2.0 ให้ลองเลือก ถ้ายังไม่มีใช้ Runtime 1.3 ต่อ) — สังเกตรายละเอียด Spark/Python/Delta ที่แสดงตามที่เลือก

4. ติดตั้ง library จาก PyPI: Public libraries → ค้นหาและติดตั้ง `semantic-link` (ใช้จริงในโมดูลถัดไป)

5. สำรวจ Spark compute: แทป Spark compute — ดู driver/executor size และ autoscale (ห้องนี้ปล่อย default)

6. **Publish** environment — สำคัญ: ถ้าไม่กดขั้นนี้ ทุกอย่างข้างบนยังไม่มีผล รอ status เปลี่ยนเป็น published

   ผลที่ควรเห็น: `Fabric Course Env` แสดง runtime + 1 library ในสถานะ published

7. ผูกกับ notebook: สร้าง Notebook ทดสอบ → ที่แถบ Environment ด้านข้าง → เลือก `Fabric Course Env` → รัน cell:

   ```python
   import sys
   print(sys.version)
   ```

   ผลที่ควรเห็น: เวอร์ชัน Python ตรงกับ runtime ที่เลือก — นี่คือพิสูจน์ว่า environment ทำงานจริง

## ✅ Checkpoint

- [ ] เห็น Spark settings ของ workspace (pool + timeout) และบอกได้ว่ามันคุมอะไร
- [ ] Environment published พร้อม `semantic-link`
- [ ] notebook ผูก environment แล้วรัน sys.version สำเร็จ
- [ ] อธิบายได้ว่า library จาก PyPI เข้ามาได้อย่างไร

## 🛠 Troubleshooting

| อาการ | สาเหตุ | แก้ |
|---|---|---|
| Publish ค้าง | environment กำลัง build | รอ 2–5 นาที แล้ว refresh หน้า |
| library ติดตั้งแล้ว notebook import ไม่เจอ | ยังไม่ publish หรือ notebook ยังไม่ผูก environment | Publish → ผูกที่แถบ Environment ใน notebook → restart session |
| ไม่เห็นแท็บ Spark settings | สิทธิ์ workspace ไม่ถึง admin/member | ทำใน My workspace ของตัวเองจะมีสิทธิ์เต็ม |
| session ช้ามากหลังผูก env | env กำลัง spawn รอบแรก | รอรอบแรก ครั้งถัดไป cache แล้วเร็ว |

## 🆘 Behind? Catch up

Environment ไม่บังคับในแล็บถัดไป — โมดูล 10 ติดตั้ง `semantic-link` inline ด้วย `%pip install` ได้ ข้ามไปโมดูล 10 แล้วย้อนมาทำทีหลังได้

## Stretch / ต่อยอด

อัปโหลด library .whl ที่สร้างเอง (จาก `pip wheel <ชื่อแพ็กเกจเล็ก ๆ>`) แล้ว publish — เทียบประสบการณ์กับการติดตั้งจาก PyPI ว่าต่างตรงขั้นไหน
