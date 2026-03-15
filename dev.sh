#!/bin/bash

# RitelKit Ecosystem Dev Runner
# Menjalankan Central Dashboard (4322) dan Tenant App (4321) secara bersamaan.

# Warna untuk output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🚀 Memulai RitelKit Development Ecosystem...${NC}"

# Cek apakah folder exist
if [ ! -d "ritelkit" ] || [ ! -d "ritelkit-app" ]; then
    echo "❌ Error: Folder ritelkit atau ritelkit-app tidak ditemukan."
    echo "💡 Pastikan Anda menjalankan script ini dari root ritelkit-dev."
    exit 1
fi

# Fungsi untuk kill process saat script di-stop (Ctrl+C)
cleanup() {
    echo -e "\n${BLUE}🛑 Menghentikan semua server...${NC}"
    kill $DASHBOARD_PID $APP_PID 2>/dev/null
    exit
}

trap cleanup SIGINT

# 1. Menjalankan RitelKit Central (Dashboard) pada Port 4322
echo -e "${GREEN}📡 Menjalankan RitelKit Central di port 4322...${NC}"
(cd ritelkit && pnpm dev --port 4322 > ../dashboard.log 2>&1) &
DASHBOARD_PID=$!

# 2. Menjalankan RitelKit App (Tenant) pada Port 4321
echo -e "${GREEN}📱 Menjalankan RitelKit App di port 4321...${NC}"
(cd ritelkit-app && pnpm dev --port 4321 > ../app.log 2>&1) &
APP_PID=$!

echo -e "${BLUE}---------------------------------------------------${NC}"
echo -e "✅ Server berhasil dijalankan!"
echo -e "🌐 Dashboard: ${BLUE}http://ritelkit.local:4322${NC}"
echo -e "🌐 App:       ${BLUE}http://kopi-toktok.ritelkit.local:4321${NC}"
echo -e "📝 Log tersimpan di dashboard.log dan app.log"
echo -e "${BLUE}---------------------------------------------------${NC}"
echo -e "Tekan Ctrl+C untuk menghentikan kedua server."

# Tunggu sampai proses selesai
wait
