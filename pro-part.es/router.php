<?php
/**
 * Simple router for PHP built-in server
 * Handles WordPress REST API routing
 */

$uri = urldecode(parse_url($_SERVER['REQUEST_URI'], PHP_URL_PATH));

// Handle REST API requests
if (strpos($uri, '/wp-json/') === 0) {
    $_SERVER['REQUEST_URI'] = '/index.php?rest_route=' . str_replace('/wp-json', '', $uri);
    require_once 'index.php';
    return true;
}

// Handle static files
if ($uri !== '/' && file_exists(__DIR__ . $uri)) {
    return false; // Let PHP built-in server handle it
}

// Handle WordPress pretty permalinks
$_SERVER['REQUEST_URI'] = $uri;
require_once 'index.php';
return true;

