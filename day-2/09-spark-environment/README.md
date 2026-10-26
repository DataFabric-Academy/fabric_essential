# Module 09 — Spark: ทำไม Fabric เลือกมัน และคุมมันอย่างไร

> ⏱ ~40 นาที · 🎯 อธิบายบทบาทของ Spark ใน Fabric ได้ และจัดการสามชั้นการควบคุม: workspace settings, Environment, Notebook · Fabric hides the cluster — you bring the code, Fabric brings the nodes.

## Key idea / แนวคิดหลัก — เล่าเรื่อง

เมื่อข้อมูลไม่ใช่สิบล้านแถวแต่เป็นพันล้านแถวระดับเพตะไบต์ เครื่องเดียวที่พิมพ์ SQL อยู่จะเริ่มสะดุด **Apache Spark** คือคำตอบที่โลก big data เลือกใช้มากว่าทศวรรษ: กระจายงานไปหลายเครื่องพร้อมกัน และมันเป็นภาษาแม่ของสาย Data Engineer และ Data Science ที่เขียน Python/Scala ทุกวัน

ที่เดิม การมี Spark หนึ่ง cluster คืองานของทีมคนดูแลระบบ — จัดการเครื่อง จัดการ node ตาย อัปเดต library Fabric ทำอย่างที่มันทำดีที่สุด: **ซ่อนความซับซ้อนทั้งหมด** คุณเขียนโค้ดแล้ว Fabric ยก cluster ขึ้นมารันให้เองแล้วเก็บกลับเมื่อจบ แต่ "ซ่อน" ไม่ได้แปลว่า "คุมไม่ได้" — Fabric ให้ชั้นการควบคุมสามชั้นที่ซ้อนกันเป็นระบบ

ชั้นล่างคือ **Workspace settings** — นิยามพฤติกรรม default ของทั้ง workspace: ใช้ Spark pool ไหน และ Spark session จะมีชีวิตอยู่กี่นาทีก่อนถูกปิดเอง (session มีต้นทุน ปล่อยค้างก็จ่าย) ชั้นกลางคือ **Environment** — item แยกต่างหากที่รวมสามอย่างเป็นชุดเดียว: เวอร์ชัน runtime, ขนาด compute (driver/executor) และ libraries ที่ติดตั้ง (จาก PyPI, Conda หรือ .whl ที่สร้างเอง) เมื่อ notebook ไหนผูก Environment ตัวนี้ มันจะได้โลกครบชุดเดียวกันทุกครั้ง — จบปัญหาคลาสสิก "ทำไม notebook ฉันรันได้แต่เพื่อนรันไม่ได้" ชั้นบนสุดคือ **Notebook** — ที่ที่โค้ดอยู่จริง รองรับทั้ง Spark SQL, PySpark, R และ Scala ในไฟล์ .ipynb เดียวกัน และรันทีละ cell ได้เหมือน Jupyter ทุกอย่าง

เรื่องรุ่น runtime ที่ควรรู้เพื่อความทันสมัย: ณ ตอนนี้ **Runtime 2.0 เป็น GA** (บน Spark 4.1, Delta 4) และกำลังกลายเป็นค่า default ของ item ใหม่ ส่วน **Runtime 1.3 เข้าสู่ Long Term Support จนถึง มี.ค. 2027** — Runtime 1.1/1.2 หมดการสนับสนุนไปแล้ว เวลาสร้าง Environment ในแล็บ ให้เลือกรุ่นที่ tenant ของห้องให้บริการ

ปิดท้ายด้วยเรื่องที่ผูกวันนี้เข้ากับวันแรก: สมัยก่อน เผยแพร่รายงานจาก Power BI Desktop แล้ว semantic model ถูกล็อกไว้ — คนอื่นเข้าถึงได้แค่ผ่าน REST API หรือ XMLA แต่บน Fabric model อยู่กลางองค์กร นักวิทยาศาสตร์ข้อมูลนำมันไปใช้กับ ML ได้โดยไม่ต้องทำความสะอาดข้อมูลซ้ำ — นั่นคือประตูสู่ **Semantic Link** โมดูลถัดไป

