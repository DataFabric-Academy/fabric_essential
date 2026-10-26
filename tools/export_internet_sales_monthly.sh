#!/usr/bin/env bash
# Export dbo.FactInternetSales from Azure SQL (AdventureworksDW2025) to monthly
# pipe-delimited CSV files, one file per OrderDate month.
#
# Usage: ./tools/export_internet_sales_monthly.sh [output-dir]
# Requires: sqlcmd (go-sqlcmd) signed in with Azure AD (az login)

set -euo pipefail

SERVER="ake.database.windows.net"
DATABASE="AdventureworksDW2025"
TABLE="dbo.FactInternetSales"
OUT_DIR="${1:-export_internet_sales}"

COLUMNS=$(cat <<'SQL'
ProductKey, OrderDateKey, DueDateKey, ShipDateKey, CustomerKey, PromotionKey,
CurrencyKey, SalesTerritoryKey, SalesOrderNumber, SalesOrderLineNumber,
RevisionNumber, OrderQuantity, UnitPrice, ExtendedAmount, UnitPriceDiscountPct,
DiscountAmount, ProductStandardCost, TotalProductCost, SalesAmount, TaxAmt,
Freight,
ISNULL(CarrierTrackingNumber,'') AS CarrierTrackingNumber,
ISNULL(CustomerPONumber,'') AS CustomerPONumber,
ISNULL(CONVERT(varchar(19), OrderDate, 120),'') AS OrderDate,
ISNULL(CONVERT(varchar(19), DueDate, 120),'') AS DueDate,
ISNULL(CONVERT(varchar(19), ShipDate, 120),'') AS ShipDate
SQL
)

mkdir -p "$OUT_DIR"

ym=2010-12
while [[ "$ym" < "2014-02" ]]; do
  y="${ym:0:4}"; m="${ym:5:2}"
  next=$(date -d "${ym}-01 +1 month" +%F)
  file="$OUT_DIR/FactInternetSales_${ym}.csv"
  echo "Exporting ${ym} -> ${file}"
  sqlcmd -S "$SERVER" -d "$DATABASE" --authentication-method ActiveDirectoryDefault \
    -Q "SET NOCOUNT ON; SELECT ${COLUMNS} FROM ${TABLE} WHERE OrderDate >= '${ym}-01' AND OrderDate < '${next}';" \
    -s"|" -W -l 60 | sed -e '2d' -e '/^[[:space:]]*$/d' > "$file"
  ym=$(date -d "${ym}-01 +1 month" +%Y-%m)
done

echo "--- Summary ---"
total=0
for f in "$OUT_DIR"/FactInternetSales_*.csv; do
  rows=$(( $(wc -l < "$f") - 1 ))
  total=$(( total + rows ))
  printf "%s  %d rows\n" "$(basename "$f")" "$rows"
done
echo "TOTAL: $total rows in $(ls "$OUT_DIR"/FactInternetSales_*.csv | wc -l) files"
