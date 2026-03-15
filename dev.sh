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
# Dashboard/Landing: http://ritelkit.localhost:1355
# Operation App:     http://app.ritelkit.localhost:1355
# Multi-tenant App:   http://[tenant].app.ritelkit.localhost:1355

npx concurrently \
  --prefix "[{name}]" \
  --names "Site,App" \
  --prefix-colors "green.bold,blue.bold" \
  "cd ritelkit-site && npx portless --name ritelkit pnpm dev" \
  "cd ritelkit-app && npx portless --name app.ritelkit pnpm dev"
