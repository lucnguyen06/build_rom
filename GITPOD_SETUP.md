# Gitpod Setup Guide - ROM Builder Web Interface

Hướng dẫn setup và deploy ROM Builder trên Gitpod.

## 📋 Yêu cầu

1. Tài khoản GitHub
2. Tài khoản Gitpod (miễn phí tại [gitpod.io](https://gitpod.io))
3. Repository GitHub chứa code ROM Builder

## 🚀 Cách Setup

### Bước 1: Chuẩn bị Repository

1. **Fork hoặc tạo repository mới** trên GitHub
2. **Upload tất cả files** vào repository:
   ```
   ├── .gitpod.yml
   ├── .gitpod/
   │   └── Dockerfile
   ├── web/
   │   ├── app.py
   │   └── templates/
   │       └── index.html
   ├── scripts/
   │   ├── build.sh
   │   ├── unpack.sh
   │   ├── repack.sh
   │   └── ...
   ├── tools/
   │   └── ...
   └── README.md
   ```

3. **Commit và push** lên GitHub

### Bước 2: Mở trên Gitpod

1. Truy cập: `https://gitpod.io/#<your-repo-url>`
   - Ví dụ: `https://gitpod.io/#https://github.com/username/rom-builder`

2. Gitpod sẽ tự động:
   - Clone repository
   - Build Docker image
   - Install dependencies
   - Start web server

### Bước 3: Truy cập Web Interface

1. Gitpod sẽ tự động mở browser với URL: `https://<workspace-id>.gitpod.io`
2. Hoặc click vào **"Open Browser"** trong Gitpod dashboard
3. Web interface sẽ hiển thị tại port 5000

## 🔧 Cấu hình

### File `.gitpod.yml`

File này cấu hình Gitpod workspace:

```yaml
image:
  file: .gitpod/Dockerfile

tasks:
  - name: Setup Environment
    init: |
      # Commands chạy khi workspace khởi động
    command: |
      # Commands chạy sau khi init xong

ports:
  - port: 5000
    onOpen: open-browser
    visibility: public
```

### File `.gitpod/Dockerfile`

File này định nghĩa Docker image:

```dockerfile
FROM gitpod/workspace-base:latest

# Install dependencies
RUN sudo apt-get update && \
    sudo apt-get install -y \
    python3 python3-pip aria2 p7zip-full zip unzip curl wget

# Install Python packages
RUN pip3 install flask flask-cors psutil

WORKDIR /workspace
COPY . /workspace/
RUN sudo chmod +x scripts/*.sh tools/* 2>/dev/null || true

EXPOSE 5000
```

## 📱 Sử dụng Web Interface

### 1. Nhập thông tin build

- **Device Name**: Tên thiết bị (vd: houji, garnet)
- **ROM URL**: Link download ROM
- **Region**: GLOBAL hoặc CN
- **Options**: 
  - Patch Framework
  - Patch Boot (Magisk)

### 2. Start Build

Click nút **"Start Build"** để bắt đầu quá trình build.

### 3. Theo dõi tiến trình

- **Progress Bar**: Hiển thị % hoàn thành
- **Status Text**: Bước hiện tại
- **Log Console**: Log chi tiết từ build process
- **System Info**: CPU, Memory, Disk usage

### 4. Download Output

Sau khi build xong, file `{device}_fastboot.zip` sẽ xuất hiện trong danh sách files.
Click **"Download"** để tải về.

## 🛠️ Troubleshooting

### Lỗi: Port không mở

1. Vào Gitpod dashboard
2. Click vào workspace
3. Mở tab **Ports**
4. Đảm bảo port 5000 đã được expose và public

### Lỗi: Build script không chạy

1. Kiểm tra quyền thực thi:
   ```bash
   chmod +x scripts/*.sh
   chmod +x tools/*
   ```

2. Kiểm tra dependencies:
   ```bash
   which python3 aria2 7z
   ```

### Lỗi: Web server không start

1. Kiểm tra logs trong Gitpod terminal
2. Kiểm tra Python dependencies:
   ```bash
   pip3 install flask flask-cors psutil
   ```

3. Start lại server thủ công:
   ```bash
   cd web
   python3 app.py
   ```

### Lỗi: Không đủ dung lượng

Gitpod free tier có giới hạn:
- **Storage**: 30GB
- **RAM**: 4GB
- **CPU**: 2 cores

Nếu build lớn, có thể cần:
- Upgrade Gitpod plan
- Hoặc build trên máy local

## 🔐 Bảo mật

### Public Workspace

- Gitpod workspace mặc định là **public**
- Bất kỳ ai có link đều có thể truy cập
- **Không nên** để sensitive data trong workspace

### Private Workspace

Để tạo private workspace:
1. Vào Gitpod Settings
2. Enable **"Private Workspaces"**
3. Hoặc sử dụng Gitpod Teams plan

## 📊 Monitoring

### System Resources

Web interface hiển thị:
- **CPU Usage**: % CPU đang sử dụng
- **Memory Usage**: % RAM đang sử dụng  
- **Disk Usage**: % Disk đang sử dụng

### Build Logs

Logs được lưu trong memory và hiển thị real-time:
- **Info**: Thông tin chung
- **Success**: Thành công
- **Warning**: Cảnh báo
- **Error**: Lỗi

## 🚀 Deploy Production

### Option 1: Gitpod (Recommended)

- Free tier: 50 hours/month
- Auto-sleep sau 30 phút không dùng
- Perfect cho testing và development

### Option 2: Self-hosted

1. Clone repository
2. Install dependencies:
   ```bash
   sudo apt-get install python3 python3-pip aria2 p7zip-full
   pip3 install flask flask-cors psutil
   ```

3. Start server:
   ```bash
   cd web
   python3 app.py
   ```

4. Access tại: `http://localhost:5000`

### Option 3: Docker

```dockerfile
FROM python:3.9-slim

RUN apt-get update && apt-get install -y \
    aria2 p7zip-full zip unzip curl wget

WORKDIR /app
COPY . /app/
RUN pip3 install flask flask-cors psutil
RUN chmod +x scripts/*.sh tools/*

EXPOSE 5000
CMD ["python3", "web/app.py"]
```

Build và run:
```bash
docker build -t rom-builder .
docker run -p 5000:5000 rom-builder
```

## 📝 Notes

1. **Gitpod Timeout**: Workspace sẽ sleep sau 30 phút không dùng
2. **Build Time**: Build ROM có thể mất 30-60 phút tùy ROM size
3. **Storage**: Đảm bảo có đủ dung lượng (ít nhất 20GB free)
4. **Network**: Cần kết nối internet ổn định để download ROM

## 🆘 Support

Nếu gặp vấn đề:
1. Kiểm tra logs trong Gitpod terminal
2. Kiểm tra file `.gitpod.yml` và `Dockerfile`
3. Xem README.md để biết thêm chi tiết

## 📚 Tài liệu tham khảo

- [Gitpod Documentation](https://www.gitpod.io/docs)
- [Flask Documentation](https://flask.palletsprojects.com/)
- [ROM Builder README](./README.md)
