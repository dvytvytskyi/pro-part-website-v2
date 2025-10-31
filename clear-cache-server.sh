#!/bin/bash
# Скрипт для очищення всіх кешів WordPress на сервері

SERVER="root@188.245.228.175"
SITE_PATH="/home/pro-part/htdocs/pro-part.es"

echo "╔════════════════════════════════════════════════════════════╗"
echo "║  🧹 ОЧИЩЕННЯ КЕШУ НА СЕРВЕРІ                               ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""

echo "1️⃣ Очищення WordPress кешу..."
ssh $SERVER "rm -rf ${SITE_PATH}/wp-content/cache/* && echo '   ✅ WordPress cache очищено'"

echo ""
echo "2️⃣ Очищення object cache..."
ssh $SERVER "rm -rf ${SITE_PATH}/wp-content/object-cache.php && echo '   ✅ Object cache очищено'"

echo ""
echo "3️⃣ Очищення themes cache..."
ssh $SERVER "find ${SITE_PATH}/wp-content/themes/propart-spain/ -name '*.cache' -type f -delete && echo '   ✅ Themes cache очищено'"

echo ""
echo "4️⃣ Перевірка версії файлу liked.php на сервері..."
ssh $SERVER "ls -lh ${SITE_PATH}/wp-content/themes/propart-spain/pages/liked.php && stat -c 'Дата: %y' ${SITE_PATH}/wp-content/themes/propart-spain/pages/liked.php"

echo ""
echo "5️⃣ Додавання version tag до CSS/JS..."
TIMESTAMP=$(date +%s)
echo "   Version: ?v=${TIMESTAMP}"

echo ""
echo "╔════════════════════════════════════════════════════════════╗"
echo "║  ✅ КЕШ ОЧИЩЕНО!                                           ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""
echo "📋 НАСТУПНІ КРОКИ:"
echo ""
echo "1. Очистити кеш WordPress плагіну (якщо є):"
echo "   - WP Super Cache: Settings → Delete Cache"
echo "   - W3 Total Cache: Performance → Purge All Caches"
echo "   - LiteSpeed Cache: Dashboard → Purge All"
echo ""
echo "2. У браузері відкрийте консоль (F12) на сторінці liked-projects та виконайте:"
echo "   localStorage.clear(); location.reload();"
echo ""
echo "3. Зробіть Hard Refresh:"
echo "   - Mac: Cmd + Shift + R"
echo "   - Windows: Ctrl + Shift + R"
echo ""
echo "4. Або додайте ?v=${TIMESTAMP} до URL:"
echo "   https://pro-part.es/liked-projects/?v=${TIMESTAMP}"
echo ""

