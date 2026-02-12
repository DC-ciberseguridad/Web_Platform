<?php
/**
 * Plugin Name: FastAPI Social Integration
 * Description: Integrates WordPress posts with FastAPI likes and comments.
 * Version: 1.1
 * Author: Web Platform
 */

function fastapi_scripts() {
    if (!is_single()) return;

    wp_enqueue_script(
        'fastapi-js',
        plugin_dir_url(__FILE__) . 'fastapi.js',
        array(),
        '1.1',
        true
    );

    wp_localize_script('fastapi-js', 'fastapiData', array(
        'postId' => get_the_ID(),
        'apiUrl' => '/api'  // Siempre usar reverse proxy
    ));
}

add_action('wp_enqueue_scripts', 'fastapi_scripts');
