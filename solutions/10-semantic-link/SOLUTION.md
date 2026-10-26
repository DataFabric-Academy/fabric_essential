# Workshop 11-1 — Semantic Link

## ผลลัพธ์สุดท้าย

```text
My workspace
├── Customer Profitability Sample          (semantic model จาก pbix)
├── Customer Profitability Sample          (report)
├── Customer Profitability Sample          (dashboard)
└── Semantic_Link_Demo                     (notebook, รันจบ 24 cells)
```

## ผลอ้างอิงทีละ cell

| Cell | เรียก | ผลที่ควรเห็น |
|---|---|---|
| 1 | `%pip install semantic-link` | ติดตั้ง + session รีสตาร์ท |
| 6 | `fabric.read_table(model, 'Customer')` | ตารางลูกค้าแสดง |
| 8 | `type(customer_df)` | pandas / Fabric DataFrame (ไม่ใช่ Spark) |
| 10 | `customer_df.shape` | `(___, ___)` — จดจากการซ้อม: ___ |
| 12 | `list_relationships` | รายการ relationship หลายแถว |
| 14 | `plot_relationship_metadata` | กราฟผังความสัมพันธ์ |
| 16 | `list_measures` | เห็น `Total Revenue` |
| 18 | `evaluate_measure('Total Revenue')` | ค่าเดียว = ___ |
| 20 | `evaluate_measure(..., groupby_columns=["Product[Product]"])` | ยอดต่อสินค้าหลายแถว |
| 23 | `list_relationship_violations` | ตารางผลตรวจ (คาดหวังว่างหรือใกล้ 0) |

## ตรวจผ่าน

- จำนวนแถว Customer ที่ cell 10 ตรงกับการซ้อมของผู้สอน
- ยอด Total Revenue (cell 18) ตรงกับที่รายงาน pbix แสดง — สองทางต้องเท่ากันเพราะอ่าน model เดียวกัน

## จุดพังที่พบ

| อาการ | แก้ |
|---|---|
| ModelNotFound | pbix ยังไม่อัปโหลด/ชื่อไม่ตรง |
| ModuleNotFoundError sempy | รัน cell 1 แล้วรันใหม่จากบนลงล่าง |
| session ตายกลางทาง | Restart session แล้วรันตามลำดับ |
