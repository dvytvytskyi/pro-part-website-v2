#!/bin/bash
#
# Відновлення стандартних WordPress файлів версії 6.8.3
#

# Кольори
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo "╔═══════════════════════════════════════════════════════════════════╗"
echo "║  Відновлення wp-admin/options.php і wp-admin/plugins.php         ║"
echo "╚═══════════════════════════════════════════════════════════════════╝"
echo ""

# Перевірка чи є завантажений WordPress
if [ ! -f "/Users/vytvytskyi/Downloads/wordpress-6.8.3.zip" ]; then
    echo -e "${YELLOW}WordPress 6.8.3 не знайдено в Downloads${NC}"
    echo ""
    echo "Завантажте WordPress 6.8.3:"
    echo "1. Відкрийте: https://wordpress.org/wordpress-6.8.3.zip"
    echo "2. АБО: https://wordpress.org/download/releases/"
    echo "3. Збережіть у папку Downloads"
    echo ""
    echo "Після завантаження запустіть цей скрипт знову."
    exit 1
fi

echo -e "${GREEN}✓ WordPress 6.8.3 знайдено${NC}"
echo ""

# Розпаковуємо
cd /Users/vytvytskyi/Downloads
echo "Розпаковуємо WordPress..."
unzip -q wordpress-6.8.3.zip

if [ ! -d "/Users/vytvytskyi/Downloads/wordpress" ]; then
    echo "Помилка розпакування!"
    exit 1
fi

echo -e "${GREEN}✓ Розпаковано${NC}"
echo ""

# Копіюємо файли
cd /Users/vytvytskyi/Downloads/htdocs/pro-part.es

echo "Створюємо бекапи заражених файлів..."
cp -v wp-admin/options.php wp-admin/options.php.INFECTED.backup
cp -v wp-admin/plugins.php wp-admin/plugins.php.INFECTED.backup

echo ""
echo "Копіюємо чисті файли..."
cp -v /Users/vytvytskyi/Downloads/wordpress/wp-admin/options.php wp-admin/options.php
cp -v /Users/vytvytskyi/Downloads/wordpress/wp-admin/plugins.php wp-admin/plugins.php

echo ""
echo -e "${GREEN}✅ ГОТОВО!${NC}"
echo ""
echo "Відновлені файли:"
echo "  ✓ wp-admin/options.php"
echo "  ✓ wp-admin/plugins.php"
echo ""
echo "Бекапи заражених файлів збережені як:"
echo "  • wp-admin/options.php.INFECTED.backup"
echo "  • wp-admin/plugins.php.INFECTED.backup"
echo ""
echo "─────────────────────────────────────────────────────────────────"
echo "ПЕРЕВІРТЕ адмінку WordPress:"
echo "  https://pro-part.es/wp-admin/"
echo ""
echo "Якщо все працює - можна видалити:"
echo "  rm /Users/vytvytskyi/Downloads/wordpress-6.8.3.zip"
echo "  rm -rf /Users/vytvytskyi/Downloads/wordpress"
echo "─────────────────────────────────────────────────────────────────"

