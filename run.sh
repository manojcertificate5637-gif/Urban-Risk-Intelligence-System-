#!/usr/bin/env bash
# CRIS - Urban Resilience Intelligence System
# Run script for Linux/macOS/Git Bash

set -e

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Starting CRIS Backend..."
cd "$PROJECT_ROOT/backend"
if [ ! -d ".venv" ]; then
    python3 -m venv .venv
fi
source .venv/bin/activate
pip install -q -r requirements.txt
alembic upgrade head
uvicorn app.main:app --host 127.0.0.1 --port 8000 &
BACKEND_PID=$!

sleep 3

echo "Starting CRIS Frontend..."
cd "$PROJECT_ROOT/frontend"
npm ci --legacy-peer-deps
npm run dev &
FRONTEND_PID=$!

sleep 3

echo "Opening in browser..."
if command -v xdg-open &> /dev/null; then
    xdg-open http://localhost:5173
    xdg-open http://127.0.0.1:8000/docs
elif command -v open &> /dev/null; then
    open http://localhost:5173
    open http://127.0.0.1:8000/docs
fi

echo ""
echo "=========================================="
echo "CRIS is starting up!"
echo "Frontend: http://localhost:5173"
echo "Backend API: http://127.0.0.1:8000"
echo "API Docs: http://127.0.0.1:8000/docs"
echo "=========================================="
echo ""
echo "Demo Credentials:"
echo "  Admin: admin@cris.gov / Admin@123456"
echo "  Departments: <dept>@cris.gov / Dept@123456"
echo ""
echo "Press Ctrl+C to stop all services"

# Cleanup on exit
trap "kill $BACKEND_PID $FRONTEND_PID 2>/dev/null; exit" INT TERM
wait