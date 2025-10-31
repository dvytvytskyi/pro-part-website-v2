# 🧪 Тестові запити для AI Пошуку

## 🇺🇦 Українською

### **Базові запити:**
```
Квартира в Марбельї
Будинок в Естепоні
Вілла в Бенахавісі
```

### **З кількістю спалень:**
```
2 спальні в Марбельї
Квартира 3 кімнати
Будинок з 4 спальнями
Від 2 до 4 спалень
```

### **З ціною:**
```
Квартира до 300 тисяч
Від 200 до 500 тисяч євро
Вілла до півмільйона
Бюджет 400к
```

### **З особливостями:**
```
Квартира з басейном
Вілла біля моря
Будинок з садом та гаражем
З видом на море
```

### **Комплексні запити:**
```
Квартира в Марбельї 2 спальні до 300 тисяч з басейном
Вілла в Естепоні 3-4 спальні від 500к з видом на море
Сучасна квартира в Puerto Banus з паркінгом
```

### **Оренда:**
```
Оренда квартири в Марбельї
2 спальні оренда до 2000 в місяць
Довгострокова оренда будинку
Квартира на оренду біля пляжу
```

---

## 🇬🇧 English

### **Basic:**
```
Apartment in Marbella
House in Estepona
Villa in Benahavis
```

### **With bedrooms:**
```
2 bedroom apartment
3 bed house
Villa with 4 bedrooms
2-3 bedrooms
```

### **With price:**
```
Apartment under 300k
From 200 to 500 thousand
Villa up to half a million
Budget 400 thousand euros
```

### **With features:**
```
Apartment with pool
Beachfront villa
House with garden and garage
Sea view property
```

### **Complex:**
```
Modern 2 bedroom apartment in Marbella under 300k
Luxury villa in Estepona 3-4 beds with pool and sea views
Penthouse in Puerto Banus with parking
```

### **Rental:**
```
Rent apartment in Marbella
2 bedroom rental under 2000 per month
Long term rental house
Beachfront rental property
```

---

## 🇪🇸 Español

### **Básico:**
```
Apartamento en Marbella
Casa en Estepona
Villa en Benahavís
```

### **Con dormitorios:**
```
2 dormitorios en Marbella
Apartamento de 3 habitaciones
Villa con 4 dormitorios
De 2 a 4 dormitorios
```

### **Con precio:**
```
Apartamento hasta 300 mil
De 200 a 500 mil euros
Villa hasta medio millón
Presupuesto 400k
```

### **Con características:**
```
Apartamento con piscina
Villa en primera línea de playa
Casa con jardín y garaje
Con vistas al mar
```

### **Complejas:**
```
Apartamento moderno 2 dormitorios en Marbella hasta 300mil
Villa de lujo en Estepona 3-4 dormitorios con piscina
Ático en Puerto Banús con parking
```

### **Alquiler:**
```
Alquiler apartamento en Marbella
2 dormitorios alquiler hasta 2000 al mes
Alquiler larga temporada casa
Propiedad en alquiler cerca de la playa
```

---

## 🔥 "Екстремальні" запити (для тестування)

### **Дуже специфічні:**
```
Хочу щось біля моря в Марбельї, але не дорожче 250 тисяч, з 2 спальнями та басейном
Потрібна вілла для великої родини, 5+ спалень, сад, гараж, в тихому районі
Інвестиція до 300к, краще квартира, щоб можна було здавати в оренду
```

### **Розмовні:**
```
Що можете показати за 200 тисяч?
Є щось цікаве в Естепоні?
Покажіть найкращі варіанти для сім'ї
Хочу переїхати в Іспанію, що порадите?
```

### **Неоднозначні (AI має запитати уточнення або зробити припущення):**
```
Щось недороге біля моря
Велика квартира
Хороша нерухомість для життя
Інвестиційна нерухомість
```

---

## ✅ Очікувані результати

Для кожного запиту AI має:

1. **Зрозуміти:**
   - 🏘️ Локацію (town, area)
   - 🏠 Тип нерухомості (apartment, villa, house)
   - 🛏️ Кількість спалень
   - 💰 Ціновий діапазон
   - ⭐ Особливості (pool, garden, garage, sea view)
   - 📍 Статус (sale/rent)

2. **Повернути:**
   - 📝 Пояснення українською що він зрозумів
   - 🔢 Загальну кількість знайдених варіантів
   - 🏆 Топ-5 найкращих результатів
   - 🎯 Кнопку "Показати всі" (якщо більше 5)

3. **Показати для кожного об'єкта:**
   - 🖼️ Зображення
   - 💵 Ціну (форматовано)
   - 📍 Локацію (місто + район)
   - 🛏️ Спальні
   - 🚿 Ванні
   - 📐 Площу
   - 🔗 Посилання "Детальніше"

---

## 🐛 Тестування помилок

### **Порожній запит:**
```
[просто натиснути Enter]
```
**Очікується:** Кнопка не відправляє, нічого не відбувається

### **Занадто короткий:**
```
а
123
```
**Очікується:** AI спробує щось знайти, але скаже "не вистачає інформації"

### **Неіснуюче місто:**
```
Квартира в Києві
House in New York
```
**Очікується:** Знайде 0 результатів, запропонує змінити локацію

### **Нереальна ціна:**
```
Вілла за 1000 євро
Villa for 100 million
```
**Очікується:** Знайде 0 або дуже мало результатів

---

## 📊 Метрики успішності

Протестуйте мінімум **20 різних запитів** і перевірте:

- ✅ AI розуміє запит: **>90%**
- ✅ Повертає релевантні результати: **>85%**
- ✅ Час відповіді: **<5 секунд**
- ✅ UI працює без помилок: **100%**
- ✅ Підтримує 3 мови: **100%**

---

## 💡 Поради для тестування

1. **Тестуйте різні мови:** UK, EN, ES
2. **Тестуйте різні формулювання:** "2 спальні" vs "2 кімнати" vs "2 bed"
3. **Тестуйте комбінації:** Ціна + спальні + локація + features
4. **Тестуйте край cases:** Дуже довгі запити, дуже короткі
5. **Тестуйте на мобільних:** UI має бути адаптивним

---

**Приємного тестування! 🚀**

