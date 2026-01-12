# ROM Builder Scripts

Bộ scripts để build ROM Android từ Recovery ROM zip thành Fastboot flashable package.

## Cấu trúc Scripts

| Script | Mô tả |
|--------|-------|
| `build.sh` | Script chính - Chạy toàn bộ quá trình build |
| `unpack.sh` | Download và giải nén ROM (payload.bin → images) |
| `repack.sh` | Đóng gói lại images (EROFS + super.img) |
| `patch.sh` | Patch framework files (decompile, patch, recompile) |
| `system.sh` | Modify system partition (xóa app không cần) |
| `vendor.sh` | Modify vendor partition |
| `product.sh` | Modify product partition (theo region) |
| `system_ext.sh` | Modify system_ext partition |
| `patchBOOT.sh` | Patch boot image với Magisk |

## Yêu cầu

### Công cụ cần thiết
- **bash** - Shell script interpreter
- **python3** - Cho các script patch
- **aria2c** hoặc **curl** - Download ROM
- **7z** hoặc **7zzs** - Giải nén zip
- **Java** - Nếu patch framework (cần baksmali/smali)

### Tools trong thư mục `tools/`
- `payload-dumper-go` - Giải nén payload.bin
- `extract.erofs` - Giải nén EROFS partition
- `mkfs.erofs` - Tạo EROFS image
- `lpmake` - Tạo super.img
- `vbmeta-disable-verification` - Patch vbmeta
- `fspatch.py` - Patch filesystem config
- `contextpatch.py` - Patch SELinux contexts

## Cách sử dụng

### 1. Build đầy đủ (Khuyên dùng)

```bash
# Set quyền thực thi
chmod +x scripts/*.sh

# Chạy build
./scripts/build.sh -d <device> -u "<rom_url>" -r <region> [options]
```

**Ví dụ:**
```bash
# Build ROM Global
./scripts/build.sh -d garnet -u "https://bigota.d.miui.com/.../xxx.zip" -r GLOBAL

# Build ROM CN với patch framework và boot
./scripts/build.sh -d garnet -u "https://..." -r CN -f -b
```

**Tham số:**
- `-d, --device` - Tên thiết bị (vd: garnet, marble)
- `-u, --url` - URL download ROM
- `-r, --region` - Region: `GLOBAL` hoặc `CN` (mặc định: GLOBAL)
- `-f, --framework` - Patch framework files
- `-b, --boot` - Patch boot image với Magisk
- `-h, --help` - Hiển thị help

### 2. Chạy từng bước riêng lẻ

#### Step 1: Unpack ROM
```bash
./scripts/unpack.sh <ROM_URL> <DEVICE> <WORKSPACE>
```

#### Step 2: Modify Partitions
```bash
./scripts/system.sh <DEVICE> <WORKSPACE>
./scripts/vendor.sh <DEVICE> <WORKSPACE>
./scripts/product.sh <DEVICE> <WORKSPACE> [REGION]
./scripts/system_ext.sh <DEVICE> <WORKSPACE>
```

#### Step 3: Patch Framework (Optional)
```bash
./scripts/patch.sh <DEVICE> <WORKSPACE> [CORE]
# CORE: true/false (default: false)
```

#### Step 4: Repack Images
```bash
./scripts/repack.sh <DEVICE> <WORKSPACE>
```

#### Step 5: Patch Boot (Optional)
```bash
./scripts/patchBOOT.sh <DEVICE> <WORKSPACE>
```

## Quy trình Build

```
┌─────────────────────────────────────────────────────────┐
│  Step 1: Unpack ROM                                     │
│  ├─ Download ROM zip                                    │
│  ├─ Extract payload.bin                                 │
│  ├─ Extract images từ payload                          │
│  └─ Decompress EROFS partitions                        │
└─────────────────────────────────────────────────────────┘
                        ↓
┌─────────────────────────────────────────────────────────┐
│  Step 2: Modify Partitions                              │
│  ├─ System: Xóa app không cần                          │
│  ├─ Vendor: Xóa service không cần                      │
│  ├─ Product: Xóa app theo region                       │
│  └─ System_ext: Xóa app không cần                      │
└─────────────────────────────────────────────────────────┘
                        ↓
┌─────────────────────────────────────────────────────────┐
│  Step 2.5: Patch Framework (Optional)                  │
│  ├─ Decompile framework.jar                             │
│  ├─ Patch smali files                                   │
│  └─ Recompile và đóng gói lại                          │
└─────────────────────────────────────────────────────────┘
                        ↓
┌─────────────────────────────────────────────────────────┐
│  Step 3: Repack Images                                  │
│  ├─ Patch fs_config và file_contexts                   │
│  ├─ Loại bỏ ký tự non-ASCII                            │
│  ├─ Tạo EROFS images                                    │
│  ├─ Tạo super.img                                       │
│  └─ Patch vbmeta                                        │
└─────────────────────────────────────────────────────────┘
                        ↓
┌─────────────────────────────────────────────────────────┐
│  Step 3.5: Patch Boot (Optional)                       │
│  └─ Patch boot.img với Magisk                          │
└─────────────────────────────────────────────────────────┘
                        ↓
┌─────────────────────────────────────────────────────────┐
│  Step 4: Create Flashable Package                       │
│  ├─ Copy images                                         │
│  ├─ Download flasher tools                              │
│  └─ Tạo fastboot.zip                                    │
└─────────────────────────────────────────────────────────┘
```

## Output

Sau khi build xong, file output sẽ là:
```
{device}_fastboot.zip
```

## Lưu ý quan trọng

### 1. Non-ASCII Characters
Script `repack.sh` **tự động loại bỏ ký tự non-ASCII** khỏi các file:
- `*_file_contexts`
- `*_fs_config`

Điều này giúp tránh lỗi "Non-ASCII characters found" khi build EROFS.

### 2. Region
- **GLOBAL**: Xóa các app Google không cần thiết
- **CN**: Xóa các app Xiaomi China, có thể thêm Google apps

### 3. Super Size
Mặc định super.img có size `9126805504` bytes (8.5GB). Có thể chỉnh trong script `repack.sh`.

### 4. Permissions
Một số thao tác có thể cần quyền sudo (đặc biệt trên Linux).

## Troubleshooting

### Lỗi "permission denied"
```bash
chmod +x scripts/*.sh
chmod +x tools/*
```

### Lỗi "command not found"
Kiểm tra các công cụ đã được cài đặt:
```bash
which python3 aria2c 7z java
```

### Lỗi "Non-ASCII characters found"
Script đã tự động xử lý. Nếu vẫn gặp lỗi, kiểm tra lại file config.

### Lỗi thiếu tool
Kiểm tra các tool trong thư mục `tools/`:
```bash
ls -la tools/
```

## Ví dụ đầy đủ

```bash
# 1. Set quyền
chmod +x scripts/*.sh tools/*

# 2. Build ROM
./scripts/build.sh \
    -d garnet \
    -u "https://bigota.d.miui.com/V14.0.8.0.TNREUXM/garnet_eea_global_images_V14.0.8.0.TNREUXM_20231201.0000.00_14.0_eea.zip" \
    -r GLOBAL

# 3. Output sẽ là: garnet_fastboot.zip
```

## License

MIT License
