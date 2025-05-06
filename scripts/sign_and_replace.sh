#!/usr/bin/env bash
set -euo pipefail

TIFF_PATH="/global_vs30_Cnv_Cnv.tif"
DOMAIN="https://d1f1pd1jtui8d5.cloudfront.net"
KEY_PAIR_ID="K3BYPE7UJNJQVV"
PRIVATE_KEY_FILE="./vs30_private.pem"
MAINJS="./js/main.js"

# 1) 3 gün sonrası epoch
EXP=$(( $(date +%s) + 259200 ))

# 2) imzalı URL üret
SIGNED=$(aws cloudfront sign \
   --url "${DOMAIN}${TIFF_PATH}" \
   --key-pair-id "${KEY_PAIR_ID}" \
   --private-key "file://${PRIVATE_KEY_FILE}" \
   --date-less-than "${EXP}" \
   --output text)

# 3) main.js içindeki eski URL’yi yenisiyle değiştir
echo ">>> SED ÖNCESİ:"
grep -n 'url_to_geotiff_file' "${MAINJS}" | head -1

sed -i.bak -E \
  '/var url_to_geotiff_file *=/c\var url_to_geotiff_file = "'"${SIGNED}"'";' \
  "${MAINJS}"

echo ">>> SED SONRASI:"
grep -n 'url_to_geotiff_file' "${MAINJS}" | head -1

echo "🔑  Signed URL injected into ${MAINJS}"
