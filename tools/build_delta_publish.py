"""เตรียม Delta tables ของคอร์สสำหรับเผยแพร่ขึ้น Storage Account สาธารณะ

ใช้โดยผู้สอนก่อนวันสอน — ขั้นตอนเต็มอยู่ที่ instructor/publish-delta-source.md

    pip install "deltalake" pandas
    python tools/build_delta_publish.py --out publish_delta

ผลลัพธ์: publish_delta/dimdate          (ปฏิทิน AdventureWorksDW 2010-12-29..2014-01-28)
         publish_delta/FactInternetSales (รวมทุกเดือนจาก export_internet_sales/*.csv)
"""
import argparse
from pathlib import Path

import pandas as pd
from deltalake import write_deltalake

ROOT = Path(__file__).resolve().parents[1]

DAY_NAMES = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]


def build_dimdate() -> pd.DataFrame:
    # ช่วงปฏิทินชุด AdventureWorksDW (2,192 วัน) เพื่อเทียบ COUNT กับ dw.DimDate
    dates = pd.date_range("2010-12-29", "2014-01-28", freq="D")
    return pd.DataFrame({
        "DateKey": dates.strftime("%Y%m%d").astype("int64"),
        "FullDateAlternateKey": dates.strftime("%Y-%m-%d"),
        "DayNumberOfWeek": ((dates.weekday + 1) % 7) + 1,
        "EnglishDayNameOfWeek": [DAY_NAMES[(d.weekday + 1) % 7] for d in dates],
        "EnglishMonthName": dates.strftime("%B"),
        "MonthNumberOfYear": dates.month,
        "CalendarQuarter": ((dates.month - 1) // 3) + 1,
        "CalendarYear": dates.year,
    })


def build_fact_internet_sales() -> pd.DataFrame | None:
    files = sorted((ROOT / "export_internet_sales").glob("*.csv"))
    if not files:
        return None
    # export ของคอร์สคั่นด้วย pipe (หัวคอลัมน์เริ่ม ProductKey|OrderDateKey|...)
    return pd.concat((pd.read_csv(f, sep="|") for f in files), ignore_index=True)


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--out", default="publish_delta", help="โฟลเดอร์ปลายทาง")
    args = parser.parse_args()
    out = (ROOT / args.out).resolve()
    out.mkdir(parents=True, exist_ok=True)

    write_deltalake(out / "dimdate", build_dimdate(), mode="overwrite")
    print(f"dimdate -> {out / 'dimdate'}")

    fact = build_fact_internet_sales()
    if fact is not None:
        write_deltalake(out / "FactInternetSales", fact, mode="overwrite")
        print(f"FactInternetSales ({len(fact)} แถว) -> {out / 'FactInternetSales'}")
    else:
        print("ข้าม FactInternetSales — ไม่พบ export_internet_sales/*.csv")


if __name__ == "__main__":
    main()
