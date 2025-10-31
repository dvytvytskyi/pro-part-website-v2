# 🏘️ Система полігонів районів Costa del Sol

## 📋 Опис

Система відображення багаторівневих полігонів районів Costa del Sol на карті Mapbox з можливістю показу/приховування та інтерактивної взаємодії.

## 🎯 Структура рівнів

### Рівень 1: Costa del Sol (регіон)
- Загальний полігон всього регіону Costa del Sol
- Відображається при zoom < 11
- Колір: бірюзовий (#088)

### Рівень 2: Міста
- Estepona, Marbella, Fuengirola, Mijas, Benalmádena, та інші
- Відображається при zoom >= 9
- Колір: синій (#4a90e2)
- Має підписи (labels)

### Рівень 3: Райони (neighborhoods)
- Райони всередині міст (Puerto Banús, Nueva Andalucía, Sierra Blanca, тощо)
- Відображається при zoom >= 11
- Колір: червоний (#ff6b6b)
- Має підписи (labels)
- Інтерактивні (hover, click)

## 📁 Структура файлів

```
wp-content/themes/propart-spain/
├── data/
│   ├── geojson/
│   │   ├── level-1-region.geojson          # Costa del Sol (регіон)
│   │   ├── level-2-cities.geojson          # Міста
│   │   └── level-3-neighborhoods.geojson   # Райони
│   └── README-NEIGHBORHOODS.md
├── scripts/
│   ├── fetch-neighborhoods-geojson.php     # Повний скрипт (Overpass API)
│   └── fetch-neighborhoods-quick.php       # Швидка версія (Nominatim API)
└── pages/
    └── map.php                              # Карта з інтегрованими полігонами
```

## 🚀 Як використовувати

### На карті (для користувачів)

1. Відкрийте сторінку карти `/map`
2. Знайдіть кнопку **"Neighborhoods"** біля кнопки "Draw on map"
3. Клікніть на кнопку - полігони з'являться на карті
4. Змінюйте zoom:
   - Zoom 8-10: бачите загальний регіон Costa del Sol
   - Zoom 9-12: бачите міста з підписами
   - Zoom 11+: бачите райони з підписами
5. Наведіть мишку на район - він підсвітиться
6. Клікніть на район - в консолі з'явиться інформація (TODO: додати фільтрацію)

### Оновлення GeoJSON даних

#### Варіант 1: Швидке оновлення (Nominatim API)

```bash
cd /Users/vytvytskyi/Downloads/htdocs/pro-part.es/wp-content/themes/propart-spain/scripts
php fetch-neighborhoods-quick.php
```

**Плюси:**
- Швидко (1-2 хвилини)
- Не перевантажує API

**Мінуси:**
- Приблизні полігони (bbox)
- Не всі райони знаходяться

#### Варіант 2: Повне оновлення (Overpass API)

```bash
cd /Users/vytvytskyi/Downloads/htdocs/pro-part.es/wp-content/themes/propart-spain/scripts
php fetch-neighborhoods-geojson.php
```

**Плюси:**
- Точні полігони з OpenStreetMap
- Більше деталей

**Мінуси:**
- Довго (30-60 хвилин через затримки між запитами)
- Може не знайти деякі нові райони

#### Варіант 3: Ручне редагування

1. Відкрийте файл `data/geojson/level-3-neighborhoods.geojson`
2. Додайте новий feature:

```json
{
  "type": "Feature",
  "properties": {
    "name": "Назва району",
    "type": "neighborhood",
    "parent": "Місто",
    "level": 3
  },
  "geometry": {
    "type": "Polygon",
    "coordinates": [
      [
        [lon1, lat1],
        [lon2, lat2],
        [lon3, lat3],
        [lon1, lat1]  // замкнути полігон
      ]
    ]
  }
}
```

## 🎨 Налаштування стилів

### Зміна кольорів

В `map.php`, функція `initNeighborhoodLayers()`:

```javascript
// Рівень 1 (регіон)
'fill-color': '#088',        // Змініть тут
'line-color': '#088',

// Рівень 2 (міста)
'fill-color': '#4a90e2',     // Змініть тут
'line-color': '#4a90e2',

// Рівень 3 (райони)
'fill-color': '#ff6b6b',     // Змініть тут
'line-color': '#ff6b6b',
```

### Зміна прозорості

```javascript
'fill-opacity': 0.15,  // 0.0 - 1.0
'line-opacity': 0.7,   // 0.0 - 1.0
```

### Зміна товщини ліній

```javascript
'line-width': 2,  // пікселі
```

### Зміна zoom рівнів

В функції `updateNeighborhoodVisibilityByZoom()`:

```javascript
if (currentZoom < 11) {        // Змініть тут для рівня 1
if (currentZoom >= 9) {        // Змініть тут для рівня 2
if (currentZoom >= 11) {       // Змініть тут для рівня 3
```

## 📊 Статистика поточних даних

- **Рівень 1:** 1 полігон (Costa del Sol)
- **Рівень 2:** 5 полігонів (Marbella, Estepona, Fuengirola, Mijas, Benalmádena)
- **Рівень 3:** 8 полігонів (Puerto Banús, Nueva Andalucía, Sierra Blanca, тощо)

**Примітка:** Це тестові дані з приблизними координатами. Для production рекомендується запустити один з скриптів для отримання реальних даних.

## 🔧 API функції

### JavaScript функції (в map.php)

```javascript
// Показати/приховати полігони
toggleNeighborhoods()

// Завантажити GeoJSON дані
loadNeighborhoodPolygons()

// Показати полігони
showNeighborhoods()

// Приховати полігони
hideNeighborhoods()

// Оновити видимість залежно від zoom
updateNeighborhoodVisibilityByZoom()

// Ініціалізувати шари на карті
initNeighborhoodLayers()
```

### Глобальні змінні

```javascript
neighborhoodsVisible    // boolean - чи показані полігони
neighborhoodsLoaded     // boolean - чи завантажені дані
```

## 🐛 Debugging

### Консольні логи

При роботі з полігонами в консолі браузера ви побачите:

```
🏘️ Ініціалізація шарів полігонів районів...
✅ Шари полігонів ініціалізовано
🏘️ КНОПКА NEIGHBORHOODS НАТИСНУТА!
📥 Завантаження GeoJSON полігонів...
✅ Завантажено полігонів: {level1: 1, level2: 5, level3: 8}
👁️ Показуємо полігони районів
🏘️ Клік на район: Puerto Banús ( Marbella )
```

### Перевірка шарів на карті

В консолі браузера:

```javascript
// Перевірити чи існують джерела
map.getSource('neighborhoods-level-1')
map.getSource('neighborhoods-level-2')
map.getSource('neighborhoods-level-3')

// Перевірити чи існують шари
map.getLayer('neighborhoods-fill-1')
map.getLayer('neighborhoods-fill-2')
map.getLayer('neighborhoods-fill-3')

// Перевірити дані
map.getSource('neighborhoods-level-3').serialize()
```

## 📝 TODO / Наступні кроки

- [ ] Додати фільтрацію проектів по кліку на район
- [ ] Додати breadcrumbs навігацію (як на Idealista)
- [ ] Отримати реальні GeoJSON дані з OpenStreetMap для всіх районів
- [ ] Додати можливість вибору кількох районів
- [ ] Зберігати стан полігонів в URL
- [ ] Додати mobile-friendly управління
- [ ] Додати анімацію при zoom переходах
- [ ] Оптимізувати performance для великої кількості полігонів

## 🤝 Допомога

Якщо виникають проблеми:

1. Перевірте консоль браузера (F12)
2. Перевірте чи файли GeoJSON існують і доступні
3. Перевірте чи Mapbox токен валідний
4. Перевірте чи map ініціалізована (`!!map` в консолі)

## 📚 Ресурси

- [Mapbox GL JS Documentation](https://docs.mapbox.com/mapbox-gl-js/api/)
- [GeoJSON Specification](https://geojson.org/)
- [OpenStreetMap Overpass API](https://wiki.openstreetmap.org/wiki/Overpass_API)
- [Nominatim API](https://nominatim.org/release-docs/develop/api/Overview/)

---

**Автор:** AI Assistant  
**Дата:** 30.10.2025  
**Версія:** 1.0.0

