<?php
/**
 * Debug Rent page routing
 */

require_once(__DIR__ . '/pro-part.es/wp-load.php');

echo "🔍 Debugging Rent page...\n\n";

// Check page
$page = get_page_by_path('rent');
if ($page) {
    echo "✅ Page exists:\n";
    echo "   ID: {$page->ID}\n";
    echo "   Title: {$page->post_title}\n";
    echo "   Slug: {$page->post_name}\n";
    echo "   Status: {$page->post_status}\n";
    echo "   Template: " . get_post_meta($page->ID, '_wp_page_template', true) . "\n\n";
} else {
    echo "❌ Page not found!\n\n";
}

// Check permalink structure
echo "📋 Permalink structure: " . get_option('permalink_structure') . "\n\n";

// Flush rewrite rules
flush_rewrite_rules();
echo "✅ Rewrite rules flushed\n\n";

// Test URL
echo "🔗 Try accessing:\n";
echo "   http://localhost/rent?page=1&rent_type=long\n";
echo "   Or with your domain/port\n\n";

// Check if .htaccess exists (for Apache)
$htaccess = __DIR__ . '/pro-part.es/.htaccess';
if (file_exists($htaccess)) {
    echo "✅ .htaccess exists\n";
} else {
    echo "⚠️  .htaccess not found - may need to create it\n";
}
?>

