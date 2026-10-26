# LAB — เปิด Trial, สำรวจ Fabric Home และ Workspace (guided)

> ⏱ 20 นาที · Start state: ทำ SETUP.md จบแล้ว มี Trial และ My workspace

## Goal / เป้าหมาย

หน้าจอ Fabric คุ้นมือ — คุณรู้ว่า item อยู่ตรงไหน เปิด/ลบ item เป็น และพิสูจน์แล้วว่าเครื่องคุณสร้างของได้จริง

## Steps / ขั้นตอน

1. เปิด `https://app.fabric.microsoft.com` — อยู่หน้า **Fabric Home**

   คุณจะเห็นแถบซ้ายมี Home, Workspaces, My workspace และปุ่ม **New item** — ปุ่มนี้คือประตูหลักของทั้งหลักสูตร ทุก item ที่เราจะสร้างสองวันนี้เริ่มจากปุ่มเดียวกันนี้

2. กด **New item** แล้วพิมพ์ค้นหาทีละชื่อ: `Warehouse`, `Lakehouse`, `Dataflow Gen2`, `Data pipeline`, `Notebook`, `Environment`

   คุณจะเห็น icon ทั้งหมดพร้อมกด (ยังไม่ต้องสร้างจริง) — จำภาพลิสต์นี้ไว้ วันแรกเราจะใช้สามตัวแรก วันที่สองจะใช้ที่เหลือ

> 📚 **รู้เพิ่ม:** รายการที่ค้นเจอคือ "items" แต่ละชนิดของ Fabric แต่ละชนิดมีหน้าที่เฉพาะ — สองวันนี้จะช่วยให้คุณจำได้ว่างานแบบไหนควรหยิบ item ไหน

3. เปิด **Data Hub** จากแถบซ้าย — หน้ารวมแหล่งข้อมูลและ semantic models ที่คุณมีสิทธิ์เห็น

   ตอนนี้หน้าจอมักยังเบาบาง — ถือว่าปกติ ตอนจบวันแรกหน้านี้จะมี Warehouse และ semantic model ของคุณ และเวลา Power BI Desktop อยากต่อเข้า model ก็มาหาทางหน้านี้

4. ลอง **Predesigned Task flow**: กลับ Home → ค้นหา "Task flow" หรือเข้าผ่าน New → เลือกเทมเพลต (เช่น Medallion)

   คุณจะเห็นผัง Bronze–Silver–Gold พร้อม slot ให้วาง items — ดูให้เข้าใจแนวคิดแล้วปิดไป ไม่ต้องใช้เทมเพลตนี้ในหลักสูตร เพราะเราจะประกอบแนวคิดเดียวกันด้วยมือและจะเข้าใจกลไกลึกกว่า

> 📚 **รู้เพิ่ม:** Medallion คือแนวคิดจัดชั้นคุณภาพข้อมูล ที่ Fabric วางเป็นเทมเพลตให้ — หลักสูตรนี้เดินโครงสร้างเดียวกันด้วย schema `staging` → `dw` ใน Warehouse

5. ตรวจสถานะ Trial: มุมขวาบน → Account manager

   คุณควรเห็น **Trial** พร้อมวันหมดอายุ (60 วันจากวันเปิด) — จดวันหมดอายุไว้ในโน้ตของคุณเอง เพราะ item จะถูกลบ 7 วันหลังวันนั้น

6. ทดสอบสร้าง-ลบ item อย่างเร็ว: New item → **Warehouse** ตั้งชื่อ `SetupTest` → สร้าง → เปิด → New SQL query → พิมพ์ `SELECT GETDATE();` → Run → ลบ Warehouse

   ควรเห็นคิวรี่คืนวันเวลาปัจจุบัน และ item หายจาก workspace หลังลบ — ถ้าผ่านข้อนี้ เครื่องคุณทำงานจริงครบวงจร

## ✅ Checkpoint

- [ ] Account manager ขึ้น Trial (จดวันหมดอายุแล้ว)
- [ ] New item ค้น Warehouse / Lakehouse / Dataflow Gen2 / Data pipeline / Notebook เจอครบ
- [ ] สร้าง-ลบ Warehouse ชั่วคราวสำเร็จ
- [ ] รู้ว่าตอนนี้ทุกอย่างอยู่ใน My workspace

## 🛠 Troubleshooting

| อาการ | สาเหตุ | แก้ |
|---|---|---|
| ไม่เห็น Free trial | เคยใช้ Trial (tenant ละ 5 ครั้ง) หรือ tenant ปิด | แจ้งผู้สอนใช้บัญชีสำรอง |
| ปุ่ม New item เทา | Trial ยังไม่ active | กลับ SETUP.md ขั้น 2 รอ status Trial ก่อน |
| ลบ Warehouse แล้วสร้างชื่อเดิมไม่ได้ทันที | ระบบกำลังล้างชื่อ (1–2 นาที) | รอ หรือใช้ชื่อใหม่ |
| หน้า Home โหลดนาน | capacity ห้องยุ่งช่วงเปิดคาบ | รอ — จะเข้าโซนปกติเอง |

## 🆘 Behind? Catch up

ทำ SETUP.md ขั้นที่ 6 ให้ผ่านก็ต่องานได้ทันที — เนื้อหาสาธิตหน้าจอไม่มีผลต่อแล็บถัดไป

## Stretch / ต่อยอด

เปิดหน้า [Fabric overview](https://learn.microsoft.com/en-us/fabric/fundamentals/microsoft-fabric-overview) แล้วหาว่า workload ที่คุณใช้บ่อยในงานจริง อยู่ workload ไหนของ Fabric — เก็บคำตอบไว้เล่าให้เพื่อนตอนพัก
