# 📤 Інструкція для заливки liked.php на сервер

## ✅ Що було зроблено:
- ✅ Видалено кнопку "Export PDF"
- ✅ Видалено весь код для PDF export (181 рядок)
- ✅ Видалено бібліотеки jsPDF та html2canvas
- ✅ Закомічено та запушено на GitHub

---

## 🚀 СПОСІБ 1: Через SCP (найшвидше)

Запустіть в терміналі:

```bash
cd /Users/vytvytskyi/Downloads/htdocs
scp pro-part.es/wp-content/themes/propart-spain/pages/liked.php root@188.245.228.175:/home/pro-part/htdocs/pro-part.es/wp-content/themes/propart-spain/pages/
```

Введіть пароль root коли система попросить.

---

## 🚀 СПОСІБ 2: Через rsync (рекомендовано)

```bash
cd /Users/vytvytskyi/Downloads/htdocs
rsync -avz --progress \
  pro-part.es/wp-content/themes/propart-spain/pages/liked.php \
  root@188.245.228.175:/home/pro-part/htdocs/pro-part.es/wp-content/themes/propart-spain/pages/
```

---

## 🚀 СПОСІБ 3: Через FTP клієнт (FileZilla / Cyberduck)

1. Відкрийте FTP клієнт
2. Підключіться до `188.245.228.175` (root + пароль)
3. Завантажте локальний файл:
   ```
   /Users/vytvytskyi/Downloads/htdocs/pro-part.es/wp-content/themes/propart-spain/pages/liked.php
   ```
4. На сервер в папку:
   ```
   /home/pro-part/htdocs/pro-part.es/wp-content/themes/propart-spain/pages/
   ```

---

## 🧹 ПІСЛЯ ЗАЛИВКИ:

1. **Очистити кеш браузера:**
   - Відкрийте https://pro-part.es/liked-projects/
   - Натисніть **Cmd + Shift + R** (Mac) або **Ctrl + Shift + R** (Windows)

2. **Очистити localStorage:**
   - Відкрийте консоль (F12)
   - Виконайте:
   ```javascript
   localStorage.clear();
   sessionStorage.clear();
   location.reload(true);
   ```

3. **Перевірити результат:**
   - ✅ Кнопки "Export PDF" більше немає
   - ✅ Залишились тільки "Copy link" та "Clear"

---

## ❓ Якщо все ще бачите стару версію:

Можливо WordPress кешує сторінку. Зайдіть в адмін панель:
```
https://pro-part.es/wp-admin
```

І очистіть кеш через плагін кешування (WP Super Cache / W3 Total Cache / LiteSpeed).

---

**Розмір файлу після оновлення:** 144 KB (було 152 KB)
**Видалено рядків:** 181

