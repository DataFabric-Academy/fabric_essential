# Workshop 12-1 + 12-2 — Lakehouse เริ่มต้น

## ผลลัพธ์สุดท้าย

```text
My workspace
├── AdventureworksLH                    (Lakehouse)
│   ├── Files
│   │   ├── Source/
│   │   │   ├── DimReseller.csv
│   │   │   └── DimGeopraphy.csv        (สะกดตาม repo — ห้ามเปลี่ยน)
│   │   └── external/                   (โฟลเดอร์ว่าง รอ Workshop 13)
│   └── Tables                          (ยังว่าง)
├── AdventureworksLH                    (SQL analytics endpoint)
└── AdventureworksLH                    (default semantic model)
```

## ตรวจ

1. Explorer แสดงไฟล์ 2 ตัวใต้ `Files/Source/`
2. Notebook 12-2: `display(df)` เห็น 3 แถว; `type(pdf)` เป็น pandas DataFrame
3. Data Wrangler เปิดจาก `pdf` ได้

## จุดพังที่พบ

| อาการ | แก้ |
|---|---|
| อัปโหลดแล้วหาไม่เจอ | อยู่ Files ไม่ใช่ Tables — ตรวจโฟลเดอร์ปลายทางตอน upload |
| Data Wrangler ไม่เปิด | ใช้กับ pandas DataFrame (`pdf`) ไม่ใช่ Spark `df` |
| SQL endpoint ไม่ตอบ SELECT * FROM Files | อ่านได้เฉพาะ Tables — พฤติกรรมถูกต้อง |
| ชื่อไฟล์ถูกแก้เป็น DimGeography | ตั้งกลับ — notebook โมดูล 12 อ้างชื่อต้นฉบับตรง ๆ |
