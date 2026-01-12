# Deployment Guide - ROM Builder Web Interface

Hướng dẫn deploy ROM Builder Web Interface lên các platform khác nhau.

## 🚀 Gitpod (Recommended)

### Quick Start

1. **Fork repository** lên GitHub
2. Truy cập: `https://gitpod.io/#https://github.com/your-username/rom-builder`
3. Gitpod sẽ tự động setup và start web server
4. Web interface sẽ mở tại port 5000

### Chi tiết

Xem file [GITPOD_SETUP.md](./GITPOD_SETUP.md) để biết chi tiết.

## 🐳 Docker

### Build Image

```bash
docker build -t rom-builder -f .gitpod/Dockerfile .
```

### Run Container

```bash
docker run -d \
  -p 5000:5000 \
  --name rom-builder \
  -v $(pwd):/workspace \
  rom-builder
```

### Access

Truy cập: `http://localhost:5000`

## ☁️ Cloud Platforms

### Heroku

1. **Install Heroku CLI**

2. **Create Procfile**:
   ```
   web: cd web && python3 app.py
   ```

3. **Deploy**:
   ```bash
   heroku create rom-builder
   git push heroku main
   ```

### Railway

1. **Connect GitHub repository**
2. **Set build command**: `pip3 install -r web/requirements.txt`
3. **Set start command**: `cd web && python3 app.py`
4. **Deploy**

### Render

1. **New Web Service**
2. **Connect repository**
3. **Build command**: `pip3 install -r web/requirements.txt`
4. **Start command**: `cd web && python3 app.py`
5. **Environment**: Python 3

## 💻 Local Development

### Requirements

- Python 3.8+
- pip3
- aria2
- p7zip-full
- zip, unzip

### Setup

```bash
# Clone repository
git clone https://github.com/your-username/rom-builder.git
cd rom-builder

# Install Python dependencies
pip3 install -r web/requirements.txt

# Set permissions
chmod +x scripts/*.sh tools/*

# Start server
cd web
python3 app.py
```

### Access

Truy cập: `http://localhost:5000`

## 🔧 Configuration

### Environment Variables

Có thể set các biến môi trường:

```bash
export WORKSPACE=/path/to/workspace
export PORT=5000
export DEBUG=True
```

### Port Configuration

Mặc định port là 5000. Có thể thay đổi trong `web/app.py`:

```python
app.run(host='0.0.0.0', port=5000)
```

## 📝 Notes

1. **Storage**: Đảm bảo có đủ dung lượng (ít nhất 20GB)
2. **Memory**: Build ROM cần ít nhất 4GB RAM
3. **Network**: Cần kết nối internet ổn định
4. **Timeout**: Một số platform có timeout limit

## 🆘 Troubleshooting

### Port already in use

```bash
# Find process using port 5000
lsof -i :5000

# Kill process
kill -9 <PID>
```

### Permission denied

```bash
chmod +x scripts/*.sh tools/*
```

### Dependencies missing

```bash
# Install system packages
sudo apt-get install python3 python3-pip aria2 p7zip-full zip unzip

# Install Python packages
pip3 install -r web/requirements.txt
```

## 🔐 Security

### Production Deployment

1. **Disable debug mode**:
   ```python
   app.run(host='0.0.0.0', port=5000, debug=False)
   ```

2. **Use reverse proxy** (nginx/apache)

3. **Enable HTTPS** với SSL certificate

4. **Add authentication** nếu cần

### Example nginx config

```nginx
server {
    listen 80;
    server_name your-domain.com;

    location / {
        proxy_pass http://localhost:5000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }
}
```

## 📊 Monitoring

### Logs

Logs được output ra console. Có thể redirect vào file:

```bash
python3 web/app.py >> app.log 2>&1
```

### Health Check

API endpoint để check health:

```bash
curl http://localhost:5000/api/status
```

## 🎯 Best Practices

1. **Use Gitpod** cho development và testing
2. **Use Docker** cho production deployment
3. **Monitor resources** (CPU, Memory, Disk)
4. **Backup important files** trước khi build
5. **Clean up** sau mỗi build để tiết kiệm dung lượng
