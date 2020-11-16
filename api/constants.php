<?php
date_default_timezone_set('UTC');

define('username', '_username_value_');
define('password', '_password_value_');
define('host', 'localhost');
define('name', '_database_name_value_');

define('key', '_key_value_');
define('version', '1.0.0');
define('seed', bin2hex(random_bytes(6)));
define('api', 'api');
define('description', 'by Sergey Romanenko');

define('error_server', 'server error');
define('error_noData', 'no data');
define('error_noKey', 'no key');
define('error_noOperation', 'no operation');
define('error_noValues', 'no values');
define('error_invalidKey', 'invalid key');
define('error_invalidOperation', 'invalid operation');
define('error_valueWasNotUpdated', 'value wasn\'t updated');
define('error_invalidUserOrPassword', 'invalid username or password');
define('error_userAlreadyExist', 'user already exist');
define('error_userNotCreated', 'user not created');
?>
