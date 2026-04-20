# Lab: Dataflows Gen2 — นำเข้าข้อมูล

## วัตถุประสงค์
- สร้าง Dataflow Gen2 เพื่อนำเข้าข้อมูลจากแหล่งต่าง ๆ
- ใช้ Power Query Online ในการ Transform ข้อมูล
- นำเข้าข้อมูล CSV จาก Azure Blob Storage
- นำเข้าข้อมูลตารางจาก Azure SQL Database

---

## Lab 1: นำเข้าไฟล์ CSV จาก Azure Blob Storage

### สถานการณ์
นำเข้าไฟล์ `DimReseller.csv` จาก Azure Blob Storage เพื่อเป็น Dimension Table

### ขั้นตอน

1. **สร้าง Dataflow Gen2**
   - ไปที่ Workspace → New → Dataflow Gen2
   - ตั้งชื่อ `Import DimReseller`

2. **เพิ่ม Data Source**
   - เลือก **Azure Blob Storage**
   - กำหนด Connection:
     - URL: `https://your-storage.blob.core.windows.net/source/`
     - Authentication: ตามที่อาจารย์กำหนด
   - เลือกไฟล์ `DimReseller.csv`

3. **Transform ข้อมูล (Power Query)**
   - ลบคอลัมน์ที่ไม่ใช้:
     - `ResellerAlternateKey`, `Phone`, `NumberEmployees`
     - `AddressLine1`, `AddressLine2`
     - `MinPaymentType`, `MinPaymentAmount`
     - `AnnualSales`, `AnnualRevenue`
     - `OrderMonth`, `FirstOrderYear`, `LastOrderYear`, `YearOpened`
   - เปลี่ยนชนิดข้อมูล `ResellerKey` เป็น Whole Number
   - เปลี่ยนชื่อคอลัมน์ (ถ้าจำเป็น)

4. **กำหนด Destination**
   - เลือก **Lakehouse** หรือ **Warehouse** (ตามที่ใช้)
   - Table name: `DimReseller`
   - Update method: **Replace**

5. **Publish** → ติดตามสถานะ Refresh

---

## Lab 2: นำเข้าข้อมูลจาก Azure SQL Database

### สถานการณ์
นำเข้าข้อมูล Internet Sales จาก Azure SQL Database เพื่อเป็น Fact Table

### ขั้นตอน

1. **สร้าง Dataflow Gen2** → ตั้งชื่อ `Import Internet Sales`

2. **เพิ่ม Data Source**
   - เลือก **Azure SQL Database**
   - กำหนด Connection:
     - Server: `your-server.database.windows.net`
     - Database: `AdventureWorksDW`
   - เลือกตาราง `FactInternetSales`

3. **Transform ข้อมูล (Power Query)**
   - เลือกคอลัมน์ที่ต้องใช้เท่านั้น:
     - `ProductKey`, `OrderDateKey`, `CustomerKey`
     - `OrderQuantity`, `UnitPrice`, `UnitPriceDiscountPct`
     - `DiscountAmount`, `TotalProductCost`, `SalesAmount`, `TaxAmt`
   - กรองเฉพาะข้อมูลปีที่ต้องการ (Filter rows)

4. **กำหนด Destination**
   - Table name: `FactInternetSales`
   - Update method: **Replace**

5. **Publish** → ติดตามสถานะ

---

## Lab 3: นำเข้าไฟล์ Excel (Bonus)

### สถานการณ์
นำเข้าไฟล์ Excel เพื่อเป็น Fact Table สำหรับ Reseller Sales

### ขั้นตอน

1. **สร้าง Dataflow Gen2** → ตั้งชื่อ `Import Reseller Sales`

2. **เพิ่ม Data Source**
   - เลือก **File** → **Excel workbook**
   - อัปโหลดไฟล์ หรือ ระบุ path บน Lakehouse

3. **Transform ข้อมูล**
   - เลือก Sheet ที่ต้องการ
   - ลบ header rows ที่ไม่ใช้
   - กำหนดชนิดข้อมูลให้ถูกต้อง

4. **กำหนด Destination** → Publish

---

## เปรียบเทียบ: Dataflows Gen2 vs Pipeline Copy Activity

| คุณสมบัติ | Dataflows Gen2 | Pipeline Copy Activity |
|-----------|----------------|----------------------|
| **UI** | Power Query Online (Low-code) | Pipeline canvas |
| **Transform** | ทำได้มาก (Merge, Pivot, Filter) | น้อย (Mapping เท่านั้น) |
| **Schedule** | Built-in refresh schedule | ต้องตั้ง Trigger |
| **เหมาะสำหรับ** | Self-service, Citizen Developer | IT/DE, Complex orchestration |
| **Output** | เขียนลง Lakehouse/Warehouse/... | เขียนลง Lakehouse/Warehouse |
| **Error handling** | Basic | Advanced (Retry, Alert) |

---

## คำถามทบทวน

1. Dataflows Gen2 กับ Pipeline Copy Activity เลือกใช้อย่างไร?
2. Power Query สามารถ Merge ตาราง 2 ตารางได้ไหม? ทำอย่างไร?
3. ถ้า Source file มีการเปลี่ยนแปลงทุกวัน จะตั้ง Refresh schedule อย่างไร?
