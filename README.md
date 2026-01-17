# MinIO Deployment with Docker Compose

MinIO is a high-performance, S3-compatible object storage server. This guide explains how to deploy MinIO using Docker Compose and store data in a local directory.

## Prerequisites
- Docker and Docker Compose installed

## Setup
1. **Clone or create the `docker-compose.yml` file:**

```yaml

services:
  minio:
    image: minio/minio:latest
    container_name: minio
    ports:
      - "9000:9000"   # API port
      - "9001:9001"   # WebUI port
    environment:
      MINIO_ROOT_USER: minioadmin
      MINIO_ROOT_PASSWORD: minioadmin123
    volumes:
      - ./minio_data:/data  # Local directory for data
    command: server /data --console-address ":9001"
    restart: unless-stopped
volumes:
  minio_data:
    driver: local
```

2. **Create the local data directory:**

```bash
mkdir -p minio_data
```

3. **Start MinIO:**

```bash
docker compose up -d
```

4. **Access MinIO WebUI:**
- Open [http://localhost:9001](http://localhost:9001) in your browser.
- Login with:
  - Username: `minioadmin`
  - Password: `minioadmin123`

## Notes
- Data is stored in the `minio_data` directory in your project folder.
- Change credentials for production use.
- For advanced configuration, see [MinIO documentation](https://min.io/docs/minio/linux/index.html).
