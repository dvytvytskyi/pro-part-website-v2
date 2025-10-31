#!/bin/bash
# Скрипт для синхронізації map.php на сервер
# Використання: ./deploy-changes.sh

SERVER="root@188.245.228.175"
REMOTE_BASE="/home/pro-part/htdocs/pro-part.es/wp-content/themes/propart-spain"
LOCAL_BASE="pro-part.es/wp-content/themes/propart-spain"

echo "📤 Синхронізація змін на сервер..."
echo "═══════════════════════════════════════════════════════════"
echo ""

# Завантажуємо map.php (видалено кнопку Neighborhoods)
echo "🗺️  Оновлюю map.php..."
scp "${LOCAL_BASE}/pages/map.php" "${SERVER}:${REMOTE_BASE}/pages/"

if [ $? -eq 0 ]; then
    echo "   ✅ map.php завантажено"
    echo ""
    echo "═══════════════════════════════════════════════════════════"
    echo "✅ ЗМІНИ УСПІШНО СИНХРОНІЗОВАНО НА СЕРВЕР!"
    echo "═══════════════════════════════════════════════════════════"
    echo ""
    echo "Що оновлено:"
    echo "  • Видалено кнопку 'Neighborhoods' з карти"
    echo "  • Закоментовано event listener для уникнення помилок"
else
    echo "   ❌ Помилка завантаження map.php"
    exit 1
fi
