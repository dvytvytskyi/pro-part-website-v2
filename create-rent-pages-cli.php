<?php
/**
 * CLI Script to create Rent pages in WordPress
 * Run via terminal: php create-rent-pages-cli.php
 */

// Load WordPress
require_once(__DIR__ . '/pro-part.es/wp-load.php');

echo "🚀 Creating Rent pages...\n\n";

// Create "Rent" main page
$rent_page = array(
    'post_title'    => 'Rent',
    'post_name'     => 'rent',
    'post_status'   => 'publish',
    'post_type'     => 'page',
    'post_content'  => '',
    'post_author'   => 1,
);

// Check if page already exists
$existing_page = get_page_by_path('rent');
if (!$existing_page) {
    $rent_page_id = wp_insert_post($rent_page);
    if ($rent_page_id) {
        // Set template
        update_post_meta($rent_page_id, '_wp_page_template', 'pages/rent.php');
        echo "✅ Page 'Rent' created successfully (ID: $rent_page_id)\n";
        echo "   URL: /rent\n";
        echo "   Template: pages/rent.php\n\n";
    } else {
        echo "❌ Failed to create 'Rent' page\n\n";
    }
} else {
    echo "⚠️  Page 'Rent' already exists (ID: {$existing_page->ID})\n";
    // Update template just in case
    update_post_meta($existing_page->ID, '_wp_page_template', 'pages/rent.php');
    echo "✅ Template updated for 'Rent' page\n";
    echo "   URL: /rent\n";
    echo "   Template: pages/rent.php\n\n";
}

echo "✅ Done! You can now access:\n";
echo "   - Long term rent: http://localhost/rent?page=0&rent_type=long\n";
echo "   - Short term rent: http://localhost/rent?page=0&rent_type=short\n";
echo "   - Rent details: http://localhost/rent?projectid=123&rent_type=long\n\n";
echo "⚠️  Don't forget to delete this file after running!\n";
?>

