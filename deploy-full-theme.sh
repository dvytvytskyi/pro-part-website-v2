#!/bin/bash
# Скрипт для заливки всієї теми propart-spain на сервер
# Використання: ./deploy-full-theme.sh

SERVER="root@188.245.228.175"
LOCAL_THEME="/Users/vytvytskyi/Downloads/htdocs/pro-part.es/wp-content/themes/propart-spain/"
REMOTE_THEME="/home/pro-part/htdocs/pro-part.es/wp-content/themes/"

echo "╔════════════════════════════════════════════════════════════╗"
echo "║  📤 ЗАЛИВКА ВСІЄЇ ТЕМИ НА СЕРВЕР                           ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""
echo "🔍 Локальна папка: ${LOCAL_THEME}"
echo "🌐 Сервер: ${SERVER}"
echo "📁 Віддалена папка: ${REMOTE_THEME}propart-spain/"
echo ""
echo "⚠️  УВАГА: Це замінить всі файли теми на сервері!"
echo ""
read -p "Продовжити? (y/n): " -n 1 -r
echo ""

if [[ ! $REPLY =~ ^[Yy]$ ]]
then
    echo "❌ Скасовано користувачем"
    exit 1
fi

echo ""
echo "═══════════════════════════════════════════════════════════"
echo "🚀 Починаю синхронізацію через rsync..."
echo "═══════════════════════════════════════════════════════════"
echo ""

# Використовуємо rsync для швидкої синхронізації
# -a: архівний режим (зберігає права, час створення, тощо)
# -v: verbose (показує що копіюється)
# -z: стискання даних під час передачі
# --progress: показує прогрес
# --delete: видаляє файли на сервері, яких немає локально

rsync -avz --progress \
    --exclude 'node_modules/' \
    --exclude '.git/' \
    --exclude '.DS_Store' \
    --exclude '*.log' \
    --exclude 'scripts/' \
    "${LOCAL_THEME}" \
    "${SERVER}:${REMOTE_THEME}propart-spain/"

if [ $? -eq 0 ]; then
    echo ""
    echo "═══════════════════════════════════════════════════════════"
    echo "✅ ТЕМА УСПІШНО ЗАВАНТАЖЕНА НА СЕРВЕР!"
    echo "═══════════════════════════════════════════════════════════"
    echo ""
    echo "📊 Що оновлено:"
    echo "  • Всі PHP файли"
    echo "  • Всі JS/CSS файли"
    echo "  • Всі шаблони сторінок"
    echo "  • Всі зображення та медіа"
    echo "  • GeoJSON дані"
    echo ""
    echo "⚠️  Виключено (не завантажено):"
    echo "  • Папка scripts/ (парсери)"
    echo "  • node_modules/"
    echo "  • .git/"
    echo ""
    echo "🌐 Перевірте сайт: https://pro-part.es"
else
    echo ""
    echo "═══════════════════════════════════════════════════════════"
    echo "❌ ПОМИЛКА ПІД ЧАС ЗАВАНТАЖЕННЯ!"
    echo "═══════════════════════════════════════════════════════════"
    exit 1
fi

