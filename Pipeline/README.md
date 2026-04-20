# Pipeline Lab: Data Pipeline + Copy Activity

## วัตถุประสงค์
- สร้าง Data Pipeline ใน Microsoft Fabric
- ใช้ Copy Activity นำเข้าข้อมูลจาก Azure SQL Database
- สร้าง Work Flow ด้วย Precedence Constraints
- รันและติดตามการทำงานของ Pipeline

---

## Lab 1: นำเข้าข้อมูลด้วย Copy Data Activity

### ขั้นตอน

1. **สร้าง Warehouse**
   - ไปที่ Workspace → New → Warehouse → ตั้งชื่อ `AdventureWorksDW`
   - เปิด Warehouse editor

2. **รัน SQL เพื่อสร้างตารางปลายทาง**
   - เปิดไฟล์ `01_Create Staging DimDate.sql`
   - รันใน Warehouse Query Editor

3. **สร้าง Pipeline**
   - ไปที่ Workspace → New → Data Pipeline → ตั้งชื่อ `Import DimDate`
   - เลือก **Copy Data Activity**

4. **กำหนด Source**
   - Source type: `Azure SQL Database`
   - สร้าง Connection ใหม่:
     - Server: `your-server.database.windows.net`
     - Database: `AdventureWorksDW`
     - Authentication: ตามที่อาจารย์กำหนด
   - Table: `[dbo].[DimDate]`

5. **กำหนด Destination**
   - Destination type: `Warehouse`
   - เลือก Warehouse: `AdventureWorksDW`
   - Table: `staging.DimDate`
   - Write behavior: `Overwrite`

6. **รัน Pipeline**
   - กดปุ่ม **Run** → **Run now**
   - ติดตามสถานะที่ **Output** tab

7. **ตรวจสอบผลลัพธ์**
   ```sql
   SELECT TOP 10 * FROM staging.DimDate;
   SELECT COUNT(*) AS TotalRows FROM staging.DimDate;
   ```

---

## Lab 2: สร้าง Work Flow ด้วย Precedence Constraints

### สถานการณ์
มีข้อมูล 2 ตารางที่ต้องนำเข้าตามลำดับ: ตาราง Products ต้องมาก่อน แล้วค่อยนำเข้าตาราง Sales (เพราะ Sales มี FK อ้างอิง Products)

### ขั้นตอน

1. **สร้างตาราง staging สำหรับ Lab นี้**
   ```sql
   CREATE TABLE staging.DimProduct_Lab
   (
       ProductKey INT NOT NULL,
       EnglishProductName VARCHAR(50) NULL,
       StandardCost FLOAT NULL,
       ListPrice FLOAT NULL,
       Color VARCHAR(15) NULL
   );
   GO

   CREATE TABLE staging.FactSales_Lab
   (
       ProductKey INT NOT NULL,
       OrderDateKey INT NULL,
       SalesAmount FLOAT NULL,
       OrderQuantity INT NULL
   );
   GO
   ```

2. **สร้าง Pipeline ใหม่** → ตั้งชื่อ `Import Products then Sales`

3. **เพิ่ม Copy Activity ตัวที่ 1: `CopyProducts`**
   - Source: Azure SQL Database → `[dbo].[DimProduct]`
   - Destination: Warehouse → `staging.DimProduct_Lab`

4. **เพิ่ม Copy Activity ตัวที่ 2: `CopySales`**
   - Source: Azure SQL Database → `[dbo].[FactInternetSales]`
   - Destination: Warehouse → `staging.FactSales_Lab`

5. **สร้าง Precedence Constraint**
   - ลากสายจาก `CopyProducts` ไปยัง `CopySales`
   - เงื่อนไข: **Success** (คัดลอก Products สำเร็จก่อน ค่อยเริ่มคัดลอก Sales)

6. **เพิ่ม Activity อื่น ๆ (ถ้ามีเวลา)**
   - **Stored Procedure Activity**: รัน SP หลังคัดลอกข้อมูลเสร็จ
   - **Office365 Outlook Activity**: ส่งอีเมลแจ้งเตือนเมื่อ Pipeline ทำงานเสร็จ

7. **รัน Pipeline** → ติดตามสถานะ

8. **ตรวจสอบผลลัพธ์**
   ```sql
   SELECT COUNT(*) FROM staging.DimProduct_Lab;
   SELECT COUNT(*) FROM staging.FactSales_Lab;
   ```

---

## Lab 3: รันและติดตาม Pipeline

### ขั้นตอน

1. ไปที่ Pipeline ที่สร้างไว้
2. กด **Run** → **Run now**
3. ไปที่ **Run history** tab:
   - ดูสถานะของแต่ละ Activity (Queued → Running → Succeeded)
   - ดู **Input** และ **Output** ของแต่ละ Activity
   - ดู **Duration** — เปรียบเทียบเวลาทำงาน
4. ถ้า Pipeline ล้มเหลว:
   - คลิกที่ Activity ที่ Failed
   - ดู **Error message** ใน Output tab
   - แก้ไขและ Run ใหม่

---

## คำถามทบทวน

1. Copy Activity คัดลอกข้อมูลแบบ **Overwrite** กับ **Append** ต่างกันอย่างไร?
2. Precedence Constraint แบบ **Success** กับ **Completion** ต่างกันอย่างไร?
3. ถ้าต้องการให้ Pipeline รันอัตโนมัติทุกวัน จะตั้งค่าอย่างไร?
