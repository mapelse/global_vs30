#!/usr/bin/env bash
### signs CloudFront URL and patches main.js  #########################

set -euo pipefail

TIFF_PATH="/global_vs30_Cnv_Cnv.tif"
DOMAIN="https://d1f1pd1jtui8d5.cloudfront.net"          # CF domain veya CNAME
KEY_PAIR_ID="K3BYPE7UJNJQVV"                             # PublicKey ID
PRIVATE_KEY_FILE="./vs30_private.pem"                    # repo'da değil! (bak → secrets)
MAINJS="js/main.js"                                  # URL'nin durduğu dosya

# 1) Yeni expire (3 gün = 259 200 s)
EXP=$(($(date +%s) + 259200))

# 2) imzala
SIGNED=$(aws cloudfront sign \
   --url "${DOMAIN}${TIFF_PATH}" \
   --key-pair-id "${KEY_PAIR_ID}" \
   --private-key "file://${PRIVATE_KEY_FILE}" \
   --date-less-than "${EXP}" \
   --output text)

# 3) main.js içindeki satırı değiştir
#    (URL çift tırnak içinde, tek satır)
sed -i.bak -E \
  "s|const url_to_geotiff_file = \".*\";|const url_to_geotiff_file = \"${SIGNED}\";|" \
  "${MAINJS}"

echo "🔑  Signed URL injected into ${MAINJS}"
