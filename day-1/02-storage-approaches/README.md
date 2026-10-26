# Module 02 — สองประตูเข้าสู่ข้อมูล: Warehouse กับ Lakehouse

> ⏱ ~25 นาที · 🎯 เลือกพื้นที่จัดเก็บได้ถูกงานจากสองข้อเสนอของ Fabric · Warehouse is the T-SQL engine on the lake; Lakehouse is the Spark runtime on the lake.

## Key idea / แนวคิดหลัก — เล่าเป็นเรื่อง

เมื่อข้อมูลทั้งหมดมาอยู่ใน OneLake แล้ว คำถามถัดมาเกิดขึ้นทันที: "จะประมวลผลมันด้วยภาษาอะไร" คำถามนี้ฟังเรื่องเทคนิค แต่จริง ๆ คือคำถามเรื่องคน — เพราะทีมข้อมูลในโลกจริงมักแบ่งเป็นสองพวกที่พูดคนละภาษา

พวกแรกคือทีมที่โตมากับ SQL พูดคุยกับข้อมูลด้วย SELECT และเชื่อว่า star schema คือรูปแบบที่ถูกต้องที่สุดของโลก Fabric วางประตูรองรับพวกนี้ไว้ชื่อ **Warehouse** — มันคือ T-SQL engine แบบกระจายที่วางทับบน data lake คุณเขียน CREATE TABLE, INSERT, JOIN ได้เต็มสิทธิ์เหมือน SQL Server ที่คุ้นเคย แต่ไม่ต้องจัดการเครื่องเองแม้แต่เครื่องเดียว

พวกที่สองคือทีม Data Engineer และ Data Science ที่อยู่กับ Python และ Spark Fabric วางประตูให้พวกนี้ชื่อ **Lakehouse** — มันคือ Spark runtime ที่วางทับ data lake ตัวเดียวกัน เขียนโค้ดใน Notebook ด้วย PySpark/Scala/R/Spark SQL ได้เต็มที่

สิ่งที่น่าทึ่งคือสองประตูนี้**ไม่ได้เก็บข้อมูลคนละกอง** — ทั้งคู่จบลงที่ไฟล์ Parquet + Delta log ใน OneLake เหมือนกัน นั่นแปลว่าทีม SQL ทำงานเสร็จ ทีม Python เห็นข้อมูลชุดเดียวกันทันที (และย้อนกลับกันก็จริง ผ่านทาง Shortcut ซึ่งจะเจอในวันที่สอง) ความต่างจึงอยู่ที่ "ประตูทางเข้า" ไม่ใช่ "ข้อมูลที่เก็บ"

> EN: Same lake, two doors — T-SQL through Warehouse, Spark through Lakehouse.

## Concept / เนื้อหา

ประเด็นที่ต้องชัดก่อนเลือกประตู:

| ประเด็น | Warehouse | Lakehouse |
|---|---|---|
| สาระแท้ | SQL engine on top of a data lake | Spark runtime on top of a data lake |
| ส่วนติดต่อหลัก | T-SQL (อ่าน-เขียนเต็มสิทธิ์) | Python, Scala, Java, R, Spark SQL |
| เข้าถึงด้วย T-SQL อีกทาง | — (ตัวมันเองคือ T-SQL) | ได้ แบบ **อ่านอย่างเดียว** ผ่าน SQL analytics endpoint |
| ที่เก็บจริง | Parquet + Delta log | Parquet + Delta log (Delta tables) |

หลักการเลือกในหลักสูตรนี้:

- โลก BI / งาน star schema / ทีม SQL → เริ่มที่ Warehouse (วันแรกทั้งวันของหลักสูตรคือประตูนี้)
- โลกไฟล์ใหญ่ หลากหลายรูปแบบ / ML / Spark → เริ่มที่ Lakehouse (วันที่สอง)
- ทั้งสองข้างอ่านของกันได้ผ่าน Shortcut — จึงไม่ใช่การเลือกข้าง แต่เป็นการเลือก "ประตูแรก" ที่เหมาะกับทีมคุณ

ข้อความที่ห้ามจำผิด: SQL analytics endpoint ของ Lakehouse นั้น**อ่านอย่างเดียว** — มีคนมักเข้าใจว่าเขียนด้วย T-SQL ได้เหมือน Warehouse แล้วเจอ error ตอน INSERT

## ลงมือทำตามลำดับ

โมดูลนี้เป็นการเล่าเรื่องล้วน ไม่มีแล็บ — แต่ให้เก็บคำถามหนึ่งไว้ตอบตอนจบวันที่สอง: *"งานของคุณเข้าประตูไหนดีกว่า และเพราะอะไร"* — คำตอบที่ดีมักพูดถึงคนในทีม รูปแบบข้อมูล และเครื่องมือที่ทีมถนัด ไม่ใช่แค่ว่าอันไหน "ทันสมัยกว่า"

## Common pitfalls / กับดัก

- เข้าใจว่า Lakehouse กับ Warehouse คัดลอกข้อมูลหากันไม่ได้ — จริง ๆ เชื่อมกันด้วย Shortcut โดยไม่คัดลอกเลย ข้อมูลอยู่กองเดียว
- เชื่อว่า Lakehouse เขียนด้วย T-SQL ได้ — SQL analytics endpoint **อ่านอย่างเดียว** เขียนต้องผ่าน Spark
- เข้าใจว่าต้องเลือกอย่างใดอย่างหนึ่งตลอดโครงการ — หลายโครงการจริงจบด้วยการใช้ทั้งคู่: Warehouse เก็บ dim/fact ที่สะอาด, Lakehouse ทำงานหนักฝั่ง Spark

## Quick check / ทบทวน

<details>
<summary>1. Warehouse คืออะไรในหนึ่งประโยค</summary>
SQL engine แบบกระจายบน data lake ที่เขียน-อ่านด้วย T-SQL เก็บจริงเป็น Parquet + Delta
</details>

<details>
<summary>2. Lakehouse เข้าถึงด้วย T-SQL ได้ไหม แบบไหน</summary>
ได้ — อ่านอย่างเดียว ผ่าน SQL analytics endpoint ที่มาพร้อม Lakehouse
</details>

<details>
<summary>3. ทีมที่โลกทั้งโลกเป็น Python ควรเริ่มที่ไหน</summary>
Lakehouse — เขียนด้วย Spark (PySpark/SQL/Scala/R) ได้เต็มสิทธิ์
</details>

## Go deeper

- [What is a lakehouse in Microsoft Fabric?](https://learn.microsoft.com/en-us/fabric/data-engineering/lakehouse-overview)
- [Fabric Data Warehouse documentation](https://learn.microsoft.com/en-us/fabric/data-warehouse/data-warehousing)
