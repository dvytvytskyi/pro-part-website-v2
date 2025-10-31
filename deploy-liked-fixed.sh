#!/bin/bash
# Скрипт для заливки виправленого liked.php на сервер

SERVER="root@188.245.228.175"
LOCAL_FILE="pro-part.es/wp-content/themes/propart-spain/pages/liked.php"
REMOTE_FILE="/home/pro-part/htdocs/pro-part.es/wp-content/themes/propart-spain/pages/liked.php"

echo "📤 Заливка виправленого liked.php на сервер..."
echo ""

scp "$LOCAL_FILE" "${SERVER}:${REMOTE_FILE}"

if [ $? -eq 0 ]; then
    echo ""
    echo "✅ ФАЙЛ УСПІШНО ЗАВАНТАЖЕНО!"
    echo ""
    echo "📋 ЩО ОНОВЛЕНО:"
    echo "  • Видалено виклики CRM API"
    echo "  • Генерація унікального ID на клієнті"
    echo "  • Збереження в localStorage"
    echo "  • Кожен раз новий ID"
    echo ""
    echo "🧹 НАСТУПНИЙ КРОК:"
    echo "  1. Відкрийте https://pro-part.es/liked-projects/"
    echo "  2. Натисніть Cmd+Shift+R (Mac) або Ctrl+Shift+R (Windows)"
    echo "  3. Перевірте що кнопка Copy link працює"
    echo ""
else
    echo ""
    echo "❌ ПОМИЛКА ЗАВАНТАЖЕННЯ"
    echo "Перевірте з'єднання з сервером та пароль"
    exit 1
fi

