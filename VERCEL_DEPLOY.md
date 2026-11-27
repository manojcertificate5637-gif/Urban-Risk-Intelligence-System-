# Vercel Deployment Guide

## Frontend (Vercel) - Deploy this repository

1. **Connect to Vercel:**
   - Go to https://vercel.com/new
   - Import this GitHub repository
   - Set Root Directory to `frontend`
   - Vercel auto-detects Vite

2. **Environment Variables (in Vercel Dashboard):**
   - `VITE_API_URL` = Your backend URL (e.g., `https://cris-backend.railway.app`)
   - `VITE_WS_URL` = WebSocket URL (e.g., `wss://cris-backend.railway.app`)

3. **Deploy:**
   - Click Deploy
   - Frontend will be live at `https://your-app.vercel.app`

## Backend (Deploy Separately)

**Vercel does NOT support Python/FastAPI.** Deploy backend to:

### Option 1: Railway (Recommended)
```bash
# 1. Install Railway CLI
npm i -g @railway/cli

# 2. Login and deploy from backend folder
cd backend
railway login
railway init
railway up
```

### Option 2: Render
- Connect GitHub repo
- Set Root Directory to `backend`
- Build Command: `pip install -r requirements.txt`
- Start Command: `uvicorn app.main:app --host 0.0.0.0 --port $PORT`
- Add PostgreSQL database

### Option 3: Fly.io
```bash
cd backend
fly launch
fly deploy
```

### Option 4: Docker (any VPS)
```bash
cd backend
docker build -t cris-backend .
docker run -p 8000:8000 cris-backend
```

## Required Backend Environment Variables

Set these on your backend host:
```
DATABASE_URL=postgresql+asyncpg://user:pass@host/db
SECRET_KEY=your-random-secret
JWT_SECRET_KEY=your-random-jwt-secret
JWT_REFRESH_SECRET_KEY=your-random-refresh-secret
CORS_ORIGINS=["https://your-app.vercel.app"]
DEBUG=False
```

## After Backend Deploy

1. Copy backend URL (e.g., `https://cris-backend.railway.app`)
2. In Vercel Dashboard > Settings > Environment Variables:
   - Add `VITE_API_URL` = `https://cris-backend.railway.app`
   - Add `VITE_WS_URL` = `wss://cris-backend.railway.app`
3. Redeploy frontend on Vercel

## Demo Credentials (Work in Production)
- Admin: `admin@cris.gov` / `Admin@123456`
- Departments: `<dept>@cris.gov` / `Dept@123456`

**⚠️ Change passwords before production use!**