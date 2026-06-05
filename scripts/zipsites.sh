#!/bin/bash
# zip_sites.sh — packages all built sites into a single ZIP
# Usage: bash scripts/zip_sites.sh [output_name]

OUTPUT=${1:-all_sites}
SITES_DIR="/tmp/sites"
OUT_PATH="/mnt/user-data/outputs/${OUTPUT}.zip"

echo "📦 Packaging sites from ${SITES_DIR}..."

if [ ! -d "$SITES_DIR" ]; then
  echo "❌ Error: ${SITES_DIR} not found. Run Agent 2 first."
  exit 1
fi

SITE_COUNT=$(ls -d ${SITES_DIR}/biz_* 2>/dev/null | wc -l)
echo "   Found ${SITE_COUNT} site folders."

cd /tmp
zip -r "${OUTPUT}.zip" sites/ -x "*.DS_Store"

cp "/tmp/${OUTPUT}.zip" "$OUT_PATH"

echo "✅ ZIP created: ${OUT_PATH}"
echo "   Size: $(du -sh /tmp/${OUTPUT}.zip | cut -f1)"
echo "   Sites: ${SITE_COUNT}"
