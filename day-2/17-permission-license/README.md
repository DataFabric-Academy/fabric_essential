# Module 17 — Permission และ License: ประตูที่ทำให้งานออกสู่โลก

> ⏱ ~30 นาที · 🎯 กำหนดบทบาท workspace และทดสอบสิทธิ์จากฝั่งผู้ใช้ อ่าน License mode ของ workspace ได้ · Roles live on the workspace; sharing lives on the item.

## Key idea / แนวคิดหลัก — เล่าเรื่อง

สองวันที่ผ่านมา ทุกอย่างที่คุณสร้างอยู่ใน My workspace ของแต่ละคน — จึงไม่มีใครเห็นงานใคร นั่นคือเหตุผลที่มันสะดวกสำหรับห้องเรียน แต่งานจริงต้องออกสู่โลก: ผู้บริหารต้องเห็นรายงาน ทีมต้องแก้ข้อมูลร่วมกัน และคนนอกทีมไม่ควรเห็นทุกอย่าง โมดูลสุดท้ายนี้จัดการเรื่องนั้น และมันทำงานด้วยสองกลไกที่คนมักจำสับสน

กลไกแรกคือ **workspace role** — สิทธิ์ระดับพื้นที่ทำงาน มีสี่บทบาท: **Admin** คุมทั้งหมดรวมถึงการตั้งสิทธิ์ต่อ, **Member** สร้าง/แก้ item และตั้งสิทธิ์ต่อได้, **Contributor** สร้าง/แก้ item ได้แต่ไม่คุมสิทธิ์, **Viewer** อ่านอย่างเดียว คุณกำหนดที่ Manage access ของ workspace แล้วคนรับจะเห็นทั้ง workspace พร้อม item ในนั้น ตามระดับที่ได้

กลไกที่สองคือ **item sharing** — สิทธิ์ระดับชิ้นงาน: แชร์เฉพาะรายงานหนึ่งใบ หรือ semantic model หนึ่งตัว โดยไม่ให้เข้า workspace ทั้งอัน คำถามวิศวกรรมที่ดีคือ "ผมต้องการให้ใครเห็นอะไร" — ถ้าคำตอบคือ "ทั้งทีมเห็นทุกอย่าง" ใช้ workspace role ถ้าคำตอบคือ "ผู้บริหารเห็นแค่รายงานใบเดียว" ใช้ item sharing ห้ามให้สิทธิ์เกินจากความจำเป็น

ครึ่งหลังของโมดูลคือ **License** — แผนที่ค่าใช้จ่ายที่องค์กรต้องตัดสินใจ ในห้องนี้ทุกคนวิ่งบน **Trial** (60 วัน 64 CU ครบทุกคุณสมบัติ) แต่โลกจริงมีสองสายหลัก: สาย **F (Fabric Capacity)** ซื้อผ่าน Azure SKU — มี pay-as-you-go, pause/resume/scale ได้ตลอดเวลา, ดูค่าใช้จ่ายผ่าน Cost Management สาย **P (Power BI Capacity)** ซื้อผ่าน Microsoft 365 SKU — สัญญารายปี เทียบเท่า F64 ขึ้นไปในราคาที่ถูกกว่าแต่ scale ไม่ได้ และมี **PPU** (Premium per User) ที่ความจุน้อยกว่ามาก ตารางที่ควรจำ: F2–F4 สร้าง/publish รายงานได้แต่ share ไม่ได้, F8–32 เพิ่ม embed ได้, F64+ ทำได้ทั้งหมด

เกร็ดปัจจุบันที่ควรรู้: ความสามารถ AI อย่าง **Copilot ใน Fabric** เปิดให้ใช้กับ paid Fabric SKUs ตั้งแต่ F2 ขึ้นไป (ไม่รวม Pro/PPU) — เวลาที่หน่วยงานถาม "จะได้ใช้ Copilot ไหม" คำตอบจึงขึ้นกับ SKU ที่ซื้อ ไม่ใช่แค่ license Power BI เดิม

