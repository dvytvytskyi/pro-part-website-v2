<?php
/**
 * Парсер полігонів районів з Zoddak Properties
 * Використовує REST API для отримання 4-рівневої ієрархії:
 * Comarca (регіон) → Municipio (місто) → Distrito (район) → Barrio (квартал)
 */

class ZoddakPolygonFetcher {
    private $baseUrl = 'https://app.zoddak.com/rest/properties';
    private $phpSessionId;
    private $outputDir;
    private $stats = [
        'comarca' => 0,
        'municipio' => 0,
        'distrito' => 0,
        'barrio' => 0,
    ];
    
    public function __construct($outputDir, $phpSessionId) {
        $this->outputDir = $outputDir;
        $this->phpSessionId = $phpSessionId;
        if (!is_dir($outputDir)) {
            mkdir($outputDir, 0755, true);
        }
    }
    
    /**
     * Виконати POST запит до API
     */
    private function apiRequest($endpoint, $postData) {
        $url = $this->baseUrl . '/' . $endpoint;
        $jsonData = json_encode($postData);
        
        $ch = curl_init($url);
        curl_setopt_array($ch, [
            CURLOPT_RETURNTRANSFER => true,
            CURLOPT_FOLLOWLOCATION => true,
            CURLOPT_POST => true,
            CURLOPT_POSTFIELDS => $jsonData,
            CURLOPT_HTTPHEADER => [
                'Accept: */*',
                'Accept-Language: en-US,en;q=0.9',
                'Content-Type: application/json',
                'Cookie: PHPSESSID=' . $this->phpSessionId . '; _fbp=fb.1.1761906626035.672218754704425; _ga=GA1.1.564344171.1761906640; _ga_B7Z7CYZK7C=GS2.1.s1761906639',
                'Origin: https://app.zoddak.com',
                'Referer: https://app.zoddak.com/properties',
                'Cache-Control: no-cache',
            ],
            CURLOPT_SSL_VERIFYPEER => false,
            CURLOPT_USERAGENT => 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36'
        ]);
        
        $response = curl_exec($ch);
        $httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
        curl_close($ch);
        
        if ($httpCode === 200 && $response) {
            $data = json_decode($response, true);
            
            if (isset($data['success']) && $data['success']) {
                // Іноді дані в selector.municipios або selector.distritos
                if (empty($data['data']) && isset($data['selector'])) {
                    // Перевірити чи є дані в selector
                    if (isset($data['selector']['municipios'])) {
                        return $data['selector']['municipios'];
                    }
                    if (isset($data['selector']['distritos'])) {
                        return $data['selector']['distritos'];
                    }
                    if (isset($data['selector']['barrios'])) {
                        return $data['selector']['barrios'];
                    }
                }
                return $data['data'];
            }
        }
        
        echo "   ⚠️  HTTP $httpCode для $endpoint (request: " . json_encode($postData) . ")\n";
        return null;
    }
    
    /**
     * Отримати всі Comarca (регіони) - Рівень 1
     */
    public function fetchComarcas() {
        echo "📍 Завантаження COMARCA (регіонів)...\n";
        
        $data = $this->apiRequest('getGeometryById', [
            'id' => 'todas',
            'type' => 'comarcas'
        ]);
        
        if ($data && is_array($data)) {
            $this->stats['comarca'] = count($data);
            echo "✅ Завантажено comarca: " . count($data) . "\n";
            return $data;
        }
        
        return [];
    }
    
    /**
     * Отримати Municipio (міста) для comarca - Рівень 2
     */
    public function fetchMunicipios($comarcaId) {
        $data = $this->apiRequest('findLocationsById', [
            'id' => $comarcaId,
            'type' => 'comarca'
        ]);
        
        // DEBUG
        if ($data === null) {
            echo "      ⚠️  findLocationsById повернув null для comarca $comarcaId\n";
        } elseif (empty($data)) {
            echo "      ℹ️  Немає municipio для цієї comarca\n";
        }
        
        if ($data && is_array($data)) {
            return $data;
        }
        
        return [];
    }
    
    /**
     * Отримати Distrito (райони) для municipio - Рівень 3
     */
    public function fetchDistritos($municipioId) {
        $data = $this->apiRequest('findLocationsById', [
            'id' => $municipioId,
            'type' => 'municipio'
        ]);
        
        if ($data && is_array($data)) {
            return $data;
        }
        
        return [];
    }
    
