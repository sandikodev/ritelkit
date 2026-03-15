#!/bin/bash

# RitelKit Ecosystem Dev Runner
# Smart Routing Logic:
# - ritelkit.localhost              -> Landing (ritelkit-site)
# - app.ritelkit.localhost          -> Admin Console (ritelkit-app)
# - [tenant].ritelkit.localhost     -> Storefront (ritelkit-app)

BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🚀 Memulai RitelKit Portless Orchestrator...${NC}"

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

# Jalankan dengan concurrently
# Dashboard/Site berjalan di port internal 4322 (akan di-proxy oleh App)
# App berjalan via Portless sebagai 'ritelkit' (menangkap ritelkit.localhost dan *.ritelkit.localhost)
npx concurrently \
  --prefix "[{name}]" \
  --names "Site,App" \
  --prefix-colors "green.bold,blue.bold" \
  "cd ritelkit-site && PORT=4322 pnpm dev" \
  "cd ritelkit-app && npx portless --name ritelkit pnpm dev"