แล็บนี้คุณจะทำคู่กับเพื่อน: ให้สิทธิ์จริง, ทดสอบจริงจากฝั่งผู้รับ, ยกระดับบทบาท แล้วถอน — เห็นผลของทุกระดับด้วยตาตัวเอง

> EN: Trial for class, F for flexibility, P for Power BI at scale — the workspace header tells you which you are on.

## Concept / เนื้อหา

- **Workspace roles** — Admin / Member / Contributor / Viewer อ่านตารางความสามารถเต็มที่ [Roles in workspaces](https://learn.microsoft.com/en-us/fabric/fundamentals/roles-workspaces)
- **การกำหนดบทบาท** — Workspace (… ที่ชื่อ) → Manage access → เพิ่มผู้ใช้/กลุ่ม → เลือก role
- **ทดสอบจากฝั่งผู้ใช้** — คนรับเห็น workspace + item ตามสิทธิ์ และพยายามแก้เกินสิทธิ์แล้วถูกปฏิเสธ — การทดสอบสองฝั่งคือวิธีเดียวที่พิสูจน์ว่าสิทธิ์ตั้งถูกจริง
- **Item sharing** — เปิดสิทธิ์ที่ report/semantic model ตัวนั้น โดยไม่แตะ workspace
- **License mode** — Workspace settings → ตรวจ mode ปัจจุบันของ workspace (ในห้องคือ Trial) และอ่านความต่างของ F/P/PPU ตามสไลด์ประกอบ
- **เงื่อนไขบัญชี** — การ invite กันต้องใช้บัญชีองค์กรเดียวกันหรือ external guest — ห้องที่ใช้ Trial คนละ tenant จะ invite หากันไม่ได้ จึงมีบัญชีคู่เตรียมไว้ให้

## ลงมือทำตามลำดับ

ตาม [LAB.md](LAB.md) — ทำคู่กับเพื่อนหนึ่งรอบเต็ม

## Common pitfalls / กับดัก

- ให้สิทธิ์ Contributor กับคนที่ควรเห็นอย่างเดียว — เริ่มจาก Viewer ยกขึ้นเมื่อจำเป็นเสมอ
- ลืมว่า item sharing ต่างจาก workspace role — อย่าให้เข้า workspace ทั้งอันถ้าต้องการแค่รายงานใบเดียว
- ตั้งค่าผิด workspace — กด Manage access ได้เฉพาะ workspace ที่คุณเป็น admin/member
- เชื่อว่า Trial share ให้คนนอกได้ทุกกรณี — ตรวจข้อจำกัด license ของ SKU จริงก่อนเอาไปใช้งาน

## Quick check / ทบทวน

<details>
<summary>1. สี่บทบาทของ workspace และสาระสั้น</summary>
Admin (คุมทั้งหมด + ตั้งสิทธิ์), Member (สร้าง/แก้ + ตั้งสิทธิ์ได้), Contributor (สร้าง/แก้ item), Viewer (อ่านอย่างเดียว)
</details>

<details>
<summary>2. F ต่างจาก P ตรงความยืดหยุ่นอะไร</summary>
F ซื้อผ่าน Azure ปรับ pause/resume/scale ได้ ดู cost ผ่าน Cost Management — P ซื้อรายปีผ่าน 365 SKU แต่ scale ไม่ได้
</details>

<details>
<summary>3. จะแชร์รายงานตัวเดียวโดยไม่ให้เข้า workspace</summary>
Item sharing — เปิดสิทธิ์ที่ report/semantic model ตัวนั้น
</details>

## Go deeper

- [Roles in workspaces](https://learn.microsoft.com/en-us/fabric/fundamentals/roles-workspaces)
- [Permission model in Fabric](https://learn.microsoft.com/en-us/fabric/security/permission-model)
- [Understand Fabric licenses and capacity](https://learn.microsoft.com/en-us/fabric/enterprise/licenses)
- [Buy Fabric capacity (Azure SKUs)](https://learn.microsoft.com/en-us/fabric/enterprise/buy-capacity)
- [Overview of Copilot in Fabric](https://learn.microsoft.com/en-us/fabric/fundamentals/copilot-fabric-overview)
