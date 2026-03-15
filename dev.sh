#!/bin/bash

# RitelKit Ecosystem Dev Runner
# Menjalankan Central Dashboard dan Tenant App dengan Portless Logic.

BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🚀 Memulai RitelKit Development Ecosystem dengan Portless...${NC}"

# Cek apakah folder exist
if [ ! -d "ritelkit-site" ] || [ ! -d "ritelkit-app" ]; then
    echo "❌ Error: Folder ritelkit-site atau ritelkit-app tidak ditemukan."
    exit 1
fi

# Ensure dependencies are installed if node_modules missing
if [ ! -d "node_modules" ] || [ ! -d "ritelkit-site/node_modules" ]; then
    echo -e "${BLUE}📦 Menyinkronkan dependensi workspace...${NC}"
    pnpm install
fi

# Jalankan dengan concurrently + portless
# Dashboard: http://ritelkit.localhost:1355
# App:       http://app.localhost:1355 (Wildcard: http://*.app.localhost:1355)
npx concurrently \
  --prefix "[{name}]" \
  --names "Dashboard,App" \
  --prefix-colors "green.bold,blue.bold" \
  "npx portless --name ritelkit \"cd ritelkit-site && pnpm dev\"" \
  "npx portless --name app \"cd ritelkit-app && pnpm dev\""
