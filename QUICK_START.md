# Quick Start Guide

## Build ROM với URL đã cung cấp

Bạn đã cung cấp URL ROM cho device **houji** (Xiaomi 14 Ultra).

### Cách 1: Sử dụng Quick Build Script (Khuyên dùng)

```bash
# Set quyền thực thi
chmod +x quick_build.sh

# Chạy build
./quick_build.sh
```

Script sẽ hỏi bạn có muốn patch framework và boot không.

### Cách 2: Sử dụng Build Script trực tiếp

```bash
# Build cơ bản
./scripts/build.sh \
    -d houji \
    -u "https://bkt-sgp-miui-ota-update-alisgp.oss-ap-southeast-1.aliyuncs.com/OS3.0.3.0.WNCTWXM/houji_tw_global-ota_full-OS3.0.3.0.WNCTWXM-user-16.0-cd22a3b35d.zip" \
    -r GLOBAL

# Build với patch framework và boot
./scripts/build.sh \
    -d houji \
    -u "https://bkt-sgp-miui-ota-update-alisgp.oss-ap-southeast-1.aliyuncs.com/OS3.0.3.0.WNCTWXM/houji_tw_global-ota_full-OS3.0.3.0.WNCTWXM-user-16.0-cd22a3b35d.zip" \
    -r GLOBAL \
    -f -b
```

### Thông tin ROM

- **Device**: houji (Xiaomi 14 Ultra)
- **Region**: Taiwan Global (GLOBAL)
- **Version**: OS3.0.3.0.WNCTWXM
- **Android**: 16.0

### Output

Sau khi build xong, file output sẽ là:
```
houji_fastboot.zip
```

### Lưu ý

1. Đảm bảo đã cài đặt đầy đủ dependencies (xem README.md)
2. Có đủ dung lượng ổ cứng (ít nhất 20GB free)
3. Kết nối internet ổn định để download ROM
