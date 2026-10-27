#!/usr/bin/env bash
# Export dbo.FactResellerSales from Azure SQL (AdventureworksDW2025) to monthly
# pipe-delimited CSV files, one file per OrderDate month.
# Only months that actually have rows are exported.
#
# Usage: ./tools/export_reseller_sales_monthly.sh [output-dir]
# Requires: sqlcmd (go-sqlcmd) signed in with Azure AD (az login)

set -euo pipefail

SERVER="ake.database.windows.net"
DATABASE="AdventureworksDW2025"
TABLE="dbo.FactResellerSales"
OUT_DIR="${1:-export_reseller_sales/csv}"

COLUMNS=$(cat <<'SQL'
ProductKey, OrderDateKey, DueDateKey, ShipDateKey, ResellerKey, EmployeeKey,
PromotionKey, CurrencyKey, SalesTerritoryKey, SalesOrderNumber,
SalesOrderLineNumber, RevisionNumber, OrderQuantity, UnitPrice, ExtendedAmount,
UnitPriceDiscountPct, DiscountAmount, ProductStandardCost, TotalProductCost,
SalesAmount, TaxAmt, Freight,
ISNULL(CarrierTrackingNumber,'') AS CarrierTrackingNumber,
ISNULL(CustomerPONumber,'') AS CustomerPONumber,
ISNULL(CONVERT(varchar(19), OrderDate, 120),'') AS OrderDate,
ISNULL(CONVERT(varchar(19), DueDate, 120),'') AS DueDate,
ISNULL(CONVERT(varchar(19), ShipDate, 120),'') AS ShipDate
SQL
)

mkdir -p "$OUT_DIR"

months=$(sqlcmd -S "$SERVER" -d "$DATABASE" --authentication-method ActiveDirectoryDefault \
  -Q "SET NOCOUNT ON; SELECT DISTINCT CONVERT(varchar(7), OrderDate, 126) FROM ${TABLE} ORDER BY 1;" \
  -W -h -1 -l 60 | tr -d '\r')

for ym in $months; do
  next=$(date -d "${ym}-01 +1 month" +%F)
  file="$OUT_DIR/FactResellerSales_${ym}.csv"
  echo "Exporting ${ym} -> ${file}"
  sqlcmd -S "$SERVER" -d "$DATABASE" --authentication-method ActiveDirectoryDefault \
    -Q "SET NOCOUNT ON; SELECT ${COLUMNS} FROM ${TABLE} WHERE OrderDate >= '${ym}-01' AND OrderDate < '${next}';" \
    -s"|" -W -l 60 | sed -e '2d' -e '/^[[:space:]]*$/d' > "$file"
done

echo "--- Summary ---"
total=0
for f in "$OUT_DIR"/FactResellerSales_*.csv; do
  rows=$(( $(grep -c . "$f") - 1 ))
  total=$(( total + rows ))
  printf "%s  %d rows\n" "$(basename "$f")" "$rows"
done
echo "TOTAL: $total rows in $(ls "$OUT_DIR"/FactResellerSales_*.csv | wc -l) files"
