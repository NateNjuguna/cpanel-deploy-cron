<?php

$home = __DIR__;

$config_path = str_replace('/', DIRECTORY_SEPARATOR, "{$home}/config.json");
$config = json_decode(file_get_contents($config_path));

$request_is_post = in_array($_SERVER['REQUEST_METHOD'], ['POST', 'post']);
$input_has_project = isset($_GET['project']) && array_key_exists($_GET['project'], $config);

if ($request_is_post && $input_has_project) {
    
    $project_lock_file_path = str_replace('/', DIRECTORY_SEPARATOR, "{$home}/{$_GET['project']}.lock");
    
    if (!file_exists($project_lock_file_path)) {
        touch($project_lock_file);
    }
    
}