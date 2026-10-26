# อภิธาน — Keyphrase ในห้อง MS-FB-101

## Keyphrase ในประโยคไทย

ในบทเรียนและแล็บ ให้ใช้ **คำอังกฤษคงที่** แทนการแปลย่อหรือคำกำกวม:

| Keyphrase | ใช้เมื่อ | อย่าใช้ |
|---|---|---|
| **staging** | schema พักข้อมูลดิบระหว่าง ETL | โต๊ะรับของ, พื้นที่พักกลาง |
| **semantic model** | ชั้นความหมาย (relationship, measure) | โมเดลความหมาย, ตัวแบบข้อมูล |
| **measure** | ตัวชี้วัดที่เขียนด้วย DAX | มาตรวัด, ฟิลด์คำนวณ |
| **relationship** | เส้นเชื่อมระหว่างตารางใน model | ความสัมพันธ์แบบฐานข้อมูล (ใช้ FK/PK เมื่อพูดถึง SQL) |
| **shortcut** | ตัวชี้ข้อมูลโดยไม่คัดลอก | ทางลัด, ลิงก์ย่อ |
| **Delta table** | ตารางรูปแบบ Delta (Parquet + _delta_log) | ตารางเดลต้า, ตารางทรานแซกชัน |
| **managed / external** | ประเภท Delta table ตามเจ้าของไฟล์ | ตารางใน/นอก |
| **precedence constraint** | เส้นกำกับลำดับ activity ใน pipeline | สายไฟ, เส้นเชื่อมงาน |
| **CTAS** | CREATE TABLE AS SELECT | คำสั่งสร้างตารางจาก select |
| **Combine files** | ปุ่มรวมไฟล์หลายไฟล์ใน Power Query | รวมไฟล์ (เขียนไทยได้เมื่อกำกับปุ่ม) |
| **Expand** | ดึงคอลัมน์จากตารางที่ relate | ขยาย, คลี่ |
| **default semantic model** | model อัตโนมัติที่มาพร้อม Warehouse/Lakehouse | model หลัก |
| **SQL analytics endpoint** | T-SQL อ่านอย่างเดียวของ Lakehouse | SQL endpoint (ย่อได้เมื่อกำหนดครั้งแรก) |
| **cold cache / hot cache** | สถานะแคชคอลัมน์ใน Direct Lake | แคชเย็น/ร้อน |
| **on-demand loading** | โหลดเฉพาะคอลัมน์ที่ใช้ลงแคช | โหลดตามสั่ง |

## ศัพท์อังกฤษ ↔ คำไทยในห้อง

| English | ไทยในห้องนี้ | ความหมายสั้น |
|---|---|---|
| OneLake | วันเลก (อ่านตาม) | Data lake เดียวขององค์กร |
| Workspace | พื้นที่ทำงาน | ที่เก็บ item และคุมสิทธิ์ |
| Warehouse | คลังข้อมูล | SQL engine บน data lake อ่าน-เขียนด้วย T-SQL |
| Lakehouse | เลกเฮาส์ | Spark runtime บน data lake + SQL endpoint อ่านอย่างเดียว |
| Dataflow Gen2 | ดาต้าโฟลว์ เจนทู | Power Query พร้อม data destination |
| Data pipeline | ไปป์ไลน์ | ผืนผ้าใบจัด activity และลำดับงาน |
| Notebook | โน้ตบุ๊ก | ไฟล์ .ipynb รันบน Spark |
| Environment | เอนไวรอนเมนต์ | ชุด runtime + compute + libraries |
| Measure | มาเชอร์ | ตัวชี้วัด DAX คำนวณตอน query |
| Hierarchy | ไฮเออราร์กี | ลำดับชั้น attribute เช่น ปี→ไตรมาส→เดือน |
| Drill down / up | ลงลึก/ขึ้นบน | เปลี่ยนระดับ hierarchy ใน visual |
| Slicer | สไลเซอร์ | visual กรองข้อมูลทั้งหน้า |
| Auto-create report | ออโต้ครีเอท | ให้ Fabric ประกอบรายงานจาก model เอง |
| Mark as date table | มาร์คเดตเทเบิล | ประกาศตารางปฏิทินเพื่อ Time Intelligence |
| COPY INTO | คอปีอินทู | T-SQL โหลดไฟล์เข้า Warehouse |
| Load to new table | โหลดลงตารางใหม่ | โหมด Copy activity สร้างตารางปลายทางเอง |
| Refresh | รีเฟรช | รัน/ปรับปรุงข้อมูลของ item ตาม schedule |
| Trial | ทราย | Fabric trial capacity 60 วัน |
| Capacity (F/P) | แคพาซิตี้ | หน่วยทรัพยากรที่จ่ายเงิน (CU) |
| Workspace role | บทบาทของ workspace | Admin/Member/Contributor/Viewer |
| Item sharing | แชร์ราย item | ให้สิทธิ์เฉพาะ report/model ตัวเดียว |
| Direct Lake | ไดเรกต์เลก | โหมด Power BI อ่าน Parquet จาก OneLake โดยตรง |
| Data Wrangler | ดาต้าแรงเกลอร์ | เครื่องมือแก้ข้อมูลแบบ interactive ใน notebook |
| Fabric DataFrame | แฟบริกดาต้าเฟรม | คลาสย่อยของ pandas ที่พก semantic metadata |
