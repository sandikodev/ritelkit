#!/bin/bash

# RitelKit Ecosystem Dev Runner
# Menjalankan Central Dashboard (4322) dan Tenant App (4321) secara bersamaan.

BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🚀 Memulai RitelKit Development Ecosystem dengan Concurrently...${NC}"

# Cek apakah folder exist
if [ ! -d "ritelkit" ] || [ ! -d "ritelkit-app" ]; then
    echo "❌ Error: Folder ritelkit atau ritelkit-app tidak ditemukan."
    echo "💡 Pastikan Anda menjalankan script ini dari root ritelkit-dev."
    exit 1
fi

npx concurrently \
  --prefix "[{name}]" \
  --names "Dashboard,App" \
  --prefix-colors "green.bold,blue.bold" \
  "cd ritelkit && pnpm dev --port 4322" \
  "cd ritelkit-app && pnpm dev --port 4321"
