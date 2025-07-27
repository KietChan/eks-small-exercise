# S3 Write API (Node.js)

A simple Node.js API to write data to an S3 bucket via `/s3/write?name=...&content=...`.

## Features

- Accepts `name` and `content` query parameters.
- Defaults to `default.txt` and `Hello from default content` if not provided.
- Works on local and Kubernetes (ARM64/Mac M1 compatible).

---

## 1. Run Locally

### Prerequisites

- Node.js >= 18
- AWS credentials configured
- An existing S3 bucket

### Steps

```
npm install  
export S3_BUCKET=your-bucket-name  
node index.js
```

Visit:  
http://localhost:3000/s3/write?name=test.txt&content=hello

If parameters are missing, defaults will be used.

---

## 2. Build Docker Image

### Build (for Mac M1 - ARM64)

`docker buildx build --platform linux/arm64 -t s3-write-test:latest .`

### Rebuild & Override (Save Disk Space)

`docker buildx build --platform linux/arm64 --no-cache -t s3-write-test:latest .`

### Tag for ECR

`docker tag s3-write-test:latest 537940551831.dkr.ecr.us-east-1.amazonaws.com/s3-write-test:latest`

### Push to ECR

`docker push 537940551831.dkr.ecr.us-east-1.amazonaws.com/s3-write-test:latest`


### Run
```# Ensure these environment variables are set in your shell before running:
# export S3_BUCKET=your-bucket-name
# export AWS_ACCESS_KEY_ID=your-access-key
# export AWS_SECRET_ACCESS_KEY=your-secret-key

docker run --platform linux/arm64 \
  -e S3_BUCKET \
  -e AWS_ACCESS_KEY_ID \
  -e AWS_SECRET_ACCESS_KEY \
  -p 3000:3000 s3-writer:latest
  ```

Visit:
http://localhost:3000/s3/write?name=test.txt&content=hello

---

## 3. K8S run on local

Apply & Access

```
kubectl apply -f k8s.yaml
kubectl port-forward svc/s3-writer-svc 8080:80
```

Then open in browser:
http://localhost:8080/s3/write?name=demo.txt&content=test