# Render Deployment Guide

## Option 1: Deploy with Pickle Files (Recommended for Small Models)

### Steps:
1. **Commit pickle files to GitHub** (remove from .gitignore temporarily):
   ```bash
   git add *.pickle
   git commit -m "Add trained models"
   git push origin main
   ```

2. **Create Render Web Service**:
   - Go to [render.com](https://render.com)
   - Click "New +" → "Web Service"
   - Connect your GitHub repo
   - Select the branch (main/master)
   
3. **Configure Service**:
   - **Name**: tweet-sentiment-ai
   - **Environment**: Python 3
   - **Build Command**: `pip install -r requirements.txt`
   - **Start Command**: `gunicorn app:app`
   - **Region**: Choose closest to you

4. **Deploy**: Click "Deploy"

---

## Option 2: Store Models in Cloud Storage (For Large Files)

Use AWS S3 to store pickle files and download them at runtime.

### Setup:
1. Upload pickle files to S3 bucket
2. Install boto3: `pip install boto3`
3. Update app.py to download models from S3 on startup:

```python
import boto3
import os

def load_models_from_s3():
    s3 = boto3.client('s3')
    bucket_name = os.getenv('AWS_BUCKET_NAME')
    
    s3.download_file(bucket_name, 'xgbmodel.pickle', 'xgbmodel.pickle')
    s3.download_file(bucket_name, 'TfidfVectorizer.pickle', 'TfidfVectorizer.pickle')
```

---

## Option 3: Train Models on Deployment (If CSV is Included)

Modify app.py to train models if pickle files don't exist:

```python
if not os.path.exists('xgbmodel.pickle'):
    print("Training models...")
    exec(open('Untitled.ipynb').read())  # Run training notebook
```

---

## Environment Variables on Render:

Go to **Settings** → **Environment** and add:
```
FLASK_ENV=production
PYTHONUNBUFFERED=true
```

---

## CSV File Handling:

- **Keep in repo** if < 100MB (simple)
- **Use S3** if > 100MB (recommended)
- **Generate at runtime** if data can be fetched from an API

---

## Troubleshooting:

- Check logs: Render dashboard → Service → Logs
- Test locally: `gunicorn app:app`
- Port must be set to `10000` (Render requirement)
