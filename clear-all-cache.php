<?php
/**
 * Clear all WordPress cache
 */

require_once(__DIR__ . '/pro-part.es/wp-load.php');

echo "🧹 Clearing all cache...\n\n";

// Flush rewrite rules
flush_rewrite_rules(true);
echo "✅ Rewrite rules flushed\n";

// Clear object cache
wp_cache_flush();
echo "✅ Object cache cleared\n";

// Clear transients
global $wpdb;
$wpdb->query("DELETE FROM $wpdb->options WHERE option_name LIKE '_transient_%'");
$wpdb->query("DELETE FROM $wpdb->options WHERE option_name LIKE '_site_transient_%'");
echo "✅ Transients cleared\n\n";

echo "🎉 Done! Try accessing /rent?page=1&rent_type=long now\n";
?>

