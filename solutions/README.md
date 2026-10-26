# Solutions — ผลอ้างอิงของแต่ละแล็บ

แต่ละโฟลเดอร์คือสถานะ "จบแล็บแล้ว" ของแล็บนั้น: อ่าน `SOLUTION.md` เพื่อรู้ว่าต้องมีอะไร แล้วรัน SQL ที่ `CHECK.sql` (ถ้ามี) บน Warehouse/Lakehouse endpoint ของคุณเพื่อยืนยันว่าคุณอยู่จุดเดียวกับห้อง

Fabric ไม่มีการ copy ไฟล์ solution ลง workspace แบบ code lab — "การต่องาน" คือเข้าใจว่าขาดอะไร แล้วกลับไปทำขั้นนั้น

| โฟลเดอร์ | แล็บ | สิ่งที่จบแล้วต้องมี |
|---|---|---|
| [`03-warehouse/`](03-warehouse/SOLUTION.md) | Workshop 3 | Warehouse + `staging.internetsales` |
| [`04-dataflows/`](04-dataflows/SOLUTION.md) | Workshop 4-1, 4-2 | dataflow 2 ตัว + staging 2 ตารางมีข้อมูล |
| [`05-dimcustomer/`](05-dimcustomer/SOLUTION.md) | บททดสอบ 5 | `dw.DimCustomer` ครบ 7 คอลัมน์ |
| [`06-pipeline/`](06-pipeline/SOLUTION.md) | Workshop 6-1, 6-2 | pipeline 2 ตัวเขียว + dw.DimDate/DimProduct + CHECK.sql |
| [`07-semantic-model/`](07-semantic-model/SOLUTION.md) | Workshop 7-1 | model + relationship 3 เส้น + measures 7 |
| [`08-reports/`](08-reports/SOLUTION.md) | Workshop 8/9/10 + 10-1 | report 2 ตัว + วิธีตอบ insights |
| [`10-semantic-link/`](10-semantic-link/SOLUTION.md) | Workshop 11-1 | notebook จบ 24 cells ผลอ้างอิงทีละ cell |
| [`11-lakehouse/`](11-lakehouse/SOLUTION.md) | Workshop 12-1, 12-2 | Lakehouse + Files/Source + notebook |
| [`12-notebook-etl/`](12-notebook-etl/SOLUTION.md) | Workshop 13 | manage_/external_DimReseller + CHECK.sql |
| [`13-shortcuts/`](13-shortcuts/SOLUTION.md) | Workshop 14 | shortcut DimDate/DimProduct |
| [`14-dataflow-lakehouse/`](14-dataflow-lakehouse/SOLUTION.md) | Workshop 15 | FactResellerSales + CHECK.sql |
| [`15-lh-semantic-model/`](15-lh-semantic-model/SOLUTION.md) | Workshop 16 | relationship 3 เส้น + เฉลยปม date table |
| [`16-posttest/`](16-posttest/SOLUTION.md) | บททดสอบ 17 | เกณฑ์ตรวจ + โครง model อ้างอิง |

แล็บที่ไม่มีโฟลเดอร์ (01 เปิด Trial, 09 Environment, 17 Permission) เป็น guided — จบเมื่อ checkpoint ใน LAB.md ครบ

> ตัวเลขแถว/ยอดเงินในเฉลยระบุช่อง `____` ไว้ให้ผู้สอนจากการซ้อมก่อนเรียน — ดู `instructor/preclass-checklist.md`