    /**
     * Отримати Barrio (квартали) для distrito - Рівень 4
     */
    public function fetchBarrios($distritoId) {
        $data = $this->apiRequest('findLocationsById', [
            'id' => $distritoId,
            'type' => 'distrito'
        ]);
        
        if ($data && is_array($data)) {
            return $data;
        }
        
        return [];
    }
    
    /**
     * Конвертувати Zoddak дані в GeoJSON Feature
     */
    private function convertToFeature($item, $level, $parentId = null, $parentName = null) {
        $id = $item['_id']['$oid'] ?? null;
        $name = $item['Name'] ?? 'Unknown';
        $type = strtolower($item['type'] ?? 'unknown');
        $geometry = $item['geometry'] ?? null;
        $slug = $item['slug'] ?? null;
        
        if (!$geometry) {
            return null;
        }
        
        return [
            'type' => 'Feature',
            'id' => $id,
            'properties' => [
                'name' => $name,
                'name_es' => $name,
                'type' => $type,
                'level' => $level,
                'parent_id' => $parentId,
                'parent_name' => $parentName,
                'slug' => $slug,
                'zoddak_id' => $id,
            ],
            'geometry' => $geometry
        ];
    }
    
    /**
     * Парсити всю ієрархію
     */
    public function fetchAllHierarchy() {
        $allFeatures = [
            'level1_comarca' => [],
            'level2_municipio' => [],
            'level3_distrito' => [],
            'level4_barrio' => [],
        ];
        
        // Рівень 1: Comarca
        $comarcas = $this->fetchComarcas();
        
        foreach ($comarcas as $comarca) {
            $comarcaId = $comarca['_id']['$oid'];
            $comarcaName = $comarca['Name'];
            
            // Зберегти comarca
            $feature = $this->convertToFeature($comarca, 1);
            if ($feature) {
                $allFeatures['level1_comarca'][] = $feature;
            }
            
            echo "\n🏛️  COMARCA: {$comarcaName}\n";
            echo "   ID: {$comarcaId}\n";
            
            // Затримка між запитами
            sleep(1);
            
            // Рівень 2: Municipio
            $municipios = $this->fetchMunicipios($comarcaId);
            echo "   📊 Municipio: " . count($municipios) . "\n";
            
            foreach ($municipios as $municipio) {
                $municipioId = $municipio['_id']['$oid'];
                $municipioName = $municipio['Name'];
                
                // Зберегти municipio
                $feature = $this->convertToFeature($municipio, 2, $comarcaId, $comarcaName);
                if ($feature) {
                    $allFeatures['level2_municipio'][] = $feature;
                    $this->stats['municipio']++;
                }
                
                echo "      🏙️  {$municipioName} (ID: {$municipioId})\n";
                
                sleep(1);
                
                // Рівень 3: Distrito
                $distritos = $this->fetchDistritos($municipioId);
                if (count($distritos) > 0) {
                    echo "         📊 Distrito: " . count($distritos) . "\n";
                }
                
                foreach ($distritos as $distrito) {
                    $distritoId = $distrito['_id']['$oid'];
                    $distritoName = $distrito['Name'];
                    
                    // Зберегти distrito
                    $feature = $this->convertToFeature($distrito, 3, $municipioId, $municipioName);
                    if ($feature) {
                        $allFeatures['level3_distrito'][] = $feature;
                        $this->stats['distrito']++;
                    }
                    
                    echo "            🏘️  {$distritoName}\n";
                    
                    sleep(1);
                    
                    // Рівень 4: Barrio
                    $barrios = $this->fetchBarrios($distritoId);
                    if (count($barrios) > 0) {
                        echo "               📊 Barrio: " . count($barrios) . "\n";
                    }
                    
                    foreach ($barrios as $barrio) {
                        $barrioId = $barrio['_id']['$oid'];
                        $barrioName = $barrio['Name'];
                        
                        // Зберегти barrio
                        $feature = $this->convertToFeature($barrio, 4, $distritoId, $distritoName);
                        if ($feature) {
                            $allFeatures['level4_barrio'][] = $feature;
                            $this->stats['barrio']++;
                        }
                        
                        echo "                  🏠 {$barrioName}\n";
                        
                        sleep(1);
                    }
                }
            }
        }
        
        return $allFeatures;
    }
    
