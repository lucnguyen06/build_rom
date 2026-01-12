#!/bin/bash

#==============================================================================
#  Quick Build Script for Houji (Xiaomi 14 Ultra)
#==============================================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROM_URL="https://bkt-sgp-miui-ota-update-alisgp.oss-ap-southeast-1.aliyuncs.com/OS3.0.3.0.WNCTWXM/houji_tw_global-ota_full-OS3.0.3.0.WNCTWXM-user-16.0-cd22a3b35d.zip"
DEVICE="houji"
REGION="GLOBAL"

echo "=========================================="
echo "  Building ROM for: $DEVICE"
echo "  Region: $REGION"
echo "=========================================="
echo ""

# Run build script
"${SCRIPT_DIR}/scripts/build.sh" \
    -d "$DEVICE" \
    -u "$ROM_URL" \
    -r "$REGION" \
    "$@"
