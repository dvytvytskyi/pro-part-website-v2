#!/bin/bash
#
# Команди для ручного очищення
# Виконуйте по черзі, перевіряючи сайт після кожного блоку
#

# ═══════════════════════════════════════════════════════════════════
# БЛОК 1: БЕКАП (обов'язково!)
# ═══════════════════════════════════════════════════════════════════

cd /Users/vytvytskyi/Downloads/htdocs
cp -r pro-part.es pro-part.es.BACKUP_$(date +%Y%m%d_%H%M%S)
echo "✅ Бекап створено"

# ═══════════════════════════════════════════════════════════════════
# БЛОК 2: Видалення явно шкідливих файлів
# Після цього блоку - ПЕРЕВІРТЕ САЙТ!
# ═══════════════════════════════════════════════════════════════════

cd /Users/vytvytskyi/Downloads/htdocs/pro-part.es

rm -fv wp-class.php
rm -fv wp-class.gz
rm -fv defaults.php
rm -fv options.php
rm -fv product.php
rm -rfv d65be
rm -rfv d65be+55

echo ""
echo "✅ БЛОК 2 завершено"
echo "⚠️  ПЕРЕВІРТЕ САЙТ перед продовженням!"
echo "Натисніть Enter коли перевірите..."
read

# ═══════════════════════════════════════════════════════════════════
# БЛОК 3: Очищення index.php
# Після цього блоку - ПЕРЕВІРТЕ САЙТ!
# ═══════════════════════════════════════════════════════════════════

cd /Users/vytvytskyi/Downloads/htdocs/pro-part.es

# Бекап index.php
cp -v index.php index.php.backup

# Видаляємо перший рядок
sed -i '' '1d' index.php

echo ""
echo "✅ БЛОК 3 завершено"
echo "⚠️  ПЕРЕВІРТЕ САЙТ перед продовженням!"
echo "Натисніть Enter коли перевірите..."
read

# ═══════════════════════════════════════════════════════════════════
# БЛОК 4: Видалення backdoor у темах
# Після цього блоку - ПЕРЕВІРТЕ ТЕМУ!
# ═══════════════════════════════════════════════════════════════════

cd /Users/vytvytskyi/Downloads/htdocs/pro-part.es

rm -fv wp-content/themes/propart-spain/icons/map/galleries/index.php
rm -fv wp-content/themes/propart-spain/icons/shared/post-catalog/index.php
rm -fv wp-content/themes/propart-spain/images/benahavispage/requests/index.php
rm -fv wp-content/themes/propart-spain/images/marbellapage/index.php
rm -fv wp-content/themes/propart-spain/assets/blog-sorting/index.php
rm -rfv wp-content/themes/twentytwentyfive/assets/css/cloudflare

echo ""
echo "✅ БЛОК 4 завершено"
echo "⚠️  ПЕРЕВІРТЕ ТЕМУ перед продовженням!"
echo "Натисніть Enter коли перевірите..."
read

# ═══════════════════════════════════════════════════════════════════
# БЛОК 5: Видалення backdoor у wp-includes
# Після цього блоку - ПЕРЕВІРТЕ САЙТ!
# ═══════════════════════════════════════════════════════════════════

cd /Users/vytvytskyi/Downloads/htdocs/pro-part.es

rm -rfv wp-includes/SimplePie/library/SimplePie/Decode/cloudflare
rm -rfv wp-includes/sodium_compat/src/Core32/Poly1305/i18ns
rm -rfv wp-includes/sodium_compat/src/Core/ChaCha20/i18ns

echo ""
echo "✅ БЛОК 5 завершено"
echo "⚠️  ПЕРЕВІРТЕ САЙТ перед продовженням!"
echo "Натисніть Enter коли перевірите..."
read

# ═══════════════════════════════════════════════════════════════════
# БЛОК 6: Видалення підозрілих папок
# Після цього блоку - ПЕРЕВІРТЕ АДМІНКУ!
# ═══════════════════════════════════════════════════════════════════

cd /Users/vytvytskyi/Downloads/htdocs/pro-part.es

rm -rfv wp-admin/maint/310698
rm -rfv wp-admin/network/511825
rm -rfv wp-includes/block-supports/790602
rm -rfv wp-includes/pomo/352882
rm -rfv wp-includes/html-api/296918
rm -rfv wp-includes/sitemaps/providers/996923
rm -rfv wp-includes/images/media/756030
rm -rfv wp-includes/css/dist/list-reusable-blocks/682616
rm -rfv wp-includes/css/dist/block-directory/499437

echo ""
echo "✅ БЛОК 6 завершено"
echo "⚠️  ПЕРЕВІРТЕ АДМІНКУ перед продовженням!"
echo "Натисніть Enter коли перевірите..."
read

# ═══════════════════════════════════════════════════════════════════
# БЛОК 7: ЗАВЕРШЕННЯ
# ═══════════════════════════════════════════════════════════════════

echo ""
echo "╔═══════════════════════════════════════════════════════════════╗"
echo "║  ✅ ОЧИЩЕННЯ ЗАВЕРШЕНО!                                       ║"
echo "╚═══════════════════════════════════════════════════════════════╝"
echo ""
echo "ЩО РОБИТИ ДАЛІ:"
echo ""
echo "1. ❗ Відновити стандартні WordPress файли:"
echo "   - wp-admin/options.php"
echo "   - wp-admin/plugins.php"
echo "   Завантажте вашу версію WordPress з wordpress.org"
echo ""
echo "2. ❗ НЕГАЙНО змінити паролі:"
echo "   - WordPress admin"
echo "   - База даних (wp-config.php)"
echo "   - FTP/SSH"
echo "   - Хостинг"
echo ""
echo "3. ❗ Оновити ключі безпеки:"
echo "   https://api.wordpress.org/secret-key/1.1/salt/"
echo "   Замініть у wp-config.php (рядки 52-60)"
echo ""
echo "4. ❗ Оновити WordPress, теми, плагіни"
echo ""
echo "5. ❗ Встановити Wordfence Security"
echo ""
echo "6. ❗ Проскануйти онлайн:"
echo "   https://sitecheck.sucuri.net"
echo ""
echo "7. ❗ Перевірити .htaccess на шкідливі правила"
echo ""

