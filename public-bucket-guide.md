# How to Create a Public Images Bucket in MinIO

This guide explains how to create a public bucket for images in MinIO, add folders, enable cache, and version control.

## 1. Create a Bucket
- Access MinIO WebUI at [http://localhost:9001](http://localhost:9001)
- Login with your credentials
- Click "Buckets" > "Create Bucket"
- Name it `images`

## 2. Make the Bucket Public
If the UI does not support policy editing, use MinIO Client (mc):

```bash
mc alias set myminio http://localhost:9000 minioadmin minioadmin123
mc mb myminio/images
mc anonymous set download myminio/images
```

## 3. Create Folders
You can create folders inside the bucket using the WebUI or mc:

- In WebUI: Open `images` bucket, click "+" > "Create Folder", name them `event1` and `event2`.
- Using mc:
```bash
mc cp --recursive ./event1 myminio/images/event1
mc cp --recursive ./event2 myminio/images/event2
```

## 4. Enable Cache
Add the following to your `docker-compose.yml` under the `minio` service:

```yaml
    environment:
      ...existing code...
      MINIO_CACHE_DRIVES: /data/cache
      MINIO_CACHE_EXPIRY: 90
      MINIO_CACHE_QUOTA: 80
```
And create the cache directory:
```bash
mkdir -p minio_data/cache
```

## 5. Enable Version Control
Enable versioning for the bucket using mc:

```bash
mc version enable myminio/images
```

## 6. Public Access
Objects in `images` bucket are now accessible via:
```
http://localhost:9000/images/event1/your-image.jpg
http://localhost:9000/images/event2/your-image.jpg
```

## 7. Restore a Previous Version
To restore a previous version of an object in your bucket, use MinIO Client (mc):

1. List all versions of an object:
   ```bash
   mc ls --versions myminio/images/event1/your-image.jpg
   ```
2. Copy a specific version to restore it:
   ```bash
   mc cp myminio/images/event1/your-image.jpg?versionId=<version-id> myminio/images/event1/your-image-restored.jpg
   ```
Replace `<version-id>` with the actual version ID you want to restore.

For more details, see the [MinIO Versioning documentation](https://min.io/docs/minio/linux/reference/minio-mc/mc-version.html).

## References
- [MinIO Bucket Policies](https://min.io/docs/minio/linux/reference/minio-mc/mc-anonymous-set.html)
- [MinIO Versioning](https://min.io/docs/minio/linux/reference/minio-mc/mc-version.html)
- [MinIO Caching](https://min.io/docs/minio/linux/reference/minio-server/minio-server.html#caching)
