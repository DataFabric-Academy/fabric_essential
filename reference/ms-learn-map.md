# แผนที่หัวข้อ ↔ โมดูล repo ↔ MS Learn

หน้านี้ตอบคำถาม "หัวข้อนี้มีต้นทางอ้างอิงทางการที่ไหน" ใช้ตอนผู้เรียนถามลึก หรือเวลาหน้าจอจริงไม่ตรงกับเนื้อหา (UI ของ Fabric เปลี่ยนบ่อย doc ช้ากว่า) — เรียงตามหัวข้อ ไม่ผูกกับเลขหน้าสไลด์

## พื้นฐานและการเริ่มต้น

| หัวข้อ | โมดูล | แหล่งทางการ (MS Learn) |
|---|---|---|
| Fabric overview, workloads | day-1/01 | [Fabric overview](https://learn.microsoft.com/en-us/fabric/fundamentals/microsoft-fabric-overview) |
| OneLake | day-1/01 | [OneLake overview](https://learn.microsoft.com/en-us/fabric/onelake/onelake-overview) |
| Fabric Trial | day-1/01, SETUP | [Fabric trial](https://learn.microsoft.com/en-us/fabric/fundamentals/fabric-trial) |
| Workspace roles (เบื้องต้น) | day-1/01 | [Roles in workspaces](https://learn.microsoft.com/en-us/fabric/fundamentals/roles-workspaces) |

## Data Warehouse วันแรก

| หัวข้อ | โมดูล | แหล่งทางการ |
|---|---|---|
| Warehouse overview, Parquet/Direct Lake | day-1/02, 03, 16 | [Warehouse overview](https://learn.microsoft.com/en-us/fabric/data-warehouse/data-warehousing) |
| สร้างตาราง / DDL | day-1/03 | [Create tables in the Warehouse](https://learn.microsoft.com/en-us/fabric/data-warehouse/create-table) |
| COPY INTO / CTAS / INSERT SELECT | day-1/06, 16 | [Ingest data using T-SQL](https://learn.microsoft.com/en-us/fabric/data-warehouse/ingest-data-tsql) |
| T-SQL surface area | day-1/03 | [T-SQL surface area](https://learn.microsoft.com/en-us/fabric/data-warehouse/tsql-surface-area) |

## Data Factory (Dataflow Gen2, Pipeline, Copy job)

| หัวข้อ | โมดูล | แหล่งทางการ |
|---|---|---|
| Dataflows Gen2 overview | day-1/04, 14 | [Dataflows Gen2 overview](https://learn.microsoft.com/en-us/fabric/data-factory/dataflows-gen2-overview) |
| Dataflow quickstart | day-1/04 | [Quickstart: first dataflow](https://learn.microsoft.com/en-us/fabric/data-factory/create-first-dataflow-gen2) |
| Dataflow Gen2 + CI/CD + Git | day-1/04 (ของใหม่) | [Dataflow Gen2 with CI/CD and Git integration](https://learn.microsoft.com/en-us/fabric/data-factory/dataflow-gen2-cicd-and-git-integration) |
| Copy activity | day-1/06 | [Copy activity](https://learn.microsoft.com/en-us/fabric/data-factory/copy-data-activity) |
| Stored procedure activity | day-1/06 | [Stored Procedure activity](https://learn.microsoft.com/en-us/fabric/data-factory/stored-procedure-activity) |
| Activity overview | day-1/06 | [Activity overview](https://learn.microsoft.com/en-us/fabric/data-factory/activity-overview) |
| Copy job (ของใหม่) | day-1/06 (บรรยาย) | [What is Copy job](https://learn.microsoft.com/en-us/fabric/data-factory/what-is-copy-job) · [Copy job activity ใน pipeline](https://learn.microsoft.com/en-us/fabric/data-factory/copy-job-activity) |
| Training module Dataflow Gen2 | day-1/04 | [Ingest data with Dataflows Gen2](https://learn.microsoft.com/en-us/training/modules/use-dataflow-gen-2-fabric) |
| Merge columns (Power Query) | day-1/05 | [Merge columns](https://learn.microsoft.com/en-us/power-query/merge-columns) |

## Semantic Model และ Power BI

| หัวข้อ | โมดูล | แหล่งทางการ |
|---|---|---|
| Semantic models in Fabric DW | day-1/07, 15 | [Semantic models](https://learn.microsoft.com/en-us/fabric/data-warehouse/semantic-models) |
| Manage semantic model | day-1/07, 15 | [Manage semantic model](https://learn.microsoft.com/en-us/fabric/data-warehouse/manage-semantic-model) |
| **Sunsetting default semantic models** (เปลี่ยนแปลงสำคัญ) | day-1/07, 15 | [ประกาศอย่างเป็นทางการ](https://community.fabric.microsoft.com/blog/fbc_fabricupdatesblogs/sunsetting-default-semantic-models---microsoft-fabric/5172667) |
| DAX reference | day-1/07, 16 | [DAX reference](https://learn.microsoft.com/en-us/dax/) |
| สร้างรายงานจาก model | day-1/08, 16 | [Create reports on semantic models](https://learn.microsoft.com/en-us/fabric/data-warehouse/create-reports) |
| Power BI Desktop | day-1/08 | [Power BI Desktop docs](https://learn.microsoft.com/en-us/power-bi/fundamentals/desktop-what-is-desktop) |
| Mark date tables | day-1/07, 15 | [Mark date tables](https://learn.microsoft.com/en-us/power-bi/transform-model/desktop-date-tables) |

## Spark, Lakehouse และ Semantic Link วันที่สอง

| หัวข้อ | โมดูล | แหล่งทางการ |
|---|---|---|
| Spark compute / pool | day-2/09 | [Spark compute](https://learn.microsoft.com/en-us/fabric/data-engineering/spark-compute) |
| Runtime และ **Runtime 2.0 GA** (ของใหม่) | day-2/09 | [Runtime 2.0](https://learn.microsoft.com/en-us/fabric/data-engineering/runtime-2-0) · [Apache Spark runtime](https://learn.microsoft.com/en-us/fabric/data-engineering/runtime) |
| Environment + compute settings | day-2/09 | [Create and use Environment](https://learn.microsoft.com/en-us/fabric/data-engineering/create-and-use-environment) · [Environment compute](https://learn.microsoft.com/en-us/fabric/data-engineering/environment-manage-compute) |
| Notebooks | day-2/09–12 | [How to use notebooks](https://learn.microsoft.com/en-us/fabric/data-engineering/how-to-use-notebook) |
| Library management | day-2/09 | [Manage Spark libraries](https://learn.microsoft.com/en-us/fabric/data-engineering/library-management) |
| Semantic Link + sempy | day-2/10 | [Semantic Link overview](https://learn.microsoft.com/en-us/fabric/data-science/semantic-link-overview) · [sempy API](https://learn.microsoft.com/en-us/python/api/semantic-link-sempy/sempy?view=semantic-link-python) |
| Lakehouse overview | day-2/11, 14 | [Lakehouse overview](https://learn.microsoft.com/en-us/fabric/data-engineering/lakehouse-overview) |
| Delta tables (managed/external) | day-2/11, 12 | [Lakehouse and Delta tables](https://learn.microsoft.com/en-us/fabric/data-engineering/lakehouse-and-delta-tables) |
| SQL analytics endpoint | day-2/11, 15 | [SQL analytics endpoint](https://learn.microsoft.com/en-us/fabric/data-engineering/lakehouse-sql-analytics-endpoint) |
| Data Wrangler | day-2/11 | [Data Wrangler](https://learn.microsoft.com/en-us/fabric/data-science/data-wrangler) |
| Shortcuts | day-2/13 | [OneLake shortcuts](https://learn.microsoft.com/en-us/fabric/onelake/onelake-shortcuts) · [Shortcuts in lakehouse](https://learn.microsoft.com/en-us/fabric/data-engineering/lakehouse-shortcuts) · [Create same-tenant shortcut](https://learn.microsoft.com/en-us/fabric/onelake/shortcuts/create-onelake-shortcut) |
| OneLake security (ของใหม่ — GA พ.ค. 2026) | day-2/13 (บรรยาย) | [What's new in OneLake (FabCon 2026)](https://community.fabric.microsoft.com/blog/fbc_fabricupdatesblogs/fabcon-and-sqlcon-2026-what%E2%80%99s-new-in-microsoft-onelake/5172235) |
| NYC Taxi dataset (demo) | day-2/16 | [NYC Yellow Taxi dataset](https://learn.microsoft.com/en-us/azure/open-datasets/dataset-taxi-yellow) |

## Permission, License และ AI

| หัวข้อ | โมดูล | แหล่งทางการ |
|---|---|---|
| Workspace roles + permission model | day-2/17 | [Roles in workspaces](https://learn.microsoft.com/en-us/fabric/fundamentals/roles-workspaces) · [Permission model](https://learn.microsoft.com/en-us/fabric/security/permission-model) |
| Workspace roles ฝั่ง DW | day-2/17 | [Workspace roles in DW](https://learn.microsoft.com/en-us/fabric/data-warehouse/workspace-roles) |
| Licenses + capacity (F/P/PPU) | day-2/17 | [Licenses and capacity](https://learn.microsoft.com/en-us/fabric/enterprise/licenses) · [Buy capacity](https://learn.microsoft.com/en-us/fabric/enterprise/buy-capacity) |
| Copilot in Fabric (ของใหม่ — F2+ paid SKU) | day-2/17 (บรรยาย) | [Overview of Copilot in Fabric](https://learn.microsoft.com/en-us/fabric/fundamentals/copilot-fabric-overview) |

## จุดที่เนื้อหา v6.1 ต่างจากเด็คเดิม (ตรวจเมื่อ 2026-10-25)

1. **Default semantic models ถูกยกเลิกทั้งกระบวนการ** — ตั้งแต่ ก.ย. 2025 ระบบไม่สร้าง default model อัตโนมัติ ปลาย ต.ค. 2025 ตัวเดิมถูกแปลงเป็น regular models และปลาย ธ.ค. 2025 ปิดรอบพร้อมถอด Reporting tab หลักสูตรจึงสอนด้วย **New semantic model** ทุกโมดูลที่เกี่ยวข้อง
2. **Fabric Trial** — ยืนยันแล้ว 60 วัน / 64 CU / OneLake 1 TB เพิ่มเติม: tenant ละ 5 trial และ item ถูกลบ 7 วันหลังหมดอายุ
3. **Spark Runtime 2.0 GA** (Spark 4.1, Delta 4) กำลังเป็น default ของ item ใหม่; Runtime 1.3 เข้า LTS ถึง มี.ค. 2027; 1.1/1.2 หมดการสนับสนุน
4. **Copy job** — item ใหม่ใน Data Factory สำหรับงาน copy ล้วน มี incremental/CDC ในตัว เรียกจาก pipeline ได้ผ่าน Copy job activity
5. **Dataflow Gen2** — มี Fast Copy (ingest ใหญ่วิ่งบน Copy engine) และตัวแปร CI/CD สำหรับ Git (Git-integrated ยังเรียกจาก pipeline ไม่ได้ในช่วง preview)
6. **Lakehouse** — schema-enabled lakehouse เป็นตัวเลือกตอนสร้าง; SQL endpoint สะท้อน schema ปัจจุบันเสมอ
7. **Copilot in Fabric** — ใช้ได้กับ paid SKUs (F2+) ไม่รวม Pro/PPU; ฝั่ง Warehouse มี natural language to SQL
8. **OneLake security GA** (พ.ค. 2026) + shortcut transformations
9. ตำแหน่งปุ่มใน Fabric UI อาจต่างจากภาพในสไลด์ — ยึดชื่อปุ่ม/ชื่อไดอะลอกเป็นหลัก