    /**
     * Зберегти GeoJSON у файл
     */
    public function saveGeoJSON($filename, $features) {
        $geojson = [
            'type' => 'FeatureCollection',
            'features' => $features,
        ];
        
        $filepath = $this->outputDir . '/' . $filename;
        file_put_contents($filepath, json_encode($geojson, JSON_PRETTY_PRINT | JSON_UNESCAPED_UNICODE));
        echo "💾 Збережено: {$filepath} (" . count($features) . " features)\n";
        return $filepath;
    }
    
    /**
     * Вивести статистику
     */
    public function printStats() {
        echo "\n";
        echo "═══════════════════════════════════════════════════════════\n";
        echo "📊 СТАТИСТИКА:\n";
        echo "═══════════════════════════════════════════════════════════\n";
        echo "   🌍 Comarca (регіонів):    " . $this->stats['comarca'] . "\n";
        echo "   🏙️  Municipio (міст):      " . $this->stats['municipio'] . "\n";
        echo "   🏘️  Distrito (районів):    " . $this->stats['distrito'] . "\n";
        echo "   🏠 Barrio (кварталів):    " . $this->stats['barrio'] . "\n";
        echo "   ─────────────────────────────────────\n";
        echo "   📦 ВСЬОГО:                " . array_sum($this->stats) . "\n";
        echo "═══════════════════════════════════════════════════════════\n";
    }
}

// ========== ГОЛОВНА ЛОГІКА ==========

echo "🚀 Парсер полігонів з Zoddak Properties\n";
echo "═══════════════════════════════════════════════════════════\n\n";

// ВАЖЛИВО! Для роботи скрипта потрібен PHPSESSID cookie
// Отримати його можна так:
// 1. Відкрийте https://app.zoddak.com в браузері
// 2. Залогіньтеся у свій акаунт
// 3. Відкрийте DevTools (F12) → Application → Cookies
// 4. Скопіюйте значення PHPSESSID
// 5. Вставте нижче

$phpSessionId = 'YOUR_PHPSESSID_HERE'; // ⚠️ ОНОВІТЬ ЦЕ ЗНАЧЕННЯ!
$outputDir = __DIR__ . '/../data/geojson';

echo "🔑 PHPSESSID: {$phpSessionId}\n";
echo "📁 Вихідна директорія: {$outputDir}\n\n";

$fetcher = new ZoddakPolygonFetcher($outputDir, $phpSessionId);

// Парсити всю ієрархію
echo "⏳ Починаємо парсинг (це займе ~5-15 хвилин)...\n";
echo "═══════════════════════════════════════════════════════════\n";

$startTime = microtime(true);
$allData = $fetcher->fetchAllHierarchy();

echo "\n";
echo "═══════════════════════════════════════════════════════════\n";
echo "💾 ЗБЕРЕЖЕННЯ ФАЙЛІВ\n";
echo "═══════════════════════════════════════════════════════════\n";

// Зберегти окремі файли по рівнях
$fetcher->saveGeoJSON('zoddak-level-1-comarca.geojson', $allData['level1_comarca']);
$fetcher->saveGeoJSON('zoddak-level-2-municipio.geojson', $allData['level2_municipio']);
$fetcher->saveGeoJSON('zoddak-level-3-distrito.geojson', $allData['level3_distrito']);
$fetcher->saveGeoJSON('zoddak-level-4-barrio.geojson', $allData['level4_barrio']);

// Зберегти все разом
$allFeatures = array_merge(
    $allData['level1_comarca'],
    $allData['level2_municipio'],
    $allData['level3_distrito'],
    $allData['level4_barrio']
);
$fetcher->saveGeoJSON('zoddak-all-levels.geojson', $allFeatures);

// Створити мапінг рівнів для фронтенду (як у поточної системи)
$fetcher->saveGeoJSON('level-1-region.geojson', $allData['level1_comarca']);
$fetcher->saveGeoJSON('level-2-cities.geojson', $allData['level2_municipio']);
$fetcher->saveGeoJSON('level-3-neighborhoods.geojson', array_merge($allData['level3_distrito'], $allData['level4_barrio']));

// Статистика
$endTime = microtime(true);
$duration = round($endTime - $startTime, 2);

$fetcher->printStats();
echo "\n⏱️  Час виконання: {$duration} секунд\n";
echo "✅ ГОТОВО!\n";
echo "═══════════════════════════════════════════════════════════\n";
