# Module 01 — รู้จักกับ Microsoft Fabric, OneLake และ Workspace

> ⏱ ~50 นาที · 🎯 เล่าได้ว่า Fabric แก้ปัญหาอะไรขององค์กร และเปิด Trial + ใช้ Workspace เป็น · OneLake is one copy of data for every workload.

## Key idea / แนวคิดหลัก — เล่าเป็นเรื่อง

ลองนึกภาพองค์กรหนึ่ง ทีมขายมี SQL server ของตัวเอง ทีมการตลาดเก็บไฟล์ไว้ใน Azure Blob ทีมวิเคราะห์ดึงข้อมูลไปทำอีกทีใน Power BI และทุกทีมต่างก็ "คัดลอก" ข้อมูลที่ตัวเองต้องใช้มากองไว้ข้างตัว ปัญหาไม่ใช่แค่เสียพื้นที่เก็บเท่าตัว แต่คือข้อมูลแต่ละชุดเริ่มเบี่ยงเบนจากกัน — ยอดขายที่ทีมขายเห็น กับยอดที่ทีมวิเคราะห์เห็น เป็นเลขคนละชุดเพราะ copy มาคนละวัน

Microsoft Fabric เกิดมาเพื่อตัดวงจรคัดลอกนี้ มันเสนออะไรสองชั้น ชั้นแรกคือ **OneLake** — ที่เก็บข้อมูลที่เดียวของทั้งองค์กร ข้อมูลจากไฟล์ ฐานข้อมูล หรือบริการภายนอก จะถูกนำเข้ามาอยู่จุดเดียวกัน ชั้นที่สองคือ workloads ทุกประเภทที่คุณคุ้นเคย — Data Engineering (Spark), Data Warehouse (T-SQL), Power BI — ทั้งหมดชี้มาอ่านข้อมูลกองเดียวกันโดยไม่ต้องทำสำเนาข้ามระบบ ทุก workload เป็น SaaS ใน app เดียว (app.fabric.microsoft.com) คุณไม่ต้อง provision เครื่อง ไม่ต้องติดตั้ง สร้าง item ปุ๊บ ใช้ได้เลย

ส่วนที่คุณจะแตะเป็นอย่างแรกคือ **Workspace** — พื้นที่เก็บ items และจุดคุมสิทธิ์ คุณจะเจอสองชนิด: **My workspace** ที่ระบบสร้างให้อัตโนมัติและตอนเริ่มมองเห็นเฉพาะเจ้าของ ซึ่งเหมาะกับห้องเรียนนี้ทั้งสองวัน และ **workspace ที่สร้างใหม่** ซึ่งออกแบบมาเพื่อทีม — กำหนดได้ว่าใครเห็นอะไร และการสร้าง Power BI items ในนั้นต้องมี license รองรับ เรื่องสิทธิ์จะกลับมาลึกอีกทีตอนท้ายวันที่สอง วันนี้แค่รู้ว่าทุกอย่างที่คุณสร้างจะอยู่ใน My workspace ของคุณ

> EN: Fabric unifies storage (OneLake) and all analytics workloads in one SaaS app — one copy of data, no cross-system duplication.

## Concept / เนื้อหา

แนวคิดที่จะผูกกันทั้งสองวันมีไม่กี่คำ:

