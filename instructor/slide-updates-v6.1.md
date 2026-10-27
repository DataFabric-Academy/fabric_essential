# Slide updates v6.1 — บันทึกการปรับเด็คให้ทันสมัย (ตุลาคม 2026)

เด็คที่แก้แล้วอยู่ที่ `Trainer_Docs/9Expert Training-MS-FB-101-Aj-Phakkapong-Version 6.1.pptx` (เด็คเดิม v6 ยังเก็บไว้คู่กัน) การแก้ประกอบด้วยสามส่วน: แก้ข้อความในสไลด์ที่ล้าสมัย, ใส่ speaker notes "v6.1:" ให้ผู้สอน และเพิ่มภาคผนวกท้ายเด็ค

ทุกการเปลี่ยนแปลงอ้างอิง MS Learn และประกาศทางการของ Microsoft ณ วันที่ 2026-10-25 — แหล่งรวมอยู่ที่ [`../reference/ms-learn-map.md`](../reference/ms-learn-map.md)

## 1. เปลี่ยนแปลงเชิงโครงสร้างที่ทำให้ต้องแก้เด็ค: Default Semantic Model ถูกยกเลิก

ประกาศทางการ ([Sunsetting Default Semantic Models](https://community.fabric.microsoft.com/blog/fbc_fabricupdatesblogs/sunsetting-default-semantic-models---microsoft-fabric/5172667)):

- ก.ย. 2025: ระบบไม่สร้าง default semantic model ให้อัตโนมัติอีก (warehouse, lakehouse, SQL database, mirrored items)
- ปลาย ต.ค. 2025: default models ที่มีอยู่ถูกแปลงเป็น regular semantic models
- ปลาย ธ.ค. 2025: ปิดรอบ + ถอด Reporting tab ที่พึ่ง default model

ผลต่อเด็ค: สไลด์ที่พูดถึง "Power BI semantic model (Default) สร้าง/อัปเดตอัตโนมัติ" และ flow "Manage default Power BI semantic model" ทั้งหมดต้องเปลี่ยนเป็น flow **New semantic model** ซึ่งเนื้อหาของ repo (โมดูล 07, 15) ใช้อยู่แล้ว

## 2. ข้อความในสไลด์ที่ถูกแก้ใน v6.1

| จุดในเด็ค (สิ่งที่อ้างถึง) | ของเดิม | ของใหม่ |
|---|---|---|
| สไลด์สร้าง Warehouse แรก (ข้อความประกอบภาพ) | "Power BI semantic model (Default) ถูกสร้างขึ้น และอัปเดตอัตโนมัติ…" | "Semantic model สร้างเองด้วยปุ่ม New semantic model เมื่อ Tables/Views พร้อม (default model ยกเลิกแล้ว — ดูภาคผนวก v6.1)" |
| สไลด์ Semantic Model (บทบาท model) | "Default ถูกสร้างอัตโนมัติพร้อม Warehouse สร้างเพิ่มได้" | "สร้างด้วย New semantic model (default model ยกเลิกแล้ว — ภาคผนวก v6.1)" |
| สไลด์สร้าง Lakehouse แรก | "Power BI semantic model (Default) ปรับปรุงอัตโนมัติเมื่อ Delta-Table ถูกเพิ่มหรือปรับปรุง" | "Semantic model สร้างเองด้วย New semantic model; ตาราง Delta สะท้อนผ่าน SQL analytics endpoint (default model ยกเลิกแล้ว — ภาคผนวก v6.1)" |
| สไลด์ Semantic Model บน SQL endpoint | "Default ถูกสร้างอัตโนมัติพร้อม Lakehouse สร้างเพิ่มได้" | "สร้างด้วย New semantic model จาก SQL analytics endpoint (default model ยกเลิกแล้ว — ภาคผนวก v6.1)" |
| สไลด์ "แก้ไข Semantic Model (default)" ชุด flow ฝั่ง endpoint | "กดปุ่ม Manage default Power BI semantic Model ภายใน SQL analytics endpoint" | "สร้าง semantic model จาก SQL analytics endpoint ด้วยปุ่ม New semantic model (ปุ่ม Manage default model ถูกถอดออกแล้ว — ภาคผนวก v6.1)" + หัวข้อสไลด์เปลี่ยนจาก "(default)" เป็น "(สร้างเอง)" |
| สไลด์ภาพรวม Warehouse (ตารางเทียบ) | คอลัมน์ default semantic model | ตัวหนังสือในเซลล์แก้ตามแนว New semantic model |
| สไลด์ Pipeline "Get date" (พิมพ์ผิด) | "เลือก Get date" | "เลือก Get data" |
| สไลด์บททดสอบ DimCustomer | "DimGeoghapy" (สะกดผิด) | "DimGeography" |
| สไลด์ Power Query (ชุด Lakehouse) | "Combile files" (สะกดผิด) | "Combine files" |
| สไลด์ ETL ด้วย Notebook | "อัฟโหลด" (สะกดผิด) | "อัปโหลด" |

## 3. Speaker notes "v6.1:" ที่ใส่ให้ผู้สอน

| สไลด์ | สรุปเนื้อหาใน note |
|---|---|
| สร้าง Warehouse แรก / Semantic Model บทบาท model / สร้าง Lakehouse แรก / Semantic Model บน SQL endpoint / ภาพรวม Warehouse | default model ยกเลิกแล้วทั้งกระบวนการ — สอนด้วย New semantic model (ลิงก์ประกาศใน note) |
| Dataflow Gen2 แนะนำ | Fast Copy (ingest ใหญ่บาง connector วิ่งบน Copy engine) + ตัวแปร CI/CD สำหรับ Git integration |
| สรุปการนำเข้า Warehouse | Copy job — item ใหม่ของ Data Factory สำหรับงาน copy ล้วน มี incremental/CDC ในตัว เรียกจาก pipeline ได้ |
| ตาราง Microsoft Fabric Runtime | Runtime 2.0 GA (Spark 4.1, Delta 4) กำลังเป็น default ของ item ใหม่; Runtime 1.3 LTS ถึง มี.ค. 2027; 1.1/1.2 หมดการสนับสนุน — ตรวจรุ่นจริงบน tenant ก่อนสอน |
| Flow แก้ไข Semantic Model (ชุด endpoint) | ทำบน semantic model ที่สร้างเอง (New semantic model) — ปุ่ม Manage default model ถูกถอด |
| ปม Mark as date table บน Lakehouse | นอกจากสมมติฐาน type/ค่าซ้ำ ให้ทดสอบบน model ที่สร้างเองเสมอ (default ไม่มีแล้ว) |
| License ชุด Trial/F/P/PPU | Trial ยืนยัน 60 วัน/64 CU/1 TB + tenant ละ 5 ครั้ง + ลบ item 7 วันหลังหมดอายุ; Copilot ใช้ได้กับ paid F SKU (F2+) ไม่รวม Pro/PPU; ตรวจราคา/SKU ปัจจุบันก่อนคาบ |

## 4. ภาคผนวกท้ายเด็ค (สไลด์ใหม่ที่เพิ่ม)

ชุดสไลด์ "ภาคผนวก v6.1 — อัปเดตให้ทันสมัย" ต่อท้ายเด็ค:

1. หน้าชื่อภาคผนวก + หลักการ (อิง MS Learn ล่าสุด, ไม่ผูกเลขหน้า)
2. Default Semantic Model ถูกยกเลิก — ไทม์ไลน์และสิ่งที่ต้องทำ
3. วิธีทำงานกับ Semantic Model วันนี้ (New semantic model / model editor)
4. Fabric Trial ปัจจุบัน (60 วัน / 64 CU / 1 TB / 5 ต่อ tenant / ลบ 7 วันหลังหมดอายุ)
5. Spark Runtime วันนี้ (2.0 GA / 1.3 LTS / 1.1-1.2 retired)
6. Dataflow Gen2 วันนี้ (Fast Copy / CI-CD และข้อจำกัด Git-integrated)
7. Copy job — ตัวใหม่ใน Data Factory (เทียบ pipeline/dataflow)
8. Lakehouse วันนี้ (schema-enabled / SQL endpoint / Materialized Lake Views)
9. Copilot ใน Fabric (ขอบเขต + เงื่อนไข SKU)
10. OneLake วันนี้ (security GA + shortcut transformations)
11. ศัพท์ที่ควรใช้/เลี่ยง (default model → custom model ฯลฯ)
12. สิ่งที่ผู้สอนต้องเดินตรวจก่อนคาบ (เชื่อมกับ preclass-checklist)
13. แหล่งอ้างอิงทั้งหมด (ลิงก์ MS Learn + ประกาศ)

## 5. หลักการหน้าจูงใจ: เด็คไม่ผูกเลขหน้า

เอกสารประกอบทั้งชุด (repo) **ไม่อ้างเลขหน้าสไลด์** — อ้างด้วยชื่อหัวข้อ/item/ปุ่ม เพื่อให้เด็คแก้ไข-เรียงใหม่ได้อิสระ เมื่อแก้เด็ครอบหน้า: แก้ตามชื่อหัวข้อในไฟล์นี้ ไม่ต้องไล่ตามเลขหน้า

## 6. สไลด์แทรกหลังสไลด์โมดูล Shortcut (Workshop 14): ทิศ External + ของใหม่ 2026

เด็คเดิมคงไว้ทั้งหมด (แล็บ Warehouse shortcut ยังใช้อยู่) — แทรกเพิ่ม 3 หน้า **หลังสไลด์เดโม shortcut Internal ก่อนสไลด์สรุปโมดูล** เพื่อสอนแล็บแทรก [LAB-EXTERNAL.md](../day-2/13-shortcuts/LAB-EXTERNAL.md):

1. **"Shortcut สองทิศ: Internal ↔ External"**
   - Internal = ของใน OneLake เอง (Lakehouse, Warehouse, KQL ฯลฯ) — ใช้สิทธิ์ของผู้เรียก
   - External = ADLS Gen2, Azure Blob Storage, S3, GCS, Dataverse, OneDrive/SharePoint — ใช้ connection ที่เก็บ credential ไว้
   - จุดพีคสำหรับห้องเรียน: **Anonymous** เป็น auth kind ที่เลือกได้กับ Azure Blob Storage — ข้อมูลสาธารณะจึงทำแล็บได้โดยไม่ต้องมี Azure subscription
   - อ้างอิง: [Create an Azure Blob Storage shortcut](https://learn.microsoft.com/en-us/fabric/onelake/shortcuts/create-blob-shortcut)

2. **"แล็บ 14B — จาก Parquet สาธารณะสู่ Delta table"** (flow หน้าเดียว)
   - `azureopendatastorage` (Azure Open Datasets — NYC Taxi, Parquet) → New table shortcut → Authentication **Anonymous** → โฟลเดอร์ `nyctlc/green/puYear=2019/puMonth=1` → Transform → Delta table ใน Tables
   - จุดเชอร์: หน้า **Manage shortcut** แสดง Refresh history — Fabric sync ต้นทางทุก 2 นาที

3. **"Pointer vs Auto-sync copy — อ่าน shortcut ให้เป็น"**
   - Pure shortcut (W14): pointer ล้วน ไม่มีการ copy ไม่กิน storage
   - Shortcut transformation (W14B, GA สำหรับ CSV/Parquet/JSON): Fabric Spark แปลงไฟล์เป็น managed Delta table และ sync ทุก 2 นาที — กิน storage จริง
   - ต้นทางเป็น Delta อยู่แล้ว → ไม่มีขั้น Transform กลับเป็น pointer ล้วน (ตัวอย่างที่ผู้สอนเผยแพร่เอง: [`publish-delta-source.md`](publish-delta-source.md))
   - อ้างอิง: [Shortcut transformations](https://learn.microsoft.com/en-us/fabric/onelake/shortcuts/transformations) · [Shortcuts in a lakehouse](https://learn.microsoft.com/en-us/fabric/data-engineering/lakehouse-shortcuts)
