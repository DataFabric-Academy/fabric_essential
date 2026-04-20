# Microsoft Fabric Essential for Business — Hands-on Labs

หลักสูตรอบรม Microsoft Fabric แบบ hands-on ระยะเวลา 2 วัน (12 ชม.) เน้นปฏิบัติจริงตั้งแต่ต้นจนจบกระบวนการ

## Prerequisites

- Microsoft Fabric License (Trial หรือ Paid)
- Web browser เวอร์ชันล่าสุด
- พื้นฐาน SQL (แนะนำ)
- พื้นฐาน Python/PySpark (แนะนำ สำหรับ Lakehouse module)
- พื้นฐาน Power BI (เป็นประโยชน์)

## Course Outline

### Day 1 — Data Warehouse + Data Ingestion

| ลำดับ | หัวข้อ | Lab | โฟลเดอร์ |
|-------|--------|-----|----------|
| 1 | รู้จัก Microsoft Fabric, OneLake, Data Mesh | — (สไลด์) | — |
| 2 | สร้าง Workspace + เปิดใช้งาน Fabric | Workshop | — |
| 3 | **แนวทางการจัดเก็บข้อมูล** — Warehouse vs Lakehouse vs Datamart | — (สไลด์) | — |
| 4 | **Data Warehouse — สร้างตาราง + โหลดข้อมูล** | Demo: NYC Taxi | `Demo/` |
| 5 | **Dataflows Gen2 — นำเข้าข้อมูลจากแหล่งต่าง ๆ** | Workshop | `DFGen2/` |
| 6 | **Data Pipeline — Copy Activity + Work Flow** | Workshop | `Pipeline/` |
| 7 | **Semantic Model** — Relationships, Attributes, DAX Measures | Workshop | `DW/` |
| 8 | **Power BI Report** — สร้างรายงานจาก Semantic Model | Workshop | `.pbix` |

### Day 2 — Lakehouse + Spark + Advanced

| ลำดับ | หัวข้อ | Lab | โฟลเดอร์ |
|-------|--------|-----|----------|
| 9 | **Apache Spark** — Environment, Notebook, Spark Job | Workshop | `LH/` |
| 10 | **Semantic Link (SemPy)** — เข้าถึง Semantic Model ผ่าน Python | Demo | `Semantic_Link_Demo.ipynb` |
| 11 | **Delta Lake** — Managed Tables vs External Tables | Workshop | `LH/` |
| 12 | **Lakehouse Shortcuts** — เชื่อมข้อมูลข้าม Warehouse ↔ Lakehouse | Workshop | `Shortcuts/` |
| 13 | **SQL Endpoint + Semantic Model บน Lakehouse** | Workshop | `LH/` |
| 14 | **Columnar Storage + On-Demand Loading** | Demo | `Demo/` |
| 15 | **Security** — Workspace + Fabric Items | Demo | — |
| 16 | **Copilot for Microsoft Fabric** | Demo | — |

## Folder Structure

```
fabric_essential/
├── Demo/                    # Lab 4: NYC Taxi Data Warehouse demo
├── DW/                      # Lab 7-8: AdventureWorks star schema (staging → dim → fact)
├── DFGen2/                  # Lab 5: Dataflows Gen2 exercises
├── Pipeline/                # Lab 6: Data Pipeline + Copy Activity exercises
├── LH/                      # Lab 9,11,13: Lakehouse ETL (PySpark + Delta)
├── Shortcuts/               # Lab 12: Lakehouse Shortcuts exercises
├── Semantic_Link_Demo.ipynb # Lab 10: SemPy demo notebook
├── *.pbix                   # Lab 8: Power BI sample reports
└── README.md
```

## Data Sources

หลักสูตรใช้ข้อมูลจาก:

| แหล่งข้อมูล | ใช้ใน | คำอธิบาย |
|-------------|--------|----------|
| NYC TLC Open Dataset | Demo/ | ข้อมูล Taxi trip 170M+ rows (Azure Blob) |
| AdventureWorksDW | DW/ | ข้อมูลตัวอย่างจาก Microsoft (SQL Database) |
| CSV files | LH/, DFGen2/ | DimReseller, DimGeography, sample files |
| Azure SQL Database | Pipeline/ | แหล่งข้อมูลต้นทางสำหรับ Pipeline |

## DAX Measures (สำหรับ Semantic Model)

```
Revenue = SUM(FactInternetSales[SalesAmount])
Cost = SUM(FactInternetSales[TotalProductCost])
Profit = [Revenue] - [Cost]
Margin = [Profit] / [Revenue]
Previous Year Revenue = CALCULATE([Revenue], SAMEPERIODLASTYEAR('dw.DimDate'[FullDateAlternateKey]))
```

## วัตถุประสงค์การเรียนรู้

เมื่อจบหลักสูตร ผู้เรียนจะสามารถ:

1. อธิบายส่วนประกอบและประโยชน์ของ Microsoft Fabric ได้
2. จัดเตรียมข้อมูลจากแหล่งต่าง ๆ ด้วย Dataflows Gen2 ได้
3. สร้าง Semantic Model เพื่อใช้ในองค์กรได้
4. สร้าง Data Insights จาก Power BI และเครื่องมือต่าง ๆ ได้

## แหล่งอ้างอิง

- [Microsoft Fabric Documentation](https://learn.microsoft.com/en-us/fabric/)
- [Microsoft Fabric Learning Paths](https://learn.microsoft.com/en-us/training/browse/?terms=fabric)
- [AdventureWorks Sample Databases](https://learn.microsoft.com/en-us/sql/samples/adventureworks-install-configure)
