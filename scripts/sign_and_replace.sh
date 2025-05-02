#!/usr/bin/env bash
set -euo pipefail

TIFF_PATH="/global_vs30_Cnv_Cnv.tif"
DOMAIN="https://d1f1pd1jtui8d5.cloudfront.net"
KEY_PAIR_ID="K3BYPE7UJNJQVV"
PRIVATE_KEY_FILE="./vs30_private.pem"
MAINJS="./js/main.js"                 # <— tam yol

# 1) 3 gün sonrası epoch
EXP=$(( $(date +%s) + 259200 ))

# 2) imzalı URL
SIGNED=$(aws cloudfront sign \
   --url "${DOMAIN}${TIFF_PATH}" \
   --key-pair-id "${KEY_PAIR_ID}" \
   --private-key "file://${PRIVATE_KEY_FILE}" \
   --date-less-than "${EXP}" \
   --output text)

# 3) main.js içinde değiştir
sed -i.bak -E \
  "s|(const[[:space:]]+url_to_geotiff_file[[:space:]]*=[[:space:]]*\").*(\";)|\1${SIGNED}\2|" \
  "${MAINJS}"

echo "🔑  Signed URL injected into ${MAINJS}"
#
