# SETUP — เครื่องก่อนวันเรียน

ความจริงทั้งหลักสูตรนี้อยู่บน service ทั้งหมด — สิ่งที่เครื่องคุณต้องมีจริง ๆ มีแค่เบราว์เซอร์ บัญชี Microsoft ที่เปิด Trial ได้ และ Power BI Desktop สำหรับบ่ายวันแรก หน้านี้เดินให้ครบทั้งสามอย่างภายใน 15 นาที

## 1. เข้าสู่ระบบ Microsoft Fabric

เปิดเบราว์เซอร์ไปที่ `https://app.fabric.microsoft.com` แล้วล็อกอินด้วยบัญชีที่ผู้จัดให้ (หรือบัญชีองค์กรของตัวเอง)

ผลที่คาดหวัง: หน้า Fabric Home โผล่ขึ้นมา แถบซ้ายมี "My workspace" ของคุณเอง

ถ้าคุณเป็นบัญชีส่วนบุคคลและยังไม่มี tenant ของตัวเอง ให้สร้างจาก Azure ฟรีก่อนหนึ่งขั้น — วิธีอยู่ที่ [Start a Fabric trial with a personal email](https://learn.microsoft.com/en-us/fabric/fundamentals/free-trial-account-personal-email)

## 2. เปิด Fabric Trial

จากมุมขวาบนคลิกไอคอนรูปคน (Account manager) → **Free trial** → เลือก **Fabric trial** → ตรวจ region แล้วกด Activate

ผลที่คาดหวัง: ข้อความยืนยัน success และ Account manager แสดงสถานะ **Trial**

สิ่งที่ควรรู้เกี่ยวกับ Trial ก่อนพึ่งพามัน (ตาม [Fabric trial capacity](https://learn.microsoft.com/en-us/fabric/fundamentals/fabric-trial)):

- ใช้ได้ **60 วัน** จากวันเปิด ทรัพยากรระดับ **64 capacity units** OneLake สูงสุด **1 TB**
- tenant หนึ่งเปิด Trial ได้ไม่เกิน **5 ครั้ง** — เครื่องไหนเคยใช้ไปแล้วจะเปิดซ้ำไม่ได้
- **7 วันหลัง Trial หมดอายุ** ทุก item ที่สร้างไว้จะถูกลบ — งานที่อยากเก็บต้องย้ายก่อน

เพราะสามข้อนี้ หลักสูตรจึงบังคับให้เปิด Trial **ก่อนวันสอน** ไม่ใช่ในห้อง

## 3. Workspace ที่ใช้

หลักสูตรนี้ใช้ **My workspace** ของผู้เรียนเอง — workspace ส่วนตัวที่ระบบสร้างให้อัตโนมัติ มันเหมาะกับห้องเรียนเพราะไม่ต้องขอสิทธิ์ใคร ไม่ต้องตั้งค่า license mode และทุกอย่างที่สร้างเป็นของคุณจนจบ

ตรวจว่าพร้อมแล้ว: คลิก My workspace → ปุ่ม **New item** บนทูลบาร์ต้องกดได้ ถ้าเทา ให้กลับไปขั้นที่ 2 เพราะ Trial ยังไม่ active

## 4. รับไฟล์ Link.txt และโคลน repo

ขอสองอย่างจากผู้สอน:

```text
Link.txt  มี 4 ค่าที่หลักสูตรใช้ตลอดสองวัน:
- Storage account name (Azure Blob)
- Storage Access Key
- Azure SQL server address
- Azure SQL user + password
```

และ URL ของ repo นี้ จากนั้นโคลนด้วยเครื่องมือไหนก็ได้:

```bash
git clone <url-ของ-repo-นี้>
```

ไฟล์ที่จะใช้บ่อยอยู่ใน `DW/`, `LH/` และ `Demo/` — สคริปต์ทั้งหมดจะถูก copy-paste ลง SQL query editor ใน Fabric ไม่มีการรันอะไรในเครื่องคุณ

> 🔒 อย่า commit `Link.txt` หรือค่า key ลง repo เด็ดขาด

## 5. ติดตั้ง Power BI Desktop

ดาวน์โหลดรุ่นล่าสุดจาก [Power BI Desktop](https://www.microsoft.com/en-us/download/details.aspx?id=58494) หรือ Microsoft Store ติดตั้ง เปิดครั้งแรก แล้ว **Sign in** ด้วยบัญชีเดียวกับ Fabric

ผลที่คาดหวัง: มุมขวาบนแสดงชื่อบัญชีของคุณ นี่สำคัญมากในบ่ายวันแรก — ถ้า Desktop ล็อกอินคนละบัญชีกับ Fabric คุณจะมองไม่เห็น semantic model ที่ตัวเองเพิ่งสร้าง

## 6. ทดสอบความพร้อม (2 นาที)

ทดสอบทั้งสามอย่างในรอบเดียว:

1. My workspace → **New item** → ค้นหา `Warehouse` → ตั้งชื่อ `SetupTest` → Create
2. New SQL query → พิมพ์ `SELECT GETDATE();` → Run
3. ลบ Warehouse ทิ้ง (… ที่ชื่อ → Delete)

ผ่านทั้งสามข้อ = ทุกอย่างพร้อม

## ปัญหาที่พบบ่อย

| อาการ | สาเหตุ | แก้ |
|---|---|---|
| ไม่เห็นปุ่ม Free trial | บัญชีนี้เคยใช้ Trial (tenant ละ 5 ครั้ง) หรือ tenant ปิด trial | แจ้งผู้สอน — ใช้บัญชีสำรองที่ผู้จัดเตรียม |
| Trial หมดกลางหลักสูตร | เปิดค้างไว้เกิน 60 วัน | เปิดใหม่ด้วยบัญชีอื่น หรือใช้ F capacity ที่ผู้จัดเตรียม อย่ารอ — item จะถูกลบ 7 วันหลังหมดอายุ |
| New item ไม่มี Warehouse | Trial ยังไม่ active หรือ tenant ปิด Fabric switch | ตรวจ Account manager ให้ขึ้น Trial ก่อน |
| Power BI Desktop ล็อกอินไม่ได้ | บัญชีต่างจาก Fabric | Sign out แล้ว Sign in ใหม่ด้วยบัญชีเดียวกัน |
| ชื่อ item สร้างใหม่ไม่ได้ทันทีหลังลบ | Fabric ล้างชื่อช้า 1–2 นาที | รอ หรือใช้ชื่อลงท้ายเลข (`AdventureworksDW2`) |
| SQL query รันแล้วค้าง | capacity ห้องยุ่งช่วงทุกคนรันพร้อมกัน | กด Stop แล้ว Run ใหม่ หรือเปิด query tab ใหม่ |

## สิ่งที่ SETUP นี้ยังไม่ตรวจ

การเข้าถึง Azure Blob + Azure SQL ของหลักสูตรจริง (ทดสอบครั้งแรกตอน Workshop 4-1 กับ 6-1), quota ของ capacity ห้องสอนเมื่อทุกคน copy พร้อมกัน และสิทธิ์ workspace แบบสองบัญชีสำหรับโมดูล 17 — ส่วนนี้ผู้สอนเดินเองก่อนเริ่ม ดู `instructor/preclass-checklist.md`
