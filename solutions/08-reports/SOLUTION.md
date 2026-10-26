# Workshop 8 + 9 + 10 + บททดสอบ 10-1 — Reports

## ผลลัพธ์สุดท้าย

```text
My workspace
├── Auto Sales Report        (auto-create จาก model)
└── report จาก Desktop       (publish ลง My workspace, หน้า Sales Overview ครบ 6 visuals)
```

## เกณฑ์ตรวจหน้า Sales Overview

- New Card แสดง Revenue (มี image + accent bar ตามเอกสาร New card ของ Power BI)
- Table ต่อ Model + Top N (Top 10 by Revenue, มี Title)
- Clustered column ใช้ hierarchy Calendar และ drill down ได้
- Map แสดงตาม geography hierarchy
- Slicer category แบบ Tile กรองทุก visual
- ทุก visual ใช้ measure (Revenue) ไม่ใช่ SUM ของคอลัมน์ดิบ

## เฉลยแนวทางบททดสอบ 10-1

| ข้อ | เครื่องมือ |
|---|---|
| 1. Model ขายดีสุดปี 2014 | Table Top 10 + slicer ปี 2014 (หรือ sort ตารางด้วย Revenue) |
| 2. เดือนสูงสุดในปีนั้น | drill down column chart ถึงระดับเดือน |
| 3. ประเทศที่ Bikes ขายดีสุด | slicer category = Bikes → Map/bar by Country |
| 4. ยอดขายข้อ 3 | tooltip หรือ card จาก visual ข้อ 3 |
| 5. City สูงสุดในประเทศนั้น | drill down map ลง City |

> ตัวเลขคำตอบขึ้นกับ dataset ที่ห้องโหลด — ผู้สอนซ้อมก่อนเรียนแล้วจดตัวเลขจริงที่นี่:
> 1. Model = `____`
> 2. เดือน = `____`
> 3. ประเทศ = `____`
> 4. ยอดขาย = `____`
> 5. City = `____`

## จุดพังที่พบ

| อาการ | แก้ |
|---|---|
| Data hub ไม่เห็น model | บัญชี Desktop ≠ บัญชี Fabric — sign in ให้ตรง |
| Map ว่าง | ตั้ง Data category ให้คอลัมน์ geography |
| Top N ไม่ทำงาน | ใส่ by value = Revenue แล้วกด Apply |
| เลขไม่ตรงกันระหว่าง visual | ใช้ measure ไม่ใช่ aggregate ของ column |