- **OneLake** — data lake เดียวขององค์กร ทำหน้าที่ data hub รับส่งข้อมูลกับภายนอก ทุก item ที่คุณจะสร้าง (Warehouse, Lakehouse, Dataflow…) เก็บข้อมูลจริง ๆ ในนี้ทั้งหมด
- **Data Hub** — มุมมองที่ Fabric จัดให้ เป็นรายการรวมแหล่งข้อมูลและ semantic models ที่คุณมีสิทธิ์เห็น — เวลาอยากรู้ว่า "ข้อมูลอะไรมีให้ใช้บ้าง" เริ่มจากหน้านี้
- **Predesigned Task flow** — เทมเพลตขั้นตอนงานที่ Microsoft เตรียมไว้ ชื่อที่เจอบ่อยคือ **Medallion**: แนวคิดจัดชั้นคุณภาพข้อมูล Bronze (ดิบ) → Silver (สะอาด) → Gold (พร้อมใช้) หลักสูตรนี้ไม่ใช้เทมเพลต แต่ทำแนวคิดเดียวกันด้วยมือด้วย schema `staging` → `dw` ใน Warehouse ซึ่งให้เห็นกลไกชัดกว่า
- **Workspace** — พื้นที่เก็บ item และคุมสิทธิ์ (Admin/Member/Contributor/Viewer — จะเจอตอนโมดูล 17)
- **Fabric Trial** — license ทดลองที่คุณจะเปิดใช้ในแล็บนี้: 60 วัน ทรัพยากรระดับ 64 capacity units OneLake สูงสุด 1 TB tenant หนึ่งเปิดได้ไม่เกิน 5 ครั้ง และ item จะถูกลบ 7 วันหลังหมดอายุ

## ลงมือทำตามลำดับ

บทเรียนนี้เริ่มที่การตั้งเครื่องแล้วปิดด้วยแล็บสำรวจหน้าจอ:

1. ทำ [SETUP.md](../../SETUP.md) ให้จบทุกขั้น — เปิด Trial และผ่านการทดสอบ `SELECT GETDATE()`
2. แล็บ guided: [LAB.md](LAB.md) — เดินหน้าจอ Fabric Home, เปิด New item ดูรายการ items ทั้งหมดที่สองวันนี้จะใช้, แวะ Data Hub และ Predesigned Task flow แล้วสร้าง-ลบ Warehouse ชั่วคราวเพื่อพิสูจน์ว่าเครื่องคุณทำงานจริง

## Common pitfalls / กับดัก

- เปิด Trial วันสอนเอง — บัญชีไหนใช้ Trial ไปแล้ว (tenant ละ 5 ครั้ง) จะเปิดซ้ำไม่ได้ และช่วงเปิดใหม่ UI อาจยังไม่สเถียร เรื่องนี้ควรจบก่อนมาถึงห้อง
- สับสน My workspace กับ workspace ใหม่ — ทุกแล็บอ้าง My workspace ถ้าคุณเผลอสร้างของใน workspace อื่น จะเจอปัญหา "หา item ไม่เจอ" ตลอด
- ลืมว่า Trial มีอายุและลบของตอนตาย — อย่าใช้ Trial เป็นที่เก็บงานจริง มันคือห้องทดลอง
- ใช้บัญชีต่างกันระหว่าง Power BI Desktop กับ Fabric — ผลจะโผล่ตอนโมดูล 08 ในรูป "เห็น model ไม่ครบ" ซึ่งแก้ยากกว่าที่ควรจะเป็น

## Quick check / ทบทวน

<details>
<summary>1. OneLake แก้ปัญหาอะไรในองค์กร</summary>
ลดการคัดลอกข้อมูลซ้ำหลายที่ — ทุก workload ชี้ข้อมูลชุดเดียว ตัวเลขทุกทีมจึงมาจากกองเดียวกัน
</details>

<details>
<summary>2. My workspace กับ workspace ใหม่ต่างกันอย่างไร</summary>
My workspace อัตโนมัติและมองเห็นเฉพาะเจ้าของตอนเริ่ม workspace ใหม่คุมสิทธิ์ให้ทีมได้และใช้กับงานที่ต้องแชร์
</details>

<details>
<summary>3. Trial ให้อะไร และหมดอายุแล้วเกิดอะไร</summary>
คุณสมบัติครบ 60 วัน (64 CU, OneLake 1 TB) — 7 วันหลังหมดอายุ item ทั้งหมดถูกลบ
</details>

## Go deeper

- [Microsoft Fabric overview](https://learn.microsoft.com/en-us/fabric/fundamentals/microsoft-fabric-overview)
- [OneLake overview](https://learn.microsoft.com/en-us/fabric/onelake/onelake-overview)
- [Fabric trial capacity](https://learn.microsoft.com/en-us/fabric/fundamentals/fabric-trial)
- [Roles in workspaces](https://learn.microsoft.com/en-us/fabric/fundamentals/roles-workspaces)
