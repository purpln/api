<?php
require_once 'constants.php';

function getIp(){
    switch(true){
        case (!empty($_SERVER['HTTP_X_REAL_IP'])) : return $_SERVER['HTTP_X_REAL_IP'];
        case (!empty($_SERVER['HTTP_CLIENT_IP'])) : return $_SERVER['HTTP_CLIENT_IP'];
        case (!empty($_SERVER['HTTP_X_FORWARDED_FOR'])) : return $_SERVER['HTTP_X_FORWARDED_FOR'];
        default : return $_SERVER['REMOTE_ADDR'];
    }
}

function information($error, $data){
    $info = array('api'=>api, 'version'=>version, 'description'=>description, 'error'=>$error, 'data'=>$data, 'seed'=>seed);
    if ($error){
        logs(seed, 'error', $data);
    }else{
        logs(seed, ' ok. ', $data);
    }
    return $info;
}

function error($error){
    return array('info'=>information(true, $error));
}

function response($values, $info){
    return array('values'=>$values, 'info'=>information(false, $info));
}

function logs($seed, $value, $description){
    $date = date("Y-m-d H:i:s");
    $ip = getIp();
    $values = "$date [$value] $seed - $ip - $description\n";
    file_put_contents('logs.log', $values, FILE_APPEND | LOCK_EX);
}

function timeUpdate($token){
    $date = date("Y-m-d H:i:s");
    $mysqli = mysqli_connect(host, username, password, name);
    $stmt = $mysqli->prepare("UPDATE users SET last=? WHERE token=?");
    $stmt->bind_param("ss", $date, $token);
    $stmt->execute();
    $stmt->close();
}

function randomToken(){
    $token = bin2hex(random_bytes(8));
    $mysqli = mysqli_connect(host, username, password, name);
    $stmt = $mysqli->prepare("SELECT id FROM users WHERE token=?");
    $stmt->bind_param("s", $token);
    $stmt->execute();
    $stmt->store_result();
    if ($stmt->num_rows > 0){
        return bin2hex(random_bytes(8));
    }else{
        return $token;
    }
}
?>