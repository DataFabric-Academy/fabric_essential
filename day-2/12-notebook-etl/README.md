# Module 12 — ETL ด้วย Notebook: managed กับ external Delta Table

> ⏱ ~30 นาที · 🎯 รัน ETL notebook ครบและจับต้องความต่าง managed กับ external ได้ · saveAsTable with no path is managed; with a path, the files are yours.

## Key idea / แนวคิดหลัก — เล่าเรื่อง

โมดูลก่อนคุณมีไฟล์ CSV ดิบวางใน Files แล้ว แต่ยังไม่ใช่ตาราง — โมดูลนี้คุณจะเปลี่ยนมันด้วยมือตัวเองผ่าน PySpark ใน notebook `LH/ETL DimReseller.ipynb` เส้นเรื่องของ ETL นี้คือเรื่องเดียวกับที่ทีมข้อมูลทำทุกวัน: อ่านของดิบ, ตัดส่วนที่ไม่ใช้, ต่อข้อมูลจากสองแหล่ง, จัดชื่อ-จัดชนิดให้คนอื่นใช้ต่อได้ แล้วเขียนออกเป็นตาราง

เส้นทางของ notebook มีห้าองค์:

1. อ่าน `Files/Source/DimReseller.csv` เข้า Spark DataFrame (header=true) — ตอนนี้ทุกคอลัมน์เป็น string ทั้งหมด เพราะ Spark ไม่เดา type ให้เกินกว่าที่คุณบอก
2. `drop()` คอลัมน์ที่ไม่ใช้ 13 ตัว (ResellerAlternateKey, Phone, ที่อยู่, ตัวเลขพนักงาน ฯลฯ) — ตัดสิ่งที่ BI ไม่ต้องใช้ตั้งแต่ปลายน้ำต้น
3. อ่าน `DimGeopraphy.csv` → drop อีก 5 คอลัมน์ → **join** สอง DataFrame บน GeographyKey — สังเกตว่ามันคือ JOIN เดียวกับที่คุณเขียน SQL มาทั้งชีวิต แต่อยู่ในรูป `.join()` และกระจายงานไปหลายเครื่องเอง
4. `withColumnRenamed` เปลี่ยนชื่อให้เป็นภาษาธุรกิจ (StateProvinceName → Province) และ `cast("Integer")` ให้ ResellerKey กลับมาเป็นตัวเลข
5. เขียนออกเป็น Delta table **สองแบบ** — และนี่คือหัวใจของโมดูล:

```python
# Managed: Fabric เป็นเจ้าของไฟล์ทั้งหมด (เก็บในโฟลเดอร์ Tables)
output_df.write.format("delta").mode("overwrite") \
    .option("overwriteSchema", "true").saveAsTable("manage_DimReseller")

# External: metadata อยู่ใน lakehouse แต่ไฟล์อยู่ที่ path ที่คุณชี้
output_df.write.format("delta") \
    .saveAsTable("external_DimReseller", path="Files/external/external_DimReseller")
```

ความต่างอยู่ที่การมี/ไม่มี `path=` — ไม่ใส่ path = **managed table**: Fabric จัดการไฟล์ใน Tables ทั้งหมด ลบ table ไฟล์หายตาม ใส่ path = **external table**: คุณเป็นเจ้าของไฟล์ที่ `Files/external/...` ลบ table แล้วไฟล์ยังอยู่ — ในแล็บคุณจะลบของจริงเพื่อพิสูจน์ข้อความนี้ ไม่ใช่แค่เชื่อ

> EN: Same DataFrame, two destinies — managed under Tables/, external under your own path.

## Concept / เนื้อหา

- **เมื่อไหร่ใช้ external** — เมื่อไฟล์มีเจ้าของอื่น (แชร์ร่วมกับ process อื่น), เมื่อต้องการควบคุมที่เก็บเอง หรือเมื่ออยากลบ/สร้าง table รอบ ๆ ได้โดยไฟล์ไม่ตก ที่เหลือ managed ง่ายและสะอาดกว่า
- **`mode("overwrite")` + `overwriteSchema=true`** — ทำให้รัน notebook ซ้ำได้ปลอดภัยแม้ schema เปลี่ยน นี่คือเวอร์ชัน Spark ของ "Replace" ที่คุณตั้งใน Dataflow วันแรก
- **แถวชนิดข้อมูล** — อ่าน CSV มาทุกอย่างเป็น string cast ทีหลังเป็นการฝึกที่ดี เพราะงานจริงคุณต้องเลือกว่า cast ก่อน join หรือหลัง (ถ้า key สองฝั่งชนิดไม่ตรง join จะคืนแถว 0 — บั๊กที่เงียบที่สุดของโลก ETL)

## ลงมือทำตามลำดับ

ตาม [LAB.md](LAB.md) — ไฟล์: `LH/ETL DimReseller.ipynb`

## Common pitfalls / กับดัก

- รัน notebook โดยไม่ผูก Lakehouse — `Files/...` หา path ไม่เจอทันที
- รันสองรอบแล้วกลัวข้อมูลซ้ำ — `mode("overwrite")` ทับให้เอง ไม่ต้องกลัว แต่ถ้าคุณแก้ cell แล้วเผลอตัด mode นี้ออก ตารางจะคูณแถว
- ลบ external table แล้วเข้าใจว่าไฟล์หาย — ไฟล์ยังอยู่ที่ `Files/external/...` เสมอ ใช้จุดนี้สอนตัวเอง
- แตะชื่อไฟล์ DimGeopraphy.csv — notebook อ้างตรง ๆ

## Quick check / ทบทวน

<details>
<summary>1. ลบ managed table กับ external table ต่างกันยังไง</summary>
ลบ managed = ไฟล์หายด้วย ลบ external = ตัด metadata ไฟล์ยังอยู่ที่ path เดิม
</details>

<details>
<summary>2. overwriteSchema=true ทำเมื่อไหร่</summary>
เมื่อ overwrite ตารางเดิมที่ schema อาจเปลี่ยน — ไม่งั้น write ซ้ำจะชน schema
</details>

<details>
<summary>3. join นี้เกิดที่ไหน</summary>
บน Spark compute ของ session — ข้อมูลยังอยู่ใน OneLake ทั้งก่อนและหลัง
</details>

## Go deeper

- [Lakehouse and Delta Lake tables](https://learn.microsoft.com/en-us/fabric/data-engineering/lakehouse-and-delta-tables)
- [How to use Fabric notebooks](https://learn.microsoft.com/en-us/fabric/data-engineering/how-to-use-notebook)
- [PySpark DataFrame API](https://spark.apache.org/docs/latest/api/python/reference/pyspark.sql.html)
