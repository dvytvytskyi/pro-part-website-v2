<?php
/**
 * Flush WordPress rewrite rules
 * Run via terminal: php flush-permalinks.php
 */

require_once(__DIR__ . '/pro-part.es/wp-load.php');

echo "🔄 Flushing WordPress rewrite rules...\n\n";

// Flush rewrite rules
flush_rewrite_rules();

echo "✅ Rewrite rules flushed successfully!\n";
echo "   You can now try accessing: /rent?page=0&rent_type=long\n\n";
?>

