#!/bin/bash

#==============================================================================
#  Quick Build Script - Build ROM with predefined URL
#==============================================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# ROM URL from user
ROM_URL="https://bkt-sgp-miui-ota-update-alisgp.oss-ap-southeast-1.aliyuncs.com/OS3.0.3.0.WNCTWXM/houji_tw_global-ota_full-OS3.0.3.0.WNCTWXM-user-16.0-cd22a3b35d.zip"

# Extract device name from URL (houji)
DEVICE="houji"

# Region (tw_global = Taiwan Global = GLOBAL)
REGION="GLOBAL"

# Colors
CYAN='\033[1;36m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${CYAN}╔══════════════════════════════════════════════════════════════════════╗${NC}"
echo -e "${CYAN}║                    QUICK BUILD - HOUJI ROM                          ║${NC}"
echo -e "${CYAN}╠══════════════════════════════════════════════════════════════════════╣${NC}"
echo -e "${CYAN}║${NC} Device:    ${GREEN}${DEVICE}${NC}"
echo -e "${CYAN}║${NC} Region:    ${GREEN}${REGION}${NC}"
echo -e "${CYAN}║${NC} URL:       ${YELLOW}${ROM_URL:0:60}...${NC}"
echo -e "${CYAN}╚══════════════════════════════════════════════════════════════════════╝${NC}"
echo ""

# Ask for options
read -p "Patch Framework? (y/n) [n]: " patch_fw
PATCH_FRAMEWORK=""
if [ "$patch_fw" == "y" ] || [ "$patch_fw" == "Y" ]; then
    PATCH_FRAMEWORK="-f"
fi

read -p "Patch Boot with Magisk? (y/n) [n]: " patch_boot
PATCH_BOOT=""
if [ "$patch_boot" == "y" ] || [ "$patch_boot" == "Y" ]; then
    PATCH_BOOT="-b"
fi

echo ""
echo "Starting build..."
echo ""

# Run build script
"${SCRIPT_DIR}/scripts/build.sh" \
    -d "$DEVICE" \
    -u "$ROM_URL" \
    -r "$REGION" \
    $PATCH_FRAMEWORK \
    $PATCH_BOOT
