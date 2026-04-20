# Lab: Lakehouse Shortcuts — เชื่อมข้อมูลข้าม Warehouse ↔ Lakehouse

## วัตถุประสงค์
- สร้าง Shortcut ใน Lakehouse ไปยังข้อมูลบน Warehouse
- เข้าใจว่า Shortcuts ช่วยลดการคัดลอกข้อมูลซ้ำซ้อน
- ใช้ Shortcut ร่วมกับ SQL Endpoint และ Power BI

---

## ทำความเข้าใจ Shortcuts

**Shortcut** คือตัวชี้ (pointer) ไปยังข้อมูลที่อยู่ที่อื่น โดยไม่ต้องคัดลอกข้อมูลมาเก็บซ้ำ

```
Lakehouse A                          Warehouse
┌──────────────────┐                ┌──────────────────┐
│ DimReseller      │ (Delta table)  │ DimDate          │
│ FactResellerSales│                │ DimProduct       │
│                  │◄── shortcut ───│ DimCustomer      │
│ [DimDate] ───────┼──── pointer    │ FactInternetSales│
│ [DimProduct] ────┼──── pointer    │                  │
└──────────────────┘                └──────────────────┘
```

**ข้อดี:**
- ไม่ต้องคัดลอกข้อมูล → ลดค่าใช้จ่าย storage
- ข้อมูลอัปเดต real-time จากแหล่งเดิม
- แหล่งข้อมูลอยู่ที่ไหนก็ได้ (Warehouse, Lakehouse, ADLS, S3)

---

## Lab 1: สร้าง Shortcut จาก Warehouse ไปยัง Lakehouse

### Prerequisites
- มี Warehouse ที่มีตาราง `DimDate`, `DimProduct`, `DimCustomer` อยู่แล้ว (จาก DW lab)
- มี Lakehouse ที่สร้างไว้แล้ว (จาก LH lab)

### ขั้นตอน

1. **เปิด Lakehouse**
   - ไปที่ Workspace → เปิด Lakehouse ที่ต้องการ

2. **สร้าง Shortcut**
   - คลิกขวาที่ **Tables** folder → **New shortcut**
   - หรือกดปุ่ม **New shortcut** บน ribbon

3. **เลือก Source**
   - Internal sources → เลือก **Warehouse** ใน Workspace เดียวกัน
   - เลือก Warehouse: `AdventureWorksDW`

4. **เลือกตารางที่ต้องการ**
   - ✅ `dw.DimDate`
   - ✅ `dw.DimProduct`
   - ✅ `dw.DimCustomer`

5. **กำหนด Shortcut name**
   - ปล่อยเป็นชื่อเดิม หรือเปลี่ยนชื่อตามต้องการ

6. **ตรวจสอบ**
   - สังเกตไอคอน 🔗 ที่ปรากฏข้างชื่อตาราง (แสดงว่าเป็น Shortcut)
   - ลอง query ข้อมูล:
     ```sql
     SELECT TOP 10 * FROM DimDate;
     ```

---

## Lab 2: ใช้ Shortcut ร่วมกับ SQL Endpoint

### ขั้นตอน

1. **เปิด SQL Endpoint ของ Lakehouse**
   - ที่ Lakehouse → เลือก **SQL Endpoint** (มุมขวาบน)

2. **Query ข้ามแหล่งข้อมูล**
   ```sql
   -- ตารางจริงอยู่ที่ Lakehouse
   SELECT ResellerKey, ResellerName FROM manage_DimReseller;

   -- ตารางจริงอยู่ที่ Warehouse แต่เข้าถึงผ่าน Shortcut
   SELECT DateKey, FullDateAlternateKey, EnglishMonthName FROM DimDate;

   -- Join ข้ามแหล่งข้อมูล
   SELECT
       r.ResellerName,
       d.EnglishMonthName,
       SUM(f.SalesAmount) AS TotalSales
   FROM FactResellerSales f
   JOIN manage_DimReseller r ON f.ResellerKey = r.ResellerKey
   JOIN DimDate d ON f.OrderDateKey = d.DateKey
   GROUP BY r.ResellerName, d.EnglishMonthName
   ORDER BY TotalSales DESC;
   ```

---

## Lab 3: สร้าง Power BI Report จาก Shortcut

### ขั้นตอน

1. **สร้าง Semantic Model บน Lakehouse SQL Endpoint**
   - ที่ Lakehouse → **New semantic model**
   - เลือกตาราง:
     - `manage_DimReseller` (จริง — อยู่ที่ Lakehouse)
     - `DimDate` (shortcut — ข้อมูลอยู่ที่ Warehouse)
     - `DimProduct` (shortcut — ข้อมูลอยู่ที่ Warehouse)
     - `FactResellerSales` (จริง — อยู่ที่ Lakehouse)

2. **สร้าง Relationships**
   - `FactResellerSales[ResellerKey]` → `manage_DimReseller[ResellerKey]`
   - `FactResellerSales[OrderDateKey]` → `DimDate[DateKey]`

3. **สร้าง Measures**
   ```dax
   Total Sales = SUM(FactResellerSales[SalesAmount])
   Total Orders = SUM(FactResellerSales[OrderQuantity])
   Avg Order Value = [Total Sales] / [Total Orders]
   ```

4. **สร้าง Power BI Report**
   - Bar chart: Reseller Name vs Total Sales
   - Line chart: Month vs Total Sales (ใช้ DimDate จาก Shortcut)
   - KPI cards: Total Sales, Total Orders

---

## สรุป: Shortcuts ช่วยอะไร?

| ก่อน (ไม่มี Shortcut) | หลัง (มี Shortcut) |
|----------------------|-------------------|
| ต้องคัดลอกตาราง DimDate จาก Warehouse มา Lakehouse | สร้าง Shortcut ชี้ไปที่ Warehouse ได้เลย |
| ข้อมูลซ้ำซ้อน 2 ที่ | ข้อมูลอยู่ที่เดียว |
| อัปเดตข้อมูลต้อง sync ทั้ง 2 ที่ | อัปเดตที่ต้นทาง → ได้ข้อมูลล่าสุดทันที |
| เสีย storage 2 เท่า | เสีย storage เท่าเดียว |

---

## คำถามทบทวน

1. Shortcut ต่างจาก การคัดลอกตาราง (COPY INTO) อย่างไร?
2. ถ้าต้นทาง (Warehouse) ลบตารางที่ Shortcut ชี้ไป จะเกิดอะไรขึ้น?
3. Shortcut สามารถชี้ไปที่แหล่งข้อมูลภายนอก (ADLS, S3) ได้ไหม?