> EN: Spark pools, environments and notebooks — three layers of control over the same compute.

## Concept / เนื้อหา

- **Spark Pool** (ชั้น workspace) — นิยามว่า session ใช้ resources เท่าไรและมีอายุเท่าไรก่อนปิดเอง ตั้งที่ Workspace settings → Data Engineering/Science ในห้องนี้ปล่อย default ก็พอ แต่คุณต้องรู้ว่ามันอยู่ตรงนั้น
- **Environment** (ชั้น item) — ตั้งค่าครบสามอย่างแล้ว **Publish** จึงมีผล (คนลืมกันเยอะ) การเปลี่ยน environment ที่มี library ใหญ่ทำให้ session แรกหลัง publish เริ่มช้าหนึ่งรอบ
- **Notebook** (ชั้นโค้ด) — cell ได้ทั้ง Code/Markdown รันทีละ cell ผูก lakehouse เป็น context และผูก environment เป็นชุดความพร้อม
- **Runtime ปัจจุบัน** — Runtime 2.0 GA (Spark 4.1, Delta 4) กำลังเป็น default ของ item ใหม่; Runtime 1.3 LTS ถึง มี.ค. 2027; 1.1/1.2 หมดการสนับสนุน — ตรวจรุ่นที่ tenant ห้องให้ก่อนสอน

## ลงมือทำตามลำดับ

บรรยายเช้าวันที่สองชุดนี้ แล้วแล็บ guided สร้าง Environment หนึ่งตัวพร้อม library จาก PyPI — [LAB.md](LAB.md)

## Common pitfalls / กับดัก

- แก้ Environment แล้วลืม Publish — การเปลี่ยนแปลงยังไม่ถูกนำไปใช้กับ notebook อะไรเลย
- ติดตั้ง library ใหญ่ทั้งที่ไม่ใช้ — session ทุกครั้งเริ่มช้าขึ้น ใน Trial นี่คือเวลาเรียนที่หายไปฟรี
- สับสนว่าตั้งอะไรที่ไหน — pool/session อยู่ที่ workspace settings, runtime+libraries+compute อยู่ที่ Environment, โค้ดอยู่ที่ Notebook ถ้าตั้งผิดชั้น จะงงว่าแก้แล้วทำไมไม่เห็นผล
- สองคนแก้ notebook เดียวพร้อมกัน — Fabric มี co-authoring แต่ output ชนกันได้ งานห้องแบ่ง notebook ดีกว่า

## Quick check / ทบทวน

<details>
<summary>1. Environment แก้ปัญหาอะไร</summary>
ล็อก runtime + compute + libraries เป็นชุดเดียว ใช้ซ้ำได้ทุก notebook — จบปัญหาเครื่องใครเครื่องมัน
</details>

<details>
<summary>2. Spark session ตายเองได้ไหม</summary>
ได้ — pool นิยาม idle timeout ที่ session จะปิดเอง เพราะ session ค้างก็จ่าย capacity
</details>

<details>
<summary>3. Notebook ของ Fabric ต่างจาก Jupyter ยังไง</summary>
ไฟล์ .ipynb เดียวกัน แต่รันบน Spark pool ของ Fabric และผูก Lakehouse/Environment เป็น context ได้
</details>

## Go deeper

- [Apache Spark compute in Fabric](https://learn.microsoft.com/en-us/fabric/data-engineering/spark-compute)
- [Create, configure and use an Environment](https://learn.microsoft.com/en-us/fabric/data-engineering/create-and-use-environment)
- [Runtime 2.0 in Fabric](https://learn.microsoft.com/en-us/fabric/data-engineering/runtime-2-0)
- [How to use Fabric notebooks](https://learn.microsoft.com/en-us/fabric/data-engineering/how-to-use-notebook)
- [Manage Spark libraries](https://learn.microsoft.com/en-us/fabric/data-engineering/library-management)
