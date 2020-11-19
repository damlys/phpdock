#!/usr/bin/env php
<?php

require_once __DIR__.'/../vendor/autoload.php';

/** @var string $env */
$env = $_ENV['APP_ENV'] ?? 'production';

error_log('App logs some dummy error.');

echo 'Hello world!'.PHP_EOL;
