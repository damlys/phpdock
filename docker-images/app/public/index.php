<?php

require_once __DIR__.'/../vendor/autoload.php';

error_log('HTTP request logs some error.');

header('Content-Type: application/json');
echo json_encode([
    'message' => 'Hello world!',
]);
