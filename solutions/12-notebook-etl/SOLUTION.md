# Workshop 13 — ETL ด้วย Notebook

## ผลลัพธ์สุดท้าย

```text
AdventureworksLH
├── Tables
│   ├── manage_DimReseller            (managed Delta table)
│   └── external_DimReseller          (external Delta table)
└── Files
    └── external/external_DimReseller/  (ไฟล์ Parquet + _delta_log ของ external)
```

## ตรวจ (CHECK.sql)

รันไฟล์ [`CHECK.sql`](CHECK.sql) ที่ SQL analytics endpoint ของ Lakehouse — คาดหวังทุกแถว `OK`

## จุดเชิงแนวคิดที่ต้องตอบได้

| คำถาม | คำตอบอ้างอิง |
|---|---|
| ลบ manage_DimReseller แล้วไฟล์? | หาย — Fabric เป็นเจ้าของไฟล์ |
| ลบ external_DimReseller แล้วไฟล์? | ยังอยู่ที่ `Files/external/...` |
| cell ไหนตัดสิน managed/external | มี/ไม่มี `path=` ใน `saveAsTable` |
| ทำไม COUNT สองตารางเท่ากัน | เขียนจาก DataFrame เดียวกัน — ต่างแค่ที่เก็บไฟล์ |

## จุดพังที่พบ

| อาการ | แก้ |
|---|---|
| Path not found | notebook ยังไม่ผูก lakehouse หรือชื่อไฟล์ไม่ตรง (DimGeopraphy.csv) |
| Delta table already exists | คง `mode("overwrite").option("overwriteSchema","true")` จาก notebook |
| SQL endpoint ยังไม่เห็นตาราง | กด Refresh ที่ endpoint รอ metadata sync |
