#!/bin/bash
# Скрипт для завантаження актуальної версії liked.php з сервера

SERVER="root@188.245.228.175"
REMOTE_FILE="/home/pro-part/htdocs/pro-part.es/wp-content/themes/propart-spain/pages/liked.php"
LOCAL_FILE="pro-part.es/wp-content/themes/propart-spain/pages/liked.php"

echo "╔════════════════════════════════════════════════════════════╗"
echo "║  📥 ЗАВАНТАЖЕННЯ АКТУАЛЬНОЇ ВЕРСІЇ З СЕРВЕРА               ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""
echo "🔍 Сервер: ${SERVER}"
echo "📁 Віддалений файл: ${REMOTE_FILE}"
echo "💾 Локальний файл: ${LOCAL_FILE}"
echo ""

# Створюємо backup поточного файлу
echo "📦 Створюю backup локального файлу..."
cp "$LOCAL_FILE" "${LOCAL_FILE}.old-backup"
echo "   ✅ Backup: ${LOCAL_FILE}.old-backup"
echo ""

# Завантажуємо файл з сервера
echo "📥 Завантажую файл з сервера..."
scp "${SERVER}:${REMOTE_FILE}" "$LOCAL_FILE"

if [ $? -eq 0 ]; then
    echo ""
    echo "╔════════════════════════════════════════════════════════════╗"
    echo "║  ✅ ФАЙЛ УСПІШНО ЗАВАНТАЖЕНО!                              ║"
    echo "╚════════════════════════════════════════════════════════════╝"
    echo ""
    echo "📊 ПОРІВНЯННЯ РОЗМІРІВ:"
    echo ""
    echo "Стара локальна версія:"
    ls -lh "${LOCAL_FILE}.old-backup" | awk '{print "   " $5 " - " $9}'
    echo ""
    echo "Нова версія з сервера:"
    ls -lh "$LOCAL_FILE" | awk '{print "   " $5 " - " $9}'
    echo ""
    echo "📋 НАСТУПНІ КРОКИ:"
    echo ""
    echo "1. Відкрийте файл і перевірте функціонал:"
    echo "   - Copy link повинен працювати"
    echo "   - Фото повинні скролитись"
    echo ""
    echo "2. Видаліть кнопку Export PDF (якщо вона є)"
    echo ""
    echo "3. Закомітьте зміни:"
    echo "   git add $LOCAL_FILE"
    echo "   git commit -m 'Update liked.php from production server'"
    echo "   git push origin main"
    echo ""
else
    echo ""
    echo "❌ ПОМИЛКА ЗАВАНТАЖЕННЯ"
    echo ""
    echo "Відновлюю з backup..."
    mv "${LOCAL_FILE}.old-backup" "$LOCAL_FILE"
    echo "✅ Файл відновлено"
    exit 1
fi

